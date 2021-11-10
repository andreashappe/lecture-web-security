#!/bin/bash

TARGET=./../docs/

mkdir -p $TARGET
pandoc -t revealjs -s -V theme=solarized --slide-level=2 --css custom.css -o $TARGET/web-appsec.html web-appsec.md;
