-- CSV / TSV
--
-- 2種類を併用する (性質が違うため):
--   rainbow_csv   : 列ごとの虹色ハイライト。VSCode の Rainbow CSV と同じ作者・同じ思想。
--                   RBQL (SQL 風クエリ) で :Select / :Update も使える。
--   csvview.nvim  : virtual text で列を整列させて表形式に見せる。必要なときだけトグルする。
--
-- treesitter の csv パーサは意図的に入れていない (rainbow_csv のハイライトと衝突するため)。

return {
  {
    'mechatroner/rainbow_csv',
    ft = { 'csv', 'tsv', 'psv' },
  },

  {
    'hat0uma/csvview.nvim',
    ft = { 'csv', 'tsv', 'psv' },
    cmd = { 'CsvViewEnable', 'CsvViewDisable', 'CsvViewToggle' },
    opts = {
      parser = { comments = { '#', '//' } },
      view = {
        display_mode = 'border', -- 列の区切りを罫線で表示する
        header_lnum = 1, -- 1行目をヘッダとして固定表示する
      },
      keymaps = {
        -- セル単位の移動 (Excel 風)
        textobject_field_inner = { 'if', mode = { 'o', 'x' } },
        textobject_field_outer = { 'af', mode = { 'o', 'x' } },
        jump_next_field_end = { '<Tab>', mode = { 'n', 'v' } },
        jump_prev_field_end = { '<S-Tab>', mode = { 'n', 'v' } },
        jump_next_row = { '<Enter>', mode = { 'n', 'v' } },
        jump_prev_row = { '<S-Enter>', mode = { 'n', 'v' } },
      },
    },
  },
}
