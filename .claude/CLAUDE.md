
# rule
* sed ではなく `gsed` を使ってください
* cat ではなく `gcat` を使ってください
* 関連する skill がある場合**必ず**使ってください
* rules は**必ず**守ってください
* go言語で、構造体に適当に値を設定したい場合は fillstruct を使ってください
  * https://github.com/nametake/fillstruct
* **python/sed/awkの利用は禁止です。** 大規模なファイルを編集する場合は、Edit/Search/Grepツールを使え
* タブやスペースの数が違ってもOK。最後にフォーマットを実行してください
* コードコメントは日本語で書いてください
* git commitするときは、co-author は**絶対に**付けないでください
* 調査やプラン検討は
  * 1つの関心事に2つ以上のエージェントで実行してください
    * それぞれのエージェントの調査結果や検討が一致するかチェックしてください
    * 一致しない場合は追加の調査・検討してください
  * 関心事はある程度の塊に分割し、並行して調査・統合するようにしてください
* 調査してもわからない知識は Web 検索してください
* `while true; do ... ; done` 禁止。sleepを使って手動でポーリングしてください。
* ビルドやテストのタイムアウトは10分に伸ばす
* 一時的なファイルやディレクトリを扱いたい場合
  * 一時ファイル: ` mktemp -p /var/tmp/AgentsSandbox`
  * 一時ディレクトリ: ` mktemp -d -p /var/tmp/AgentsSandbox`

# import
- @~/.claude/docs/karpathy-guidelines.md
