-- リーダーキーはプラグイン読み込みより前に設定する必要がある
vim.g.mapleader = ' '
vim.g.maplocalleader = ','

local o = vim.o

-- 表示
o.number = true
o.signcolumn = 'yes' -- 診断マークで画面幅がガタつくのを防ぐ
o.cursorline = true
o.scrolloff = 4
o.splitright = true
o.splitbelow = true
o.winborder = 'rounded' -- フローティングウィンドウの枠線 (0.11+)
o.pumheight = 12
o.termguicolors = true

-- 検索
o.hlsearch = true
o.incsearch = true
o.ignorecase = true
o.smartcase = true

-- インデント (実際の整形は conform.nvim / LSP に任せる)
o.expandtab = true
o.tabstop = 2
o.shiftwidth = 2
o.smartindent = true

-- 編集
o.hidden = true
o.undofile = true -- アンドゥ履歴を永続化する
o.updatetime = 250
o.timeoutlen = 400
o.helplang = 'ja,en'

-- OS のクリップボードと共有する
vim.opt.clipboard:prepend('unnamed')

-- 補完 (Neovim 組み込みの LSP 補完で使う)
o.completeopt = 'menu,menuone,noselect,fuzzy'

-- 全文検索のバックエンドを ripgrep にする (:grep で使う)
if vim.fn.executable('rg') == 1 then
  o.grepprg = 'rg --vimgrep --smart-case'
  o.grepformat = '%f:%l:%c:%m'
end

-- 診断の表示方法
vim.diagnostic.config({
  virtual_text = { prefix = '●' },
  severity_sort = true,
  float = { border = 'rounded', source = true },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = 'E',
      [vim.diagnostic.severity.WARN] = 'W',
      [vim.diagnostic.severity.INFO] = 'I',
      [vim.diagnostic.severity.HINT] = 'H',
    },
  },
})
