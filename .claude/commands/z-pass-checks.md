local で test, fmt, lint をパスする

* タスクを実行するとき timeout を10分に伸ばしてください
* このブランチの内容を `git diff origin/main...HEAD --name-only` と `git status` の両方で確認し、serverやtsiproxy等のサブディレクトリなど変更があったディレクトリに移動し make を実行してください

## 作業

1. make ターゲットをリストの上から順に1つずつ実行する
    * 各 make ターゲットは必ず `flock /tmp/erp-longtask` でラップして実行する（例: `cd server && flock /tmp/erp-longtask make fmt`）
    * flock を使う理由: 1マシンで並列開発しているため、これらの重たい処理が同時に実行するとマシンが重たくなり雑務ができなくなる。flock が同一ロック (`/tmp/erp-longtask`) を直列化し、他セッションの重い処理の終了を自動で待つ（手動の pgrep 待機ループは不要）
    * flock がロックを取れず10分以上待つ場合はユーザに通知して指示を仰ぐ
    * 変更があったディレクトリが複数ある場合は、1つのディレクトリで全ターゲット（fmt→lint_slow→golangci-lint→test）を完了してから次のディレクトリへ移る
2. エラーを修正し、問題がなくなるまで繰り返す。
    * 再開位置: make ターゲットは失敗したものから再開する（例: `lint_slow` で失敗したら `lint_slow` から再開し、それ以前のターゲットは再実行しない）

make ターゲット（この順で実行する。prefix/suffixなし、記載どおりのターゲット名を `flock /tmp/erp-longtask` でラップして実行する）

1. `make test`
    * `make test` が Spanner エミュレータなどのコンテナ起因（CommitTimestamp とローカルクロックのズレ、エミュレータの一時的な応答不良など）で失敗する場合があれば、失敗したパッケージをリトライして直るかどうか確認してください。リトライして直る場合は無視してください。
    * リトライしても直らない場合、または変更内容に起因する失敗の場合は修正してください。
2. `make fmt`
3. `make lint_slow`
4. `make golangci-lint`

修正方法が分からない場合は、自己判断で試行せず即座に聞いてください。
