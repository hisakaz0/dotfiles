-- 曖昧ファイル検索 (VSCode の Ctrl-P 相当)
--
-- fzf-lua を使う。既にインストール済みの fzf バイナリと fd/rg をそのまま利用するので
-- 追加のビルドや依存が無く、大きいリポジトリでも速い。

return {
  {
    'ibhagwan/fzf-lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    cmd = 'FzfLua',
    keys = {
      -- ファイル検索
      { '<C-p>', function() require('fzf-lua').files() end, desc = 'ファイル検索' },
      { '<leader>ff', function() require('fzf-lua').files() end, desc = 'ファイル検索' },
      { '<leader>fr', function() require('fzf-lua').oldfiles() end, desc = '最近開いたファイル' },
      { '<leader>fb', function() require('fzf-lua').buffers() end, desc = 'バッファ一覧' },
      { '<leader><leader>', function() require('fzf-lua').buffers() end, desc = 'バッファ一覧' },
      -- 検索系
      { '<leader>fg', function() require('fzf-lua').live_grep() end, desc = '全文検索 (インクリメンタル)' },
      { '<leader>fw', function() require('fzf-lua').grep_cword() end, desc = 'カーソル位置の単語を検索' },
      { '<leader>fl', function() require('fzf-lua').blines() end, desc = 'バッファ内の行検索' },
      -- LSP / 診断
      { '<leader>fs', function() require('fzf-lua').lsp_document_symbols() end, desc = 'シンボル一覧 (ファイル)' },
      { '<leader>fS', function() require('fzf-lua').lsp_live_workspace_symbols() end, desc = 'シンボル一覧 (プロジェクト)' },
      { '<leader>fd', function() require('fzf-lua').diagnostics_workspace() end, desc = '診断一覧' },
      -- その他
      { '<leader>fh', function() require('fzf-lua').helptags() end, desc = 'ヘルプ検索' },
      { '<leader>fk', function() require('fzf-lua').keymaps() end, desc = 'キーマップ一覧' },
      { '<leader>fc', function() require('fzf-lua').resume() end, desc = '直前の検索を再開' },
    },
    config = function()
      local fzf = require('fzf-lua')
      fzf.setup({
        'default', -- プロファイル。速度優先なら 'max-perf' に変更する
        winopts = {
          height = 0.85,
          width = 0.85,
          preview = { layout = 'flex', scrollbar = false },
        },
        files = {
          -- .gitignore を尊重し、隠しファイルも対象にする
          fd_opts = [[--color=never --type f --hidden --follow --exclude .git]],
        },
        oldfiles = {
          include_current_session = true, -- 現在のセッションで開いたファイルも履歴に含める
        },
      })
      -- vim.ui.select を fzf-lua に置き換える (LSP の code action 選択等が快適になる)
      fzf.register_ui_select()
    end,
  },
}
