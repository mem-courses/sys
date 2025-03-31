# extract_images.py
# description: 通过约定的方式提取课件中的图片
# author: memset0 (with help from LLM)
# version: 3.0.0 (2025-04-01)

import os
import sys
import fitz  # PyMuPDF
from PIL import Image


def get_page_filename(page_num):
    return "%04d.jpg" % (page_num + 1)


def extract_images(input_file, output_folder, clip, dpi=300, columns=2, rows=4, page_limit=None):
    """
    从 PDF 的每一页提取一张 JPG 图片，应用裁剪并设置 DPI。

    Args:
        input_file (str): 输入 PDF 文件的路径。
        output_folder (str): 保存输出 JPG 图片的文件夹路径。
        clip (dict): 包含 'up', 'down', 'left', 'right' 比例的字典，
                     指定从各边缘裁剪掉的页面比例 (0.0 到 1.0)。
                     例如 {'up': 0.1, 'down': 0.1, 'left': 0.05, 'right': 0.05}
    """
    # 检查输入文件是否存在
    if not os.path.exists(input_file):
        print(f"错误: 输入文件 '{input_file}' 不存在。", file=sys.stderr)
        return

    # 如果输出文件夹不存在，则创建它
    if not os.path.exists(output_folder):
        try:
            os.makedirs(output_folder)
            print(f"创建输出文件夹: '{output_folder}'")
        except OSError as e:
            print(f"错误: 无法创建文件夹 '{output_folder}'. {e}", file=sys.stderr)
            return

    # --- 验证 clip 字典 (可选但推荐) ---
    required_keys = {'up', 'down', 'left', 'right'}
    if not isinstance(clip, dict) or not required_keys.issubset(clip.keys()):
        print(f"错误: 'clip' 参数必须是包含 'up', 'down', 'left', 'right'键的字典。", file=sys.stderr)
        return
    for key in required_keys:
        if not (isinstance(clip[key], (int, float)) and 0 <= clip[key] <= 1):
            print(f"错误: 'clip' 中的 '{key}' 值 ({clip[key]}) 必须是 0 到 1 之间的数字。", file=sys.stderr)
            return
    if clip['up'] + clip['down'] >= 1 or clip['left'] + clip['right'] >= 1:
        print(f"警告: 'clip' 比例设置可能导致裁剪掉整个页面。", file=sys.stderr)
    # --- 验证结束 ---

    # PyMuPDF 使用缩放因子 matrix 来控制 DPI。默认 PDF DPI 为 72。
    zoom = dpi / 72.0
    matrix = fitz.Matrix(zoom, zoom)

    try:
        # 打开 PDF 文件
        doc = fitz.open(input_file)
        print(f"正在处理 PDF: '{input_file}', 共 {doc.page_count} 页...")

        # 遍历每一页
        for page_num in range(doc.page_count):
            if page_limit is not None and page_num >= page_limit:
                break
            for row in range(rows):
                for col in range(columns):
                    page_id = page_num * columns * rows + row * columns + col

                    page = doc.load_page(page_num)
                    page_rect = page.rect  # 获取页面原始尺寸 (单位: points)

                    page_width = (page_rect.x1 - page_rect.x0) / columns
                    page_height = (page_rect.y1 - page_rect.y0) / rows

                    # --- 计算裁剪区域 (clip rectangle) ---
                    # PyMuPDF 的 clip 参数需要一个 fitz.Rect 对象，坐标单位是 points
                    clip_x0 = page_rect.x0 + page_width * clip.get('left', 0) + page_width * col
                    clip_y0 = page_rect.y0 + page_height * clip.get('up', 0) + page_height * row
                    clip_x1 = page_rect.x0 - page_width * clip.get('right', 0) + page_width * (col + 1)
                    clip_y1 = page_rect.y0 - page_height * clip.get('down', 0) + page_height * (row + 1)

                    # 创建裁剪矩形，确保坐标有效 (x0 < x1 and y0 < y1)
                    if clip_x0 < clip_x1 and clip_y0 < clip_y1:
                        clip_rect = fitz.Rect(clip_x0, clip_y0, clip_x1, clip_y1)
                    else:
                        # 如果裁剪比例无效（例如左右裁剪超过100%），则不进行裁剪
                        print(f"警告: 第 {page_num + 1} 页的裁剪比例设置无效，将不进行裁剪。")
                        clip_rect = page_rect  # 使用整个页面的矩形

                    try:
                        # 使用 matrix 设置 DPI，使用 clip 进行裁剪
                        # 注意：clip 是在渲染时应用的，直接得到裁剪后的图像
                        pix = page.get_pixmap(matrix=matrix, clip=clip_rect, alpha=False)  # alpha=False 用于JPG输出

                        # 构建输出文件名 (例如: page_1.jpg, page_2.jpg, ...)
                        output_filename = get_page_filename(page_id)
                        output_path = os.path.join(output_folder, output_filename)

                        # 保存为 JPG 图片
                        pix.save(output_path)
                        print(f"已保存: '{output_path}' (尺寸: {pix.width}x{pix.height} px, DPI: {dpi})")

                    except Exception as e:
                        print(f"错误: 处理第 {page_num + 1} 页时出错: {e}", file=sys.stderr)
                        # 可以选择是继续处理下一页还是停止脚本
                        # continue

        print("所有页面处理完成。")

    except fitz.fitz.FileNotFoundError:
        print(f"错误: 无法打开文件 '{input_file}'. 文件是否损坏或不存在？", file=sys.stderr)
    except Exception as e:
        print(f"处理 PDF 时发生意外错误: {e}", file=sys.stderr)
    finally:
        # 确保在任何情况下都关闭文档
        if 'doc' in locals() and doc:
            doc.close()


def flatten(x): return [y for l in x for y in flatten(l)] if type(x) is list else [x]


def analyze_image_whitespace(image_path):
    """
    分析图片，获取宽度、高度以及顶部和底部的纯白色区域高度。

    Args:
        image_path (str): 图片文件的完整路径。

    Returns:
        dict: 包含图片信息的字典 {'width': W, 'height': H, 'top_white_height': TWH, 'bottom_white_height': BWH}
              如果图片无法打开或不是有效图片，则返回 None。
    """
    try:
        with Image.open(image_path) as img:
            # 尝试转换为RGB模式以便统一处理像素值
            # 如果图片本身不是RGB兼容模式（如索引调色板），转换可能改变原始像素
            # 但对于检查纯白 (255, 255, 255) 来说，转换为RGB是常用做法
            # 如果需要严格保持原始模式检查，逻辑会更复杂
            try:
                img_rgb = img.convert('RGB')
            except OSError:
                # 有些特殊格式可能无法直接转换，例如某些灰度图，尝试直接获取像素
                if img.mode == 'L':  # 灰度图
                    img_rgb = img  # 直接使用，白色是 255
                elif img.mode == 'RGBA':  # 带 Alpha 通道的图
                    img_rgb = img.convert('RGB')  # 丢弃 Alpha，检查 RGB 是否为白
                else:
                    print(f"警告: 无法将图片 '{os.path.basename(image_path)}' (模式: {img.mode}) 转换为 RGB，可能跳过或结果不准确。")
                    # 尝试直接获取像素，但这可能不适用于所有模式
                    img_rgb = img

            width, height = img_rgb.size
            top_white_height = 0
            bottom_white_height = 0

            # --- 分析顶部白色区域 ---
            for y in range(height):
                is_row_white = True
                for x in range(width):
                    pixel = img_rgb.getpixel((x, y))
                    # 检查是否为白色 (RGB 或 灰度)
                    # 注意：对于非 RGB/L 模式，getpixel 返回值可能不同
                    is_white = False
                    if isinstance(pixel, int):  # 灰度图 (L mode)
                        is_white = (pixel == 255)
                    elif isinstance(pixel, tuple) and len(pixel) >= 3:  # RGB 或 RGBA 等
                        is_white = (pixel[0] == 255 and pixel[1] == 255 and pixel[2] == 255)

                    if not is_white:
                        is_row_white = False
                        break  # 这一行不是纯白，停止检查这一行

                if is_row_white:
                    top_white_height += 1
                else:
                    break  # 遇到第一个非纯白行，停止向上检查

            # --- 分析底部白色区域 ---
            for y in range(height - 1, -1, -1):  # 从倒数第一行开始向上检查
                is_row_white = True
                for x in range(width):
                    pixel = img_rgb.getpixel((x, y))
                    # 检查是否为白色 (RGB 或 灰度)
                    is_white = False
                    if isinstance(pixel, int):  # 灰度图 (L mode)
                        is_white = (pixel == 255)
                    elif isinstance(pixel, tuple) and len(pixel) >= 3:  # RGB 或 RGBA 等
                        is_white = (pixel[0] == 255 and pixel[1] == 255 and pixel[2] == 255)

                    if not is_white:
                        is_row_white = False
                        break  # 这一行不是纯白，停止检查这一行

                if is_row_white:
                    bottom_white_height += 1
                else:
                    break  # 遇到第一个非纯白行，停止向下检查

            return {
                'width': width,
                'height': height,
                'top_white_height': top_white_height,
                'bottom_white_height': bottom_white_height
            }

    except FileNotFoundError:
        print(f"错误: 文件未找到 '{image_path}'")
        return None
    except Image.UnidentifiedImageError:
        print(f"错误: 无法识别或打开图片文件 '{image_path}'，可能文件已损坏或不是有效的图片格式。")
        return None
    except Exception as e:
        print(f"处理图片 '{image_path}' 时发生意外错误: {e}")
        return None


if __name__ == '__main__':
    os.chdir(os.path.dirname(os.path.abspath(__file__)))

    source = os.path.abspath(os.path.join('../../assets'))
    target = os.path.abspath(os.path.join('../../public'))

    slides = list(map(lambda x: x[:-4], filter(lambda x: x.endswith('.pdf'), os.listdir(os.path.join(source, 'translated')))))
    print('slides:', slides)

    clip = {'up': 0.01, 'down': 0.05, 'left': 0.03, 'right': 0.03}
    blank_space = 0.03

    pdf_files = flatten([
        ['merged/%s.pdf' % slide, 'translated/%s.pdf' % slide]
        for slide in slides
    ])
    print(pdf_files)

    for slide in pdf_files:
        input_file = os.path.join(source, slide)

        folder_name = slide.replace('/', '-').replace('.pdf', '')
        output_dir = os.path.join(target, folder_name)

        extract_images(input_file, output_dir, clip=clip, dpi=100)

    SLIDE2X = '#slide2x([{page}], image("../public/merged-{slide}/{page0}.jpg"), image("../public/translated-{slide}/{page0}.jpg"){params})'

    for slide_id in slides:
        dir1 = 'merged-%s' % slide_id
        dir2 = 'translated-%s' % slide_id
        dir1_imgs = os.path.join(target, dir1.replace('.pdf', ''))
        dir2_imgs = os.path.join(target, dir2.replace('.pdf', ''))
        num = max(
            len(os.listdir(dir1_imgs)),
            len(os.listdir(dir2_imgs)),
        )
        print(slide_id, 'num:', num)

        analysis_results = {}
        for filename in os.listdir(dir1_imgs):
            if filename.lower().endswith(".jpg"):
                file_path = os.path.join(dir1_imgs, filename)

                print(f"\n--- 正在分析图片: {filename} ---")
                analysis_results[filename] = analyze_image_whitespace(file_path)

                if analysis_results[filename]:
                    print(f"  宽度 (Width): {analysis_results[filename]['width']} px")
                    print(f"  高度 (Height): {analysis_results[filename]['height']} px")
                    print(f"  顶部纯白高度 (Top White Height): {analysis_results[filename]['top_white_height']} px")
                    print(f"  底部纯白高度 (Bottom White Height): {analysis_results[filename]['bottom_white_height']} px")
                else:
                    print(f"  无法分析图片 {filename}。")

        output = ''
        for i in range(1, num + 1):
            filename = '%04d.jpg' % i
            ct = analysis_results[filename]['top_white_height'] / float(analysis_results[filename]['height'])
            cb = analysis_results[filename]['bottom_white_height'] / float(analysis_results[filename]['height'])

            params = ''
            if ct > blank_space:
                params += ', ct: %.2f' % max(min(ct - blank_space, 0.5), 0.01)
            if cb > blank_space:
                params += ', cb: %.2f' % max(min(cb - blank_space, 0.5), 0.01)

            output += SLIDE2X.format(
                page=i,
                slide=slide_id,
                page0='%04d' % i,
                params=params,
            )
            output += '\n\n'

        output_file = os.path.join(target, '%s.txt' % slide_id)
        with open(output_file, 'w+') as f:
            f.write(output)
            f.close()
