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