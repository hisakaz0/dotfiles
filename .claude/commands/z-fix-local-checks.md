local で test, fmt, lint をパスする

* auto approve モードに移動してください
* タスクを実行するとき timeout を10分に伸ばしてください
* このブランチの内容を確認し、serverやtsiproxy等のサブディレクトリなど変更があったディレクトリに移動し make を実行してください

## 作業
1. 次の make をそれぞれ実行してください
    * test
    * fmt
    * lint_slow
    * golangci-lint
2. エラーがでなくなる修正し make を続けてください

修正方法が分からない場合は聞いてください。
