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

