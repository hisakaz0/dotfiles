> e2e をパスさせる: $ARGUMENTS

e2e テストが失敗します。ultrathink で原因を調査し、修正してください。
$ARGUMENTS がない場合は即時終了してください。

* プランモードで開始してください
* 修正する前に、確認を取ってください
* テストを開始する前に、 `make deploy_e2e_a1` を実行してください
* テストの graphql に変更を加えた場合は、`scripts/lib/gqlgenc_e2e_client.sh <path>` を実行してください。
* テストは `scripts/e2e.sh` <path> を使って実行してください。
* deadline exceeded 系のエラーはリトライで治ります
    * 失敗したテストだけ実行して、問題ないか一応確認してください。
