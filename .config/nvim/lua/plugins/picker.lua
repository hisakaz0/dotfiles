-- 曖昧ファイル検索 (VSCode の Ctrl-P 相当)
--
-- fzf-lua を使う。既にインストール済みの fzf バイナリと fd/rg をそのまま利用するので
-- 追加のビルドや依存が無く、大きいリポジトリでも速い。
--
-- キーの役割分担
--   <C-p>             開いているバッファ + 最近開いたファイル + cwd 以下の全ファイル (combine)
--   <C-S-p>           コマンドパレット (VSCode の Ctrl-Shift-P 相当)
--   <leader><leader>  バッファ一覧
--
-- 個別のピッカーは :FzfLua <Tab> から呼べる (例 :FzfLua live_grep / :FzfLua keymaps)

----------------------------------------------------------------------
-- query 末尾の :line:col への対応
--
-- `server/src/domain/foo.go:568` のような文字列 (Claude Code や CI ログの出力形式)
-- をそのままファイル検索に貼り付けても候補が出て、選択でその行へ飛べるようにする。
--
-- 素の fzf は query の全文字を候補にマッチさせるため、`:568` の 4 文字が
-- パスに存在せず候補が 0 件になる。そこで fzf の transform-search で
-- 「検索に使う文字列」からだけ行番号を落とし、表示上の query ({q}) は元のまま残す。
-- fzf-lua は accept 時に {q} を opts.last_query へ渡すので、そこから行番号を読む。
--
-- fzf-lua には同じ用途の line_query オプションがあるが、行の適用が
-- path.entry_to_file 内の FzfLua.get_info().query 経由になっており、
-- accept 時の opts が行を持たないため自前で組む。
----------------------------------------------------------------------

-- 検索文字列から末尾の :line / :line:col を落とす (表示上の query は変えない)
local STRIP_LINE_BIND = [[transform-search(printf %s {q} | sed -E 's/:[0-9]+(:[0-9]+)?$//')]]

--- カーソルを line:col へ移動する
---@param line integer?
---@param col integer?
local function jump_to(line, col)
  if not line then
    return
  end
  local last = vim.api.nvim_buf_line_count(0)
  vim.api.nvim_win_set_cursor(0, { math.min(line, last), math.max((col or 1) - 1, 0) })
  vim.cmd('normal! zz')
end

--- query 末尾の :line:col を解釈するピッカー用オプションを返す
---@param extra table? 追加のオプション
---@return table
local function line_aware(extra)
  return vim.tbl_deep_extend('force', {
    keymap = {
      fzf = {
        -- start も入れるのは、query を prefill して開いた場合に change が発火しないため
        ['start'] = STRIP_LINE_BIND,
        ['change'] = STRIP_LINE_BIND,
      },
    },
    actions = {
      ['enter'] = function(selected, o)
        if not selected or not selected[1] then
          return
        end
        -- opts.last_query は accept 時点の query ({q})。行番号を落としていないので読める
        local line, col = tostring(o.last_query or ''):match(':(%d+):?(%d*)$')
        require('fzf-lua.actions').file_edit(selected, o)
        jump_to(tonumber(line), tonumber(col))
      end,
    },
  }, extra or {})
end

return {
  {
    'ibhagwan/fzf-lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    -- ColorSchemeSelect は下の config で定義する。
    -- lazy.nvim がスタブコマンドを作り、実行時に fzf-lua をロードしてから本体を呼ぶ
    cmd = { 'FzfLua', 'ColorSchemeSelect' },
    keys = {
      -- ファイル検索 (いずれも query 末尾の :line に対応)
      {
        '<C-p>',
        function()
          require('fzf-lua').combine(line_aware({
            -- 開いているバッファ → 最近開いたファイル → cwd 以下の全ファイルの順に並べる。
            -- 順序に意味があり、よく使うものが上に来る
            pickers = 'buffers;oldfiles;files',
            -- 履歴に別プロジェクトのファイルを混ぜない (タブごとの :tcd に追従する)
            cwd_only = true,
            -- combine は先頭ピッカーの見出しを使うので実態に合わせて上書きする
            winopts = { title = ' Buffers + Recent + Files ' },
          }))
        end,
        desc = 'バッファ + 履歴 + 全ファイル',
      },
      { '<leader><leader>', function() require('fzf-lua').buffers() end, desc = 'バッファ一覧' },
      -- コマンドパレット (VSCode の Ctrl-Shift-P 相当)
      --
      -- Ctrl-Shift-P と Ctrl-P は素の端末だと同じバイト (0x10) になり区別できない。
      -- Ghostty が kitty keyboard protocol に対応していて、tmux 側も
      -- extended-keys / terminal-features の extkeys で CSI u をそのまま通すので、
      -- Neovim が <C-S-p> を別のキーとして受け取れる。
      -- 効かない場合は挿入モードで <C-v> を押してから Ctrl-Shift-P し、
      -- 何が入力されているか確認する。
      { '<C-S-p>', function() require('fzf-lua').commands() end, mode = { 'n', 'i', 'v' }, desc = 'コマンドパレット' },
    },
    config = function()
      local fzf = require('fzf-lua')
      local actions = require('fzf-lua.actions')

      --- コマンドパレットで選んだコマンドを実行する
      ---
      --- fzf-lua の commands ピッカーの既定は ex_run で、選んでも `:Cmd` が
      --- コマンドラインに載るだけで実行されない。VSCode のコマンドパレットのように
      --- 選んだ時点で走らせたいので ex_run_cr (:execute する方) に差し替える。
      --- ただし引数が必須のコマンドをそのまま実行すると E471 になるだけなので、
      --- その場合だけ従来どおりコマンドラインに載せて入力を待つ。
      ---@param selected string[]
      ---@param o table
      local function run_command(selected, o)
        local cmd = selected and selected[1]
        if not cmd then
          return
        end
        -- 引数の要否はユーザ定義コマンドの nargs から判断する
        -- (組み込みコマンドは一覧に無いので nil になり、そのまま実行される)
        local def = vim.api.nvim_buf_get_commands(0, {})[cmd] or vim.api.nvim_get_commands({})[cmd]
        if def and (def.nargs == '1' or def.nargs == '+') then
          return actions.ex_run(selected, o)
        end
        return actions.ex_run_cr(selected, o)
      end

      fzf.setup({
        'default', -- プロファイル。速度優先なら 'max-perf' に変更する
        winopts = {
          height = 0.85,
          width = 0.85,
          preview = { layout = 'flex', scrollbar = false },
        },
        files = {
          -- .gitignore を尊重し、隠しファイルも対象にする
          fd_opts = [[--color=never --type f --hidden --follow --exclude .git]],
        },
        oldfiles = {
          include_current_session = true, -- 現在のセッションで開いたファイルも履歴に含める
        },
        commands = {
          actions = {
            ['enter'] = run_command,
            -- 引数を足してから実行したい時はコマンドラインに載せるだけにする
            ['ctrl-e'] = actions.ex_run,
          },
        },
      })
      -- vim.ui.select を fzf-lua に置き換える (LSP の code action 選択等が快適になる)
      fzf.register_ui_select()

      -- カラースキームをプレビューしながら選ぶ
      -- カーソルを動かすたびに即適用し、<CR> で確定、<Esc> で元のテーマへ戻す
      -- (fzf-lua の colorschemes は live_preview を既定で有効にする)
      vim.api.nvim_create_user_command('ColorSchemeSelect', function()
        fzf.colorschemes({
          -- <Tab> / <S-Tab> でも候補を送れるようにする
          keymap = { fzf = { ['tab'] = 'down', ['shift-tab'] = 'up' } },
        })
      end, { desc = 'カラースキームをプレビュー付きで選ぶ' })
    end,
  },
}
