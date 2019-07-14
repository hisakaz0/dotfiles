
## vals
set _uname (uname)

set _hostname ""
if [ $_uname = "Darwin" ]
  set _hostname (hostname -s)
else if [ $_uname = "FreeBSD" ]
  set _hostname (hostname)
else
  set _hostname (hostname -f)
end


## stty
stty sane # reset all option to reasonable value
stty -ixon -ixoff # ctrl+s, ctrl+qの無効化
[ -x "`which tabs`" ] && tabs -2 # tab width

## user-wide envs
function set_date_val -d 'set $DATE with format yyyymmdd'
  set -x DATE (date +%Y%m%d)
end

[ -z "$LD_LIBRARY_PATH" ] && set -x LD_LIBRARY_PATH ""
[ -z "$DYLD_LIBRARY_PATH" ] && set -x DYLD_LIBRARY_PATH ""
[ -z "$CPATH" ] && set -x CPATH ""
[ -z "$LIBRARY_PATH" ] && set -x LIBRARY_PATH ""

set -x LANG "en_US.UTF-8"
set -x LC_ALL "en_US.UTF-8"
if [ -x (which vim) ]
  set -x EDITOR 'vim'
else
  set -x EDITOR 'vi'
end
set_date_val
set -x PAGER 'less'
set -x SVN_SSH 'ssh -q'
set -x MEMO_PATH "$HOME/.memo"

## alias
alias ls='ls -G'
alias ll='ls -hlF'
alias la='ls -aF'
alias li='ls -1F'
alias his='history'
alias where='which'
alias mkdri='mkdir'
alias sl='ls'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias v='vi'
alias gpp='g++'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ducks='du -h -d 1'

alias RM='rm -f'
alias CP='cp -f'
alias MV='mv -f'

if [ "$_uname" != 'Darwin' ] && [ -x (which xdg-open) ]
  alias open='xdg-open'
end
if [ -x (which tmux) ]
  alias tmux='tmux -2'
end

if [ "$_uname" = 'Darwin' ] && [ -d "$HOME/.Trash" ]
  function trash
    mv $argv $HOME/.Trash
  end
end

## tmux
if [ "$_uname" = "Darwin" ]
  ln -sf ~/.tmux.mac.conf ~/.tmux.conf
else
  ln -sf ~/.tmux.noplugin.conf ~/.tmux.conf
end

set -x SCREENDIR "$HOME/.screen/$_hostname"
if [ ! -d "$SCREENDIR" ]
  mkdir -p $SCREENDIR
  chmod 700 $SCREENDIR
end

## print battery status
if [ "$_uname" = "FreeBSD" ]
  function _print_battery_status
    if [ "$1" != "-o" ]
      acpiconf -i 0
      return 0
    end
    acpiconf -i 0 | tail -n4 | head -n1 | awk '{ print $3 }'
  end
else if [ "$_uname" = "Darwin" ]
  function _print_battery_status
    pmset -g ps | egrep -o "[0-9]{1,3}%"
  end
end

## prompt
function fish_prompt
  set_date_val

  set -l prompt (printf "%s@%s:%s" (id -un) (prompt_hostname) (prompt_pwd))

  if [ $_uname = "Darwin" ] || [ $_uname = "FreeBSD" ]
    set prompt (printf '(%s) %s' (_print_battery_status) $prompt)
  end

  set -l git_prompt (__fish_git_prompt)
  if [ -n "$git_prompt" ]
    set prompt (printf '%s%s' $prompt $git_prompt)
  end
  set prompt (printf '%s$ ' $prompt)

  echo $prompt
end

## path / user commands
function _check_and_add_path
  [ ! -d "$1" ] && return
  set -x PATH $1 $PATH
end

_check_and_add_path "/usr/local/sbin"
_check_and_add_path "/usr/local/share/app/flutter/bin"
_check_and_add_path "$HOME/.local/bin"
_check_and_add_path "$HOME/bin"
_check_and_add_path "/usr/local/opt/gettext/bin"
_check_and_add_path "$HOME/Library/Python/2.7/bin"
_check_and_add_path "$HOME/Library/Python/3.6/bin"
_check_and_add_path "$HOME/.rvm/bin"
_check_and_add_path "$HOME/Library/Android/sdk/platform-tools"
_check_and_add_path "$HOME/Library/Android/sdk/tools"
_check_and_add_path "$HOME/Library/Android/sdk/ndk-bundle"
_check_and_add_path "$HOME/Work/Tools/dmmgw_util"
_check_and_add_path "$HOME/Work/Tools/onefetch/target/release"
_check_and_add_path "$HOME/.bin"
_check_and_add_path "/usr/local/texlive/2015/bin/x86_64-darwin"
_check_and_add_path "/usr/local/wine/bin"
_check_and_add_path "$HOME/tmp/utils/bin"
_check_and_add_path "$HOME/tmp/kancolle/utils/macosx-x64-ex.2.3.4"
_check_and_add_path "$HOME/Work/gist-dmm/slack-msg/slack-cli/build/bin" # src slack-cli

## Android
if [ -d "$HOME/Library/Android/sdk" ]
  set -x ANDROID_HOME "$HOME/Library/Android/sdk"
end
if [ -d "$HOME/Library/Android/sdk" ]
  set -x ANDROID_SDK_PATH "$HOME/Library/Android/sdk"
end

if [ -x (which hub) ]
  eval (hub alias -s)
end

# fisher: bootstrap installation
if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

## nvm
if [ -d $HOME/.nvm ]
  set -x NVM_DIR "$HOME/.nvm"
  if [ -s $NVM_DIR/nvm.sh ]
    bass source $NVM_DIR/nvm.sh ';' nvm use default
    function nvm -d "nvm wrapper for fish(bass pkg)"
      bass source $NVM_DIR/nvm.sh ';' nvm $argv
    end
  end
end

set sh_root $HOME/.config/bash
function _load_bash_script
  if [ -f "$1" ]
    bass source "$1"
  end
end

## go lang
_load_bash_script $sh_root/go_install.sh
## 個人用のenv
if [ -f $HOME/.env.sh ]
  source $HOME/.env.sh
end
if [ -f $HOME/.env.dmm.sh ]
  source $HOME/.env.dmm.sh
end
## rust
_load_bash_script $HOME/.cargo/env
## fishmarks / https://github.com/techwizrd/fishmarks
if [ -f $HOME/.repository/github/techwizrd/fishmarks/marks.fish ]
  source $HOME/.repository/github/techwizrd/fishmarks/marks.fish
end

# TODO: history 設定

## vi mode
fish_vi_key_bindings

# vi modenにdefaultのkey bindingを足して、bashっぽくする
bind -M insert \cf 'forward-char'   # Ctrl-Fで推測された補完候補の全補完
bind -M insert \cp 'up-or-search'   # 検索と次へ
bind -M insert \cn 'down-or-search' # 検索と前へ
bind \cp 'up-or-search'   # 検索と次へ
bind \cn 'down-or-search' # 検索と前へ

## git_prompt
set __fish_git_prompt_show_informative_status
set __fish_git_prompt_showcolorhints
set __fish_git_prompt_showupstream "informative"

