import os
import subprocess
import tempfile
import re


TAG_BEGIN_BEGIN = '😡'
TAG_BEGIN_END = '🥶'
TAG_END = '🐯'

IMAGE_BEGIN = TAG_BEGIN_BEGIN + "image" + TAG_END
IMAGE_END = TAG_BEGIN_END + "image" + TAG_END

MARK_BEGIN = TAG_BEGIN_BEGIN + "mark" + TAG_END
MARK_END = TAG_BEGIN_END + "mark" + TAG_END

QUOTE_BEGIN = TAG_BEGIN_BEGIN + "quote" + TAG_END
QUOTE_END = TAG_BEGIN_END + "quote" + TAG_END

CALLOUT_TYPE_BEGIN = TAG_BEGIN_BEGIN + "callout" + TAG_END
CALLOUT_TYPE_END = TAG_BEGIN_END + "callout" + TAG_END

CALLOUT_TYPES = ['note', 'tip', 'example', 'quote']

template = f'''
#let project = (body, ..) => body
#let mark = (it) => {{
    text("{MARK_BEGIN}")
    it
    text("{MARK_END}")
}}
#let image(src, width: 100%) = [
    {IMAGE_BEGIN}src="#src;" width="#width;"{IMAGE_END}
]
#let align(pos, body) = body
#let slide2x = (..) => par[]
#let no-par-margin = (..) => par[]
'''

for callout_type in CALLOUT_TYPES:
    template += f'''
    #let {callout_type} = (body) => [
        {QUOTE_BEGIN} {CALLOUT_TYPE_BEGIN}{callout_type}{CALLOUT_TYPE_END}
        
        #body
        
        {QUOTE_END}
    ]
    '''


def pre_process(content):
    # 处理对slide-width和slide-height的修改
    content = '\n'.join([line for line in content.split('\n') if not line.startswith('#slide')])
    # TBD: 处理对slide-width和slide-height的修改

    # 过滤掉所有#import、#outline开头的行
    content = '\n'.join([line for line in content.split('\n') if not line.startswith('#import ')])
    content = '\n'.join([line for line in content.split('\n') if not line.startswith('#outline(')])

    # 过滤掉#show: project.with(...)部分，注意需要...内部也可能有括号，需要记录括号个数来维护括号匹配
    lines = content.split('\n')
    filtered_lines = []
    skip_mode = False
    bracket_count = 0

    for line in lines:
        if not skip_mode:
            if line.strip().startswith('#show: project.with'):
                if '(' in line:
                    skip_mode = True
                    bracket_count = line.count('(')
                    bracket_count -= line.count(')')
                    if bracket_count == 0:
                        skip_mode = False
                    continue
            filtered_lines.append(line)
        else:
            bracket_count += line.count('(')
            bracket_count -= line.count(')')
            if bracket_count <= 0:
                skip_mode = False
    content = '\n'.join(filtered_lines)

    content = template + '\n\n' + content

    print(content[:1000])
    return content


def post_process(content):
    # 处理mark
    content = content.replace(MARK_BEGIN, "<mark>")
    content = content.replace(MARK_END, "</mark>")

    # 处理image
    content = content.replace(IMAGE_BEGIN, "<img ")
    content = content.replace(IMAGE_END, " />")

    # 处理quote（用正则表达式找出来并用lambda函数进行处理）
    quote_pattern = re.compile(f'{QUOTE_BEGIN}(.*?){QUOTE_END}', re.DOTALL)
    content = quote_pattern.sub(lambda x: '\n'.join(['> ' + l for l in x.group(1).split('\n')]), content)
    
    # 处理callout type
    content = content.replace(CALLOUT_TYPE_BEGIN, '[!')
    content = content.replace(CALLOUT_TYPE_END, ']')
    
    # 处理破折号
    content = content.replace('------', '——')

    return content


def pandoc_process(content, source_dir):
    '''
    使用pandoc将typst格式的内容（content）转化为markdown格式并作为字符串返回
    '''

    with tempfile.NamedTemporaryFile(suffix='.typ', mode='w', delete=False, encoding='utf8') as temp_file:
        temp_path = temp_file.name
        temp_file.write(content)

    output_path = None
    try:
        with tempfile.NamedTemporaryFile(suffix='.md', mode='w', delete=False, encoding='utf8') as output_file:
            output_path = output_file.name

        cmd = [
            'pandoc',
            '--from=typst',
            '--to=markdown',
            '--wrap=none',
            '--output=' + output_path,
            temp_path
        ]

        result = subprocess.run(cmd, check=False, cwd=source_dir,
                                stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                                text=True)

        if result.stderr:
            print(f"Pandoc错误: {result.stderr}")

        if result.returncode != 0:
            print(f"Pandoc转换失败，返回码: {result.returncode}")
            return ""

        with open(output_path, 'r', encoding='utf8') as f:
            md_content = f.read()

        if os.path.exists(temp_path):
            os.remove(temp_path)
        if output_path and os.path.exists(output_path):
            os.remove(output_path)

        return md_content

    except Exception as e:
        print(f"转换过程中发生错误: {str(e)}")
        return ""


def convert(source_file, target_file):
    source_file = os.path.abspath(source_file)
    source_dir = os.path.dirname(source_file)
    target_file = os.path.abspath(target_file)

    content = open(source_file, encoding='utf8').read()
    content = pre_process(content)
    content = pandoc_process(content, source_dir)
    content = post_process(content)

    if not content:
        print("转换失败，未生成有效内容")
        return

    with open(target_file, 'w', encoding='utf8') as f:
        f.write(content)
        f.close()

    print('转化完成！')


if __name__ == "__main__":
    os.chdir(os.path.join(os.path.dirname(__file__), '..'))
    convert('notes/chap2.typ', 'notes/chap2.md')
