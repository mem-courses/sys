import os
import os.path
import win32com
import win32com.client


def ppt2pptx(source, dist):
    powerpoint = win32com.client.Dispatch('PowerPoint.Application')
    win32com.client.gencache.EnsureDispatch('PowerPoint.Application')
    powerpoint.Visible = 1
    ppt = powerpoint.Presentations.Open(source)
    ppt.SaveAs(dist)
    powerpoint.Quit()


path = os.path.dirname(os.path.abspath(__file__))
for subPath in os.listdir(path):
    source = os.path.join(path, subPath)
    dist = source + 'x' 
    if source.endswith('.ppt') and not os.path.exists(dist):
        print(source)
        ppt2pptx(source, dist)
