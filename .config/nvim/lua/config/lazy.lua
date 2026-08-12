-- lazy.nvim のブートストラップ
-- 初回起動時に自動で clone するので、新しいマシンでも追加作業は不要
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local repo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', repo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'lazy.nvim の clone に失敗しました:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  -- lua/plugins/*.lua を全て読み込む
  spec = { { import = 'plugins' } },
  -- バージョンは lazy-lock.json で固定する (dotfiles に commit 済み)
  lockfile = vim.fn.stdpath('config') .. '/lazy-lock.json',
  install = { colorscheme = { 'habamax' } },
  checker = { enabled = false }, -- 起動時の更新チェックはしない (起動を速く保つ)
  change_detection = { notify = false },
  performance = {
    rtp = {
      disabled_plugins = { 'gzip', 'tarPlugin', 'tohtml', 'zipPlugin', 'tutor' },
    },
  },
})
