-- Markdown
--
-- 2種類を併用する:
--   render-markdown.nvim  : バッファ内で見出し・表・箇条書きを整形表示 (編集しながら見る用)
--   markdown-preview.nvim : ブラウザでライブプレビュー (mermaid を図として見る用)
--
-- コードフェンス内 (```go / ```graphql / ```mermaid など) のシンタックスハイライトは
-- treesitter の injection が担当する。対応パーサは lua/plugins/treesitter.lua で導入済み。

return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    ft = { 'markdown' },
    opts = {
      file_types = { 'markdown' },
      -- コードブロックを枠で囲んで言語名を出す
      code = {
        style = 'full',
        width = 'block',
        left_pad = 1,
        right_pad = 1,
      },
      heading = {
        sign = false,
        position = 'inline',
      },
      -- LaTeX は latex2text が必要なので使わない
      latex = { enabled = false },
      -- 挿入モードでは素のテキストにして編集しやすくする
      render_modes = { 'n', 'v', 'i', 'c' },
      anti_conceal = { enabled = true },
    },
    keys = {
      { '<leader>mr', '<Cmd>RenderMarkdown toggle<CR>', desc = 'Markdown レンダリングを開閉' },
    },
  },

  {
    'iamcco/markdown-preview.nvim',
    ft = { 'markdown' },
    cmd = { 'MarkdownPreview', 'MarkdownPreviewStop', 'MarkdownPreviewToggle' },
    -- プリビルドのプレビュー用バイナリを取得する。yarn は不要
    build = function()
      vim.cmd('Lazy load markdown-preview.nvim')
      vim.fn['mkdp#util#install']()
    end,
    init = function()
      vim.g.mkdp_auto_close = 0 -- バッファを離れてもプレビューを閉じない
      vim.g.mkdp_filetypes = { 'markdown' }
      vim.g.mkdp_theme = 'dark'
    end,
    keys = {
      { '<leader>mp', '<Cmd>MarkdownPreviewToggle<CR>', desc = 'Markdown プレビュー (ブラウザ)' },
    },
  },
}
