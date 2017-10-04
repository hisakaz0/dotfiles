#!/bin/bash
### If bash does not exist, return{{{
[ -z "$BASH" ] && return
[ -z "$PS1" ] && return
#}}}
### source system wide aliases{{{
if [ -f /etc/bashrc ]; then
    source /etc/bashrc
fi
#}}}
### hostname (long style{{{
__uname=`uname`
if [ "$__uname" = 'Darwin' ] ; then
  cmd_hostname="scutil --get LocalHostName"
elif [ "$__uname" = "FreeBSD" ] ; then
  cmd_hostname="hostname"
elif [ "$__uname" = "Linux" ] ; then
  cmd_hostname="hostname -f" # linux style
fi
__hostname=`$cmd_hostname`
if [ -z "$__hostname" ] ; then
  echo ">> error: hostname is not set!!!" 1>&2
fi
# }}}
### reset env variables{{{
[ -z "$LD_LIBRARY_PATH" ] && export LD_LIBRARY_PATH=""
[ -z "$DYLD_LIBRARY_PATH" ] && export DYLD_LIBRARY_PATH=""
[ -z "$CPATH" ] && export CPATH=""
[ -z "$LIBRARY_PATH" ] && export LIBRARY_PATH=""
#}}}
### Internet access{{{
{
  __is_interface_active() {
    if [ "$__uname" = 'Darwin' ] ; then
      local is="`ifconfig -u $1 | grep 'status: active'`"
    else
      local is="`ifconfig $1 2>/dev/null `"
    fi
    if [ "$is" ] ; then
      return 0 # possible to access internet
    else
      return 1 # impossible to access internet
    fi
    unset -v $is
  }
  __is_net() {
    while [ -n "$1" ]
    do
      __is_interface_active "$1"
      if [ $? -eq 0 ] ; then
        return 0 # possible
      fi
      shift
    done
    return 1 # impossible
  }

  echo "checking to access to internet..."
  __is_net 'en0' 'bridge 0' 'eth0' 'bce0' 'eno1'
  export IS_INTERNET_ACTIVE=$?
  if [ $IS_INTERNET_ACTIVE -eq 0 ] ; then
    echo ">> possible to access to internet!!"
  else
    echo ">> impossible to access to internet :("
  fi
  unset -f __is_interface_active
  unset -f __is_net
}
#}}}
### stty / options {{{
stty sane # reset all option to reasonable value
stty -ixon -ixoff # ctrl+s, ctrl+qの無効化
if [ "$__uname" != 'Darwin' ] && [ -z "`stty | grep erase`" ] ; then
   # If a escape sequence which deletes a charactor is not set correctly, the
   # sequence is set to 
   stty erase 
fi
[ -x "`which tabs`" ] && tabs -2 # tab width
set -o vi
#}}}
### language{{{
# NOTE: To check avaliable font list with `local -a | grep "ja"`
if [ "$__hostname" = 'kirara' ] ; then
  export LANG='ja_JP.UTF-8'
  export LC_ALL='ja_JP.UTF-8'
elif [ "$__uname" = "FreeBSD" ] ; then
  # export LANG=ja_JP.SJIS
  # export LC_ALL=ja_JP.SJIS
  # export LANG=ja_JP.eucJP
  # export LC_ALL=ja_JP.eucJP
  :
elif [ "$__uname" = "Linux" ] ; then
  export LANG=en_US.UTF-8
  export LC_ALL=en_US.UTF-8
fi
#}}}
### alias{{{
alias ls='ls -G'
alias ll='ls -hlF'
alias la='ls -aF'
# alias l='ls -CF'
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
alias RM='rm -f'
alias rm='rm -i'
alias CP='cp -f'
alias cp='cp -i'
alias mv='mv -i'
alias today='date'
export DATE=`date +%Y%m%d`
alias update_date='export DATE=`date +%Y%m%d`' # year month day
alias update_time='export TIME=`date +%s`'
alias bash_keybind="bind -p | grep 'C-' | grep -v 'abort\|version\|accept' | less"
alias ducks='du -h -d 1'
if [ "$__uname" != 'Darwin' ] && [ -x "`which xdg-open`" ] ; then
  # NOTE: On the Darwin, `open` is supported in default
  alias open='xdg-open'
fi
if [ -x "`which tmux`" ] ; then
  alias tmux='tmux -2'
  alias ta='tmux a'
  alias tat='tmux a -t'
fi
#}}}
### GNU Screen#{{{
if [ -x "`which screen`" ] ; then
  # The alias is the meant that if there is no available session, create new
  # session, else attach a most recently session.
  alias scr='screen -D -RR'
fi
# Creating directory to manage the screen sesison, to avoid a error such
# impossible to create session file beacase of permission.
export SCREENDIR=$HOME/.screen/$__hostname
if [ ! -d "$SCREENDIR" ] ; then
  mkdir -p $SCREENDIR
  chmod 700 $SCREENDIR
fi
#}}}
### utiles{{{
# [ -s ${HOME}/tmp/bash/fpath.sh ] && \
#   . $HOME/tmp/bash/fpath.sh ## get full path func
# [ -s ${HOME}/tmp/bash/prand.sh ] && \
#   . $HOME/tmp/bash/prand.sh ## print random charactors
# [ -s ${HOME}/tmp/bash/makeMakefile.sh ] && \
#   . $HOME/tmp/bash/makeMakefile.sh ## create template files for c lang
[ -s ${HOME}/tmp/kancolle/utils/kancolle_logbook.sh ] && \
  . $HOME/tmp/kancolle/utils/kancolle_logbook.sh ## kancolle logbook

# if [ "`which find`" ] && [ "`which xargs`" ] && [ "`which egrep`" ] ; then
#   fgx() {
#     __search_path=$1 && shift
#     __filetype=$1 && shift
#     __filename=$1 && shift
#     __regex=$1
#     find $__search_path -type $__filetype -name "$__filename" | \
#       xargs -I% egrep -H "$__regex" %
#   }
# fi

# Function printing the battery status
if [ "$__uname" = 'FreeBSD' ] ; then
  _print_battery_status () {
    if [ "$1" != '-o' ] ; then
      acpiconf -i 0
      return 0
    fi
    acpiconf -i 0 | tail -n4 | head -n1 | awk '{print $3}'
  }
elif [ "$__uname" = 'Darwin' ] ; then
  _print_battery_status () {
    # Show current battery status on Mac.
    # The items of battery status are both of percentage of remain battery,
    # and remain time to charge.
    #
    # Input args:
    #     <no parameters>
    # Options:
    #     -o: only percent of battery
    if [ "$1" != "-o" ] ; then
      pmset -g ps
      return 0
    fi
    pmset -g ps | egrep -o "[0-9]{1,3}%"
  }
fi
#}}}
### autoextract {{{
# complete -W "vim study php html cake" cake # cakeの補完設定
[ -x "`which autoextract`" ] && \
  complete -d autoextract # ~/bin/autoextracの補完
#}}}
### environments{{{
export PAGER='less'
export SVN_SSH='ssh -q'
export DAY=`date +%d` # month day
export MONTH=`date +%B` # month in literal
export YEAR=`date +%Y` # year
export MEMO_PATH=${HOME}/.memo
#}}}
### console style{{{
if [ "$__uname" = "Darwin" ] || [ "$__uname" = "FreeBSD" ]  ; then
  export PS1='($(_print_battery_status -o)) \u@\h:\W\$ '
else
  export PS1='\u@\h:\W\$ '
fi
if [ "`echo $TERM | grep 'screen'`" != "" ]; then
  export PROMPT_COMMAND='pwd=`pwd`; echo -ne "\033k\033\0134\033k`basename $pwd`\033\\";share_history'
else
  export PROMPT_COMMAND='share_history'
fi
share_history() {
  history -a
  history -c
  history -r
  update_time
}
export HISTCONTROL=ignoredups
export HISTFILE=$HOME/.bash_history
export HISTIGNORE="cd*:pwd*:fg*:bg*"
shopt -u histappend
export HISTSIZE=10000
## Current command name as window name
#export PS1='\[\033k\033\\\][\u@\h \W]\$ '
#export PS1='\[\033k\033\\\]\u@\h:\W\$ '
## PWD as window name
#export PS1='\u@\h:\W\$ '
#export PROMPT_COMMAND='echo -ne "\033k$(basename $(pwd))\033\\"'
## PWD when no command is running, otherwise current command name as window name
#export PS1='\u@\h:\W\$ '
#export PROMPT_COMMAND='echo -ne "\033k\033\0134\033k$(basename $(pwd))\033\\"'
## Above with a shared history among all terminals
#}}}
### shopt{{{
# shopt -s cdspell
# shopt -s extglob
# shopt -s histreedit
# shopt -s no_empty_cmd_completion
#}}}
### ls color{{{
if [ "$__uname" = "Linux" ]; then
    alias ls='ls -NF --show-control-chars'
    # if you use color ls, comment out above line and uncomment below 2 lines.
    LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.i386.rpm=01;31:*.src.rpm=01;30:*.jpg=01;35:*.gif=01;35:*.bmp=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.png=01;35:' ; export LS_COLORS
    alias ls='ls --color=auto -NF --show-control-chars'
elif [ "$__uname" = 'FreeBSD' ]; then
    export LSCOLORS=gxfxcxdxbxegedabagacad
    alias ls='ls -G'
fi
#}}}
### rbenv{{{
export RUBYGEMS_GEMDEPS=
[ -d $HOME/.rbenv ] &&
  export PATH=$HOME/.rbenv:$PATH
if [ -x "`which rbenv`" ] ; then
  export RBENV_ROOT=`rbenv root`
  echo "RBENV_ROOT: $RBENV_ROOT"
  eval "`rbenv init -`"
fi
#}}}
### user commands {{{
# [ "$__uname" = "Linux" ] && [ "`uname -a | grep 'x86_64'`" ] && \
#   [ -d $HOME/.usr/local/linux_x64/bin ] && \
#   export PATH=$HOME/.usr/local/linux_x64/bin:$PATH
[ "$__uname" = "FreeBSD" ] && [ -z "`uname -a | grep 'x86_64'`" ] && \
  [ -d $HOME/.usr/local/freebsd_386 ] && \
  export PATH=$HOME/.usr/local/freebsd_386/bin:$PATH
[ "$__uname" = "Linux" ] && [ -d $HOME/.usr/bin ] && \
  export PATH=$HOME/.usr/bin:$PATH
[ "$__uname" = "FreeBSD" ] && [ -d $HOME/usr/bin ] && \
  export PATH=$HOME/usr/bin:$PATH
[ "$__uname" = "Linux" ] && [ -d $HOME/bin/centos ] && \
  export PATH=$HOME/bin/centos:$PATH
[ -d $HOME/.bin ] && \
  export PATH=$HOME/.bin:$PATH
[ -d /usr/local/texlive/2015/bin/x86_64-darwin ] && \
  export PATH=/usr/local/texlive/2015/bin/x86_64-darwin:$PATH
[ -d /usr/local/wine/bin ] && \
  export PATH=/usr/local/wine/bin:$PATH
[ -d $HOME/tmp/utils/bin ] && \
  export PATH=$HOME/tmp/utils/bin:$PATH
[ -d $HOME/tmp/kancolle/utils/macosx-x64-ex.2.3.4 ] && \
  export PATH=$HOME/tmp/kancolle/utils/macosx-x64-ex.2.3.4:$PATH
if [ -f "/etc/redhat-release" ] ; then
  __arr=( `cat /etc/redhat-release | cut -d' ' -f3 | tr -s '.' ' '` )
  if [ ${__arr[0]} -eq 6 ] ; then
    export PATH=$HOME/.usr/local/cent69/usr/bin:$PATH
    export PATH=$HOME/.usr/local/cent6/usr/bin:$PATH
  fi
  unset -v __arr
fi

#}}}
### machine specific .bashrc{{{
if [ -s ".$__hostname/dot.bashrc.bash" ] ; then
    source ".$__hostname/dot.bashrc.bash"
fi
#}}}
### ssh-agent{{{
if [ "$__hostname" = 'quark' ] ; then
  # Refs: http://qiita.com/isaoshimizu/items/84ac5a0b1d42b9d355cf
  # eval `ssh-agent`
  SSH_IDENTIFY_FILE="$HOME/.ssh/hisakazu_quark"
  [ -z "`ssh-add -l | grep $SSH_IDENTIFY_FILE`" ] && \
    ssh-add $SSH_IDENTIFY_FILE
  SSH_IDENTIFY_FILE="$HOME/.ssh/hisakazu_quark_bitbucket"
  [ -z "`ssh-add -l | grep $SSH_IDENTIFY_FILE`" ] && \
    ssh-add $SSH_IDENTIFY_FILE
fi
if [ "$__uname" != 'Darwin' ] ; then
  SSH_AGENT_FILE="${HOME}/.ssh/.ssh-agent.$__hostname"
  if [ -f ${SSH_AGENT_FILE} ]; then
      eval `cat ${SSH_AGENT_FILE}`
      ssh_agent_exist=0
      for id in `ps ax|grep 'ssh-agent'|sed -e 's/\([0-9]\+\).*/\1/'`
      do
          if [ "${SSH_AGENT_PID}" = "${id}" ]
          then
              ssh_agent_exist=1
          fi
      done
      if [ $ssh_agent_exist = 0 ]
      then
          rm -f ${SSH_AGENT_FILE}
          ssh-agent > ${SSH_AGENT_FILE}
          chmod 600 ${SSH_AGENT_FILE}
          eval `cat ${SSH_AGENT_FILE}`
          ssh-add ${SSH_IDENTITY_FILE}
      fi
  else
      ssh-agent > ${SSH_AGENT_FILE}
      chmod 600 ${SSH_AGENT_FILE}
      eval `cat ${SSH_AGENT_FILE}`
      ssh-add ${SSH_IDENTITY_FILE}
  fi
  alias sshkey='eval `cat ${SSH_AGENT_FILE}`'
  alias sshrm='rm -f ${SSH_AGENT_FILE}'
fi
#}}}
### hub (github{{{
# Load hub
if [ -x "`which hub`" ] ; then
  eval "`hub alias -s`"
fi
#}}}
### autoupdate dotfiles{{{
(
  dotfiles_update () {
    [ $IS_INTERNET_ACTIVE -ne 0 ] && return
    if [ "$__hostname" = 'quark' ] ; then
      dotfiles_dir="$HOME/work/github/pinkienort/dotfiles"
    else
      dotfiles_dir="$HOME/work/github/dotfiles"
    fi
    [ ! -d $dotfiles_dir ] && return
    cd $dotfiles_dir
    git_status=`git status -s`
    if [ -z "$git_status" ] ; then
      echo "dotfiles >> autoupdating..."
      git_update () {
        git_autoupdate_logfile="$dotfiles_dir/.autoupdate.log"
        echo "Date: `date`" > $git_autoupdate_logfile
        is_update=`git fetch`
        if [ "$is_update" ] ; then
          echo ">> Pull new updates." >> $git_autoupdate_logfile
          git pull origin master >> $git_autoupdate_logfile 2>&1
        else
          echo ">> No new updates." >> $git_autoupdate_logfile
        fi
      }
      git_update &
    else
      echo "dotfiles >> following files are remained..."
      git status -s
    fi
  }
  dotfiles_update
)
#}}}
### github install#{{{
__github_info () {
  # args:
  #   github_url
  # return value:
  #   "$user $repo"
  user="${1##*:}" ; user="${user%%\/*}"
  repo="${1##*\/}"; repo="${repo%%.*}"
  echo "$user $repo"
}
__github_install () {
  (
    if [ -z "`which git`" ] ; then
      return
    fi
    url="$1"
    arr=( $(__github_info "$url") )
    user_dir="$HOME/work/github/${arr[0]}"
    repo_dir="$user_dir/${arr[1]}"
    log="$HOME/work/github/.install.log"
    if [ -f "$user_dir" ] ; then
      return # exception
    fi
    if [ ! -d "$user_dir" ] ; then
      echo "Make directory: $user_dir" | tee $log
      mkdir -p "$user_dir"
    fi
    cd "$user_dir"
    if [ -d "$repo_dir" ] ; then
      return
    fi
    echo "Install $user/$repo" | tee $log
    git clone $url >> $log 2>&1 &
  )
}
__repo_arr=( "git@github.com:pinkienort/dotfiles.git" "git@github.com:usp-engineers-community/Open-usp-Tukubai.git" "git@github.com:huyng/bashmarks.git" )
for url in ${__repo_arr[*]}
do
  __github_install "$url"
done
#}}}
### tukubai#{{{
__tukubai_inf=( $(__github_info "git@github.com:usp-engineers-community/Open-usp-Tukubai.git") )
__tukubai_dir="$HOME/work/github/${__tukubai_inf[0]}/${__tukubai_inf[1]}"
if [ -d "$__tukubai_dir" ] ; then
  export PATH="$__tukubai_dir/COMMANDS:$PATH"
fi
unset -v __tukubai_info
unset -v __tukubai_dir
unset -f __github_install
unset -f __github_info
unset -v __repo_arr
#}}}
### kancolle logbook (check wheather process is running{{{
if [ "$__hostname" = 'quark' ] ; then
  logbook_pid=`ps aux| grep "logbook" | grep -v "grep" | awk '{ print $2; }'`
  if [ -z $logbook_pid ]; then
    echo "Kancolle Logbook is not started..."
  else
    echo "Kancolle Logbook is already run!"
  fi
fi
#}}}
### vim settings{{{
# NOTE: make executable file without dynamic link lib.
alias vim 1>/dev/null 2>&1  # reset vim alias
if [ $? -eq 0 ] ; then
  unalias vim
fi

if [ "`which ldd`" ] ; then
  __which_vim=`which vim`
  __vim_lib_error="`ldd $__which_vim 2>&1 1>/dev/null`"
  unset -v __which_vim
else
  __vim_lib_error=""
fi
if [ -z "$__vim_lib_error" ] &&
   [ "$__hostname" != "cad103.naist.jp" ] &&
   [ "$__hostname" != "cad104.naist.jp" ] ; then
  echo "vim > use package installed"
  __vim_path=`which vim`
  alias vim=$__vim_path
  export EDITOR=$__vim_path
  unset -v __vim_path
elif [ -x /usr/bin/vim ] ; then
  echo "vim > use system"
  alias vim=/usr/bin/vim
  export EDITOR=/usr/bin/vim
else
  echo "vim > there are no vim to execute..."
  export EDITOR=vi
fi

# thinca/vim-themis: test tool for vim plugins
[ -d $HOME/.vim/bundle/repos/github.com/thinca/vim-themis/bin ] &&
  export PATH=$HOME/.vim/bundle/repos/github.com/thinca/vim-themis/bin:$PATH
unset -v __vim_lib_error
#}}}
### bashmarks{{{
if [ -r $HOME/.local/bin/bashmarks.sh ] ; then
  . $HOME/.local/bin/bashmarks.sh
fi
#}}}
### docker{{{
if [ -x "`which docker-machine`" ] ; then
  eval `docker-machine env default`
fi
#}}}
### cad tools{{{
# vdec (synopsys, cadence{{{
case "$__hostname" in
  "cad110.naist.jp" )
    if [ `uname` = Linux ] && [ -s /opt/xilinx/ise101/ISE/settings64.sh ] ; then
      echo "=========================================="
      echo "======== ISE101/GP8M is available ========"
      echo "=========================================="
      source /opt/xilinx/ise101/ISE/settings64.sh
    fi
  ;;
  "cad101.naist.jp" | "cad102.naist.jp" )
    if [ `uname` = Linux ] && [ -s /opt/xilinx/ise123/settings64.sh ] ; then
      echo "=========================================="
      echo "======== ISE123/GP5V is available ========"
      echo "=========================================="
      source /opt/xilinx/ise123/settings64.sh
    fi
    ;;
  "arch16.naist.jp" | "arch17.naist.jp" )
    if [ `uname` = Linux ] && [ -s /opt/xilinx/ise134/settings64.sh ] ; then
      echo "=========================================="
      echo "======== ISE134/GP6V is available ========"
      echo "=========================================="
      source /opt/xilinx/ise134/settings64.sh
    fi
    ;;
  "cad111.naist.jp" | "cad112.naist.jp" | "cad113.naist.jp" | "cad114.naist.jp" )
    if [ `uname` = Linux ] && [ -s /opt/vdec/setup/vdec_tools.2016.sh ] ; then
      echo "=========================================="
      echo "======== VDEC Tools are available ========"
      echo "=========================================="
      source /opt/vdec/setup/vdec_tools.2016.sh
    fi
    ;;
esac
#}}}
# vivado{{{
case "$__hostname" in
  "arch09.naist.jp" | "cad101.naist.jp" | "cad102.naist.jp" | \
  "cad103.naist.jp" | "cad104.naist.jp" | "cad115.naist.jp" | \
  "cad116.naist.jp" | "cad117.naist.jp" | "cad118.naist.jp" )
    if [ `uname` = Linux ] && [ -s /opt/xilinx/Vivado/2016.2/settings64.sh ] ; then
      source /opt/xilinx/Vivado/2016.2/settings64.sh
      echo "=========================================="
      echo "======== Vivado/ZYNQ is available ========"
      echo "=========================================="
      echo "Vivado: $XILINX_VIVADO"
    fi
    ;;
esac
#}}}
# petalinux{{{
# case "$__hostname" in
#   "cad101.naist.jp" | "cad102.naist.jp" | "cad106.naist.jp" | "cad107.naist.jp" )
#     if [ `uname` = Linux ] && [ -s /opt/xilinx/PetaLinux/petalinux-v2016.4-final/settings.sh ] ; then
#       source /opt/xilinx/PetaLinux/petalinux-v2016.4-final/settings.sh
#       echo "========================================"
#       echo "======== Petalinux is available ========"
#       echo "========================================"
#     fi
#     ;;
#  esac
#}}}
#}}}
### nvm (Node Version Manager{{{
export NVM_DIR="$HOME/.nvm"
# This loads nvm
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
# This loads nvm bash_completion
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
# Use latest node
nvm use `ls -1 $NVM_DIR/versions/node/ | sort | tail -n1`
#}}}
### java{{{
[ -x "/usr/libexec/java_home" ] && \
  export JAVA_HOME="`/usr/libexec/java_home`"
#}}}
### pyenv{{{
#
# NOTE: pyenv is PYthon ENVironment manager...maybe.
# pyenv can install official python distributions, and also
# can install 'anaconda distributions.
# In anaconda distribution, virtual environments are created by
# 'conda' command(Usually, in officail python distributions,
# you should use 'pyenv virtualenv' command.
#
# How to manage python environments on Anaconda python distribution.
# reference: http://qiita.com/y__sama/items/5b62d31cb7e6ed50f02c
#          : http://qiita.com/y__sama/items/f732bb7bec2bff355b69
# - Create new env.
#   >> conda -n <env name>
# - Enable a env. DO NOT USE 'source activate/diactivate' commands
#   which are introduced in official. Above commands are conflicts
#   with 'source' command of 'bash'.
#   >> pyenv activate <env name>
#   Disable a env.
#   >> pyenv deactivate <env name>
# - Install python of anaconda distribution
#   >> pyenv installpython ver. or distribution>
# - Show env list.
#   >> conda env list
# - Remove a env.
#   >> conda remove -n <env name> --all
#

if \
  # NOTE: #2 has chainer, version 2.0.0
  # But current program of train_imagenet is worked
  # in version 1.23.0. And #3 is has 1.23.0
  #
  # Date: 2017/09/21
  # cad11{5,8,9} machies are assigned as machine for Machine Learning.
  # Previously, cad10{3,4,5,6} are assigned, but GPUs on these machine are
  # migrated to cad11{5,8}. Old pythnon env. are reamined such as
  # ~/.pyenv/s{2,3,4,5,6}. Currently, no-GPU machines use same python env.,
  # such as 's1'. Other machiens which has GPUs, has own env which is named
  # with `hostname`.
  [ "$__hostname" = "cad101.naist.jp" ] ||
  [ "$__hostname" = "cad102.naist.jp" ] ||
  [ "$__hostname" = "cad103.naist.jp" ] ||
  [ "$__hostname" = "cad104.naist.jp" ] ||
  [ "$__hostname" = "cad105.naist.jp" ] ||
  [ "$__hostname" = "cad106.naist.jp" ] ||

  [ "$__hostname" = "cad110.naist.jp" ] ||
  [ "$__hostname" = "cad111.naist.jp" ] ||
  [ "$__hostname" = "cad112.naist.jp" ] ||
  [ "$__hostname" = "cad113.naist.jp" ] ||
  [ "$__hostname" = "cad114.naist.jp" ] ||
  [ "$__hostname" = "cad116.naist.jp" ] ||
  [ "$__hostname" = "cad117.naist.jp" ] ; then
  export PYENV_ROOT=$HOME/.pyenv/s1
elif \
  [ "$__hostname" = "cad115.naist.jp" ] ; then
  export PYENV_ROOT=$HOME/.pyenv/cad115
elif \
  [ "$__hostname" = "cad118.naist.jp" ] ; then
  export PYENV_ROOT=$HOME/.pyenv/cad118
elif \
  [ "$__hostname" = "cad119.naist.jp" ] ; then
  export PYENV_ROOT=$HOME/.pyenv/cad119
else
  export PYENV_ROOT=$HOME/.pyenv
fi
if [ -d "$PYENV_ROOT" ] ; then
  echo "PYENV_ROOT: $PYENV_ROOT"
  export PATH=$PYENV_ROOT/bin:$PATH
  eval "`pyenv init -`"
  eval "`pyenv virtualenv-init -`"
fi
#}}}
### Python {{{
[ -d "$HOME/work/edge-iot/exp/chainer/dataset/imagenet/lib" ] &&
  export PYTHONPATH="$HOME/work/edge-iot/exp/chainer/dataset/imagenet/lib"
#}}}
### cuda{{{
if   [ -d /usr/local/cuda-8.0 ] ; then
  __cuda_dir='/usr/local/cuda-8.0'
elif [ -d /usr/local/cuda-7.5 ] ; then
  __cuda_dir='/usr/local/cuda-7.5'
elif [ -d /usr/local/cuda-7.0 ] ; then
  __cuda_dir='/usr/local/cuda-7.0'
elif [ -d /usr/local/cuda ] ; then
  __cuda_dir='/usr/local/cuda'
fi
if [ -d "$__cuda_dir" ] ; then
  export CUDA_PATH="$__cuda_dir"
  export PATH="$CUDA_PATH/bin:$PATH"
  export CFLAGS="-I$CUDA_PATH/include"
  export LDFLAGS="-L$CUDA_PATH/lib64"
  export LD_LIBRARY_PATH="$CUDA_PATH/lib64:$LD_LIBRARY_PATH"
  export DYLD_LIBRARY_PATH="$CUDA_PATH/lib64:$DYLD_LIBRARY_PATH"
  nvcc -V
  if [ -f $CUDA_PATH/include/cudnn.h ] ; then
    echo ">> cudnn is available"
  fi
fi
unset -v __cuda_dir
### NCCL#{{{
if [ -d "$HOME/.usr/local/cad115/nccl" ] ; then
  export NCCL_ROOT=$HOME/.usr/local/cad115/nccl
fi
if [ -d "$HOME/.usr/local/cad118/nccl" ] ; then
  export NCCL_ROOT=$HOME/.usr/local/cad118/nccl
fi
# On cad119, use system-wide NCCL lib.
# if [ -d "$HOME/.usr/local/cad115/nccl" ] ; then
#  export NCCL_ROOT=$HOME/.usr/local/cad119/nccl
# if

if [ -n "$NCCL_ROOT" ] ; then
  export CPATH=$NCCL_ROOT/include:$CPATH
  export LD_LIBRARY_PATH=$NCCL_ROOT/lib:$LD_LIBRARY_PATH
  export LIBRARY_PATH=$NCCL_ROOT/lib:$LIBRARY_PATH
fi
#}}}
#}}}
### perl {{{
# TODO: fix error (see log
# if [ ! $IS_INTERNET_ACTIVE ] ; then
#   PERL_MM_OPT="INSTALL_BASE=$HOME/perl5" cpan local::lib
#   eval "`perl -I$HOME/perl5/lib/perl5 -Mlocal::lib`"
# fi
[ -d $HOME/.usr/local/perl/modules/lib/perl5 ] && \
  export PERL5LIB=$HOME/.usr/local/perl/modules/lib/perl5
[ -d $HOME/.usr/local/perl/modules/lib64/perl5 ] && \
  export PERL5LIB=$HOME/.usr/local/perl/modules/lib64/perl5:$PERL5LIB
alias iperl="perl -de 0"
#}}}
### emax{{{
# [ -d $HOME/work/emaxv/nakashim/proj-arm64.cent ] && \
#   export EMAXV_SIML_PROJ_ROOT="$HOME/work/emaxv/nakashim/proj-arm64.cent"
# [ -d $EMAXV_SIML_PROJ_ROOT/bin ] && \
#   export PATH=$EMAXV_SIML_PROJ_ROOT/bin:$PATH
# [ -d $EMAXV_SIML_PROJ_ROOT/lib ] && \
#   export LD_LIBRARY_PATH=$EMAXV_SIML_PROJ_ROOT/lib:$LD_LIBRARY_PATH
# [ -d "$HOME/works/nakashim/proj-arm64.cent/lib/asim64-lib" ] && \
#   export LD_LIBRARY_PATH="$HOME/works/nakashim/proj-arm64.cent/lib/asim64-lib:$LD_LIBRARY_PATH"
#}}}
### Rails(ruby){{{
# completion
[ -s "`brew --prefix`/etc/bash_completion.d/rails.bash" ] && \
  . `brew --prefix`/etc/bash_completion.d/rails.bash
#}}}
### go lang{{{
# macOS
[ -d /usr/local/opt/go/libexec ] && \
  export GOROOT=/usr/local/opt/go/libexec # go lang bin dir
# linux
[ -d $HOME/.go/versions/1.6 ] && \
  export GOROOT=$HOME/.go/versions/1.6
export GOPATH=$HOME/work/share/go # workspace dir
[ ! -d "$GOPATH" ] && mkdir -p $GOPATH
[   -d "$GOPATH" ] && export PATH=$GOPATH/bin:$PATH
(
  # Install twitter client written with go-lang. The process launched as child
  # of this bash process so that it takes a time.
  if [ ! -x "$GOPATH/bin/ringot" ] && [ -n "`which go`" ] ; then
    logfile="$GOPATH/.install.log"
    echo ">> install ringot... | logfile: $logfile"
    go get     github.com/tSU-RooT/ringot 1> $logfile 2>&1 &
    go install github.com/tSU-RooT/ringot 1> $logfile 2>&1 &
  fi
)
#}}}
### remove duplicate ENVs{{{
{
  __remove_duplicate() {
    local _env=""
    local _env_name="$1"
    local _ENV="${!1}"
    for _e in `echo $_ENV | tr ':' ' '`; do
      case ":${_env}:" in
        *:"${_e}":* )
          ;;
        * )
          if [ "$_env" ]; then
            _env="$_env:$_e"
          else
            _env=$_e
          fi
          ;;
      esac
    done
    eval "export $_env_name=$_env"
    unset _e
    unset _env
    unset _env_name
    unset _ENV
  }
  __remove_duplicate "PATH"
  __remove_duplicate "LD_LIBRARY_PATH"
  __remove_duplicate "DYLD_LIBRARY_PATH"
  __remove_duplicate "LIBRARY_PATH"
  __remove_duplicate "CPATH"
  unset -f __remove_duplicate
}
#}}}
### homebrew{{{
[ -s "`brew --prefix`/etc/bash_completion" ] &&
  . `brew --prefix`/etc/bash_completion
if [ "`which brew`" ] && [ -d $PYENV_ROOT ] ; then
  alias brew="env PATH=${PATH/${PYENV_ROOT}\/shims:/} brew"
fi
#}}}

unset -v __uname
unset -v __hostname


update_date
update_time
