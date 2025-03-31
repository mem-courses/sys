import os
import sys
import fitz  # PyMuPDF


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


if __name__ == "__main__":
    input_pdf_path = "demo.pdf"
    output_images_folder = "output_images"

    clip_region = {
        'up': 0.2,
        'down': 0.2,
        'left': 0.1,
        'right': 0.1
    }

    extract_images(input_pdf_path, output_images_folder, clip_region)
    print("提取完成！")
