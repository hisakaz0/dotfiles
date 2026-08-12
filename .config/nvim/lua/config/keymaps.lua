-- キーマップ (プラグイン固有のものは lua/plugins/*.lua の keys で定義している)
local map = vim.keymap.set

-- 検索ハイライトを消す
map('n', '<Esc>', '<Cmd>nohlsearch<CR>', { desc = '検索ハイライトを消す' })

-- 保存
map({ 'n', 'i' }, '<C-s>', '<Cmd>write<CR><Esc>', { desc = '保存' })

-- ウィンドウ移動
map('n', '<C-h>', '<C-w>h', { desc = '左のウィンドウへ' })
map('n', '<C-j>', '<C-w>j', { desc = '下のウィンドウへ' })
map('n', '<C-k>', '<C-w>k', { desc = '上のウィンドウへ' })
map('n', '<C-l>', '<C-w>l', { desc = '右のウィンドウへ' })

-- バッファ移動
map('n', '[b', '<Cmd>bprevious<CR>', { desc = '前のバッファ' })
map('n', ']b', '<Cmd>bnext<CR>', { desc = '次のバッファ' })
map('n', '<leader>bd', '<Cmd>bdelete<CR>', { desc = 'バッファを閉じる' })

-- ターミナル
map('t', '<Esc><Esc>', [[<C-\><C-n>]], { desc = 'ターミナルをノーマルモードへ' })

-- 保存時フォーマットの一時無効化
map('n', '<leader>uf', function()
  vim.g.disable_autoformat = not vim.g.disable_autoformat
  vim.notify('保存時フォーマット: ' .. (vim.g.disable_autoformat and 'OFF' or 'ON'))
end, { desc = '保存時フォーマットをトグル' })

-- 設定を再読み込みする (プラグインは対象外)
map('n', '<leader>ur', function()
  for name in pairs(package.loaded) do
    if name:match('^config%.') then
      package.loaded[name] = nil
    end
  end
  dofile(vim.env.MYVIMRC)
  vim.notify('設定を再読み込みしました')
end, { desc = '設定を再読み込み' })

----------------------------------------------------------------------
-- ワークスペース (VSCode の multi-root workspace 相当)
--
-- Neovim にはルートを複数同時にツリー表示する機能が無いので、
-- 「タブページ = 1ルート」として :tcd でタブローカルの cwd を切り替える。
-- ファイラー・ファイル検索・全文検索はいずれも cwd 基準なので、
-- タブを切り替えるだけで対象プロジェクトが切り替わる。
----------------------------------------------------------------------

--- 新しいタブをルート dir のワークスペースとして開く
---@param dir string
local function open_workspace(dir)
  dir = vim.fn.fnamemodify(vim.fn.expand(dir), ':p')
  if vim.fn.isdirectory(dir) == 0 then
    vim.notify('ディレクトリが見つかりません: ' .. dir, vim.log.levels.ERROR)
    return
  end
  vim.cmd('tabnew')
  vim.cmd('tcd ' .. vim.fn.fnameescape(dir))
  vim.cmd('Neotree show')
  vim.notify('ワークスペースを追加しました: ' .. dir)
end

vim.api.nvim_create_user_command('Workspace', function(opts)
  open_workspace(opts.args)
end, { nargs = 1, complete = 'dir', desc = '指定ディレクトリを新しいタブのルートとして開く' })

map('n', '<leader>wa', function()
  vim.ui.input({ prompt = 'ワークスペースに追加するディレクトリ: ', completion = 'dir' }, function(input)
    if input and input ~= '' then
      open_workspace(input)
    end
  end)
end, { desc = 'ワークスペースを追加 (新しいタブ)' })

map('n', '<leader>wc', function()
  vim.cmd('tcd %:p:h')
  vim.notify('このタブのルート: ' .. vim.fn.getcwd())
end, { desc = '現在のファイルの場所をこのタブのルートにする' })

map('n', '<leader>wp', function()
  vim.notify('このタブのルート: ' .. vim.fn.getcwd())
end, { desc = 'このタブのルートを表示' })

map('n', '<leader>wq', '<Cmd>tabclose<CR>', { desc = 'ワークスペース (タブ) を閉じる' })
map('n', ']w', '<Cmd>tabnext<CR>', { desc = '次のワークスペース' })
map('n', '[w', '<Cmd>tabprevious<CR>', { desc = '前のワークスペース' })
