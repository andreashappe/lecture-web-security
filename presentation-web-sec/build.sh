#!/bin/bash

TARGET=./../docs/web-sec

mkdir -p $TARGET
for i in *.md; do
	pandoc -t revealjs -s -V theme=solarized --slide-level=2 --css custom.css -o $TARGET/$i.html $i;
done

cp custom.css ./../docs
cp build/* $TARGET
