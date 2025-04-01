import os
import re
import json
import yaml
import base64
import tempfile
import subprocess
from abc import ABC

SETTINGS = {
    "CDN_ROOT": "https://course.cdn.memset0.cn/ca/",
}


TAG_BEGIN_BEGIN = '😡'
TAG_BEGIN_END = '🥶'
TAG_END = '🐯'

HEADING_BEGIN = TAG_BEGIN_BEGIN + "heading" + TAG_END
HEADING_END = TAG_BEGIN_END + "heading" + TAG_END

RESOURCE_BEGIN = TAG_BEGIN_BEGIN + "resource" + TAG_END
RESOURCE_END = TAG_BEGIN_END + "resource" + TAG_END

IMAGE_BEGIN = TAG_BEGIN_BEGIN + "image" + TAG_END
IMAGE_END = TAG_BEGIN_END + "image" + TAG_END

MARK_BEGIN = TAG_BEGIN_BEGIN + "mark" + TAG_END
MARK_END = TAG_BEGIN_END + "mark" + TAG_END

QUOTE_BEGIN = TAG_BEGIN_BEGIN + "quote" + TAG_END
QUOTE_END = TAG_BEGIN_END + "quote" + TAG_END

CALLOUT_BEGIN = TAG_BEGIN_BEGIN + "callout" + TAG_END
CALLOUT_END = TAG_BEGIN_END + "callout" + TAG_END

FRONTMATTER_BEGIN = TAG_BEGIN_BEGIN + "frontmatter" + TAG_END
FRONTMATTER_END = TAG_BEGIN_END + "frontmatter" + TAG_END


class Feature(ABC):
    def __init__(self):
        pass

    @staticmethod
    def pre_process(content):
        return content

    @staticmethod
    def post_process(content):
        return content


class TypstRefine(Feature):
    TEMPLATE = '''
    #let align(pos, body) = body
    #let no-par-margin = (..) => par[]
    #show "。": "．"
    '''

    @staticmethod
    def pre_process(content):
        content = TypstRefine.TEMPLATE + '\n\n' + content
        return content

    @staticmethod
    def post_process(content):
        # 处理破折号
        content = content.replace('------', '——')

        # 处理数学公式
        content = content.replace('$$', '\n$$\n')

        # 删除空白注释
        content = re.sub(r'\<\!\-\-\s+\-\-\>', '', content)

        return content


class FrontMatter(Feature):
    '''
    处理front matter
    '''

    @staticmethod
    def dump(content):
        data = yaml.safe_load(content)
        json_str = json.dumps(data, ensure_ascii=False)
        hash = base64.b64encode(json_str.encode()).decode()
        return f'{FRONTMATTER_BEGIN}{hash}{FRONTMATTER_END}'

    @staticmethod
    def load(hash):
        json_str = base64.b64decode(hash).decode()
        data = json.loads(json_str)
        return yaml.safe_dump(data, allow_unicode=True)

    @staticmethod
    def pre_process(content):
        frontmatter_pattern = re.compile(r'\/\*(.*?)\*\/', re.DOTALL)
        content = frontmatter_pattern.sub(lambda x: FrontMatter.dump(x.group(1)), content)
        return content

    @staticmethod
    def post_process(content):
        frontmatter_pattern = re.compile(f'{FRONTMATTER_BEGIN}(.*?){FRONTMATTER_END}', re.DOTALL)

        match = frontmatter_pattern.search(content)
        frontmatter = FrontMatter.load(match.group(1))
        content = frontmatter_pattern.sub('', content)

        return '---\n' + frontmatter.strip() + '\n---\n\n' + content


class Headings(Feature):
    '''
    处理标题
    '''

    @staticmethod
    def pre_process(content):
        return content, f'''
        #show heading: it => {{
            [{HEADING_BEGIN}];it.fields().level;[{HEADING_END}] it.fields().body
        }}
        '''

    @staticmethod
    def post_process(content):
        counter = [0] * 6
        min_level = 6

        def get_min_level(match):
            nonlocal min_level
            level = int(match.group(1).strip())
            if level < min_level:
                min_level = level
            return match.group(0)

        def get_numbering(match):
            level = int(match.group(1).strip())
            counter[level - 1] += 1
            for i in range(level, 6):
                counter[i] = 0
            prefix = '#' * (2 - min_level + level)
            numbering = '.'.join(map(str, counter[:level])) + '. '
            return '\n\n' + prefix + ' ' + numbering

        heading_pattern = re.compile(f'{HEADING_BEGIN}(.*?){HEADING_END}', re.DOTALL)
        content = heading_pattern.sub(get_min_level, content)
        content = heading_pattern.sub(get_numbering, content)

        return content


class Images(Feature):
    '''
    处理图片
    '''

    @staticmethod
    def pre_process(content):
        return content, f'''
        #let image(src, width: 100%) = {{
            [{IMAGE_BEGIN}]
            [src="{RESOURCE_BEGIN}#src;{RESOURCE_END}" ]
            [width="#width;" ]
            [{IMAGE_END}]
        }}
        '''

    @staticmethod
    def post_process(content):
        # 替换图片标签
        content = content.replace(IMAGE_BEGIN, "<img ")
        content = content.replace(IMAGE_END, "/>")

        return content


class MarkStyle(Feature):
    '''
    处理标记语法
    - Example: #mark[...]
    '''

    @staticmethod
    def pre_process(content):
        return content, f'''
        #let mark = (it) => {{
            text("{MARK_BEGIN}")
            it
            text("{MARK_END}")
        }}
        '''

    @staticmethod
    def post_process(content):
        return content.replace(MARK_BEGIN, "<mark>") \
                      .replace(MARK_END, "</mark>")


class QuoteAndCallout(Feature):
    '''
    处理引用和 callout 语法
    '''

    CALLOUT_TYPES = ['example', 'proof', 'abstract', 'summary', 'info', 'note', 'tip', 'hint', 'success', 'help', 'warning', 'attention', 'caution', 'failure', 'danger', 'error', 'bug', 'quote', 'cite']

    @staticmethod
    def pre_process(content):
        template = ''
        for callout_type in QuoteAndCallout.CALLOUT_TYPES:
            template += f'''
            #let {callout_type} = (body, title: "{callout_type.capitalize()}") => [
                {QUOTE_BEGIN} {CALLOUT_BEGIN}{callout_type}{CALLOUT_END} #title
                
                #body
                
                {QUOTE_END}
            ]
            '''
        return content, template

    @staticmethod
    def post_process(content):
        # 处理quote（用正则表达式找出来并用lambda函数进行处理）
        quote_pattern = re.compile(f'{QUOTE_BEGIN}(.*?){QUOTE_END}', re.DOTALL)
        content = quote_pattern.sub(lambda x: '\n'.join(['> ' + l for l in x.group(1).split('\n')]), content)

        # 处理callout type
        content = content.replace(CALLOUT_BEGIN, '[!')
        content = content.replace(CALLOUT_END, ']')

        return content


class SlidePreview(Feature):
    '''
    处理幻灯片预览
    '''

    TEMPLATE = f'''
    #let slide2x = (
        page,
        img1,
        img2,
        crop: none,
        header: true,
        h: none,
        ct: none,
        cb: none,
    ) => {{
        let crop-top = 0 // within [0, 1)
        let crop-bottom = 0 // within [0, 1)

        if h == false or header == false {{
            crop-top += slide-header-height.get()
        }}
        if crop != none {{
            crop-bottom += 1 - crop
        }}
        if ct != none {{
            crop-top += ct
        }}
        if cb != none {{
            crop-bottom += cb
        }}
        
        [{TAG_BEGIN_BEGIN}div class="slide2x" style="--crop-top: #crop-top;; --crop-bottom: #crop-bottom;"{TAG_END}]
        [{TAG_BEGIN_BEGIN}div class="slide1x"{TAG_END}#img1;{TAG_BEGIN_END}div{TAG_END}]
        [{TAG_BEGIN_BEGIN}div class="slide1x"{TAG_END}#img2;{TAG_BEGIN_END}div{TAG_END}]
        [{TAG_BEGIN_END}div{TAG_END}]
    }}
    '''

    STYLE = '''
    :root {
        --slide-width: 1254;
        --slide-height: 706;
    }
    .slide2x {
        width: 100%;
        display: flex;
        border: 1px solid black;
        margin-left: auto;
        margin-right: auto;
        overflow: hidden;
        border-radius: 6px;
    }
    .slide2x .slide1x {
        width: 50%;
        height: auto;
        aspect-ratio: calc(var(--slide-width)) / calc(var(--slide-height) * (1 - var(--crop-top) - var(--crop-bottom)));
        overflow: hidden;
        position: relative;
    }
    .slide2x .slide1x img {
        position: absolute;
        top: calc(100% * var(--crop-top));
        left: 0;
        width: 100%;
        height: auto;
    }
    '''

    @staticmethod
    def pre_process(content):
        return content, SlidePreview.TEMPLATE

    @staticmethod
    def post_process(content):
        return '<style>' + SlidePreview.STYLE + '</style>\n\n' + content


class NoSlidePreview(Feature):
    '''
    不处理幻灯片预览
    '''

    @staticmethod
    def pre_process(content):
        return content, '#let slide2x = (..) => par[]'


FEATURE_LIST = [
    TypstRefine,
    FrontMatter,
    Headings,
    Images,
    MarkStyle,
    QuoteAndCallout,
    SlidePreview,
    NoSlidePreview,
]


def pre_process(content, features=FEATURE_LIST):
    # 处理对slide-width和slide-height的修改
    content = '\n'.join([line for line in content.split('\n') if not line.startswith('#slide-')])
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

    template = ''
    for feature in features:
        result = feature.pre_process(content)
        if isinstance(result, tuple):
            content, new_template = result
            template += new_template + '\n\n'
        else:
            content = result
    content = template + '\n\n' + content

    return content


def post_process(content, source_dir, features=FEATURE_LIST):
    for feature in reversed(features):
        content = feature.post_process(content)

    # 处理CDN资源
    def get_cdn_url(match):
        path = match.group(1)
        file_path = os.path.abspath(os.path.join(source_dir, path))
        rel_path = os.path.relpath(file_path, '.')
        return SETTINGS["CDN_ROOT"] + rel_path.replace('\\', '/')

    resource_pattern = re.compile(f'{RESOURCE_BEGIN}(.*?){RESOURCE_END}', re.DOTALL)
    content = resource_pattern.sub(get_cdn_url, content)

    # 处理剩余的特殊token
    content = content.replace(TAG_BEGIN_BEGIN, '<')
    content = content.replace(TAG_BEGIN_END, '</')
    content = content.replace(TAG_END, '>')

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
    content = post_process(content, source_dir)

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
