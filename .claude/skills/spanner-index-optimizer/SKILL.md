---
name: spanner-index-optimizer
description: |
  与えられたクエリやその周辺クエリに対して Spanner のセカンダリインデックスを最適化します。
  以下の場合に特に有用です：
  - xxx
allowed-tools: ["Read", "Bash", "Glob", "Grep", "AskUserQuestion"]
---

# 作業

* 資料を確認する
* 上限値を確認する
* クエリに有効なインデックスを算出する
* 既存のクエリと噛み合わせを考える

## 資料を読み込む

* domain/*.go
  * 事前にクエリするエンティティの組織毎の上限値を調べる
  * フィールドとエンティティの関連を調べる
    * 調べてもわからない場合は、AskUserQuestionツールを使ってユーザに質問してください
* https://docs.cloud.google.com/spanner/docs/query-execution-plans?hl=ja
* https://docs.cloud.google.com/spanner/docs/secondary-indexes?hl=ja

## 戦略

* OrganizationID を先頭に付ける
  * 理由: OrganzationID フィールドを付けることでマルチテナントを実現しており、基本的にクエリに `OrganizationID` を指定するから
  * OrganizationID を付けないインデックスを追加しないとパフォーマンスがでない場合はクエリが悪い。
* キー列は含めなくていい
  * 理由: Spanner は自動的にキー列をインデックスに追加するから
  * ただし、ただし保存しているキーは昇順(`ASC`)なため、キー列を逆順(`DESC`)にソートする場合は必要。
* ソート条件は最後に持ってくる
  * 理由: 絞り込んだデータに対してソートするため最後じゃないと意味がない
  * 次のようなクエリがある場合 `InventoryLogicalAdjustmentGroup(OrganizationID, CreatedAt DESC)` が効く
```sql
SELECT
  *
FROM 
  InventoryLogicalAdjustmentGroup
WHERE 
  OrganizationID = @organizationID
ORDER BY
  CreatedAt DESC 
LIMIT 
  1000
```
* 1000以下のレコードからデータを絞り込むために、インデックス追加は必要ない
  * 理由: 1000以下であればマシンが頑張って絞り込む
  * たとえばBrandの上限値は250。Organization にインデックスを貼るだけでいい
* JOIN後のデータを参照する場合は `STORING` を付ける
  * 理由: `STORING` を付けないとテーブルへデータ取得、バック結合が発生するため遅くなるため
  * ただしデータ取得が1000件以下になる場合は `STORING` は付けなくていい
* `@{FORCE_INDEX=...}` 等のクエリヒントは極力使わない
  * 理由: 基本的にオプティマイザーは最悪の結果にならないように調整してくれているから
  * 指定しないとフルスキャンしてしまう場合は使ってOKだが、理由を明記する
* WHERE句 CreatedAt や UpdatedAt レンジで指定する場合に `DESC` を付ける必要はない
  * 理由: `DESC` はWHERE句では意味がないから
  * たとえば `CreatedAt >= 昨日` などでほとんど過去のデータがほとんどで、条件に当てはまるデータが少なくても問題ない
* カーディナリティが高いものから順にインデックスを貼る
  * 理由: インデックスを流用できる可能性が高いから
  * カーディナリティが同じくらいなフィールドな場合はクエリを見て判断すればいい
  * 例: ProductVariant テーブルであれば `OrganzationID, ProductID` でよさそう
  * 例: InventoryLogicalChange は `OrganizationID, LocationID` まではよさそう。`InventoryItemID, InventoryLogicalState` はクエリ次第。場所によらず全体の在庫を見たい場合は `LocationID` が2番目にくることもない
```sql
CREATE TABLE InventoryLogicalChange (
  ID STRING(MAX) NOT NULL,
  OrganizationID STRING(MAX) NOT NULL,
  ProductVariantID STRING(MAX) NOT NULL,
  InventoryItemID STRING(MAX) NOT NULL,
  LocationID STRING(MAX) NOT NULL,
  InventoryLogicalState STRING(MAX) NOT NULL,
  Delta INT64 NOT NULL,
  CreatedAt TIMESTAMP NOT NULL DEFAULT (CURRENT_TIMESTAMP()),
  UpdatedAt TIMESTAMP NOT NULL OPTIONS (allow_commit_timestamp = true),
) PRIMARY KEY(ID);
```
## STORING の使い所

STORING 列はインデックスの並び順に関与しない。役割は「インデックス行に列の値を同居させ、テーブル本体のバック結合を減らす」ことだけで、走査範囲を狭める効果はない。

* キー列: 絞り込み・並び順で走査範囲そのものを狭める
* STORING 列: 走査範囲は狭めず、読んだ行の判定と取得をインデックス内で完結させる

このプロジェクトは最終取得を `SELECT *` にするルールなので、最終取得でのカバリングインデックスは成立しない。使い所は「`SELECT *` に至る前の中間段階」に集まる。

1. Join テーブル経由の絞り込み（最多）
   * `XxxAndYyyJoin(OrganizationID, XxxID) STORING (YyyID)` の形で、Join テーブルからは ID だけ取り出し、本体テーブルを `SELECT *` する
   * 例: `InventoryLogicalChangeAndDraftOrderJoin(OrganizationID, DraftOrderID) STORING (InventoryLogicalChangeID)`、`LocationGroupAndLocationJoin(OrganizationID, LocationGroupID) STORING (LocationID)`
2. 集計クエリ
   * `SUM` / `COUNT` の対象列を STORING すると、集計がインデックス内で完結する
   * 例: `InventoryLogicalChange(OrganizationID, LocationID, InventoryLogicalState, InventoryItemID) STORING (Delta)`、`InventoryLogicalQuantitySnapshot(OrganizationID, TargetMonth) STORING (Quantity)`
3. 残余フィルタ
   * 並び順を変えずに WHERE の判定をインデックス内で済ませ、バック結合を該当行だけに絞る
   * 向く条件: 既存の並び順で走査してよい / 絞り込みで読む行が数倍程度に収まる / 専用のキー列インデックスを足すほど頻度・選択性が高くない / 絞り込み条件が今後増える見込みで、条件ごとにインデックスを増やしたくない
   * 絞り込みが強く効き（該当行が全体のごく一部）かつ頻繁に呼ぶクエリなら、STORING ではなくキー列に置く。走査行数が桁で変わる
4. 小さい子テーブルの全列 STORING
   * 例: `InventoryPurchaseOrderContact(OrganizationID, InventoryPurchaseOrderID) STORING (FirstName, LastName, Email, ...)`
   * `SELECT *` なら列追加のたびに STORING も追従が要る。保守負担が大きいので積極的には勧めない

### 例: 任意の絞り込みを持つ一覧クエリ

```sql
SELECT * FROM DraftOrder
WHERE OrganizationID = @organizationID
  AND RetailLocationID = @retailLocationID  -- 任意。無い場合もある
ORDER BY CreatedAt DESC, ID DESC
LIMIT @p_limit OFFSET @p_offset
```

| 候補 | 絞り込みなし | 絞り込みあり | 今後の絞り込み追加 |
|---|---|---|---|
| 1. `(OrganizationID, CreatedAt DESC, ID DESC) STORING (RetailLocationID)` | インデックス順に読み LIMIT で早期終了 | CreatedAt 順に走査し STORING 列で残余フィルタ。走査行数は `(LIMIT + OFFSET) ÷ 該当店舗の割合` 程度に増える | STORING に列を足すだけで 1 本が全パターンを担う |
| 2. `(OrganizationID, RetailLocationID, CreatedAt DESC, ID DESC)` | 使えない。別インデックスが必要 | 最適。必要な行だけ読む | 条件の組み合わせごとにインデックスが増える |

* 「絞り込みなしもある」「絞り込みが今後増える」なら 1 を選ぶ。2 は結局 1 相当も必要になり、インデックスが 2 本になる
* 1 と 2 を単体で比べると mutation コストはほぼ同じ（どちらも 1 行につきインデックス行 1 件）。コストが増えるのは 2 に加えて絞り込みなし用のインデックスを足し、2 本になった時点
* キー列の更新はインデックス行の削除 + 挿入、STORING 列の更新はインデックス行の更新で済む。ただし絞り込み列を後から変えることが稀なら、この差は無視できる
* DDL 追加後は `spanner-plan-analyze` で両クエリの実行計画を確認する。オプティマイザが 1 を選ばなければ理由付きで `FORCE_INDEX` を検討する
