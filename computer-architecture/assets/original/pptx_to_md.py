import os
from pathlib import Path
from pptx2md import convert, ConversionConfig


def pptx_to_md(source, dist):
    if not os.path.exists(dist+'_img'):
        os.makedirs(dist+'_img')
    convert(
        ConversionConfig(
            pptx_path=Path(source),
            output_path=Path(dist),
            image_dir=Path(dist+'_img'),
            disable_notes=True
        )
    )


path = os.path.dirname(os.path.abspath(__file__))
for subPath in os.listdir(path):
    source = os.path.join(path, subPath)
    if source.endswith('.pptx'):
        print(source)
        dist = source[:-5] + '.md'
        if not os.path.exists(dist):
            pptx_to_md(source, dist)
