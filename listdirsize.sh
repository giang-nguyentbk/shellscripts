#!/bin/bash

find . -maxdepth 1 -type d | grep -vE ".snapshot" | grep "\./" > dir.txt

while IFS= read -r line
    do
#        du -sh "$line" | grep -vE "[0-9].*K"
         du -sh "$line" | sed 's/[0-9].*K/0M/g'
    done < dir.txt

rm -rf ./dir.txt

