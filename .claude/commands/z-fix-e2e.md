> e2e をパスさせる

* プランモードで開始してください
* テストを開始する前にデプロイしてください。
* テストの graphql に変更を加えた場合は、`scripts/lib/gqlgenc_e2e_client.sh <path>` を実行してください。
* テストは `scripts/e2e.sh` <path> を使って実行してください。
    * `<path>` は `src/entrypoint/e2e/xxx/yyyy` 等のディレクトリ名を入力してください
* deadline exceeded 系のエラーはリトライで治ります
    * 失敗したテストだけ実行して、問題ないか一応確認してください。

## e2e環境にデプロイする

1. 変更が残っている場合、git add && git commit してください
2. デプロイしてください
    * make deploy_e2e_a1
    * ジョブを実行する場合は make deploy_job_e2e_a1 BATCH_PATH=/path/to/job
    * `schema.sql` を変更する場合は、止めて連絡してください

[!WARNING] e2eファイル以外を修正した場合、毎回デプロイが必要です