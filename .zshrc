
# rbenv
if type rbenv &>/dev/null; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init - zsh)"
fi

# common alias
alias ls='ls -G'
alias l='ls'
alias la='ls -a'
alias ll='ls -lh'
alias ..='cd ..'
alias ...='cd .. && cd ..'
alias ....='cd .. && cd .. && cd ..'
alias less='less -R'

# Java, Android Studio
export PATH="/Applications/Android Studio.app/Contents/jre/Contents/Home/bin:$PATH"
# /usr/libexec/java_homeが動かない場合実行する
#sudo ln -sfn "/Applications/Android Studio.app/Contents/jre" "/Library/Java/JavaVirtualMachines/openjdk.jdk" 

# Set /usr/libexec/java_home
#sudo ln -sfn "/Applications/Android Studio.app/Contents/jre" "/Library/Java/JavaVirtualMachines/openjdk-11.jdk"

# Homebrew
export PATH="$PATH:/opt/homebrew/bin" # システムのrubygemsを優先したいため後ろに追加
# 次のエラーを出さなくするため
# zsh compinit: insecure directories, run compaudit for list.
# Ignore insecure directories and continue [y] or abort compinit [n]?
chmod 755 /opt/homebrew
chmod 755 /opt/homebrew/share


# Cisco VPN client
export PATH="/opt/cisco/anyconnect/bin:$PATH"

vpn() (
  # エラー対応
  set -eu

  # "vpn" "vpn connect" 以外の呼び出しは元のコマンドに流す
  if [[ "$#" -ne 0 && ( "$#" -ne 1 || "$1" != 'connect' ) ]]; then
    exec command vpn "$@"
  fi

  # GUI 版が起動していたら一度強制終了する
  killall 'Cisco AnyConnect Secure Mobility Client' >/dev/null 2>&1 || :

  # 既に VPN に接続していたら強制切断する
  expect -c '
    set log_user 0
    set timeout 5
    spawn vpn disconnect
    expect ">> state: Disconnected"
    interact
  '

  # キーチェーンからの取得
  VPN_PASSWORD="$(security find-generic-password -s "$VPN_PASSWORD_KEYNAME" -w)"
  VPN_TOKEN="$(oathtool --totp --base32 "$(security find-generic-password -s "$VPN_TOTP_SECRET_KEYNAME" -w)")"
  export VPN_PASSWORD
  export VPN_TOKEN

  # 接続
  expect -c '
    set log_user 0
    set timeout 5

    spawn vpn connect $env(VPN_HOST)

    expect "Group:"
    send "$env(VPN_GROUP)\r"
    expect "Username:"
    send "$env(VPN_USERNAME)\r"
    expect "Password:"
    send "$env(VPN_PASSWORD)\r"
    expect "Second Username:"
    send "$env(VPN_SECOND_USERNAME)\r"
    expect "Second Password:"
    send "$env(VPN_TOKEN)\r"

    interact
  '

  # GUI 版を起動
  open '/Applications/Cisco/Cisco AnyConnect Secure Mobility Client.app'
)

# Screenshot(一度だけ実行する)
#defaults write com.apple.screencapture location ~/Pictures/Screenshots && killall SystemUIServer

# volta
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# android emulator`
export PATH="$HOME/Library/Android/sdk/emulator:$PATH"

eval "$(direnv hook zsh)"

# zsh completion
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

  autoload -Uz compinit
  compinit
fi

export JAVA_HOME="/Applications/Android Studio.app/Contents/jre/Contents/Home"

# git reset HEAD^ の^を使えるようにするため
setopt noEXTENDED_GLOB

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/.local/share/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/.local/share/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/.local/share/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/.local/share/google-cloud-sdk/completion.zsh.inc"; fi

