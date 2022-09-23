#!/bin/sh
# pandoc -t revealjs --slide-level=2 -s presentation-src.md -o presentation.html -V revealjs-url=https://unpkg.com/reveal.js@3.9.2/ -V theme=beige --css=custom.css

mkdir -p ./../docs/web-app-sec-2020
cp *.html *.jpg *.jpeg *.png *.css ./../docs/web-app-sec-2020
