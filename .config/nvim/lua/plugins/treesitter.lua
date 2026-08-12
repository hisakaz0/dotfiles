-- シンタックスハイライト (treesitter)
--
-- main ブランチを使う。master との違い:
--   * tree-sitter CLI (brew の tree-sitter-cli) と C コンパイラが必須
--   * ハイライトが自動で有効にならないので FileType autocmd で自分で起動する
--   * インデントは experimental なので使わず、整形は conform.nvim / LSP に任せる
--
-- csv / tsv のパーサは入れない。列ごとの虹色表示は rainbow_csv が担当し、
-- treesitter のハイライトと衝突させないため (lua/plugins/csv.lua を参照)

local parsers = {
  -- メモの要件
  'go',
  'graphql',
  'typescript',
  'tsx',
  'javascript',
  'yaml',
  'bash',
  'make',
  -- markdown とコードフェンス内のハイライト (mermaid / go 等の injection 用)
  'markdown',
  'markdown_inline',
  'mermaid',
  -- Go 周辺ファイル
  'gomod',
  'gosum',
  'gowork',
  -- 実務で開く頻度が高いもの
  'json',
  'toml',
  'hcl',
  'terraform',
  'dockerfile',
  'sql',
  'python',
  'diff',
  'gitcommit',
  'git_config',
  'git_rebase',
  -- Neovim 設定自体を書くため
  'lua',
  'vim',
  'vimdoc',
  'query',
}

return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false, -- ハイライトは常に必要なので遅延させない
    build = ':TSUpdate',
    config = function()
      local ts = require('nvim-treesitter')
      ts.setup()

      -- 未インストールのパーサだけ非同期で入れる
      -- (install() は既存分をスキップするが、起動毎にジョブを起こさないよう差分を取る)
      local installed = ts.get_installed('parsers')
      local missing = vim.tbl_filter(function(lang)
        return not vim.tbl_contains(installed, lang)
      end, parsers)
      if #missing > 0 then
        ts.install(missing)
      end

      -- main ブランチはハイライトを自前で有効化する必要がある
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('treesitter-start', { clear = true }),
        callback = function(ev)
          local lang = vim.treesitter.language.get_lang(ev.match)
          if not lang then
            return
          end
          -- パーサが未インストールの filetype は素の syntax にフォールバックさせる
          if not vim.tbl_contains(ts.get_installed('parsers'), lang) then
            return
          end
          pcall(vim.treesitter.start, ev.buf, lang)
          -- 折りたたみも treesitter ベースにする
          vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
          vim.wo.foldmethod = 'expr'
          vim.wo.foldlevel = 99 -- 開いた状態から始める
        end,
      })
    end,
  },
}
