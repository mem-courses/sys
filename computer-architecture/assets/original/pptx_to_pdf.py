import os
import os.path
import win32com.client
from win32com.client import constants

def pptx_to_pdf(source, output_pdf):
    """将PPTX文件转换为PDF
    
    Args:
        source: PPTX文件的完整路径
        output_pdf: 输出PDF文件的完整路径
    """
    powerpoint = win32com.client.Dispatch('PowerPoint.Application')
    powerpoint.Visible = 1
    
    try:
        deck = powerpoint.Presentations.Open(source)
        # 将PPTX保存为PDF格式
        deck.SaveAs(output_pdf, 32)  # 32 代表 PDF 格式
        deck.Close()
    finally:
        powerpoint.Quit()

def main():
    # 获取当前脚本所在目录
    path = os.path.dirname(os.path.abspath(__file__))
    
    # 遍历目录中的所有文件
    for filename in os.listdir(path):
        if filename.endswith(('.pptx', '.ppt')):
            source = os.path.join(path, filename)
            # 生成PDF文件名（将扩展名改为.pdf）
            pdf_name = os.path.splitext(filename)[0] + '.pdf'
            output_pdf = os.path.join(path, pdf_name)
            
            # 如果PDF文件不存在，则进行转换
            if not os.path.exists(output_pdf):
                print(f"正在转换: {filename} -> {pdf_name}")
                try:
                    pptx_to_pdf(source, output_pdf)
                    print(f"转换成功: {pdf_name}")
                except Exception as e:
                    print(f"转换失败: {filename}")
                    print(f"错误信息: {str(e)}")

if __name__ == '__main__':
    main()
