#!/bin/bash

TARGET=./../docs/apis

mkdir $TARGET
pandoc -t revealjs -s -V theme=solarized --slide-level=2 --css custom.css -o $TARGET/index.html index.md;

cp -r build/* $TARGET
