local function augroup(name)
  return vim.api.nvim_create_augroup('config-' .. name, { clear = true })
end

----------------------------------------------------------------------
-- LSP
----------------------------------------------------------------------
vim.api.nvim_create_autocmd('LspAttach', {
  group = augroup('lsp-attach'),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then
      return
    end

    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, desc = 'LSP: ' .. desc })
    end

    -- コードジャンプ
    map('n', 'gd', vim.lsp.buf.definition, '定義へジャンプ')
    map('n', 'gD', vim.lsp.buf.declaration, '宣言へジャンプ')
    map('n', 'gi', vim.lsp.buf.implementation, '実装へジャンプ')
    map('n', 'gy', vim.lsp.buf.type_definition, '型定義へジャンプ')
    map('n', 'gr', function()
      require('fzf-lua').lsp_references()
    end, '参照一覧')

    -- シンボルのリネーム
    map('n', '<F2>', vim.lsp.buf.rename, 'シンボルをリネーム')
    map('n', '<leader>cr', vim.lsp.buf.rename, 'シンボルをリネーム')

    -- その他
    map({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, 'コードアクション')
    map('n', '<leader>cf', function()
      require('conform').format({ async = true, lsp_format = 'fallback' })
    end, 'フォーマット')
    map('n', 'K', vim.lsp.buf.hover, 'ホバー')
    map('n', '<leader>cd', vim.diagnostic.open_float, '診断を表示')

    -- インレイヒント (型注釈などを薄く表示する)。<leader>uh でトグル
    if client:supports_method('textDocument/inlayHint') then
      vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
      map('n', '<leader>uh', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf }), { bufnr = ev.buf })
      end, 'インレイヒントをトグル')
    end

    -- Neovim 組み込みの LSP 補完を使う (補完プラグインは入れていない)
    -- <C-n> / <C-p> で候補を選択、<C-y> で確定
    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
  end,
})

-- Go: 保存時に import を整理する (gopls の code action を使う)
vim.api.nvim_create_autocmd('BufWritePre', {
  group = augroup('go-organize-imports'),
  pattern = '*.go',
  callback = function(ev)
    local clients = vim.lsp.get_clients({ bufnr = ev.buf, name = 'gopls' })
    if #clients == 0 then
      return
    end
    local encoding = clients[1].offset_encoding or 'utf-16'
    local params = vim.lsp.util.make_range_params(0, encoding)
    params.context = { only = { 'source.organizeImports' }, diagnostics = {} }

    local results = vim.lsp.buf_request_sync(ev.buf, 'textDocument/codeAction', params, 2000)
    for _, res in pairs(results or {}) do
      for _, action in pairs(res.result or {}) do
        if action.edit then
          vim.lsp.util.apply_workspace_edit(action.edit, encoding)
        end
      end
    end
  end,
})

----------------------------------------------------------------------
-- ファイルタイプ固有の設定
----------------------------------------------------------------------

-- Go は gofmt の仕様どおりタブインデント
vim.api.nvim_create_autocmd('FileType', {
  group = augroup('ft-go'),
  pattern = 'go',
  callback = function()
    vim.bo.expandtab = false
    vim.bo.tabstop = 4
    vim.bo.shiftwidth = 4
  end,
})

-- Makefile はタブでなければ動かない
vim.api.nvim_create_autocmd('FileType', {
  group = augroup('ft-make'),
  pattern = 'make',
  callback = function()
    vim.bo.expandtab = false
  end,
})

-- Markdown は折り返して読む
vim.api.nvim_create_autocmd('FileType', {
  group = augroup('ft-markdown'),
  pattern = 'markdown',
  callback = function()
    vim.wo.wrap = true
    vim.wo.linebreak = true
    vim.bo.textwidth = 0
  end,
})

-- ヘルプや quickfix は q で閉じる
vim.api.nvim_create_autocmd('FileType', {
  group = augroup('close-with-q'),
  pattern = { 'help', 'qf', 'checkhealth', 'lspinfo', 'man' },
  callback = function(ev)
    vim.bo[ev.buf].buflisted = false
    vim.keymap.set('n', 'q', '<Cmd>close<CR>', { buffer = ev.buf, silent = true })
  end,
})

-- ターミナルは行番号を消す
vim.api.nvim_create_autocmd('TermOpen', {
  group = augroup('term-open'),
  callback = function()
    vim.wo.number = false
    vim.wo.signcolumn = 'no'
  end,
})

----------------------------------------------------------------------
-- 使い勝手
----------------------------------------------------------------------

-- ヤンクした範囲を一瞬光らせる
vim.api.nvim_create_autocmd('TextYankPost', {
  group = augroup('highlight-yank'),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- 前回のカーソル位置を復元する
vim.api.nvim_create_autocmd('BufReadPost', {
  group = augroup('restore-cursor'),
  callback = function(ev)
    if vim.bo[ev.buf].filetype == 'gitcommit' then
      return
    end
    local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(ev.buf) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})
