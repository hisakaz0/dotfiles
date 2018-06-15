
@test "Return errno 1 when args is less than 1" {
  run make_parent_directory ""
  [ "$status" -eq 1 ]
  [ "$output" = "usage: make_parent_directory <target>" ]
}

@test 'Success when parent dir of "$dist" is "$HOME" #1' {
  run make_parent_directory "$HOME/path"
  [ "$status" -eq 0 ]
}

@test 'Success when parent dir of "$dist" is "$HOME" #2' {
  run make_parent_directory "$HOME/path.to"
  [ "$status" -eq 0 ]
}

@test 'Success when parent dir of "$dist" is "$HOME" #3' {
  run make_parent_directory "$HOME/path.to.file"
  [ "$status" -eq 0 ]
}

@test 'Return errno 1 when parent of "$dist" is not dirctory' {
  target_parent="$HOME/path"
  touch "$target_parent"

  run make_parent_directory "$target_parent/to"

  rm -f "$target_parent"

  [ "$status" -eq 1 ]
  [ "$output" = "Error: '$target_parent/to' parent is already existed as a regular file" ]
}

@test 'Success when parent dir of "$dist" is already existed' {
  target_parent="$HOME/path-dir"
  mkdir $target_parent

  run make_parent_directory "$target_parent/to"

  rmdir $target_parent

  [ "$status" -eq 0 ]
}

@test 'Success when parent dir of "$dist" is created' {
  target_parent="$HOME/path-dir-yet"

  run make_parent_directory "$target_parent/to"

  [ -d "$target_parent" ]

  rmdir $target_parent

  [ "$status" -eq 0 ]
}
