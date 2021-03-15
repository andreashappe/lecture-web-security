#!/bin/sh
pandoc -t revealjs --slide-level=2 -s presentation.md -o presentation.html -V revealjs-url=https://unpkg.com/reveal.js@3.9.2/ -V theme=beige --css=custom.css
cp -r . ./../docs/side-notes-http-header
