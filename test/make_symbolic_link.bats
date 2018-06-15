
@test "Return errno 1 when args is less than 2" {
  run make_symbolic_link "hisa"
  [ "$status" -eq 1 ]
  [ "$output" = "usage: make_symbolic_link <src> <dist>" ]
}

@test 'Return errno 1 when "$src" is not existed' {
  src="/tmp/path-dir/to-file"
  dist="$HOME/path-dir/to-file"

  run make_symbolic_link $src $dist
  [ "$status" -eq 1 ]
  [ "$output" = "Error: '$src' is not exist" ]
}

@test 'Return errno 1 when "$src" is not regular file or not directory' {
  src="/tmp/path-dir/to-file"
  src_parent="/tmp/path-dir"
  dist="$HOME/path-dir/to-file"
  mkdir -p $src_parent
  ln -s '/tmp' $src

  run make_symbolic_link $src $dist

  rm -f $src
  rmdir $src_parent

  [ "$status" -eq 1 ]
  [ "$output" = "Error: '$src' must be regular file or directory" ]
}

@test 'Return errno 1 when "$src" is relative path' {
  src="path-dir"
  dist="$HOME/path-file"
  mkdir -p $src

  run make_symbolic_link $src $dist

  rmdir $src

  [ "$status" -eq 1 ]
  [ "$output" = "Error: '$src' path must be absolute path" ]
}

@test 'Return errno 1 when "$dist" is not symbolic link' {
  src="/tmp/path-dir/to-file"
  dist="$HOME/path-file"
  touch $dist

  run make_symbolic_link $src $dist

  rm -f $dist

  [ "$status" -eq 1 ]
  [ "$output" = "Error: '$dist' which is not symbolic link, is already existed" ]
}

@test 'Success when "$dist" is symbolic link' {
  src="/tmp/path-dir"
  dist="$HOME/path-file"
  mkdir $src
  ln -s /tmp $dist

  run make_symbolic_link $src $dist

  rm -f $dist
  rmdir $src

  [ "$status" -eq 0 ]
}

@test 'Success when symbolic link of "$dist" is created' {
  src="/tmp/path-dir"
  dist="$HOME/path-file"
  mkdir -p $src

  run make_symbolic_link $src $dist

  rmdir $src

  [ -h "$dist" ]

  rm -f $dist

  [ "$status" -eq 0 ]
}

