### common alias
alias ls='ls -G'
alias l='ls'
alias la='ls -a'
alias ll='ls -lh'
alias ..='cd ..'
alias ...='cd .. && cd ..'
alias ....='cd .. && cd .. && cd ..'
alias less='less -R'

# エディタはvim
export EDITOR='vim'
# だけど、Ctrl-AやCtrl-Rが効かなくなるので、shellではemacs
bindkey -e
# zshでもdeleteを使えるように
bindkey "^[[3~" delete-char

### Java, Android Studio
export JAVA_HOME="/Applications/Android Studio.app/Contents/jbr/Contents/Home"
export PATH="$JAVA_HOME/bin:$PATH"
export PATH="$HOME/Library/Android/sdk/emulator:$PATH"
export PATH="$HOME/Library/Android/sdk/platform-tools:$PATH"
export PATH="$HOME/Library/Android/sdk/tools/bin:$PATH"

# /usr/libexec/java_homeが動かない場合実行する
#sudo ln -sfn "/Applications/Android Studio.app/Contents/jre" "/Library/Java/JavaVirtualMachines/openjdk.jdk" 

### Homebrew
# エラーになるため、osのコマンドを優先する
export PATH="$PATH:/opt/homebrew/bin"
export PATH="$PATH:/opt/homebrew/sbin"
# 次のエラーを出さなくするため
# zsh compinit: insecure directories, run compaudit for list.
# Ignore insecure directories and continue [y] or abort compinit [n]?
chmod 755 /opt/homebrew
chmod 755 /opt/homebrew/share

# Screenshot(一度だけ実行する)
#defaults write com.apple.screencapture location ~/Pictures/Screenshots && killall SystemUIServer

### direnv
eval "$(direnv hook zsh)"

### completion
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
  autoload -Uz compinit
  compinit
fi
if [ -d "$(brew --prefix)/share/zsh/site-functions" ] ; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
  autoload -Uz compinit
  compinit
fi

# git reset HEAD^ の^を使えるようにするため
setopt noEXTENDED_GLOB


### gcp sdk
### git prompt
# git-promptの読み込み
source ~/.zsh/git-prompt.sh

# git-completionの読み込み
fpath=(~/.zsh $fpath)
zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
autoload -Uz compinit && compinit

# プロンプトのオプション表示設定
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUPSTREAM=auto
# {time} {user}@{host}: {directories} {git} $
# 改行入れると狭いターミナルが余計に狭くなって嫌だが、PROMPTが長くて
# search historyするときタイプする場所（右側）とsearch historyが表示される場所（左側）が離れてめっちゃやりづらい
setopt PROMPT_SUBST ; PS1='%F{green}%n@%m%f: %F{cyan}%~%f %F{red}$(__git_ps1 "(%s) ")%f
 %F{247}%D{%H:%M:%S}%f \$ '

### enhancd
export ENHANCD_ENABLE_DOUBLE_DOT=false
# cd は claude など agent 系が利用するので別名にする
export ENHANCD_COMMAND=c
alias c.='c .'
alias c-='c -'
# dotfilesは $HOME/Works/dotfiles に配置する
source $HOME/Works/dotfiles/enhancd/init.sh

### golang
export PATH="/Users/hisakazu/go/bin:$PATH"

### gnu make
export PATH="/opt/homebrew/opt/make/libexec/gnubin:$PATH"

### google cloud sdk
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/hisakazu/.google-cloud-sdk/path.zsh.inc' ]; then . '/Users/hisakazu/.google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/hisakazu/.google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/hisakazu/.google-cloud-sdk/completion.zsh.inc'; fi

# bun completions
[ -s "/Users/hisakazu/.bun/_bun" ] && source "/Users/hisakazu/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export MANPATH=$HOME/tools/ripgrep/doc/man:$MANPATH
export FPATH=$HOME/tools/ripgrep/complete:$FPATH

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/hisakazu/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)


### history
# 履歴をすべてのzsh terminalで共有する
setopt share_history
# コマンド履歴に保持する行数を設定 (セッション内)
HISTSIZE=10000
# 履歴ファイルに保存する行数を設定 (再起動後も保持)
SAVEHIST=10000
# 重複したコマンドを無視する
setopt hist_ignore_dups
# タイムスタンプ付きhistoryを記録
# 履歴はaudit_log的な扱いじゃなく、速くコマンドを見つけるために使っているため、無意味なタイムスタンプ機能はオフにする
# setopt extended_history
# コマンド実行後すぐに履歴に追加
setopt inc_append_history_time
# 検索時に重複を表示しない
setopt hist_find_no_dups          


# fzf
# - --ansi: ANSIカラーを有効にする
# - --prompt: プロンプト(シェルの左に表示される文字列)
# - --layout=reverse: 入力欄を上部に表示（下から上に候補が表示される）
# - --border=rounded: 枠線を表示
# - --height 40%: 画面の40%の高さで表示（全画面にならない）
# - --expect=ctrl-e,esc: Ctrl+EまたはESCを押した場合は編集モード、Enterは即実行
export FZF_DEFAULT_OPTS="--ansi --prompt='QUERY> ' --layout=reverse --border=rounded --height 40% --expect=ctrl-e,esc"


# Ctrl+R でfzfを使ったhistory検索を有効化
# - Enter: 選択したコマンドを即実行
# - Ctrl+E または ESC: 選択したコマンドをバッファに入れて編集可能な状態にする
function fzf-select-history() {
	# fzfのデフォルトオプション（インライン表示）
	local selected
	# - --query "$LBUFFER": カーソル左側の文字列を初期検索クエリとして使用
	selected=$(history -n -r 1 | fzf --query "$LBUFFER")
	local key=$(echo "$selected" | head -1)
	local cmd=$(echo "$selected" | tail -n +2)

	if [ -n "$cmd" ]; then
		BUFFER=$cmd
		CURSOR=$#BUFFER
		if [ "$key" = "ctrl-e" ] || [ "$key" = "esc" ]; then
			zle reset-prompt
		else
			zle accept-line
		fi
	fi
}
zle -N fzf-select-history
bindkey '^R' fzf-select-history

# pnpm
export PNPM_HOME="/Users/hisakazu/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

export PATH="$HOME/.local/bin:$PATH"

. "$HOME/.local/bin/env"


# shellcheck shell=bash

# =============================================================================
#
# Utility functions for zoxide.
#

# pwd based on the value of _ZO_RESOLVE_SYMLINKS.
function __zoxide_pwd() {
    \builtin pwd -L
}

# cd + custom logic based on the value of _ZO_ECHO.
function __zoxide_cd() {
    # shellcheck disable=SC2164
    \builtin cd -- "$@"
}

# =============================================================================
#
# Hook configuration for zoxide.
#

# Hook to add new entries to the database.
function __zoxide_hook() {
    # shellcheck disable=SC2312
    \command zoxide add -- "$(__zoxide_pwd)"
}

# Initialize hook.
\builtin typeset -ga precmd_functions
\builtin typeset -ga chpwd_functions
# shellcheck disable=SC2034,SC2296
precmd_functions=("${(@)precmd_functions:#__zoxide_hook}")
# shellcheck disable=SC2034,SC2296
chpwd_functions=("${(@)chpwd_functions:#__zoxide_hook}")
chpwd_functions+=(__zoxide_hook)

# Report common issues.
function __zoxide_doctor() {
    [[ ${_ZO_DOCTOR:-1} -ne 0 ]] || return 0
    [[ ${chpwd_functions[(Ie)__zoxide_hook]:-} -eq 0 ]] || return 0

    _ZO_DOCTOR=0
    \builtin printf '%s\n' \
        'zoxide: detected a possible configuration issue.' \
        'Please ensure that zoxide is initialized right at the end of your shell configuration file (usually ~/.zshrc).' \
        '' \
        'If the issue persists, consider filing an issue at:' \
        'https://github.com/ajeetdsouza/zoxide/issues' \
        '' \
        'Disable this message by setting _ZO_DOCTOR=0.' \
        '' >&2
}

# =============================================================================
#
# When using zoxide with --no-cmd, alias these internal functions as desired.
#

# Jump to a directory using only keywords.
function __zoxide_z() {
    __zoxide_doctor
    if [[ "$#" -eq 0 ]]; then
        __zoxide_cd ~
    elif [[ "$#" -eq 1 ]] && { [[ -d "$1" ]] || [[ "$1" = '-' ]] || [[ "$1" =~ ^[-+][0-9]$ ]]; }; then
        __zoxide_cd "$1"
    elif [[ "$#" -eq 2 ]] && [[ "$1" = "--" ]]; then
        __zoxide_cd "$2"
    else
        \builtin local result
        # shellcheck disable=SC2312
        result="$(\command zoxide query --exclude "$(__zoxide_pwd)" -- "$@")" && __zoxide_cd "${result}"
    fi
}

# Jump to a directory using interactive search.
function __zoxide_zi() {
    __zoxide_doctor
    \builtin local result
    result="$(\command zoxide query --interactive -- "$@")" && __zoxide_cd "${result}"
}

# =============================================================================
#
# Commands for zoxide. Disable these using --no-cmd.
#

function z() {
    __zoxide_z "$@"
}

function zi() {
    __zoxide_zi "$@"
}

# Completions.
if [[ -o zle ]]; then
    __zoxide_result=''

    function __zoxide_z_complete() {
        # Only show completions when the cursor is at the end of the line.
        # shellcheck disable=SC2154
        [[ "${#words[@]}" -eq "${CURRENT}" ]] || return 0

        if [[ "${#words[@]}" -eq 2 ]]; then
            # Show completions for local directories.
            _cd -/

        elif [[ "${words[-1]}" == '' ]]; then
            # Show completions for Space-Tab.
            # shellcheck disable=SC2086
            __zoxide_result="$(\command zoxide query --exclude "$(__zoxide_pwd || \builtin true)" --interactive -- ${words[2,-1]})" || __zoxide_result=''

            # Set a result to ensure completion doesn't re-run
            compadd -Q ""

            # Bind '\e[0n' to helper function.
            \builtin bindkey '\e[0n' '__zoxide_z_complete_helper'
            # Sends query device status code, which results in a '\e[0n' being sent to console input.
            \builtin printf '\e[5n'

            # Report that the completion was successful, so that we don't fall back
            # to another completion function.
            return 0
        fi
    }

    function __zoxide_z_complete_helper() {
        if [[ -n "${__zoxide_result}" ]]; then
            # shellcheck disable=SC2034,SC2296
            BUFFER="z ${(q-)__zoxide_result}"
            __zoxide_result=''
            \builtin zle reset-prompt
            \builtin zle accept-line
        else
            \builtin zle reset-prompt
        fi
    }
    \builtin zle -N __zoxide_z_complete_helper

    [[ "${+functions[compdef]}" -ne 0 ]] && \compdef __zoxide_z_complete z
fi

# =============================================================================
#
# To initialize zoxide, add this to your shell configuration file (usually ~/.zshrc):
#
# eval "$(zoxide init zsh)"
