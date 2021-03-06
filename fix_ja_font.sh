#!/bin/bash

### RStudio Cloudでグラフの日本語表示をするためのスクリプト
### Author: Kenta Tanaka (https://mana.bi/)
### 以下の記事を参考 (ほぼ丸パクり) にしました
### https://ziomatrix18.blog.fc2.com/blog-entry-853.html
###
### 使い方
### RStudio Cloudの [Terminal] で以下のように実行してください
### curl -fsSL https://github.com/ltl-manabi/R/raw/master/fix_ja_font.sh | sh -s

mkdir ~/tmp
cd ~/tmp
curl -O -L https://moji.or.jp/wp-content/ipafont/IPAexfont/IPAexfont00401.zip
unzip IPAexfont00401.zip
mkdir -p ~/.fonts/ipa
cp ./IPAexfont00401/*.ttf ~/.fonts/ipa
fc-cache -f ~/.fonts
