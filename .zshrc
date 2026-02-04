### common alias
alias ls='ls -G'
alias l='ls'
alias la='ls -a'
alias ll='ls -lh'
alias ..='cd ..'
alias ...='cd .. && cd ..'
alias ....='cd .. && cd .. && cd ..'
alias less='less -R'

# python
alias pip='pip3'
alias python='python3'

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


### git prompt
# git-promptの読み込み
source ~/.zsh/git-prompt.sh
# TODO: precmd を使って速くしたいが、今のPS1を使いつつ precmd を使うとエラーになる
# 15分ぐらいで設定できなかったので、一旦諦める


##### 計測
# zshのフック関数管理機能をロード
autoload -Uz add-zsh-hook
# 高精度な時間取得モジュールをロード
zmodload zsh/datetime

# 開始時間を記録する関数
_timer_start() {
  _cmd_start_time=$EPOCHREALTIME
}

# 終了時間を計算して表示する関数
_timer_stop() {
  if (( _cmd_start_time )); then
    local delta=$(( EPOCHREALTIME - _cmd_start_time ))
    # 0.01ms単位まで表示
    printf "\n\e[2m(Process took: %.3f ms)\e[0m\n" $(( delta * 1000 ))
    unset _cmd_start_time
  fi
}

# 既存の処理を邪魔せずに、計測処理を「登録」する
add-zsh-hook preexec _timer_start
add-zsh-hook precmd _timer_stop


# git-completionの読み込み
fpath=(~/.zsh $fpath)
zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
autoload -Uz compinit && compinit

# プロンプトのオプション表示設定
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUPSTREAM=auto

# 速くするため次は設定しない
unset GIT_PS1_SHOWDIRTYSTATE
unset GIT_PS1_SHOWUNTRACKEDFILES
unset GIT_PS1_SHOWUPSTREAM
# {time} {user}@{host}: {directories} {git} $
# 改行入れると狭いターミナルが余計に狭くなって嫌だが、PROMPTが長くて
# search historyするときタイプする場所（右側）とsearch historyが表示される場所（左側）が離れてめっちゃやりづらい
setopt PROMPT_SUBST ; PS1='%F{green}%n@%m%f: %F{cyan}%~%f %F{red}$(__git_ps1 "(%s) ")%f
 %F{247}%D{%H:%M:%S}%f \$ '

### enhancd(動かなくなったのでコメントアウト。fzfまわり)
#export ENHANCD_ENABLE_DOUBLE_DOT=false
# cd は claude など agent 系が利用するので別名にする
#export ENHANCD_COMMAND=c
#alias c.='c .'
#alias c-='c -'
# dotfilesは $HOME/Works/dotfiles に配置する
#source $HOME/Works/dotfiles/enhancd/init.sh

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


# fzf
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

# pnpm
export PNPM_HOME="/Users/hisakazu/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

export PATH="$HOME/.local/bin:$PATH"

# zoxide.
eval "$(zoxide init zsh)"

# GCP
export GOOGLE_CLOUD_PROJECT_ID='erp-server-dev'