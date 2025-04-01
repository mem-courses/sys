#!/bin/bash

mkdir -p computer-architecture/public
cd computer-architecture/

cd assets/original
python merge_pdf.py
python extract_images.py

# cd ../../scripts
# python typ2md.py