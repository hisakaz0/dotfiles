local で test, fmt, lint をパスする

* auto approve モードに移動してください
* タスクを実行するとき timeout を10分に伸ばしてください
* serverやtsiproxy等のサブディレクトリに移動後、make を実行してください


## 作業
1. 次の make をそれぞれ実行してください
    * test
    * fmt
    * lint_slow
2. エラーがでなくなる修正し make を続けてください
3. 修正した場合は git add して git commit -m 'fix' してください
    * コミットは1つだけにしてください

修正方法が分からない場合は聞いてください。

