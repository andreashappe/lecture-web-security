#!/bin/bash

for i in *.md; do
	pandoc -t revealjs -s -V theme=solarized --slide-level=2 -V revealjs-url=https://unpkg.com/reveal.js@3.9.2/ --css custom.css -o build/$i.html $i;
done
