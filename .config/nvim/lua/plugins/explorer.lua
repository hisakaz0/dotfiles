-- ファイラー (画面左ペイン)
--
-- neo-tree.nvim。マルチルート (VSCode の multi-root workspace 相当) は
-- 「タブページごとに :tcd でルートを変える」方式で実現する。
-- cwd_target.sidebar = 'tab' により、neo-tree でルートを変えるとそのタブの cwd も追従する。
-- ワークスペースを増やすキーマップは lua/config/keymaps.lua の <leader>wa を参照。

return {
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    cmd = 'Neotree',
    keys = {
      { '<leader>e', '<Cmd>Neotree toggle<CR>', desc = 'ファイラーを開閉' },
      { '<leader>E', '<Cmd>Neotree reveal<CR>', desc = 'ファイラーで現在のファイルを表示' },
    },
    opts = {
      close_if_last_window = true,
      popup_border_style = 'rounded',
      enable_git_status = true,
      enable_diagnostics = true,
      window = {
        position = 'left',
        width = 32,
        mappings = {
          ['<Space>'] = 'none', -- リーダーキーと衝突するので無効化
          ['l'] = 'open',
          ['h'] = 'close_node',
          ['<CR>'] = 'open',
          ['<C-v>'] = 'open_vsplit',
          ['<C-x>'] = 'open_split',
          ['<C-t>'] = 'open_tabnew',
        },
      },
      filesystem = {
        bind_to_cwd = true,
        -- サイドバーでルートを変更したらタブページの cwd (:tcd) も変える
        cwd_target = { sidebar = 'tab', current = 'window' },
        follow_current_file = { enabled = true, leave_dirs_open = true },
        use_libuv_file_watcher = true, -- 外部でのファイル変更を自動反映
        hijack_netrw_behavior = 'open_current',
        filtered_items = {
          visible = false,
          hide_dotfiles = false, -- ドットファイルは表示する
          hide_gitignored = true,
          hide_by_name = { '.git', 'node_modules' },
        },
      },
      default_component_configs = {
        indent = { with_expanders = true },
        git_status = {
          symbols = {
            added = 'A',
            modified = 'M',
            deleted = 'D',
            renamed = 'R',
            untracked = '?',
            ignored = 'I',
            unstaged = 'U',
            staged = 'S',
            conflict = 'C',
          },
        },
      },
    },
  },
}
