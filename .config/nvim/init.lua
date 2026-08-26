-- Neovim のエントリポイント
-- 読み込み順に意味があるので入れ替えないこと
--   1. options : mapleader をプラグイン読み込み前に確定させる
--   2. lazy    : プラグインを読み込む
--   3. keymaps : プラグイン提供のコマンドに割り当てる
--   4. autocmds: ファイルタイプ毎の設定
--   5. markdown: 外部コマンド (gh markdown-preview) による Markdown プレビュー
require('config.options')
require('config.lazy')
require('config.keymaps')
require('config.autocmds')
require('config.markdown')
