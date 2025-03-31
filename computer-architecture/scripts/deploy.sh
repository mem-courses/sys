#!/bin/bash

cd $(pwd)

mkdir public

cd assets/original
python merge_pdf.py

cd ../../scripts
python pdf2img.py