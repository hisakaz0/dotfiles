
# ## go lang
function _install_go_pkg() {
  set _pkg_root $GOPATH/pkg/(go version | awk '{ print $4 }'  | sed 's/\//_/')
  # echo $_pkg_root
  # go get install $1
}

if [ -x "$(which go)" ] ; then
  export GOPATH="$HOME/.go-lang"
  if [ ! -e "$GOPATH" ] && [ ! -d "$GOPATH" ] ; then
    mkdir -p $GOPATH
  fi
  export PATH="$GOPATH/bin:$PATH"
  _install_go_pkg
  # set -e _repos
  # set _repos github.com/tSU-RooT/ringot
fi
