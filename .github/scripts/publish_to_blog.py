import os
import re
import sys
import yaml
import hashlib


chg_flag = False
dirname = os.path.dirname(__file__)
frontmatter_pattern = re.compile(r'^-{3,}\n\s*(.+?)\n-{3,}\n', re.DOTALL)


def read_file(file_path):
    with open(file_path, 'r+', encoding='utf8') as f:
        content = f.read()
    content = re.sub('<!-- begin-private-notes -->.*?<!-- end-private-notes -->', '', content, flags=re.DOTALL)
    content = re.sub('\%\%.+?\%\%', '', content)
    return content


def write_file(file_path, content):
    old_md5 = filemd5(file_path) if os.path.exists(file_path) else ''
    if not os.path.exists(os.path.dirname(file_path)):
        os.makedirs(os.path.dirname(file_path))
    with open(file_path, 'w+', encoding='utf8') as f:
        f.write(content)
    new_md5 = filemd5(file_path)
    if old_md5 != new_md5:
        global chg_flag
        chg_flag = True


def filemd5(file_path):
    hash_md5 = hashlib.md5()
    with open(file_path, "rb") as f:
        for chunk in iter(lambda: f.read(4096), b""):
            hash_md5.update(chunk)
    return hash_md5.hexdigest()


def read_frontmatter(content):
    try:
        match = frontmatter_pattern.search(content)
        if match:
            frontmatter = yaml.safe_load(match.group(1))
            return frontmatter
        else:
            return {}
    except Exception as e:
        print('error in read_frontmatter:', e)
        return {}


def get_uri(filename):
    if not filename.startswith('/'):
        filename = '/' + filename
    if filename.endswith('/index.md'):
        filename = filename[:-8]
    if filename.endswith('.md'):
        filename = filename[:-3]
    if not filename.endswith('/'):
        filename = filename + '/'
    return filename


def get_filename(slug):
    if slug.endswith('.md'):
        return slug
    if slug.endswith('/'):
        return slug + 'index.md'
    return slug + '.md'


if __name__ == '__main__':
    if len(sys.argv) > 2:
        root = os.path.abspath(sys.argv[2])
    else:
        root = os.path.abspath(os.path.join(dirname, '../../'))
    if not os.path.exists(root):
        print('error: root directory not found')
        sys.exit(1)

    if len(sys.argv) > 1:
        repo = os.path.abspath(sys.argv[1])
    else:
        repo = os.path.abspath(os.path.join(dirname, '../public/blog-posts'))
    if not os.path.exists(repo):
        os.makedirs(repo)

    posts = []

    for root, dirs, files in os.walk(root):
        # Skip the specified folder
        if '.git' in dirs:
            dirs.remove('.git')
        if '.github' in dirs:
            dirs.remove('.github')

        for file in files:
            if file.endswith('.md'):
                data = {}
                data['src'] = os.path.join(root, file)
                content = read_file(data['src'])
                matter = read_frontmatter(content)

                sync = None
                if 'sync' in matter:
                    sync = matter['sync']
                elif 'slug' in matter:
                    sync = matter['slug']
                if sync is None:
                    continue

                data['slug'] = get_uri(sync)
                data['filename'] = os.path.splitext(file)[0]
                if 'title' in matter:
                    data['title'] = matter['title']
                else:
                    data['title'] = data['filename']
                data['dst'] = os.path.abspath(os.path.join(repo, get_filename(sync).strip('/')))
                posts.append(data)

    for post in posts:
        content = read_file(post['src'])
        for other in posts:
            content = content.replace('[[' + other['filename'] + ']]', '[' + other['title'] + '](' + other['slug'] + ')')
        write_file(post['dst'], content)
        if len(sys.argv) == 1:
            print(post['src'], '->', post['dst'])
            print(post)

    # if chg_flag:
    #     # 文件有变化
    #     with open(os.path.abspath(os.path.join(repo, '../../../.git/refs/heads/master')), 'r', encoding='utf8') as f:
    #         githead = f.read().strip()
    #     with open(os.path.join(repo, 'OBSIDIAN_HEAD'), 'w', encoding='utf8') as f:
    #         f.write(githead)
