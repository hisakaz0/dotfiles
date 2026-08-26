-- 全文検索・一括置換 (VSCode の Search パネル相当)
--
-- grug-far.nvim。専用バッファが開き、以下の欄を埋めて検索する:
--   Search       : 検索語 (rg のパターン)
--   Replace      : 置換後の文字列 (空なら検索のみ)
--   Files Filter : 対象を絞る glob   例) *.go   src/**/*.ts
--   Flags        : rg のフラグ       例) --hidden --glob=!**/node_modules/** --glob=!**/vendor/**
--   Paths        : 検索対象パス      例) internal/ cmd/   (空なら cwd。複数指定可)
--
-- 検索結果のバッファをそのまま編集して <localleader>r で一括置換できる。

return {
  {
    'MagicDuck/grug-far.nvim',
    cmd = { 'GrugFar', 'GrugFarWithin' },
    keys = {
      {
        '<leader>ss',
        function()
          require('grug-far').open()
        end,
        desc = '全文検索・一括置換',
      },
      {
        '<leader>s',
        function()
          require('grug-far').with_visual_selection()
        end,
        mode = 'v',
        desc = '選択範囲で全文検索',
      },
      {
        '<leader>sf',
        function()
          -- 現在のファイル内だけを対象にする
          require('grug-far').open({ prefills = { paths = vim.fn.expand('%') } })
        end,
        desc = '現在のファイル内を検索・置換',
      },
    },
    config = function()
      require('grug-far').setup({
        engine = 'ripgrep',
        -- 除外の常用パターンを初期値に入れておく (検索バッファ上で編集可能)
        prefills = {
          flags = '--hidden --glob=!**/.git/** --glob=!**/node_modules/** --glob=!**/vendor/**',
        },
        windowCreationCommand = 'tabnew %', -- 別タブで開いて作業中のレイアウトを壊さない
      })
    end,
  },
}
