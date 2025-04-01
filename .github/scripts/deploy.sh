#!/bin/bash

mkdir -p computer-architecture/upload
cd computer-architecture/

# 复制public目录到upload
cp -r public upload/

# 函数：复制指定目录中的图片到upload目录，保持完整目录结构
copy_images_to_upload() {
    local source_dir="$1"
    
    # 检查源目录是否存在
    if [ ! -d "$source_dir" ]; then
        echo "错误：源目录 '$source_dir' 不存在"
        return 1
    fi
    
    # 查找所有.jpg和.png文件并复制到upload目录，保持完整目录结构
    find "$source_dir" -type f \( -name "*.jpg" -o -name "*.png" \) | while read -r img_file; do
        # 创建目标目录，保留源目录名称
        target_dir="upload/$(dirname "$img_file")"
        mkdir -p "$target_dir"
        # 复制文件
        cp "$img_file" "$target_dir/"
        echo "已复制: $img_file -> $target_dir/"
    done
    
    echo "图片复制完成：从 $source_dir 到 upload/$source_dir 目录"
}

copy_images_to_upload "notes"

