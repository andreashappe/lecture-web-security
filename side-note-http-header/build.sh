#!/bin/sh

TARGET=./../docs/side-notes-http-header

mkdir $TARGET
pandoc -t revealjs --slide-level=2 -s presentation.md -o $TARGET/presentation.html -V theme=beige --css=custom.css
cp ./build/* $TARGET
