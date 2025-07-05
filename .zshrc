### common alias
alias ls='ls -G'
alias l='ls'
alias la='ls -a'
alias ll='ls -lh'
alias ..='cd ..'
alias ...='cd .. && cd ..'
alias ....='cd .. && cd .. && cd ..'
alias less='less -R'

# エディタはvimだけど、Ctrl-AやCtrl-Rが効かなくなるので、shellではemacs
export EDITOR='vim'
bindkey -e

### Java, Android Studio
export JAVA_HOME="/Applications/Android Studio.app/Contents/jbr/Contents/Home"
export PATH="$JAVA_HOME/bin:$PATH"
export PATH="$HOME/Library/Android/sdk/emulator:$PATH"
export PATH="$HOME/Library/Android/sdk/platform-tools:$PATH"
export PATH="$HOME/Library/Android/sdk/tools/bin:$PATH"

# /usr/libexec/java_homeが動かない場合実行する
#sudo ln -sfn "/Applications/Android Studio.app/Contents/jre" "/Library/Java/JavaVirtualMachines/openjdk.jdk" 

### Homebrew
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/sbin:$PATH"
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
# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/.local/share/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/.local/share/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/.local/share/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/.local/share/google-cloud-sdk/completion.zsh.inc"; fi

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
setopt PROMPT_SUBST ; PS1='%F{green}%n@%m%f: %F{cyan}%~%f %F{red}$(__git_ps1 "(%s)")%f \$ '

### enhancd
export ENHANCD_ENABLE_DOUBLE_DOT=false
source /Users/hisakazu/.enhancd/enhancd/init.sh

### golang

export PATH="/usr/local/go/bin:$PATH"

### gnu make
#export PATH="/opt/homebrew/opt/make/libexec/gnubin:$PATH"
