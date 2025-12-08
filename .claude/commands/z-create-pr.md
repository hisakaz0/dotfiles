PRテンプレートに沿ってDraft PRを作成し、Geminiレビューを待機してください。

次の手順で実行してください。

1. `git status` でブランチ名を確認する
2. `git log main..HEAD --oneline` でコミット履歴を確認する
3. `git diff main...HEAD --stat` で変更内容を確認する
4. 上記の情報から、PRテンプレート（`.github/pull_request_template.md`）に沿ったPR本文を生成する
   - チェックシートは**すべてチェック済み（`[x]`）**にする
   - 背景と課題を簡潔に記述する
   - 実装内容を箇条書きで記述する
5. **必ず**PRをユーザーに確認してもらう
   - タイトル、本文
6. ユーザーの承認後、ブランチをpush（まだの場合）：`git push -u origin <branch-name>`
7. Draft状態でPRを作成：`gh pr create --draft --title "..." --body "..."`
8. PR番号を取得し、`/gemini review` コメントを投稿：`gh pr comment <PR番号> --body "/gemini review"`
9. Geminiからのレビューが投稿されるまで**foregroundで待機**する
   - 60秒ごとにレビューコメントの有無をチェック
   - レビューが投稿されたら、レビュー内容を表示して終了
   - 最大10分まで待機

注意事項：
- PRの内容確認は**必須**です。ユーザーの承認なしにPRを作成しないでください
- PRは必ずDraft状態で作成してください
- Geminiのレビュー待機中は、タイムアウト（10分）するまでforegroundで待ち続けてください
