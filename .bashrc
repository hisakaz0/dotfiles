__is_interface_active() {
  is=`ifconfig -u $1 | grep "status: active"`
  if [ -n "$is" ] ; then
    return 0 # possible to access internet
  else
    return 1 # impossible to access internet
  fi
}
__is_net() {
  export IS_INTERNET_ACTIVE=1 # initialize impossible to access internet
  for intf in `echo bridge0 en0`
  do
    __is_interface_active $intf
    if [ "$?" -eq 0 ] ; then
      export IS_INTERNET_ACTIVE=0
    fi
  done
}
__is_net

###  alias
alias ls='ls -G'
alias ll='ls -hlF'
alias la='ls -aF'
alias l='ls -CF'
alias li='ls -1F'
alias his='history'
alias where='which'
alias mkdri='mkdir'
alias vi='vim'
alias sl='ls'
alias ta='tmux a'
alias tmux='tmux -2'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias v='vi'
alias gpp='g++'
alias tat='tmux a -t'
alias RM='rm -f'
alias rm='rm -i'
alias CP='cp -f'
alias cp='cp -i'
alias today='date'
alias update_date='export DATE=`date +%Y%m%d`' # year month day
alias update_time='export TIME=`date +%s`'
alias bash_keybind="bind -p | grep 'C-' | grep -v 'abort\|version\|accept' | less"
alias ducks='du -h -d 1'

### source
# source ${HOME}/tmp/bash/fpath.sh ## get full path func
# source ${HOME}/tmp/bash/prand.sh ## print random charactors
# source ${HOME}/tmp/bash/makeMakefile.sh ## create template files for c lang
# source ${HOME}/tmp/kancolle/utils/kancolle_logbook.sh ## kancolle logbook

### go lang
export GOROOT=/usr/local/opt/go/libexec # go lang bin dir
export GOPATH=$HOME/tmp/go # workspace dir
export PATH=$GOPATH/bin:$PATH

### general path
export PATH=/opt/local/bin:$PATH
export PATH=/opt/local/sbin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/sbin:$PATH
export PATH=/usr/local/texlive/2015/bin/x86_64-darwin:$PATH
export PATH=/usr/local/wine/bin:$PATH
export PATH=$HOME/tmp/utils/bin:$PATH
export PATH=$HOME/.bin:$PATH
export PATH=$HOME/arch/emax5/proj-arm64/bin:$PATH
export PATH=$HOME/tmp/kancolle/utils/macosx-x64-ex.2.3.4:$PATH

###  Completion
# complete -W "vim study php html cake" cake # cakeの補完設定
complete -d autoextract # ~/bin/autoextracの補完

###  Environments
export EDITOR=vim
export DAY=`date +%d` # month day
export MONTH=`date +%B` # month in literal
export YEAR=`date +%Y` # year
export MEMO_PATH=${HOME}/Copy/Documents/.memo
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8 # non error for perl
# export PAGER="col -b -x | vim -"
# export XMODIFIERS=@im=uim
# export GTK_IM_MODULE=uim
##  Prompt
export PS1='\u@\h:\W 〆 '

stty -ixon -ixoff # ctrl+s, ctrl+qの無効化
tabs -2 # tab width
update_date
update_time

###  shopt
# shopt -s cdspell
# shopt -s extglob
# shopt -s histreedit
# shopt -s no_empty_cmd_completion

###  Completion
# escape loading bash_completion error
cd
# Bash Completion
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi
# Rails Completion
if [ -f `brew --prefix`/etc/bash_completion.d/rails.bash ]; then
  source `brew --prefix`/etc/bash_completion.d/rails.bash
fi
cd ${OLDPWD}

### shell history
# alias cal='hisa=`date +%d`;cal | sed -e "s/ ${hisa} / [1;35m${hisa}[m /"'
function share_history {
history -a
history -c
history -r
update_time
}
PROMPT_COMMAND='share_history'
shopt -u histappend
export HISTSIZE=9999

### remove redundant line
# perl -pi -e 's/^l(l|s)?\n//' ~/.bash_history
# perl -pi -e 's/^cd\s?(\.\.)?\n//' ~/.bash_history

### rbenv
export RUBYGEMS_GEMDEPS=
eval "$(rbenv init -)"

### hub
eval "$(hub alias -s)"

### nvm (Node Version Manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

### key
# ssh-add ~/.ssh/hisakazu_quark_bitbucket

### docker
# eval $(docker-machine env default)

### SSH AGENT
# Refs:  http://qiita.com/isaoshimizu/items/84ac5a0b1d42b9d355cf
# eval $(ssh-agent)
ssh-add ${HOME}/.ssh/hisakazu_quark

### kancolle logbook (check wheather process is running
logbook_pid=`ps aux| grep "logbook" | grep -v "grep" | awk '{ print $2; }'`
if [ -z $logbook_pid ]; then
  echo "Kancolle Logbook is not started..."
else
  echo "Kancolle Logbook is already run!"
fi

### JAVA_HOME
export JAVA_HOME="`/usr/libexec/java_home`"


### pyenv
export PYENV_ROOT=$HOME/.pyenv
export PATH=$PYENV_ROOT/bin:$PATH
eval "$(pyenv init -)"
# pyenv-virtualenv
eval "$(pyenv virtualenv-init -)"

### perl (brew)
# TODO: fix error (see log
# if [ ! $INTERNET_IS_ACTIVE ] ; then
#   PERL_MM_OPT="INSTALL_BASE=$HOME/perl5" cpan local::lib
#   eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib)"
# fi

### remove duplicate of PATH
__pathctl() {
  _path=""
  for _p in $(echo $PATH | tr ':' ' '); do
    case ":${_path}:" in
      *:"${_p}":* )
        ;;
      * )
        if [ "$_path" ]; then
          _path="$_path:$_p"
        else
          _path=$_p
        fi
        ;;
    esac
  done
  PATH=$_path
  unset _p
  unset _path
}
__pathctl

### homebrew
if [ `uname` = "Darwin" ] && [ -n `which brew` ] && [ -d $PYENV_ROOT ] ; then
  alias brew="env PATH=${PATH/${PYENV_ROOT}\/shims:/} brew"
fi

