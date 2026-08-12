-- LSP
--
-- Neovim 0.11+ の組み込み API (vim.lsp.config / vim.lsp.enable) を使う。
-- nvim-lspconfig は「各サーバの起動コマンドと root_dir の定義集」としてのみ使い、
-- 旧来の require('lspconfig').xxx.setup{} は使わない。
--
-- サーバ本体は Brewfile / npm / go install で管理する (mason.nvim は使わない):
--   gopls                        -> go install golang.org/x/tools/gopls@latest
--   vtsls                        -> npm i -g @vtsls/language-server
--   graphql-lsp                  -> npm i -g graphql-language-service-cli
--   yaml-language-server         -> brew install yaml-language-server
--   lua-language-server          -> brew install lua-language-server

return {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      -- サーバ個別の設定 (Neovim が nvim-lspconfig の定義へ上書きマージする)
      vim.lsp.config('gopls', {
        settings = {
          gopls = {
            gofumpt = true,
            staticcheck = true,
            usePlaceholders = true,
            analyses = {
              unusedparams = true,
              unusedwrite = true,
              nilness = true,
            },
            hints = {
              parameterNames = false, -- 呼び出し箇所に引数名を出すヒントは邪魔なので出さない
              assignVariableTypes = true,
              compositeLiteralFields = true,
              constantValues = true,
              functionTypeParameters = true,
            },
          },
        },
      })

      vim.lsp.config('lua_ls', {
        settings = {
          Lua = {
            runtime = { version = 'LuaJIT' },
            workspace = {
              checkThirdParty = false,
              -- Neovim 設定を書くときに vim.* を解決できるようにする
              library = vim.api.nvim_get_runtime_file('lua', true),
            },
            diagnostics = { globals = { 'vim' } },
            telemetry = { enable = false },
          },
        },
      })

      -- 有効化するサーバ
      -- 速度が気になったら 'vtsls' を 'tsgo' に差し替えて比較できる
      vim.lsp.enable({
        'gopls',
        'vtsls',
        'graphql',
        'yamlls',
        'lua_ls',
      })
    end,
  },
}
