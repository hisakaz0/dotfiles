# common alias
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

# Java, Android Studio
export JAVA_HOME="/Applications/Android Studio.app/Contents/jbr/Contents/Home"
export PATH="$JAVA_HOME/bin:$PATH"
export PATH="$HOME/Library/Android/sdk/emulator:$PATH"
export PATH="$HOME/Library/Android/sdk/platform-tools:$PATH"
export PATH="$HOME/Library/Android/sdk/tools/bin:$PATH"


# /usr/libexec/java_homeが動かない場合実行する
#sudo ln -sfn "/Applications/Android Studio.app/Contents/jre" "/Library/Java/JavaVirtualMachines/openjdk.jdk" 

# Homebrew
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/sbin:$PATH"
# 次のエラーを出さなくするため
# zsh compinit: insecure directories, run compaudit for list.
# Ignore insecure directories and continue [y] or abort compinit [n]?
chmod 755 /opt/homebrew
chmod 755 /opt/homebrew/share

# Screenshot(一度だけ実行する)
#defaults write com.apple.screencapture location ~/Pictures/Screenshots && killall SystemUIServer

# volta
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"


eval "$(direnv hook zsh)"

# zsh completion
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

  autoload -Uz compinit
  compinit
fi

# git reset HEAD^ の^を使えるようにするため
setopt noEXTENDED_GLOB

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/.local/share/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/.local/share/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/.local/share/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/.local/share/google-cloud-sdk/completion.zsh.inc"; fi

