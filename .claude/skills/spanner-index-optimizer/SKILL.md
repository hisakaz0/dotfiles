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
* https://docs.cloud.google.com/spanner/docs/secondary-indexes?hl=ja
  * テーブルのキーはセカンダリインデックスに含めない
    * ただし、キーを `DESC` でソートする場合は含める必要がある
  * WHERE句やON句の条件に対してインデックスを追加する場合は `DESC` は付ける必要はない
  * 数千以下のデータを絞り込むために、インデックスは追加しない
  * JOIN後にデータを SELECT する場合、そのデータが多量の場合はバック結合が発生しないように `STORING` するか検討する
    * https://docs.cloud.google.com/spanner/docs/query-execution-plans?hl=ja#index_and_back_join_queries

## ステップ2: 与えられたクエリに対して最適なクエリを検討する

* https://docs.cloud.google.com/spanner/docs/reference/standard-sql/query-syntax#hints
  * FORCE_INDEX等のヒントは使わない

