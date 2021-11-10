#!/bin/sh
pandoc -t revealjs --slide-level=2 -s presentation-src.md -o presentation.html -V revealjs-url=https://unpkg.com/reveal.js@4.1.3/ -V theme=beige --css=custom.css

cp *.html *.png *.css *.jpg *.jpeg ./../docs/presentation-web-app-sec
