#!/usr/bin/env bash

#set -x # debug

: "define" && {
  function run_bats_test() {
    bats_file="$1"
    if [ -z "$bats_file" ] ; then
      return 1
    fi
    cmd="bats $bats_file"
    echo $cmd && $cmd && echo
  }
}

: "preprocess" && {
  cd $(dirname $0)

  if [ ! -x "$(which bats)" ] ; then
    echo "Error: please install bats command" 1>&2
    exit 1
  fi

  test_dir="./test"
  script_dir="$(pwd)/script"
  export PATH="$script_dir:$PATH"
}

: "main process" && {
  for bats_file in $(find test -type f -name "*.bats")
  do
    run_bats_test $bats_file
  done
}
