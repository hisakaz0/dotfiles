-- 保存時のフォーマット
--
-- conform.nvim。フォーマッタ本体は外部コマンドで管理する:
--   gofumpt  -> go install mvdan.cc/gofumpt@latest
--   prettier -> npm i -g prettier
--   shfmt    -> brew install shfmt
-- 対応するフォーマッタが無い filetype は LSP のフォーマットにフォールバックする。
--
-- 一時的に無効化したいときは <leader>uf でトグルする (config/keymaps.lua)。

return {
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = 'ConformInfo',
    opts = {
      formatters_by_ft = {
        go = { 'gofumpt' },
        typescript = { 'prettier' },
        typescriptreact = { 'prettier' },
        javascript = { 'prettier' },
        javascriptreact = { 'prettier' },
        -- graphql は prettier ではなく biome で整形する。
        -- erp リポジトリが biome.jsonc (lineWidth 320 / indentStyle space) を置いており、
        -- server/scripts/fmt.sh も biome で .graphql を整形するため。
        graphql = { 'biome' },
        yaml = { 'prettier' },
        json = { 'prettier' },
        jsonc = { 'prettier' },
        markdown = { 'prettier' },
        css = { 'prettier' },
        html = { 'prettier' },
        sh = { 'shfmt' },
        bash = { 'shfmt' },
        zsh = { 'shfmt' },
      },
      format_on_save = function(bufnr)
        -- <leader>uf でのトグル、および巨大ファイルでは保存時整形をしない
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        return { timeout_ms = 3000, lsp_format = 'fallback' }
      end,
      formatters = {
        biome = {
          -- biome.json{,c} を持つプロジェクトでだけ動かす。
          -- 設定が無いリポジトリで biome の既定値を勝手に当てないため
          require_cwd = true,
        },
        shfmt = {
          prepend_args = { '-i', '2', '-ci' }, -- インデント2、case もインデントする
        },
      },
    },
  },
}
