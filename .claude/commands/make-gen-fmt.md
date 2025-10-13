
~/Works/buildbystack/erp/serverディレクトリでmake関連のタスクを実行して、変更があれば自動的にコミットしてください。

手順：
1. serverディレクトリに移動
2. `make gen` を実行し、差分があればコミット（メッセージ: `make gen`）
3. `make fmt` を実行し、差分があればコミット（メッセージ: `make fmt`）

各ステップで：
- コマンド実行前後でgit statusを確認
- 変更があれば該当ファイルをgit addしてコミット
- エラーがあれば報告して修正提案
