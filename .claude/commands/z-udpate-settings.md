claude/settings.json を整理する

planモードに変更してから進めてください。

次の2つのファイルを読んで整理してください。

1. ~/.claude/settings.json（グローバル設定）
2. ~/Works/buildbystack/erp/.claude/settings.local.json（プロジェクト固有設定、erp-1/erp-2はシンボリックリンク）

## 整理ルール

- 一般的なパーミッション（汎用CLIツール、WebFetch等）は 1 に配置する
- プロジェクト固有のパーミッション（相対パスのスクリプト等）は 2 に配置する
- 広いパターンが狭いパターンを包含する場合、狭い方を削除する（例: `Bash(go *)` があれば `Bash(go test *)` は不要）
- 1回限りのコマンド（フルパスやtmpファイル指定）は削除する
- 1 と 2 で重複するエントリは 2 から削除する

## 並び順ルール

項目を追加するときは、関連する項目の近くに配置してください。並び順がぐちゃぐちゃにならないようにしてください。

- `Bash(...)` はBashの近くに
- `WebFetch(...)` はWebFetchの近くに
- `Skill(...)` はSkillの近くに
- `Read(...)` はReadの近くに
- `Write(...)` はWriteの近くに
- 同じカテゴリ内では、既存の項目との関連性を考慮して配置する（例: `gh` 系は `gh` 系の近くに、`pnpm` 系は `pnpm` 系の近くに）

## ファイル構成

- `erp/.claude/settings.local.json` が実体ファイル
- `erp-1/.claude/settings.local.json` → シンボリックリンク（erp のものを参照）
- `erp-2/.claude/settings.local.json` → シンボリックリンク（erp のものを参照）
