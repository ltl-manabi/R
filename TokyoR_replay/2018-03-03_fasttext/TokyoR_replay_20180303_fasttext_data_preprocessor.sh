#!/bin/bash
wget https://www.rondhuit.com/download/ldcc-20140209.tar.gz
tar xzvf ldcc-20140209.tar.gz
mv text/ ldcc-20140209/
cd ldcc-20140209
find . -type f -name "[A-Z]*" -exec rm -f {} \;
find . -type f -name "*.txt" | parallel -j +0 "sed -e '1,3d' -e '/^$/d' -e 's/^　//g' {} > {}.tmp && mv {}.tmp {}"
