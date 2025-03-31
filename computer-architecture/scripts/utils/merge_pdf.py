import os
import fitz  # PyMuPDF


def merge_pdf(input_file, output_file, columns=2, rows=4):
    os.makedirs(os.path.dirname(output_file), exist_ok=True)
    
    doc_in = fitz.open(input_file)
    doc_out = fitz.open()
    page_count = doc_in.page_count

    # 假设所有页面尺寸相同，这里以第 1 页为参考
    ref_page = doc_in.load_page(0)
    rect = ref_page.rect
    # 新页面的尺寸：宽度 = 2 × 单页宽度，高度 = 4 × 单页高度
    new_width = rect.width * columns
    new_height = rect.height * rows

    # 按照每 8 页为一组进行处理
    for i in range(0, page_count, columns * rows):
        # 创建新页面
        new_page = doc_out.new_page(width=new_width, height=new_height)

        # 取最多 8 页（不足 8 页时只取剩余的）
        pages_subset = range(i, min(i + columns * rows, page_count))

        for idx, pagenum in enumerate(pages_subset):
            # 行列计算：2 列 4 行
            row = idx // columns  # 取值 0 ~ 3
            col = idx % columns   # 取值 0 ~ 1
            # 计算在新页面上的放置区域 sub_rect
            sub_rect = fitz.Rect(
                col * rect.width,      # left
                row * rect.height,     # top
                (col + 1) * rect.width,  # right
                (row + 1) * rect.height  # bottom
            )
            # 将第 pagenum 页内容贴到新页面的 sub_rect 区域
            new_page.show_pdf_page(sub_rect, doc_in, pagenum, keep_proportion=False)

    doc_out.save(output_file)
    doc_out.close()
    doc_in.close()


if __name__ == "__main__":
    import sys

    if len(sys.argv) < 3:
        print("用法: python merge_pdf_8up.py <输入PDF> <输出PDF>")
        sys.exit(1)

    input_pdf = sys.argv[1]
    output_pdf = sys.argv[2]

    merge_pdf(input_pdf, output_pdf)
    print(f"合并完成，输出文件: {output_pdf}")
