/*
title: "I. Introduction"
create-date: "2025-03-31"
update-date: "2025-04-01"
slug: /course/ca/note/1
*/

#import "../template-note.typ": *

#show: project.with(
  course: "Computer Architecture",
  course_fullname: "Computer Architecture",
  course_code: "CS2051M",
  title: link(
    "https://mem.ac",
    "Chapter 1",
  ),
  authors: (
    (
      name: "memset0",
      email: "memset0@outlook.com",
      link: "https://mem.ac/",
    ),
  ),
  semester: "Spring-Summer 2025",
  date: "March 31, 2025",
)


#slide-width.update(x => 1254)
#slide-height.update(x => 706)

#outline(title: [TOC], indent: 2em)

= Introduction to Computer Architecture

#align(center, image("images/2025-04-02-11-34-10.png", width: 75%))

#slide2x([2], image("../public/merged-1-1/0002.jpg"), image("../public/translated-1-1/0002.jpg"), cb: 0.01)

#slide2x([4], image("../public/merged-1-1/0004.jpg"), image("../public/translated-1-1/0004.jpg"), ct: 0.01, cb: 0.12)

#slide2x([5], image("../public/merged-1-1/0005.jpg"), image("../public/translated-1-1/0005.jpg"), ct: 0.01, cb: 0.30)

#slide2x([6], image("../public/merged-1-1/0006.jpg"), image("../public/translated-1-1/0006.jpg"), ct: 0.01, cb: 0.06)

#slide2x([7], image("../public/merged-1-1/0007.jpg"), image("../public/translated-1-1/0007.jpg"), ct: 0.02, cb: 0.02)

#slide2x([8], image("../public/merged-1-1/0008.jpg"), image("../public/translated-1-1/0008.jpg"), ct: 0.01, cb: 0.23)

#slide2x([9], image("../public/merged-1-1/0009.jpg"), image("../public/translated-1-1/0009.jpg"))

#slide2x([10], image("../public/merged-1-1/0010.jpg"), image("../public/translated-1-1/0010.jpg"), cb: 0.02)

#slide2x([11], image("../public/merged-1-1/0011.jpg"), image("../public/translated-1-1/0011.jpg"), cb: 0.02)

#slide2x([12], image("../public/merged-1-1/0012.jpg"), image("../public/translated-1-1/0012.jpg"), ct: 0.01, cb: 0.17)

#slide2x([13], image("../public/merged-1-1/0013.jpg"), image("../public/translated-1-1/0013.jpg"), ct: 0.01, cb: 0.05)

#slide2x([14], image("../public/merged-1-1/0014.jpg"), image("../public/translated-1-1/0014.jpg"), ct: 0.01, cb: 0.09)

#slide2x([15], image("../public/merged-1-1/0015.jpg"), image("../public/translated-1-1/0015.jpg"))

#slide2x([16], image("../public/merged-1-1/0016.jpg"), image("../public/translated-1-1/0016.jpg"), ct: 0.01, cb: 0.13)

#slide2x([17], image("../public/merged-1-1/0017.jpg"), image("../public/translated-1-1/0017.jpg"), cb: 0.02)

#slide2x([18], image("../public/merged-1-1/0018.jpg"), image("../public/translated-1-1/0018.jpg"), cb: 0.03)

#slide2x([19], image("../public/merged-1-1/0019.jpg"), image("../public/translated-1-1/0019.jpg"), cb: 0.02)

#slide2x([20], image("../public/merged-1-1/0020.jpg"), image("../public/translated-1-1/0020.jpg"), ct: 0.01, cb: 0.14)

#slide2x([21], image("../public/merged-1-1/0021.jpg"), image("../public/translated-1-1/0021.jpg"))

#slide2x([22], image("../public/merged-1-1/0022.jpg"), image("../public/translated-1-1/0022.jpg"), ct: 0.01)

#slide2x([23], image("../public/merged-1-1/0023.jpg"), image("../public/translated-1-1/0023.jpg"), ct: 0.02, cb: 0.03)

#slide2x([24], image("../public/merged-1-1/0024.jpg"), image("../public/translated-1-1/0024.jpg"), cb: 0.03)

#slide2x([25], image("../public/merged-1-1/0025.jpg"), image("../public/translated-1-1/0025.jpg"), cb: 0.05)

#slide2x([26], image("../public/merged-1-1/0026.jpg"), image("../public/translated-1-1/0026.jpg"), cb: 0.02)

#slide2x([27], image("../public/merged-1-1/0027.jpg"), image("../public/translated-1-1/0027.jpg"), ct: 0.01)

#slide2x([28], image("../public/merged-1-1/0028.jpg"), image("../public/translated-1-1/0028.jpg"), ct: 0.01)

#slide2x([29], image("../public/merged-1-1/0029.jpg"), image("../public/translated-1-1/0029.jpg"), ct: 0.01)

#slide2x([30], image("../public/merged-1-1/0030.jpg"), image("../public/translated-1-1/0030.jpg"), ct: 0.01)

#slide2x([31], image("../public/merged-1-1/0031.jpg"), image("../public/translated-1-1/0031.jpg"), cb: 0.04)

#slide2x([32], image("../public/merged-1-1/0032.jpg"), image("../public/translated-1-1/0032.jpg"))

#slide2x([33], image("../public/merged-1-1/0033.jpg"), image("../public/translated-1-1/0033.jpg"), ct: 0.22, cb: 0.40)

#slide2x([34], image("../public/merged-1-1/0034.jpg"), image("../public/translated-1-1/0034.jpg"), ct: 0.01, cb: 0.09)

#slide2x([35], image("../public/merged-1-1/0035.jpg"), image("../public/translated-1-1/0035.jpg"), cb: 0.04)


#slide2x([50], image("../public/merged-1-1/0050.jpg"), image("../public/translated-1-1/0050.jpg"))

#slide2x([51], image("../public/merged-1-1/0051.jpg"), image("../public/translated-1-1/0051.jpg"))

#slide2x([52], image("../public/merged-1-1/0052.jpg"), image("../public/translated-1-1/0052.jpg"), cb: 0.17)

#slide2x([53], image("../public/merged-1-1/0053.jpg"), image("../public/translated-1-1/0053.jpg"))

#slide2x([54], image("../public/merged-1-1/0054.jpg"), image("../public/translated-1-1/0054.jpg"), cb: 0.03)

#slide2x([55], image("../public/merged-1-1/0055.jpg"), image("../public/translated-1-1/0055.jpg"), ct: 0.01, cb: 0.12)

#slide2x([56], image("../public/merged-1-1/0056.jpg"), image("../public/translated-1-1/0056.jpg"), cb: 0.02)

#slide2x([57], image("../public/merged-1-1/0057.jpg"), image("../public/translated-1-1/0057.jpg"), ct: 0.01, cb: 0.03)

#slide2x([58], image("../public/merged-1-1/0058.jpg"), image("../public/translated-1-1/0058.jpg"), ct: 0.01, cb: 0.20)

#slide2x([59], image("../public/merged-1-1/0059.jpg"), image("../public/translated-1-1/0059.jpg"), ct: 0.01, cb: 0.09)

#slide2x([60], image("../public/merged-1-1/0060.jpg"), image("../public/translated-1-1/0060.jpg"))

#slide2x([61], image("../public/merged-1-1/0061.jpg"), image("../public/translated-1-1/0061.jpg"), ct: 0.01, cb: 0.01)

#slide2x([63], image("../public/merged-1-1/0063.jpg"), image("../public/translated-1-1/0063.jpg"))

#slide2x([64], image("../public/merged-1-1/0064.jpg"), image("../public/translated-1-1/0064.jpg"), cb: 0.01)

#slide2x([65], image("../public/merged-1-1/0065.jpg"), image("../public/translated-1-1/0065.jpg"), ct: 0.03, cb: 0.06)

#slide2x([2], image("../public/merged-1-2/0002.jpg"), image("../public/translated-1-2/0002.jpg"))

= Classes of Computers

#slide2x([4], image("../public/merged-1-2/0004.jpg"), image("../public/translated-1-2/0004.jpg"), cb: 0.04)

#slide2x([5], image("../public/merged-1-2/0005.jpg"), image("../public/translated-1-2/0005.jpg"), ct: 0.01, cb: 0.05)

#slide2x([6], image("../public/merged-1-2/0006.jpg"), image("../public/translated-1-2/0006.jpg"), ct: 0.01, cb: 0.05)

#slide2x([7], image("../public/merged-1-2/0007.jpg"), image("../public/translated-1-2/0007.jpg"), cb: 0.27)

#slide2x([8], image("../public/merged-1-2/0008.jpg"), image("../public/translated-1-2/0008.jpg"), ct: 0.01, cb: 0.02)

#slide2x([9], image("../public/merged-1-2/0009.jpg"), image("../public/translated-1-2/0009.jpg"), cb: 0.20)

#slide2x([10], image("../public/merged-1-2/0010.jpg"), image("../public/translated-1-2/0010.jpg"))

#slide2x([11], image("../public/merged-1-2/0011.jpg"), image("../public/translated-1-2/0011.jpg"), ct: 0.01, cb: 0.15)

#slide2x([12], image("../public/merged-1-2/0012.jpg"), image("../public/translated-1-2/0012.jpg"), ct: 0.01, cb: 0.11)

#slide2x([13], image("../public/merged-1-2/0013.jpg"), image("../public/translated-1-2/0013.jpg"))

#slide2x([14], image("../public/merged-1-2/0014.jpg"), image("../public/translated-1-2/0014.jpg"), ct: 0.01, cb: 0.15)

== Flynn's Taxonomy

#slide2x([15], image("../public/merged-1-2/0015.jpg"), image("../public/translated-1-2/0015.jpg"))

- *单指令流单数据流(Single Instruction Stream Single Data Stream, SISD)* ：早期的单核 PC 采用此架构。
- *单指令流多数据流(Single Instruction Stream Multiple Data Stream, SIMD)*：一条指令可以处理多条数据流（如向量数据），便于进行流水线操作。
- *多指令流单数据流(Multiple Instruction Stream Single Data Stream, MISD)* ：理论上的并行计算架构，并不实际存在。
- *多指令流多数据流(Multiple Instruction Stream Multiple Data Stream, MIMD)* ：每个处理器都可以执行不同的指令流，处理不同的数据流。如多核处理器和计算机集群，能够实现真正的并行计算。

#no-par-margin
#align(center, image("images/2025-04-01-08-39-27.png", width: 80%))

#slide2x([16], image("../public/merged-1-2/0016.jpg"), image("../public/translated-1-2/0016.jpg"))

#slide2x([17], image("../public/merged-1-2/0017.jpg"), image("../public/translated-1-2/0017.jpg"), ct: 0.01, cb: 0.01)

#slide2x([18], image("../public/merged-1-2/0018.jpg"), image("../public/translated-1-2/0018.jpg"), cb: 0.06)

#slide2x([19], image("../public/merged-1-2/0019.jpg"), image("../public/translated-1-2/0019.jpg"), ct: 0.01, cb: 0.12)

#slide2x([20], image("../public/merged-1-2/0020.jpg"), image("../public/translated-1-2/0020.jpg"), cb: 0.07)

#slide2x([21], image("../public/merged-1-2/0021.jpg"), image("../public/translated-1-2/0021.jpg"), cb: 0.02)

#slide2x([22], image("../public/merged-1-2/0022.jpg"), image("../public/translated-1-2/0022.jpg"), cb: 0.15)

= Trends | 趋势

#slide2x([23], image("../public/merged-1-2/0023.jpg"), image("../public/translated-1-2/0023.jpg"))

#slide2x([24], image("../public/merged-1-2/0024.jpg"), image("../public/translated-1-2/0024.jpg"), ct: 0.01, cb: 0.05)

#slide2x([25], image("../public/merged-1-2/0025.jpg"), image("../public/translated-1-2/0025.jpg"), ct: 0.01, cb: 0.31)

#slide2x([26], image("../public/merged-1-2/0026.jpg"), image("../public/translated-1-2/0026.jpg"))

#slide2x([27], image("../public/merged-1-2/0027.jpg"), image("../public/translated-1-2/0027.jpg"), ct: 0.01, cb: 0.03)

#slide2x([28], image("../public/merged-1-2/0028.jpg"), image("../public/translated-1-2/0028.jpg"), cb: 0.17)

#slide2x([29], image("../public/merged-1-2/0029.jpg"), image("../public/translated-1-2/0029.jpg"), ct: 0.01, cb: 0.43)

#slide2x([30], image("../public/merged-1-2/0030.jpg"), image("../public/translated-1-2/0030.jpg"), cb: 0.05)

#slide2x([31], image("../public/merged-1-2/0031.jpg"), image("../public/translated-1-2/0031.jpg"), ct: 0.01, cb: 0.23)

#slide2x([32], image("../public/merged-1-2/0032.jpg"), image("../public/translated-1-2/0032.jpg"), ct: 0.01, cb: 0.06)

#slide2x([33], image("../public/merged-1-2/0033.jpg"), image("../public/translated-1-2/0033.jpg"), ct: 0.01)

#slide2x([34], image("../public/merged-1-2/0034.jpg"), image("../public/translated-1-2/0034.jpg"), ct: 0.01, cb: 0.14)

#slide2x([35], image("../public/merged-1-2/0035.jpg"), image("../public/translated-1-2/0035.jpg"), ct: 0.01, cb: 0.14)

#slide2x([36], image("../public/merged-1-2/0036.jpg"), image("../public/translated-1-2/0036.jpg"), ct: 0.01, cb: 0.18)

#slide2x([37], image("../public/merged-1-2/0037.jpg"), image("../public/translated-1-2/0037.jpg"), ct: 0.01, cb: 0.01)

#slide2x([38], image("../public/merged-1-2/0038.jpg"), image("../public/translated-1-2/0038.jpg"), ct: 0.01)

#slide2x([39], image("../public/merged-1-2/0039.jpg"), image("../public/translated-1-2/0039.jpg"), ct: 0.01, cb: 0.03)

#slide2x([40], image("../public/merged-1-2/0040.jpg"), image("../public/translated-1-2/0040.jpg"), cb: 0.07)

#slide2x([41], image("../public/merged-1-2/0041.jpg"), image("../public/translated-1-2/0041.jpg"), cb: 0.18)

#slide2x([42], image("../public/merged-1-2/0042.jpg"), image("../public/translated-1-2/0042.jpg"), ct: 0.05, cb: 0.03)

#slide2x([43], image("../public/merged-1-2/0043.jpg"), image("../public/translated-1-2/0043.jpg"), ct: 0.01)

#slide2x([44], image("../public/merged-1-2/0044.jpg"), image("../public/translated-1-2/0044.jpg"), cb: 0.12)

#slide2x([45], image("../public/merged-1-2/0045.jpg"), image("../public/translated-1-2/0045.jpg"), ct: 0.01, cb: 0.07)

#slide2x([46], image("../public/merged-1-2/0046.jpg"), image("../public/translated-1-2/0046.jpg"), ct: 0.01, cb: 0.01)

#slide2x([47], image("../public/merged-1-2/0047.jpg"), image("../public/translated-1-2/0047.jpg"), ct: 0.01, cb: 0.06)

#slide2x([48], image("../public/merged-1-2/0048.jpg"), image("../public/translated-1-2/0048.jpg"), cb: 0.09)

#slide2x([49], image("../public/merged-1-2/0049.jpg"), image("../public/translated-1-2/0049.jpg"), cb: 0.06)

#slide2x([50], image("../public/merged-1-2/0050.jpg"), image("../public/translated-1-2/0050.jpg"), ct: 0.02)

#slide2x([51], image("../public/merged-1-2/0051.jpg"), image("../public/translated-1-2/0051.jpg"), cb: 0.05)

#slide2x([52], image("../public/merged-1-2/0052.jpg"), image("../public/translated-1-2/0052.jpg"), ct: 0.01)

#slide2x([53], image("../public/merged-1-2/0053.jpg"), image("../public/translated-1-2/0053.jpg"))

#slide2x([54], image("../public/merged-1-2/0054.jpg"), image("../public/translated-1-2/0054.jpg"), ct: 0.01, cb: 0.06)

#slide2x([55], image("../public/merged-1-2/0055.jpg"), image("../public/translated-1-2/0055.jpg"), ct: 0.01)

#slide2x([56], image("../public/merged-1-2/0056.jpg"), image("../public/translated-1-2/0056.jpg"), ct: 0.01, cb: 0.07)

#slide2x([57], image("../public/merged-1-2/0057.jpg"), image("../public/translated-1-2/0057.jpg"), ct: 0.01, cb: 0.04)

#slide2x([58], image("../public/merged-1-2/0058.jpg"), image("../public/translated-1-2/0058.jpg"), ct: 0.01)

#slide2x([59], image("../public/merged-1-2/0059.jpg"), image("../public/translated-1-2/0059.jpg"), ct: 0.01)

#slide2x([60], image("../public/merged-1-2/0060.jpg"), image("../public/translated-1-2/0060.jpg"), cb: 0.09)

#slide2x([61], image("../public/merged-1-2/0061.jpg"), image("../public/translated-1-2/0061.jpg"), ct: 0.02, cb: 0.06)

#slide2x([62], image("../public/merged-1-2/0062.jpg"), image("../public/translated-1-2/0062.jpg"), ct: 0.01)

#slide2x([63], image("../public/merged-1-2/0063.jpg"), image("../public/translated-1-2/0063.jpg"), cb: 0.30)

#slide2x([64], image("../public/merged-1-2/0064.jpg"), image("../public/translated-1-2/0064.jpg"), ct: 0.01, cb: 0.35)

= Quantitative Measurement of Performance

#slide2x([65], image("../public/merged-1-2/0065.jpg"), image("../public/translated-1-2/0065.jpg"), cb: 0.01)

#slide2x([66], image("../public/merged-1-2/0066.jpg"), image("../public/translated-1-2/0066.jpg"), ct: 0.02, cb: 0.10)

#slide2x([67], image("../public/merged-1-2/0067.jpg"), image("../public/translated-1-2/0067.jpg"), cb: 0.05)

#slide2x([68], image("../public/merged-1-2/0068.jpg"), image("../public/translated-1-2/0068.jpg"), ct: 0.01, cb: 0.01)

#slide2x([69], image("../public/merged-1-2/0069.jpg"), image("../public/translated-1-2/0069.jpg"), cb: 0.07)

#slide2x([70], image("../public/merged-1-2/0070.jpg"), image("../public/translated-1-2/0070.jpg"), ct: 0.02, cb: 0.06)

#slide2x([71], image("../public/merged-1-2/0071.jpg"), image("../public/translated-1-2/0071.jpg"), ct: 0.01, cb: 0.20)

#slide2x([72], image("../public/merged-1-2/0072.jpg"), image("../public/translated-1-2/0072.jpg"), cb: 0.09)

#slide2x([73], image("../public/merged-1-2/0073.jpg"), image("../public/translated-1-2/0073.jpg"), ct: 0.02, cb: 0.17)

#slide2x([74], image("../public/merged-1-2/0074.jpg"), image("../public/translated-1-2/0074.jpg"))

#slide2x([75], image("../public/merged-1-2/0075.jpg"), image("../public/translated-1-2/0075.jpg"), ct: 0.02, cb: 0.09)

#slide2x([76], image("../public/merged-1-2/0076.jpg"), image("../public/translated-1-2/0076.jpg"), cb: 0.05)

#slide2x([77], image("../public/merged-1-2/0077.jpg"), image("../public/translated-1-2/0077.jpg"))

#slide2x([78], image("../public/merged-1-2/0078.jpg"), image("../public/translated-1-2/0078.jpg"), ct: 0.01, cb: 0.02)

#slide2x([79], image("../public/merged-1-2/0079.jpg"), image("../public/translated-1-2/0079.jpg"), cb: 0.01)

#slide2x([80], image("../public/merged-1-2/0080.jpg"), image("../public/translated-1-2/0080.jpg"), ct: 0.01, cb: 0.02)

#slide2x([87], image("../public/merged-1-2/0087.jpg"), image("../public/translated-1-2/0087.jpg"), cb: 0.20)

#slide2x([88], image("../public/merged-1-2/0088.jpg"), image("../public/translated-1-2/0088.jpg"), cb: 0.05)

== Performance

#slide2x([89], image("../public/merged-1-2/0089.jpg"), image("../public/translated-1-2/0089.jpg"), cb: 0.10)

- *性能(performance)* 是 *执行时间(execution time)* 的倒数：

#no-par-margin
$
  "Performance" = 1 / "Execution Time"
$

#slide2x([90], image("../public/merged-1-2/0090.jpg"), image("../public/translated-1-2/0090.jpg"), cb: 0.11)

- “*$X$ 比 $Y$ 好 $n$ 倍*”：

#no-par-margin
$
  n = "Execution Time"_Y / "Execution Time"_X
$

#slide2x([91], image("../public/merged-1-2/0091.jpg"), image("../public/translated-1-2/0091.jpg"), ct: 0.01, cb: 0.04)

#slide2x([92], image("../public/merged-1-2/0092.jpg"), image("../public/translated-1-2/0092.jpg"), cb: 0.11)

#slide2x([93], image("../public/merged-1-2/0093.jpg"), image("../public/translated-1-2/0093.jpg"), cb: 0.14)

#slide2x([94], image("../public/merged-1-2/0094.jpg"), image("../public/translated-1-2/0094.jpg"), cb: 0.17)

#slide2x([95], image("../public/merged-1-2/0095.jpg"), image("../public/translated-1-2/0095.jpg"), cb: 0.18)

#slide2x([96], image("../public/merged-1-2/0096.jpg"), image("../public/translated-1-2/0096.jpg"), cb: 0.09)

#slide2x([97], image("../public/merged-1-2/0097.jpg"), image("../public/translated-1-2/0097.jpg"), cb: 0.04)

#slide2x([98], image("../public/merged-1-2/0098.jpg"), image("../public/translated-1-2/0098.jpg"), cb: 0.09)

#slide2x([99], image("../public/merged-1-2/0099.jpg"), image("../public/translated-1-2/0099.jpg"), ct: 0.01, cb: 0.23)

#slide2x([100], image("../public/merged-1-2/0100.jpg"), image("../public/translated-1-2/0100.jpg"), cb: 0.19)

#slide2x([101], image("../public/merged-1-2/0101.jpg"), image("../public/translated-1-2/0101.jpg"), ct: 0.01, cb: 0.10)

#slide2x([102], image("../public/merged-1-2/0102.jpg"), image("../public/translated-1-2/0102.jpg"), ct: 0.01, cb: 0.24)

#slide2x([103], image("../public/merged-1-2/0103.jpg"), image("../public/translated-1-2/0103.jpg"), cb: 0.03)

#slide2x([104], image("../public/merged-1-2/0104.jpg"), image("../public/translated-1-2/0104.jpg"), ct: 0.01, cb: 0.07)

#slide2x([108], image("../public/merged-1-2/0108.jpg"), image("../public/translated-1-2/0108.jpg"), ct: 0.01, cb: 0.32)

#slide2x([109], image("../public/merged-1-2/0109.jpg"), image("../public/translated-1-2/0109.jpg"), ct: 0.01, cb: 0.19)

#slide2x([110], image("../public/merged-1-2/0110.jpg"), image("../public/translated-1-2/0110.jpg"), cb: 0.09)

#slide2x([111], image("../public/merged-1-2/0111.jpg"), image("../public/translated-1-2/0111.jpg"), ct: 0.01, cb: 0.12)

== Amdahl's Law | 阿姆达尔定律

#slide2x([112], image("../public/merged-1-2/0112.jpg"), image("../public/translated-1-2/0112.jpg"), ct: 0.01, cb: 0.04)

#slide2x([113], image("../public/merged-1-2/0113.jpg"), image("../public/translated-1-2/0113.jpg"), cb: 0.15)

#slide2x([114], image("../public/merged-1-2/0114.jpg"), image("../public/translated-1-2/0114.jpg"), cb: 0.09)

#slide2x([115], image("../public/merged-1-2/0115.jpg"), image("../public/translated-1-2/0115.jpg"))

#slide2x([116], image("../public/merged-1-2/0116.jpg"), image("../public/translated-1-2/0116.jpg"), cb: 0.03)

#slide2x([117], image("../public/merged-1-2/0117.jpg"), image("../public/translated-1-2/0117.jpg"), ct: 0.01, cb: 0.40)

#slide2x([118], image("../public/merged-1-2/0118.jpg"), image("../public/translated-1-2/0118.jpg"), ct: 0.01, cb: 0.13)

#slide2x([119], image("../public/merged-1-2/0119.jpg"), image("../public/translated-1-2/0119.jpg"), ct: 0.01, cb: 0.06)

#slide2x([120], image("../public/merged-1-2/0120.jpg"), image("../public/translated-1-2/0120.jpg"), ct: 0.02, cb: 0.04)

#slide2x([121], image("../public/merged-1-2/0121.jpg"), image("../public/translated-1-2/0121.jpg"), cb: 0.14)

#slide2x([122], image("../public/merged-1-2/0122.jpg"), image("../public/translated-1-2/0122.jpg"), cb: 0.07)

#slide2x([123], image("../public/merged-1-2/0123.jpg"), image("../public/translated-1-2/0123.jpg"))

#slide2x([124], image("../public/merged-1-2/0124.jpg"), image("../public/translated-1-2/0124.jpg"), cb: 0.20)

#slide2x([125], image("../public/merged-1-2/0125.jpg"), image("../public/translated-1-2/0125.jpg"), ct: 0.02, cb: 0.12)

#slide2x([126], image("../public/merged-1-2/0126.jpg"), image("../public/translated-1-2/0126.jpg"), ct: 0.01, cb: 0.11)

#slide2x([127], image("../public/merged-1-2/0127.jpg"), image("../public/translated-1-2/0127.jpg"), cb: 0.28)

#slide2x([128], image("../public/merged-1-2/0128.jpg"), image("../public/translated-1-2/0128.jpg"))

#slide2x([129], image("../public/merged-1-2/0129.jpg"), image("../public/translated-1-2/0129.jpg"), ct: 0.01, cb: 0.24)

#slide2x([130], image("../public/merged-1-2/0130.jpg"), image("../public/translated-1-2/0130.jpg"), ct: 0.01, cb: 0.06)

#slide2x([131], image("../public/merged-1-2/0131.jpg"), image("../public/translated-1-2/0131.jpg"), ct: 0.01, cb: 0.02)

#slide2x([132], image("../public/merged-1-2/0132.jpg"), image("../public/translated-1-2/0132.jpg"), ct: 0.01, cb: 0.18)

#slide2x([133], image("../public/merged-1-2/0133.jpg"), image("../public/translated-1-2/0133.jpg"), ct: 0.01, cb: 0.01)

#slide2x([134], image("../public/merged-1-2/0134.jpg"), image("../public/translated-1-2/0134.jpg"), cb: 0.01)

#slide2x([135], image("../public/merged-1-2/0135.jpg"), image("../public/translated-1-2/0135.jpg"))

#slide2x([136], image("../public/merged-1-2/0136.jpg"), image("../public/translated-1-2/0136.jpg"), ct: 0.01)

#slide2x([137], image("../public/merged-1-2/0137.jpg"), image("../public/translated-1-2/0137.jpg"), ct: 0.01, cb: 0.30)

#slide2x([138], image("../public/merged-1-2/0138.jpg"), image("../public/translated-1-2/0138.jpg"), ct: 0.01, cb: 0.03)

#slide2x([139], image("../public/merged-1-2/0139.jpg"), image("../public/translated-1-2/0139.jpg"), cb: 0.03)

= Review: Pipeline

== Introduction to Pipeline

- *流水线(pipeline)* 的核心思想是 *重叠执行(overlap)*——从微观上看每个部件只有一个指令在执行，从宏观上看CPU能在同一时间会处理多条指令。

== Classes of Pipelines

TBD：只有cr老师讲了，到时候把相关课件搬过来。

== Performance Evaluation of Pipelining

TBD

#slide2x([2], image("../public/merged-1-3/0002.jpg"), image("../public/translated-1-3/0002.jpg"), ct: 0.03, cb: 0.01)

#slide2x([3], image("../public/merged-1-3/0003.jpg"), image("../public/translated-1-3/0003.jpg"), ct: 0.01)

#slide2x([4], image("../public/merged-1-3/0004.jpg"), image("../public/translated-1-3/0004.jpg"), ct: 0.01, cb: 0.03)

== Hazards of Pipelining

#slide2x([5], image("../public/merged-1-3/0005.jpg"), image("../public/translated-1-3/0005.jpg"), cb: 0.04)

- 冒险的分类：
  - *结构冒险(structural hazard)*：多条指令征用同一资源。
  - *数据冒险(data hazard)*：指令依赖于先前计算的结果，而这一结果尚未准备好（如尚未写回到寄存器组中）。
  - *控制冒险(control hazard)*：无法正确预测下一指令的 PC 值，因为可能发生跳转。

#slide2x([6], image("../public/merged-1-3/0006.jpg"), image("../public/translated-1-3/0006.jpg"), ct: 0.02, cb: 0.10)

=== Data Hazards | 数据冒险

#slide2x([7], image("../public/merged-1-3/0007.jpg"), image("../public/translated-1-3/0007.jpg"), ct: 0.01)

#slide2x([8], image("../public/merged-1-3/0008.jpg"), image("../public/translated-1-3/0008.jpg"), cb: 0.14)

#slide2x([9], image("../public/merged-1-3/0009.jpg"), image("../public/translated-1-3/0009.jpg"), ct: 0.01, cb: 0.03)

#slide2x([10], image("../public/merged-1-3/0010.jpg"), image("../public/translated-1-3/0010.jpg"), ct: 0.02, cb: 0.03)

#slide2x([11], image("../public/merged-1-3/0011.jpg"), image("../public/translated-1-3/0011.jpg"), ct: 0.01, cb: 0.03)

#slide2x([12], image("../public/merged-1-3/0012.jpg"), image("../public/translated-1-3/0012.jpg"), cb: 0.20)

#slide2x([13], image("../public/merged-1-3/0013.jpg"), image("../public/translated-1-3/0013.jpg"), ct: 0.02, cb: 0.02)

#slide2x([14], image("../public/merged-1-3/0014.jpg"), image("../public/translated-1-3/0014.jpg"), ct: 0.01, cb: 0.05)

#slide2x([15], image("../public/merged-1-3/0015.jpg"), image("../public/translated-1-3/0015.jpg"), cb: 0.02)

#slide2x([16], image("../public/merged-1-3/0016.jpg"), image("../public/translated-1-3/0016.jpg"), cb: 0.19)

#slide2x([17], image("../public/merged-1-3/0017.jpg"), image("../public/translated-1-3/0017.jpg"), ct: 0.01)

#slide2x([18], image("../public/merged-1-3/0018.jpg"), image("../public/translated-1-3/0018.jpg"), ct: 0.01, cb: 0.06)

#slide2x([19], image("../public/merged-1-3/0019.jpg"), image("../public/translated-1-3/0019.jpg"), ct: 0.01, cb: 0.03)

#slide2x([20], image("../public/merged-1-3/0020.jpg"), image("../public/translated-1-3/0020.jpg"), ct: 0.03)

#slide2x([21], image("../public/merged-1-3/0021.jpg"), image("../public/translated-1-3/0021.jpg"), ct: 0.01, cb: 0.11)

#slide2x([22], image("../public/merged-1-3/0022.jpg"), image("../public/translated-1-3/0022.jpg"), ct: 0.01)

#slide2x([23], image("../public/merged-1-3/0023.jpg"), image("../public/translated-1-3/0023.jpg"), ct: 0.01, cb: 0.6)

- 不是所有的 RAW 都可以通过 forwarding 解决，如 load-use hazard。这是需要配合插入 bubble 一起解决。

#slide2x([24], image("../public/merged-1-3/0024.jpg"), image("../public/translated-1-3/0024.jpg"), cb: 0.06)

#slide2x([25], image("../public/merged-1-3/0025.jpg"), image("../public/translated-1-3/0025.jpg"), ct: 0.02, cb: 0.05)

=== 控制冒险

#slide2x([26], image("../public/merged-1-3/0026.jpg"), image("../public/translated-1-3/0026.jpg"), ct: 0.01)

#slide2x([27], image("../public/merged-1-3/0027.jpg"), image("../public/translated-1-3/0027.jpg"), ct: 0.01, cb: 0.11)

#slide2x([28], image("../public/merged-1-3/0028.jpg"), image("../public/translated-1-3/0028.jpg"), ct: 0.02, cb: 0.08)

#slide2x([29], image("../public/merged-1-3/0029.jpg"), image("../public/translated-1-3/0029.jpg"), ct: 0.01, cb: 0.09)

#slide2x([30], image("../public/merged-1-3/0030.jpg"), image("../public/translated-1-3/0030.jpg"), ct: 0.02, cb: 0.17)

#slide2x([31], image("../public/merged-1-3/0031.jpg"), image("../public/translated-1-3/0031.jpg"), ct: 0.01, cb: 0.05)

#slide2x([32], image("../public/merged-1-3/0032.jpg"), image("../public/translated-1-3/0032.jpg"), ct: 0.01, cb: 0.03)

#slide2x([33], image("../public/merged-1-3/0033.jpg"), image("../public/translated-1-3/0033.jpg"), ct: 0.01, cb: 0.02)

#slide2x([34], image("../public/merged-1-3/0034.jpg"), image("../public/translated-1-3/0034.jpg"), ct: 0.01, cb: 0.17)

#slide2x([35], image("../public/merged-1-3/0035.jpg"), image("../public/translated-1-3/0035.jpg"), ct: 0.01, cb: 0.18)

#slide2x([36], image("../public/merged-1-3/0036.jpg"), image("../public/translated-1-3/0036.jpg"), ct: 0.01)

#slide2x([37], image("../public/merged-1-3/0037.jpg"), image("../public/translated-1-3/0037.jpg"))

#slide2x([38], image("../public/merged-1-3/0038.jpg"), image("../public/translated-1-3/0038.jpg"), ct: 0.01)

#slide2x([39], image("../public/merged-1-3/0039.jpg"), image("../public/translated-1-3/0039.jpg"), ct: 0.01)

#slide2x([40], image("../public/merged-1-3/0040.jpg"), image("../public/translated-1-3/0040.jpg"), ct: 0.01)

#slide2x([41], image("../public/merged-1-3/0041.jpg"), image("../public/translated-1-3/0041.jpg"), ct: 0.01)

#slide2x([42], image("../public/merged-1-3/0042.jpg"), image("../public/translated-1-3/0042.jpg"), ct: 0.01)

#slide2x([43], image("../public/merged-1-3/0043.jpg"), image("../public/translated-1-3/0043.jpg"), ct: 0.01)

