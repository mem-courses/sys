#!/bin/bash

mkdir -p computer-architecture/public
cd computer-architecture/

cd assets/original/
python merge_pdf.py
python extract_images.py
cd ../../

python ./scripts/typ2md.py

python ./.github/scripts/publish_to_blog.py  ./posts ./computer-architecture/
