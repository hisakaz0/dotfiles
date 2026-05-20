local で test, fmt, lint をパスする

* タスクを実行するとき timeout を10分に伸ばしてください
* このブランチの内容を `git diff origin/main...HEAD --name-only` と `git status` の両方で確認し、serverやtsiproxy等のサブディレクトリなど変更があったディレクトリに移動し make を実行してください

## 作業

1. 次の make ターゲットが実行していないか確認する。実行している場合は終了するまで待機する。
    * 確認方法: `pgrep -af 'make (fmt|lint_slow|golangci-lint|test)'`
    * 待機方法: `until ! pgrep -af 'make (fmt|lint_slow|golangci-lint|test)'; do sleep 30; done` で polling する（最大30分。30分経っても終わらない場合はユーザに通知して指示を仰ぐ）
    * 待機する理由: 1マシンで並列開発しているため、以下の重たい処理が同時に実行するとマシンが重たくなり、雑務ができなくなるため。
2. make ターゲットをリストの上から順に1つずつ実行する
    * 変更があったディレクトリが複数ある場合は、1つのディレクトリで全ターゲット（fmt→lint_slow→golangci-lint→test）を完了してから次のディレクトリへ移る
3. エラーを修正し、問題がなくなるまで Step 1 から繰り返す。
    * Step 1 から再実行する理由: 修正作業中に他の開発で同じ make ターゲットが実行される可能性があるため、毎回 pgrep 確認を行う
    * 再開位置: make ターゲットは失敗したものから再開する（例: `lint_slow` で失敗したら `lint_slow` から再開し、それ以前のターゲットは再実行しない）

make ターゲット（この順で実行する。prefix/suffixなし、記載どおりのターゲット名で実行する）

1. `make fmt`
2. `make lint_slow`
3. `make golangci-lint`
4. `make test`

修正方法が分からない場合は、自己判断で試行せず即座に聞いてください。
