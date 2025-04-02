#!/bin/bash

mkdir -p computer-architecture/public

cd computer-architecture/assets/original/
python merge_pdf.py
python extract_images.py
cd ../../../

python ./computer-architecture/scripts/typ2md.py

python ./.github/scripts/publish_to_blog.py  ./posts ./computer-architecture/
