#!/bin/bash

# 创建 public 目录用于发布静态资源
mkdir -p computer-architecture/public

cd computer-architecture/assets/original/
python merge_pdf.py # 合并 PDF 文件
python extract_images.py # 从 PDF 中提取课件截图
cd ../../../

# 将 typst 文件转换为 markdown 文件
cd computer-architecture/
python scripts/typ2md.py
cd ../

# 将 markdown 文件发布到 blog-posts 仓库
python .github/scripts/publish_to_blog.py posts/ computer-architecture/
