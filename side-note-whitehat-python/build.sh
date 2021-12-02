#!/bin/sh
pandoc -t revealjs --slide-level=2 -s presentation-src.md -o presentation.html -V revealjs-url=https://unpkg.com/reveal.js@3.9.2/ -V theme=beige --css=custom.css

mkdir -p ./../docs/presentation-whitehat-python
cp *.html *.css *.jpg *.jpeg ./../docs/presentation-whitehat-python
