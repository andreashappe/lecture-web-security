#!/bin/sh
latexmk -e '$latex=q/pdflatex %O -shell-escape %S/' report.tex 
