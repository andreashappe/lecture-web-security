#!/bin/bash

TARGET=./../docs/

mkdir -p $TARGET
pandoc -t revealjs -s -V revealjs-url=https://unpkg.com/reveal.js@3.9.2/ -V theme=solarized --slide-level=2 --css custom.css -o $TARGET/web-appsec.html web-appsec.md;
