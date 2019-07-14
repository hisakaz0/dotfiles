
# 起動時に導入するのは重い
# 起動時にはチェックするだけ（インストールされているかどうか
  # レポのディレクトリがあるかどうか

repos_root="$HOME/.repository"
repos=( \
  "git@github.com:pinkienort/dotfiles.git" \
  "git@github.com:usp-engineers-community/Open-usp-Tukubai.git" \
  "git@github.com:huyng/bashmarks.git" \
)

function git_repo_install {
  user_and_repo=$(echo $1 | tr -s ':' '/' | awk -F'/' '{ print $(NF-1),$NF }')
  repo_dir="$repos_root/${user_and_repo[0]}/${user_and_repo[1]}"
  if [ -e "$repo_dir" ] && [ -d "$repos_dir" ] ; then
    return # already exist
  fi
  mkdir -p $repo_dir
  git clone $1 $repo_dir
}

function main() {
  if [ ! -x "$(which git)" ] ; then
    echo "Error: 'git' executable is not found." 1>&2
    exit 1
  fi
  for repo in ${repos[@]} ; do git_repo_install $repo ; done
}

if [ "$1" = "check" ] ; then
  if [ ! -d "$repos_root" ] ; then
    echo "Warning: $repos_root is installed." 1>&2
    exit 0
  fi
  exit 0
elif [ "$1" = "install" ] ; then
  main
else
  exit 1 # invalid args
fi

