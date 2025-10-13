
~/Works/buildbystack/erp/serverディレクトリでmake関連のタスクを実行して、変更があれば自動的にコミットしてください。

手順：
1. serverディレクトリに移動
2. `make lint_slow` を実行し、エラーがあれば修正してコミット（メッセージ: `make lint`）
4. `make_lint_very_slow`を実行し、エラーがあれば修正してコミット（メッセージ: `fix golangci-lint`）

各ステップで：
- コマンド実行前後でgit statusを確認
- 変更があれば該当ファイルをgit addしてコミット
- エラーがあれば報告して修正提案

修正方法がわからない場合は質問してください。
