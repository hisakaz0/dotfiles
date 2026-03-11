## 背景
### 現状
### 現状のままではこまること
## 対応

---
# AI Agent用ドキュメント

AIエージェントがこのIssueを実装する際のガイドライン。

下記は絶対に守って実装を進めること。

## Issueの読み方

- IssueのDescriptionに書いてあることは議論の決定事項になる
- IssueのCommentで発生した議論は最終的にDescriptionに反映される
- IssueのDescriptionとCommentに矛盾がある場合はDescriptionの内容が優先される
- IssueのCommentの内容は実装の補足情報として参照する
- 実装上考慮しなければならないことがあった場合はコード提案時にコードへコメントを残すこと
- 背景と要件を元に検討事項を考えてより良い方法がある場合は実装前に提案すること

## 確認方法

### 実装確認

- makeコマンドはrootディレクトリではなく1つしたのプロジェクトごとのディレクトリで実行すること

#### server等のGoプロジェクトの場合

- make fmt を実行してフォーマットを行う
- ビルドが通ることは make test で確認する
    - domain層しか変更していない場合のみ make test_domain を実行してテストが通ることを確認する
- Makefile を確認してgen_で始まる必要なコード生成コマンドを確認する
- Makefileを確認して該当のgen_admin_server等のコマンドが成功することを確認する
- 重いので **絶対にmake gen, make gen_client, make gen_server を使わないこと**

#### webadminの場合

- pnpm fmt を実行してフォーマットする
- pnpm codegen を実行してコードを生成する
- pnpm typecheck を実行して型エラーがないことを確認する

### 最終確認

下記は開発ステップ途中で実行すると重くなるため、最後にまとめて実行すること。

- make fmt を実行してフォーマットを行う
- make test を実行してテストが通ることを確認する
- make lint_slow を実行してLintエラーがないことを確認する
- go run github.com/golangci/golangci-lint/v2/cmd/golangci-lint@vX.X.X run --fix でLintエラーがないことを確認する
    - バージョンはUserMemoryやMakefileを参考にする

## 開発ステップ

- 必要な情報を取得する
- プランニングを行う
- 実装
- make test を実行してテストが通ることを確認する
- E2Eに影響がある場合は実行して動作確認する
