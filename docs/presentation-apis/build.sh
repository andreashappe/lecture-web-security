#!/bin/bash

pandoc -t revealjs -s -V theme=solarized --slide-level=2 --css custom.css -o build/index.html index.md;
