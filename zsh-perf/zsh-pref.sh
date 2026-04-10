#!/bin/bash

outfile=$1

# 前の結果が残っている可能性があるためファイルを初期化
echo           >$outfile

# 3回計測する
echo "#1"      >>$outfile
zsh -i -c exit >>$outfile
echo "#2"      >>$outfile
zsh -i -c exit >>$outfile
echo "#3"      >>$outfile
zsh -i -c exit >>$outfile
