-- Markdown
--
-- プレビューは gh の拡張 gh-markdown-preview に任せる (Neovim プラグインは使わない)。
-- GitHub の Markdown API とスタイルで描画するので、GitHub 上の見た目と一致する。
-- mermaid も GitHub 側が図として描画する。ファイル変更を監視してライブリロードする。
--
--   インストール: gh extension install yusukebe/gh-markdown-preview
--   https://github.com/yusukebe/gh-markdown-preview
--
-- コードフェンス内 (```go / ```graphql / ```mermaid など) のシンタックスハイライトは
-- treesitter の injection が担当する。対応パーサは lua/plugins/treesitter.lua で導入済み。

-- 起動中のプレビューサーバ (ファイルパス -> job id)
local servers = {}

--- 現在のバッファの Markdown プレビューを開閉する
local function toggle_preview()
  local file = vim.fn.expand('%:p')
  if file == '' then
    vim.notify('保存していないバッファはプレビューできません', vim.log.levels.ERROR)
    return
  end

  -- 起動中なら止める
  local running = servers[file]
  if running then
    vim.fn.jobstop(running)
    servers[file] = nil
    vim.notify('Markdown プレビューを停止しました')
    return
  end

  if vim.fn.executable('gh') == 0 then
    vim.notify('gh が見つかりません', vim.log.levels.ERROR)
    return
  end

  -- gh markdown-preview は監視対象やポートの情報を stderr へ出すため、
  -- stderr を拾って通知しない (通知するとプレビューを開く度にノイズになる)。
  -- 接続先はブラウザが自動で開くので Neovim 側で知る必要もない。
  local stderr = {}
  local job = vim.fn.jobstart({ 'gh', 'markdown-preview', file }, {
    on_stderr = function(_, data)
      vim.list_extend(stderr, data or {})
    end,
    on_exit = function(_, code)
      -- サーバは開いている間動き続けるので、終了時に管理表から外す
      local stopped = servers[file] == nil
      servers[file] = nil
      -- 自分で停止した場合を除き、異常終了だけ stderr を添えて知らせる
      if not stopped and code ~= 0 then
        vim.notify(
          ('gh markdown-preview が終了しました (code %d)\n%s'):format(code, vim.trim(table.concat(stderr, '\n'))),
          vim.log.levels.ERROR
        )
      end
    end,
  })
  if job <= 0 then
    vim.notify('gh markdown-preview の起動に失敗しました', vim.log.levels.ERROR)
    return
  end

  servers[file] = job
  vim.notify('Markdown プレビューを開きました: ' .. vim.fn.fnamemodify(file, ':t'))
end

-- Neovim を閉じるときにサーバを残さない
vim.api.nvim_create_autocmd('VimLeavePre', {
  group = vim.api.nvim_create_augroup('markdown-preview-cleanup', { clear = true }),
  callback = function()
    for file, job in pairs(servers) do
      -- 先に管理表から外して、終了通知を出さずに止める
      servers[file] = nil
      pcall(vim.fn.jobstop, job)
    end
  end,
})

vim.keymap.set('n', '<leader>mp', toggle_preview, { desc = 'Markdown プレビューを開閉 (gh markdown-preview)' })
