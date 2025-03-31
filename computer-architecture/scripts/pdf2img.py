import os
import sys
import fitz


from utils import extract_images


def flatten(x): return [y for l in x for y in flatten(l)] if type(x) is list else [x]


source = os.path.abspath(os.path.join('..', 'assets'))
target = os.path.abspath(os.path.join('..', 'public'))

slides = [5, 6]
clip = {'up': 0, 'down': 0, 'left': 0.05, 'right': 0.05}

pdf_files = flatten([
    ['merged/%02d.pdf' % slide, 'translated/%02d.pdf' % slide]
    for slide in slides
])
print(pdf_files)

for slide in pdf_files:
    input_file = os.path.join(source, slide)

    folder_name = slide.replace('/', '-').replace('.pdf', '')
    output_dir = os.path.join(target, folder_name)

    extract_images(input_file, output_dir, clip=clip, dpi=100)

SLIDE2X = '#slide2x([{page}], image("../public/merged-{slide0}/{page0}.jpg"), image("../public/translated-{slide0}/{page0}.jpg"))'

for slide_id in slides:
    dir1 = 'merged-%02d' % slide_id
    dir2 = 'translated-%02d' % slide_id
    dir1_imgs = os.path.join(target, dir1.replace('.pdf', ''))
    dir2_imgs = os.path.join(target, dir2.replace('.pdf', ''))
    num = max(
        len(os.listdir(dir1_imgs)),
        len(os.listdir(dir2_imgs)),
    )
    print(slide_id, 'num:', num)

    output = ''
    for i in range(1, num + 1):
        output += SLIDE2X.format(
            page=i,
            slide=slide_id,
            page0='%04d' % i,
            slide0='%02d' % slide_id,
        )
        output += '\n\n'

    output_file = os.path.join('../public', '%02d.txt' % slide_id)
    with open(output_file, 'w+') as f:
        f.write(output)
        f.close()
