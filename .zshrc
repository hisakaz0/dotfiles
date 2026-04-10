# 速度計測したい場合は、コメントアウトを外す（ファイル末尾も確認すること）
# zmodload zsh/zprof

################################################################################
# alias
################################################################################
alias ls='ls -G'
alias l='ls'
alias la='ls -a'
alias ll='ls -lh'
alias ..='cd ..'
alias ...='cd .. && cd ..'
alias ....='cd .. && cd .. && cd ..'
alias less='less -R'
alias g='git'
# python, pip コマンドで pip3, python3 を動かせるように
alias pip='pip3'
alias python='python3'

################################################################################
# zsh config 
################################################################################
# 分類が難しい設定はここにおく
# 
# Ctrl-AやCtrl-Rを使いたいので emacs モードにする
bindkey -e
# zshでもdeleteを使えるようにする
bindkey "^[[3~" delete-char

# git reset HEAD^ の^を使えるようにするため
setopt noEXTENDED_GLOB

################################################################################
# history
################################################################################
# コマンド履歴に保持する行数を設定 (セッション内)
HISTSIZE=10000
# 履歴ファイルに保存する行数を設定 (再起動後も保持)
SAVEHIST=10000

# 履歴をすべてのzsh terminalで共有する
setopt share_history
# 重複したコマンドを無視する
setopt hist_ignore_dups
# 重複するコマンドを古い方から削除
setopt hist_ignore_all_dups    
# 検索時に重複を表示しない
setopt hist_find_no_dups          
# タイムスタンプ付きhistoryを記録
# 履歴はaudit_log的な扱いじゃなく、速くコマンドを見つけるために使っているため、タイムスタンプ機能はオフにする
# setopt extended_history
# コマンド実行後すぐに履歴に追加
setopt inc_append_history_time

################################################################################
# zsh マクロ展開設定 (連想配列版)
################################################################################

# input の `git-diff-pathspec` が展開される
# input : git diff HEAD~10 --stat -- git-diff-pathspec 
# output: git diff HEAD~10 --stat -- ':!src/domain/*_test.go' ':!*_gen.go' ':!.gqlgenc.yml'    

# 1. マクロリストの定義
typeset -A MY_MACROS
MY_MACROS=(
  "git-diff-pathspec" "':!src/domain/*_test.go' ':!*_gen.go' ':!.gqlgenc.yml'"
)

# 2. 共通の展開ロジック
_expand_macro_logic() {
  # 現在の入力行の最後の単語を取得
  local last_word="${LBUFFER##* }"
  
  # マクロリストに存在するかチェック
  if [[ -n "$MY_MACROS[$last_word]" ]]; then
    # マクロを置換（最後の単語を削除して中身を挿入）
    LBUFFER="${LBUFFER%$last_word}$MY_MACROS[$last_word]"
    return 0 # 展開成功
  fi
  return 1 # 展開なし
}

# 3. スペース用ウィジェット
_magic_space_macro() {
  _expand_macro_logic
  # 展開の有無に関わらず、最後にスペースを挿入
  zle self-insert
}

# 4. エンター用ウィジェット
_magic_enter_macro() {
  if _expand_macro_logic; then
    # 展開された場合は、そこで止まる（実行しない）
    return
  else
    # 展開されなかった（マクロがなかった）場合は、即座に実行
    zle .accept-line
  fi
}

# 5. ZLEウィジェットとして登録
zle -N _magic_space_macro
zle -N _magic_enter_macro

# 6. キーバインドの設定
bindkey ' ' _magic_space_macro  # スペースキー
bindkey '^M' _magic_enter_macro # エンターキー（Ctrl+M）


################################################################################
# Workaround
################################################################################
# shell の初期設定時やツールを入れ替え時に必要になったコマンド。
#
# Homebrew で次のエラーを出さなくするため
# zsh compinit: insecure directories, run compaudit for list.
# Ignore insecure directories and continue [y] or abort compinit [n]?
#chmod 755 /opt/homebrew
#chmod 755 /opt/homebrew/share

################################################################################
# direnv
################################################################################
eval "$(direnv hook zsh)"

################################################################################
# zsh completion
################################################################################
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


################################################################################
# git prompt
################################################################################
source ~/.zsh/git-prompt.sh
# TODO: precmd を使って速くしたいが、今のPS1を使いつつ precmd を使うとエラーになる
# 15分ぐらいで設定できなかったので、一旦諦める

# git-completionの読み込み
fpath=(~/.zsh $fpath)
zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
autoload -Uz compinit && compinit

# プロンプトのオプション表示設定
export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWUNTRACKEDFILES=true
export GIT_PS1_SHOWSTASHSTATE=true
export GIT_PS1_SHOWUPSTREAM=auto

# 速くするため次は設定しない
unset GIT_PS1_SHOWDIRTYSTATE
unset GIT_PS1_SHOWUNTRACKEDFILES
unset GIT_PS1_SHOWUPSTREAM

# {time} {user}@{host}: {directories} {git} $
# 改行入れると狭いターミナルが余計に狭くなって嫌だが、PROMPTが長くて
# search historyするときタイプする場所（右側）とsearch historyが表示される場所（左側）が離れてめっちゃやりづらい
setopt PROMPT_SUBST ; PS1='%F{green}%n@%m%f: %F{cyan}%~%f %F{red}$(__git_ps1 "(%s) ")%f
 %F{247}%D{%H:%M:%S}%f \$ '

################################################################################
# extra prompt
################################################################################
# コマンドの実行時間を計測する設定
autoload -Uz add-zsh-hook # zshのフック関数管理機能をロード
zmodload zsh/datetime # 高精度な時間取得モジュールをロード

_timer_start() {
  _cmd_start_time=$EPOCHREALTIME
}

_timer_stop_and_print_exec_time() {
  if (( _cmd_start_time )); then
    local delta=$(( EPOCHREALTIME - _cmd_start_time ))
    if (( delta >= 60 )); then
      local mins=$(( delta / 60 ))
      mins=${mins%.*}
      local secs=$(( delta - mins * 60 ))
      printf "\n\e[2m(Process took: %dm%.1fs)\e[0m\n" $mins $secs
    elif (( delta >= 1 )); then
      printf "\n\e[2m(Process took: %.1fs)\e[0m\n" $delta
    else
      printf "\n\e[2m(Process took: %.1fms)\e[0m\n" $(( delta * 1000 ))
    fi
    unset _cmd_start_time
  fi
}

# 既存の処理を邪魔せずに、計測処理を「登録」する
add-zsh-hook preexec _timer_start
add-zsh-hook precmd _timer_stop_and_print_exec_time

################################################################################
# nvm
################################################################################
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


################################################################################
# fzf
################################################################################
# - --ansi: ANSIカラーを有効にする
# - --prompt: プロンプト(シェルの左に表示される文字列)
# - --layout=reverse: 入力欄を上部に表示（下から上に候補が表示される）
# - --border=rounded: 枠線を表示
# - --height 40%: 画面の40%の高さで表示（全画面にならない）
# - --expect=ctrl-e,esc: Ctrl+EまたはESCを押した場合は編集モード、Enterは即実行
# - --print0
export FZF_DEFAULT_OPTS="--ansi --prompt='QUERY> ' --layout=reverse --border=rounded --height 40% --expect=ctrl-e,esc --bind=ctrl-k:kill-line"

# Ctrl+R でfzfを使ったhistory検索を有効化
# - Enter: 選択したコマンドを即実行
# - Ctrl+E または ESC: 選択したコマンドをバッファに入れて編集可能な状態にする
function fzf-select-history() {
	# fzfのデフォルトオプション（インライン表示）
	local selected
	# - --query "$LBUFFER": カーソル左側の文字列を初期検索クエリとして使用
	selected=$(history -n -r 1 | fzf --query "$LBUFFER" --scheme=history)
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
	else
		# Ctrl-Cでキャンセルした場合もプロンプトをリセット
		zle reset-prompt
	fi
}
zle -N fzf-select-history
bindkey '^R' fzf-select-history

################################################################################
# 以下インストーラーが自動で追加する設定
################################################################################

### google cloud sdk
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/hisakazu/.google-cloud-sdk/path.zsh.inc' ]; then . '/Users/hisakazu/.google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/hisakazu/.google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/hisakazu/.google-cloud-sdk/completion.zsh.inc'; fi

# pnpm
export PNPM_HOME="/Users/hisakazu/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# zoxide.
eval "$(zoxide init zsh)"

# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/hisakazu/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions

# 速度計測したい場合は、コメントアウトを外す（ファイル先頭も確認すること）
# zprof
