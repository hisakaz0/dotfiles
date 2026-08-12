---
description: 指定セッションIDの会話ログを読み、進捗・残り作業・ゴール・背景・作業概要を新規セッション向けの引き継ぎファイルとして ~/.claude/specs/ に書き出す
argument-hint: <セッションID>
allowed-tools: Bash, Read, Write, Agent
---

引数のセッションID「$ARGUMENTS」の会話ログを読み取り、そのセッションの **作業進捗・残り作業・ゴール・背景・作業概要** を1つのマークダウンファイルにまとめてください。

このファイルの読み手は **前提知識ゼロの新規セッション** です。時系列の作業ナレーション（「まずXした、次にYした」）ではなく、**新規セッションがこのファイルだけを読んで作業を再開できる引き継ぎ資料** として書いてください。

## 手順

### 1. セッションファイルの特定

セッションログは `~/.claude/projects/<エンコード済みパス>/<セッションID>.jsonl` にあります。ファイルパスを特定します。

```bash
SID="$ARGUMENTS"
F=$(find ~/.claude/projects -name "${SID}.jsonl" -type f 2>/dev/null | head -1)
[ -z "$F" ] && echo "セッション ${SID} が見つかりません" && exit 1
echo "$F"; wc -l "$F"
```

見つからない場合はその旨を伝えて終了します。

### 2. 会話本体を中間ファイルへ抽出（メインコンテキストを汚さない）

セッションファイルは数MB規模になるため、**`.jsonl` 本体をメインコンテキストで Read しません**。先に `jq` で会話本体だけを役割ラベル付きで抽出し、scratchpad の中間ファイルに落とします。

抽出対象と注意点:
- **user**: `content` が string の場合はそのまま、array の場合は `type=="text"` ブロックのみ（`tool_result` は除外）
- **assistant**: array の `type=="text"` ブロックと、`type=="tool_use"` の `.name`（「何をしたか」のシグナルとして `[tool: <name>]` の形で残す）
- **除外するノイズ**: `<local-command-caveat>` / `<command-name>` 等のコマンドラッパー行、`attachment` / `system` / `file-history-snapshot` / `ai-title` / `mode` 等の非会話 type、system-reminder

```bash
OUT=$(mktemp -p /var/tmp/AgentsSandbox session-extract.XXXXXX.txt)
jq -r '
  if .type=="user" then
    (if (.message.content|type=="string") then "USER: "+.message.content
     else (.message.content[]? | select(.type=="text") | "USER: "+.text) end)
  elif .type=="assistant" then
    (.message.content[]? |
      if .type=="text" then "ASSISTANT: "+.text
      elif .type=="tool_use" then "ASSISTANT [tool: "+.name+"]"
      else empty end)
  else empty end
' "$F" 2>/dev/null \
  | grep -v 'local-command-caveat' \
  | grep -v '<command-name>' \
  | grep -v 'system-reminder' \
  > "$OUT"
echo "抽出先: $OUT"; wc -l "$OUT"; wc -c "$OUT"
```

あわせてメタ情報を取得します（引き継ぎに必須）。`gitBranch` はセッション途中で変わるため **最後の値** を採用します。

```bash
echo "=== 最終 gitBranch ==="; jq -r 'select(.gitBranch!=null) | .gitBranch' "$F" 2>/dev/null | tail -1
echo "=== cwd ==="; jq -r 'select(.cwd!=null) | .cwd' "$F" 2>/dev/null | tail -1
echo "=== pr-link ==="; jq -r 'select(.type=="pr-link") | (.url // .prLink // .)' "$F" 2>/dev/null
echo "=== 開始/終了時刻 ==="; jq -r 'select(.timestamp!=null) | .timestamp' "$F" 2>/dev/null | sed -n '1p;$p'
```

### 3. 抽出ファイルの読み込みと要約（サブエージェントに委譲）

**メインコンテキストを汚染しないため**、中間ファイルの読み込みと要約は Agent ツール（`subagent_type=general-purpose`）に委譲します。中間ファイルが大きい場合、サブエージェント側で Read の `offset` を使い、末尾（＝直近の作業状況）を重点的に読むよう指示します。

サブエージェントへのプロンプト（メタ情報を埋め込んで渡す）:

```
以下は Claude Code セッションの会話本体を役割ラベル付きで抽出したテキストです。
これを読み、前提知識ゼロの新規セッションが作業を再開できる引き継ぎ資料の本文（マークダウン）を作成してください。

抽出ファイル: <$OUT の絶対パス>
セッションのメタ情報:
- cwd: <cwd>
- 最終 gitBranch: <最終 gitBranch>
- PR: <pr-link があれば URL、なければ「なし」>
- 期間: <開始時刻> 〜 <終了時刻>

ファイルが大きい場合は、冒頭（ゴール・背景の把握）と末尾（直近の進捗・次の一手の把握）を優先して読み、中盤は流し読みでよい。

以下のセクション構成・見出しのマークダウン本文だけを返すこと（前後の説明文は不要）:

## ゴール
このセッションが達成しようとしている最終目的を1〜3文で。

## 背景
なぜこの作業が必要か。前提となる状況・課題を簡潔に。

## 作業概要
何をどう解決しようとしているかのアプローチを箇条書きで。

## 完了した作業
このセッションで既に終わった作業を箇条書きで。変更したファイルは `path:line` 形式で示す。

## 残り作業（次の一手）
新規セッションが最初にやるべきことから順に、具体的な箇条書きで。曖昧な表現を避け、コマンドやファイルパスを添える。

## 現在の状態
- ブランチ: <最終 gitBranch>
- 作業ディレクトリ: <cwd>
- PR: <あれば URL>
- 未コミットの変更や実行中の処理・ブロッカーがあれば明記
- 動作確認・ビルド・テストの最新状況

## 参照
関連するファイル・ドキュメント・コマンド・スキルへのポインタ。
```

### 4. ファイルへ書き出し

サブエージェントが返したマークダウン本文の先頭にタイトル（H1）とメタ情報を付け、`~/.claude/specs/{YYYY-mm-dd}-{slug}.md` に保存します。

- `{YYYY-mm-dd}`: **このコマンドを実行した当日の日付**（セッションの日付ではない）。`date +%Y-%m-%d` で取得する。
- `{slug}`: セッションの主題から付ける **英単語3語のケバブケース**（例: `fix-flaky-e2e`）。

冒頭に付けるヘッダ例:

```markdown
# <セッションの主題を表すタイトル>

- 元セッション: `/resume <セッションID>`
- 作成日: <YYYY-mm-dd>
- ブランチ: <最終 gitBranch>
- cwd: <cwd>

（以下、サブエージェントが返した本文）
```

保存後、書き出したファイルの絶対パスをユーザに1行で伝えます（`~/.claude/specs/2026-07-12-xxx.md` 形式、コードジャンプできる表現で）。
ファイルパスの1行以外は出力しないでください。

## 注意

- `.jsonl` 本体をメインコンテキストで Read しない（数MB規模のため）。抽出は `jq`、読み込みはサブエージェントに委譲する。
- 日付は **実行当日**、セッションの記録日ではない。
- slug は必ず英単語3語のケバブケース。
- 引き継ぎ資料なので **時系列ナレーションではなく前向きの作業指示** を書く（「残り作業」「現在の状態」を厚く）。
- 受動態を避け能動態で書く（主語と目的語を明確にする）。
