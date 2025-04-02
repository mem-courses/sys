/*
title: "II. Memory Hierarchy"
create-date: "2025-03-31"
update-date: "2025-04-01"
slug: /course/ca/note/2
*/

#import "../template-note.typ": *

#show: project.with(
  course: "Computer Architecture",
  course_fullname: "Computer Architecture",
  course_code: "CS2051M",
  title: link(
    "https://mem.ac",
    "Chapter 2. Memory Hierarchy",
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
// #let slide2x = (..) => par[]

= Introduction to Memory Hierarchy | 导论

#slide2x([3], image("../public/merged-2-1/0003.jpg"), image("../public/translated-2-1/0003.jpg"), ct: 0.01, cb: 0.06)

#slide2x([4], image("../public/merged-2-1/0004.jpg"), image("../public/translated-2-1/0004.jpg"), ct: 0.01, cb: 0.07)

- *随机存取存储器(random access memory, RAM)*
  - *静态随机存取存储器(static RAM, SRAM)*：快、贵、数据“永久”保留直到断电。
  - *动态随机存取存储器(dynamic RAM, DRAM)*：慢、便宜、需要定期“刷新”。

#slide2x([5], image("../public/merged-2-1/0005.jpg"), image("../public/translated-2-1/0005.jpg"), ct: 0.02, cb: 0.04)

#slide2x([6], image("../public/merged-2-1/0006.jpg"), image("../public/translated-2-1/0006.jpg"), ct: 0.01, cb: 0.34)

- *局部性原则(principle of locality)*
  - *时间局部性(temporal locality)*：最近被访问过的数据可能在不久之后会被再次访问。
  - *空间局部性(spatial locality)*：被访问过的数据的邻近数据在不久之后很可能被访问。

#slide2x([7], image("../public/merged-2-1/0007.jpg"), image("../public/translated-2-1/0007.jpg"))

#quote(title: [内存层次结构])[
  #align(center, image("images/2025-03-31-20-35-33.png", width: 56%))
]

#slide2x([8], image("../public/merged-2-1/0008.jpg"), image("../public/translated-2-1/0008.jpg"), cb: 0.13)

#slide2x([9], image("../public/merged-2-1/0009.jpg"), image("../public/translated-2-1/0009.jpg"))

#slide2x([10], image("../public/merged-2-1/0010.jpg"), image("../public/translated-2-1/0010.jpg"))

#slide2x([11], image("../public/merged-2-1/0011.jpg"), image("../public/translated-2-1/0011.jpg"), cb: 0.08)

#slide2x([12], image("../public/merged-2-1/0012.jpg"), image("../public/translated-2-1/0012.jpg"), ct: 0.01, cb: 0.69)

#example(title: [回顾：和 cache 相关的概念与名词])[
  #align(center, image("../public/merged-2-1/0013.jpg", width: 60%))
]

#slide2x([14], image("../public/merged-2-1/0014.jpg"), image("../public/translated-2-1/0014.jpg"))

= Four Questions for Memory Hierarchy Designers | 四个关键问题

#slide2x([15], image("../public/merged-2-1/0015.jpg"), image("../public/translated-2-1/0015.jpg"), cb: 0.03)

- *内存设计者需要回答的四个问题*：
  - Q1: Where can a block be placed in the upper level/main memory? (Block placement)
  - Q2: How is a block found if it is in the upper level/main memory? (Block identification)
  - Q3: Which block should be replaced on a Cache/main memory miss? (Block replacement)
  - Q4: What happens on a write? (Write strategy)

== Block Placement | 块的放置

#slide2x([16], image("../public/merged-2-1/0016.jpg"), image("../public/translated-2-1/0016.jpg"), cb: 0.05)

- *直接映射(direct mapped)*：块只能放在缓存中的一个位置。
- *全相联(fully associative)*：块可以放在缓存中的任意位置。
- *组相联(set associative)*：块可以在一个组里的任意位置，组里可以有若干块。
  - 如果组中有 $n$ 个块，则称为 $n$-路组相联。一般来说，$n<=4$。

#slide2x([17], image("../public/merged-2-1/0017.jpg"), image("../public/translated-2-1/0017.jpg"), cb: 0.05)

== Block Identification | 块的标识

#slide2x([18], image("../public/merged-2-1/0018.jpg"), image("../public/translated-2-1/0018.jpg"), cb: 0.29)

#slide2x([19], image("../public/merged-2-1/0019.jpg"), image("../public/translated-2-1/0019.jpg"), cb: 0.06)

- *块的组成部分*：
  - *标签(tag)*：可用于辨别某个块是否是所需要的，这个搜索过程一般是并行执行的。
    - 需要的 tag 位数 = 地址位数 - index 位数 - block offset 位数
  - *索引(index)*：在直接映射/组相联中用于选择具体的块/组（在全相联中就不需要）。
  - *块偏移(block offset)*：用于在一个块中选择具体数据（定位到具体字节），不包含在块地址中。

#no-par-margin
#align(center, image("images/2025-03-31-20-41-39.png", width: 40%))


#slide2x([20], image("../public/merged-2-1/0020.jpg"), image("../public/translated-2-1/0020.jpg"), cb: 0.06)

#slide2x([21], image("../public/merged-2-1/0021.jpg"), image("../public/translated-2-1/0021.jpg"), cb: 0.03)

#slide2x([22], image("../public/merged-2-1/0022.jpg"), image("../public/translated-2-1/0022.jpg"), cb: 0.02)

#slide2x([23], image("../public/merged-2-1/0023.jpg"), image("../public/translated-2-1/0023.jpg"), ct: 0.02, cb: 0.01)

== Block Replacement | 块的替换

#slide2x([24], image("../public/merged-2-1/0024.jpg"), image("../public/translated-2-1/0024.jpg"), cb: 0.03)

#slide2x([25], image("../public/merged-2-1/0025.jpg"), image("../public/translated-2-1/0025.jpg"), cb: 0.05)

- *随机替换(random replacement)*：随机选择一个cache中的块并进行替换。
  - 实现简单。也可以用一些伪随机数算法实现。
- *最近最少使用(Least-Recently Used, LRU)*：替换最近没有使用过的块——#mark[需要额外的位数来记录访问时间]。
  - 存在近似策略——使用 ref bit。
- *先进先出(First-In-First-Out, FIFO)*：选择最早进入cache的块进行替换。
  - 算是一种 LRU 的近似策略。

#slide2x([26], image("../public/merged-2-1/0026.jpg"), image("../public/translated-2-1/0026.jpg"), cb: 0.41)

#slide2x([27], image("../public/merged-2-1/0027.jpg"), image("../public/translated-2-1/0027.jpg"), cb: 0.47)

== Write Strategy | 写入策略

#slide2x([28], image("../public/merged-2-1/0028.jpg"), image("../public/translated-2-1/0028.jpg"), cb: 0.12)

#slide2x([29], image("../public/merged-2-1/0029.jpg"), image("../public/translated-2-1/0029.jpg"), cb: 0.32)

- write through V.S. write back
  - *写穿(write through)*：同时写入 cache 和下一级内存中。
    - 优点：实现简单，*数据一致性(data coherency)* 好。
    - 缺点：CPU 必须等待下一级内存写入完成才能执行下一步，称为 *写停顿(write stall)*。
      - 可以引入 *写缓冲(write buffer)* 来缓解这个问题。
      - 可以引入二级缓存（L2）来进一步缓解写缓冲区也容易饱和的问题。
  - *写回(write back)*：只写入到 cache 的块中，但是如果这个块要被移除 cache 则将数据写入到下一级内存中。
    - 优点：速度快、使用#mark[更少的内存带宽]。
    - 需要引入一个 *脏位(dirty bit)* 来标记块是否有被修改过。

#slide2x([30], image("../public/merged-2-1/0030.jpg"), image("../public/translated-2-1/0030.jpg"), cb: 0.27)

#slide2x([31], image("../public/merged-2-1/0031.jpg"), image("../public/translated-2-1/0031.jpg"))

#slide2x([32], image("../public/merged-2-1/0032.jpg"), image("../public/translated-2-1/0032.jpg"))

#slide2x([33], image("../public/merged-2-1/0033.jpg"), image("../public/translated-2-1/0033.jpg"), cb: 0.2)

- 块未命中时（write miss）的写入策略
  - *写分配(write allocate)*（对应 write back 策略）：当cache未命中时，先从下一级内存把块加载到 cache中。
  - *非写分配(no-write allocate, write around)*（对应 write through 策略）：不让 write miss 影响到 cache，而是直接写入到下一级内存中。

#slide2x([34], image("../public/merged-2-1/0034.jpg"), image("../public/translated-2-1/0034.jpg"))

#slide2x([35], image("../public/merged-2-1/0035.jpg"), image("../public/translated-2-1/0035.jpg"))

#slide2x([36], image("../public/merged-2-1/0036.jpg"), image("../public/translated-2-1/0036.jpg"), cb: 0.06)

#slide2x([37], image("../public/merged-2-1/0037.jpg"), image("../public/translated-2-1/0037.jpg"))

#slide2x([38], image("../public/merged-2-1/0038.jpg"), image("../public/translated-2-1/0038.jpg"), cb: 0.59)

?

= Cache Performance Measures | 缓存性能指标

#slide2x([41], image("../public/merged-2-1/0041.jpg"), image("../public/translated-2-1/0041.jpg"), cb: 0.45)

== CPU Execution Time | CPU 执行时间

#slide2x([39], image("../public/merged-2-1/0039.jpg"), image("../public/translated-2-1/0039.jpg"), cb: 0.06)

- *CPU 执行时间*（考虑 cache miss 导致的 memory stall）：

#no-par-margin
$
  "CPU Time" &= ("CPU Clock Cycles" + "Memory Stall Cycles") times "Clock Cycle Time" \
  &= "IC" times ("CPI" + "Mem Accesses" / "Inst" times "Miss Rate" times "Miss Penalty") times "Clock Cycle Time" \
  &= "IC" times ("CPI" + "Mem Misses" / "Inst" times "Miss Penalty") times "Clock Cycle Time"
$


== Average Memory Access Time | 平均内存访问时间

- *平均内存访问时间(average memory access time, AMAT)*：

#no-par-margin
$
  "AMAT" = "HitTime" + ("Miss Rate" times "Miss Penalty")
$
#no-par-margin

- 分开考虑 Inst. & Data 内存的情况：

#no-par-margin
$
  "AMAT" = ("HitTime"_"inst" + "MissRate"_"inst" times "MissPenalty"_"inst") + ("HitTime"_"data" + "MissRate"_"data" times "MissPenalty"_"data")
$
#no-par-margin

- 将AMAT应用到CPU Time的计算中（将指令分成 ALU 指令和内存访问相关指令两个部分）：

#no-par-margin
$
  "CPU Time" = "IC" times ("ALUOps" / "Inst" times "CPU"_"ALUOps" + "MemAccess" / "Inst" times "AMAT") times "Clock Cycle Time"
$

#slide2x([40], image("../public/merged-2-1/0040.jpg"), image("../public/translated-2-1/0040.jpg"), ct: 0.01, cb: 0.14)

#slide2x([41], image("../public/merged-2-1/0041.jpg"), image("../public/translated-2-1/0041.jpg"), ct: 0.01, cb: 0.43)

#slide2x([42], image("../public/merged-2-1/0042.jpg"), image("../public/translated-2-1/0042.jpg"), ct: 0.01)

#slide2x([43], image("../public/merged-2-1/0043.jpg"), image("../public/translated-2-1/0043.jpg"), ct: 0.01, cb: 0.18)

#slide2x([44], image("../public/merged-2-1/0044.jpg"), image("../public/translated-2-1/0044.jpg"), ct: 0.01, cb: 0.03)

#slide2x([45], image("../public/merged-2-1/0045.jpg"), image("../public/translated-2-1/0045.jpg"), cb: 0.19)

#slide2x([46], image("../public/merged-2-1/0046.jpg"), image("../public/translated-2-1/0046.jpg"), ct: 0.02, cb: 0.22)

#slide2x([47], image("../public/merged-2-1/0047.jpg"), image("../public/translated-2-1/0047.jpg"), ct: 0.01)

#slide2x([48], image("../public/merged-2-1/0048.jpg"), image("../public/translated-2-1/0048.jpg"), ct: 0.01, cb: 0.07)

#slide2x([49], image("../public/merged-2-1/0049.jpg"), image("../public/translated-2-1/0049.jpg"), ct: 0.02)

#slide2x([50], image("../public/merged-2-1/0050.jpg"), image("../public/translated-2-1/0050.jpg"), ct: 0.01, cb: 0.2)

#slide2x([51], image("../public/merged-2-1/0051.jpg"), image("../public/translated-2-1/0051.jpg"), ct: 0.01, cb: 0.03)

#slide2x([52], image("../public/merged-2-1/0052.jpg"), image("../public/translated-2-1/0052.jpg"), ct: 0.01, cb: 0.26)

#slide2x([53], image("../public/merged-2-1/0053.jpg"), image("../public/translated-2-1/0053.jpg"), cb: 0.14)

#slide2x([54], image("../public/merged-2-1/0054.jpg"), image("../public/translated-2-1/0054.jpg"), ct: 0.01, cb: 0.13)

#slide2x([55], image("../public/merged-2-1/0055.jpg"), image("../public/translated-2-1/0055.jpg"), ct: 0.01, cb: 0.14)

#slide2x([56], image("../public/merged-2-1/0056.jpg"), image("../public/translated-2-1/0056.jpg"), ct: 0.01, cb: 0.09)

#slide2x([57], image("../public/merged-2-1/0057.jpg"), image("../public/translated-2-1/0057.jpg"), ct: 0.01, cb: 0.27)

#slide2x([58], image("../public/merged-2-1/0058.jpg"), image("../public/translated-2-1/0058.jpg"), cb: 0.06)

#slide2x([59], image("../public/merged-2-1/0059.jpg"), image("../public/translated-2-1/0059.jpg"), ct: 0.01, cb: 0.48)

#slide2x([60], image("../public/merged-2-1/0060.jpg"), image("../public/translated-2-1/0060.jpg"))

#slide2x([61], image("../public/merged-2-1/0061.jpg"), image("../public/translated-2-1/0061.jpg"), ct: 0.01, cb: 0.10)

#slide-width.update(x => 940)
#slide-height.update(x => 706)

= Improve DRAM Performance | 提升DRAM性能

#slide2x([2], image("../public/merged-2-2/0002.jpg"), image("../public/translated-2-2/0002.jpg"), ct: 0.02, cb: 0.12)

#slide2x([3], image("../public/merged-2-2/0003.jpg"), image("../public/translated-2-2/0003.jpg"), ct: 0.01, cb: 0.03)

#slide2x([4], image("../public/merged-2-2/0004.jpg"), image("../public/translated-2-2/0004.jpg"), cb: 0.02)

#slide2x([5], image("../public/merged-2-2/0005.jpg"), image("../public/translated-2-2/0005.jpg"), cb: 0.02)

#slide2x([6], image("../public/merged-2-2/0006.jpg"), image("../public/translated-2-2/0006.jpg"), ct: 0.01, cb: 0.20)

#slide2x([7], image("../public/merged-2-2/0007.jpg"), image("../public/translated-2-2/0007.jpg"), ct: 0.04, cb: 0.01)

#slide2x([8], image("../public/merged-2-2/0008.jpg"), image("../public/translated-2-2/0008.jpg"), ct: 0.01, cb: 0.27)

#slide2x([9], image("../public/merged-2-2/0009.jpg"), image("../public/translated-2-2/0009.jpg"), ct: 0.01, cb: 0.13)

#slide2x([10], image("../public/merged-2-2/0010.jpg"), image("../public/translated-2-2/0010.jpg"), cb: 0.04)

#slide2x([11], image("../public/merged-2-2/0011.jpg"), image("../public/translated-2-2/0011.jpg"))

#slide2x([12], image("../public/merged-2-2/0012.jpg"), image("../public/translated-2-2/0012.jpg"))

#slide2x([13], image("../public/merged-2-2/0013.jpg"), image("../public/translated-2-2/0013.jpg"), ct: 0.01, cb: 0.11)

#slide2x([14], image("../public/merged-2-2/0014.jpg"), image("../public/translated-2-2/0014.jpg"), ct: 0.01, cb: 0.06)

#slide2x([15], image("../public/merged-2-2/0015.jpg"), image("../public/translated-2-2/0015.jpg"), ct: 0.01, cb: 0.10)

#slide2x([16], image("../public/merged-2-2/0016.jpg"), image("../public/translated-2-2/0016.jpg"), ct: 0.01, cb: 0.01)

#slide2x([17], image("../public/merged-2-2/0017.jpg"), image("../public/translated-2-2/0017.jpg"), ct: 0.02, cb: 0.14)

#slide2x([18], image("../public/merged-2-2/0018.jpg"), image("../public/translated-2-2/0018.jpg"), ct: 0.01, cb: 0.18)

#slide2x([19], image("../public/merged-2-2/0019.jpg"), image("../public/translated-2-2/0019.jpg"), ct: 0.01, cb: 0.18)

#slide2x([20], image("../public/merged-2-2/0020.jpg"), image("../public/translated-2-2/0020.jpg"), ct: 0.01, cb: 0.14)

#slide2x([21], image("../public/merged-2-2/0021.jpg"), image("../public/translated-2-2/0021.jpg"), ct: 0.01, cb: 0.10)

#slide2x([22], image("../public/merged-2-2/0022.jpg"), image("../public/translated-2-2/0022.jpg"), ct: 0.01, cb: 0.18)

#slide2x([23], image("../public/merged-2-2/0023.jpg"), image("../public/translated-2-2/0023.jpg"), ct: 0.01, cb: 0.14)

#slide2x([24], image("../public/merged-2-2/0024.jpg"), image("../public/translated-2-2/0024.jpg"), ct: 0.01, cb: 0.32)

= Improve Cache Performance | 提升缓存性能

#slide2x([25], image("../public/merged-2-2/0025.jpg"), image("../public/translated-2-2/0025.jpg"))

- 如何提升 cache 的性能？就是降低 AMAT。可以从 AMAT 的计算公式入手考虑。

#tip[
  #no-par-margin
  #align(center, image("images/2025-03-31-22-21-32.png", width: 80%))
]

== Reduce Hit Time | 减少命中时间

=== Small and Simple Caches | 使用小且简单的缓存

#slide2x([26], image("../public/merged-2-2/0026.jpg"), image("../public/translated-2-2/0026.jpg"), cb: 0.38)

- *方法*：使用小型、直接映射的cache；因为结构越简单就意味着hit时速度越快，直接映射不需要组内查找。
- *优点*：简化结构 $=>$ 减少 hit time；减少功耗。
- *缺点*：增加 miss rate。
- *结论*：广泛使用，一般用在 L1 cache。

#slide2x([27], image("../public/merged-2-2/0027.jpg"), image("../public/translated-2-2/0027.jpg"), cb: 0.08)

#slide2x([28], image("../public/merged-2-2/0028.jpg"), image("../public/translated-2-2/0028.jpg"), cb: 0.08)

=== Way Prediction | 路预测

#slide2x([29], image("../public/merged-2-2/0029.jpg"), image("../public/translated-2-2/0029.jpg"), cb: 0.15)

#slide2x([30], image("../public/merged-2-2/0030.jpg"), image("../public/translated-2-2/0030.jpg"), ct: 0.16, cb: 0.2)

- *方法*：*路预测(way-prediction)* 通过在cache中保留额外的位（称为 predictor bit）来“预测”#mark[每个组中访问的路]。实际上 predictor bit 存储的就是该组上一次访问的路。
  - 如果hit，只需要一个时钟周期，因为不需要进行查找。
  - 如果miss，更新predictor bit并继续判断，这会带来一个额外的时钟周期，直到最终hit。
- *优点*：减少 hit time；减少功耗。
- *缺点*：加大了实现流水线化 cache 的难度。

=== Avoiding Address Translation during Indexing | 减少地址转换

#slide2x([31], image("../public/merged-2-2/0031.jpg"), image("../public/translated-2-2/0031.jpg"), cb: 0.1)

- *问题*：在计算机中尝尝需要使用虚拟地址来访问内存，然而 #mark[cache 是基于物理地址的]，需要page table进行转换——相当于每次访问都需要进行两次内存操作。

#slide2x([35], image("../public/merged-2-2/0035.jpg"), image("../public/translated-2-2/0035.jpg"), cb: 0.3)

#slide2x([36], image("../public/merged-2-2/0036.jpg"), image("../public/translated-2-2/0036.jpg"), cb: 0.13)

#slide2x([37], image("../public/merged-2-2/0037.jpg"), image("../public/translated-2-2/0037.jpg"), cb: 0.26)

#slide2x([38], image("../public/merged-2-2/0038.jpg"), image("../public/translated-2-2/0038.jpg"), cb: 0.07)

#slide2x([39], image("../public/merged-2-2/0039.jpg"), image("../public/translated-2-2/0039.jpg"), cb: 0.06)

#slide2x([40], image("../public/merged-2-2/0040.jpg"), image("../public/translated-2-2/0040.jpg"), cb: 0.08)

#slide2x([41], image("../public/merged-2-2/0041.jpg"), image("../public/translated-2-2/0041.jpg"))

- 方法一：使用虚拟地址来索引 cache（virtuall addressed cache）？
  - 会导致 *同义词问题(synonym problem)*：两个虚拟地址可能映射到同一物理地址，从而导致同一个物理块在 cache 中有多个副本。进而导致数据不一致问题。

#slide2x([32], image("../public/merged-2-2/0032.jpg"), image("../public/translated-2-2/0032.jpg"), cb: 0.07)

#slide2x([33], image("../public/merged-2-2/0033.jpg"), image("../public/translated-2-2/0033.jpg"), cb: 0.02)

#slide2x([34], image("../public/merged-2-2/0034.jpg"), image("../public/translated-2-2/0034.jpg"))

- 方法二：使用计组中讲到过的 TLB。

=== Trace Caches

#slide2x([42], image("../public/merged-2-2/0042.jpg"), image("../public/translated-2-2/0042.jpg"))

#slide2x([43], image("../public/merged-2-2/0043.jpg"), image("../public/translated-2-2/0043.jpg"))

#slide2x([44], image("../public/merged-2-2/0044.jpg"), image("../public/translated-2-2/0044.jpg"))

#slide2x([45], image("../public/merged-2-2/0045.jpg"), image("../public/translated-2-2/0045.jpg"))

#slide2x([46], image("../public/merged-2-2/0046.jpg"), image("../public/translated-2-2/0046.jpg"))

#slide2x([47], image("../public/merged-2-2/0047.jpg"), image("../public/translated-2-2/0047.jpg"))

#slide2x([48], image("../public/merged-2-2/0048.jpg"), image("../public/translated-2-2/0048.jpg"))

== Increase Bandwidth

#slide2x([49], image("../public/merged-2-2/0049.jpg"), image("../public/translated-2-2/0049.jpg"))

=== Pipelined Caches

#slide2x([50], image("../public/merged-2-2/0050.jpg"), image("../public/translated-2-2/0050.jpg"), ct: 0.16, cb: 0.4)

#slide2x([51], image("../public/merged-2-2/0051.jpg"), image("../public/translated-2-2/0051.jpg"))

=== Multibanked Caches

#slide2x([52], image("../public/merged-2-2/0052.jpg"), image("../public/translated-2-2/0052.jpg"))

#slide2x([53], image("../public/merged-2-2/0053.jpg"), image("../public/translated-2-2/0053.jpg"))

=== Nonblocking Caches

#slide2x([54], image("../public/merged-2-2/0054.jpg"), image("../public/translated-2-2/0054.jpg"))

#slide2x([55], image("../public/merged-2-2/0055.jpg"), image("../public/translated-2-2/0055.jpg"))

== Reduce Miss Penalty

=== Multi-level Caches

#slide2x([57], image("../public/merged-2-2/0057.jpg"), image("../public/translated-2-2/0057.jpg"))

#slide2x([58], image("../public/merged-2-2/0058.jpg"), image("../public/translated-2-2/0058.jpg"))

#slide2x([59], image("../public/merged-2-2/0059.jpg"), image("../public/translated-2-2/0059.jpg"))

=== Giving Priority to Read Misses over Writes

#slide2x([60], image("../public/merged-2-2/0060.jpg"), image("../public/translated-2-2/0060.jpg"))

#slide2x([61], image("../public/merged-2-2/0061.jpg"), image("../public/translated-2-2/0061.jpg"))

=== Critical Word First & Early Restart

#slide2x([62], image("../public/merged-2-2/0062.jpg"), image("../public/translated-2-2/0062.jpg"))

#slide2x([63], image("../public/merged-2-2/0063.jpg"), image("../public/translated-2-2/0063.jpg"))

=== Merging Write Buffer

#slide2x([64], image("../public/merged-2-2/0064.jpg"), image("../public/translated-2-2/0064.jpg"))

#slide2x([65], image("../public/merged-2-2/0065.jpg"), image("../public/translated-2-2/0065.jpg"))

=== Victim Caches | 受害者缓存

#slide2x([66], image("../public/merged-2-2/0066.jpg"), image("../public/translated-2-2/0066.jpg"))

#slide2x([67], image("../public/merged-2-2/0067.jpg"), image("../public/translated-2-2/0067.jpg"))

#slide2x([68], image("../public/merged-2-2/0068.jpg"), image("../public/translated-2-2/0068.jpg"))

== Reduce Miss Rate

#slide2x([70], image("../public/merged-2-2/0070.jpg"), image("../public/translated-2-2/0070.jpg"))

- cache miss 的来源：
  - *强制(compulsory)*（也称为 *冷启动失效 (cold-start misses)*）：在一开始访问cache必定出现miss，因为块必须先被加载到cache中。
  - *容量(capacity)*：在程序执行的过程中，cache无法包含所有需要的块，于是不得不抛弃一些块，但之后可能又需要这些块，从而发生miss。
    - 除非增大cache容量，否则这一问题无法解决（不在本小节的讨论范围内）。
  - *冲突(conflict)*：对于组相联 / 直接映射而言，由于多个数据块映射到相同的组上，导致较早存入的数据被替换，导致后续又需要时发生miss。
  - *一致性(coherency)*：针对多核处理器导致的cache一致性缺失，不在目前的讨论范围内。

#slide2x([71], image("../public/merged-2-2/0071.jpg"), image("../public/translated-2-2/0071.jpg"))

#slide2x([72], image("../public/merged-2-2/0072.jpg"), image("../public/translated-2-2/0072.jpg"))

#slide2x([73], image("../public/merged-2-2/0073.jpg"), image("../public/translated-2-2/0073.jpg"))

=== Larger Block Size | 增加块大小

#slide2x([75], image("../public/merged-2-2/0075.jpg"), image("../public/translated-2-2/0075.jpg"), cb: 0.16)

- *优点*：减少 compulsory miss。
- *缺点*：
  - 增加 miss penalty。
  - 增加 conflict miss。
  - 增加 capacity miss，特别是对于小 cache。
- *结论*：优化曲线呈 U 形，存在 trade-off。

#no-par-margin
#align(center, image("images/2025-03-31-21-54-21.png", width: 48%))

#slide2x([76], image("../public/merged-2-2/0076.jpg"), image("../public/translated-2-2/0076.jpg"), ct: 0.22, cb: 0.22)

#slide2x([78], image("../public/merged-2-2/0078.jpg"), image("../public/translated-2-2/0078.jpg"), cb: 0.35)

#slide2x([79], image("../public/merged-2-2/0079.jpg"), image("../public/translated-2-2/0079.jpg"))

=== Larger Caches | 增加缓存大小

- *优点*：减少 capacity miss。
- *缺点*:
  - 增加 hit time。
  - 增加成本和功率。
- 在芯片高速缓存的优化中一般不考虑这种方法。

#slide2x([80], image("../public/merged-2-2/0080.jpg"), image("../public/translated-2-2/0080.jpg"))

=== Higher Associativity | 增加相联度

#slide2x([81], image("../public/merged-2-2/0081.jpg"), image("../public/translated-2-2/0081.jpg"), cb: 0.13)

- *方法*：就是增加“$n$ 路组相联”里的 $n$。
- *优点*：减少 miss rate，#mark[但也取决于具体的访问序列]。
- *缺点*：增加 hit time。
- *经验*：8路组相联降低miss rate的效果近乎等价于全相联——再提高相联度的效果不明显。
- *结论*：对于clock rate较高的情况下，不建议提升相联度；但在miss penalty较大的情况下，可以考虑提升相联度。

#slide2x([82], image("../public/merged-2-2/0082.jpg"), image("../public/translated-2-2/0082.jpg"), cb: 0.12)

#slide2x([83], image("../public/merged-2-2/0083.jpg"), image("../public/translated-2-2/0083.jpg"), cb: 0.38)

#slide2x([84], image("../public/merged-2-2/0084.jpg"), image("../public/translated-2-2/0084.jpg"), cb: 0.07)

=== Compiler Optimizations

#slide2x([85], image("../public/merged-2-2/0085.jpg"), image("../public/translated-2-2/0085.jpg"), cb: 0.07)

#slide2x([86], image("../public/merged-2-2/0086.jpg"), image("../public/translated-2-2/0086.jpg"), cb: 0.1)

#slide2x([87], image("../public/merged-2-2/0087.jpg"), image("../public/translated-2-2/0087.jpg"))

#slide2x([88], image("../public/merged-2-2/0088.jpg"), image("../public/translated-2-2/0088.jpg"))

#slide2x([89], image("../public/merged-2-2/0089.jpg"), image("../public/translated-2-2/0089.jpg"))

#slide2x([90], image("../public/merged-2-2/0090.jpg"), image("../public/translated-2-2/0090.jpg"))

#slide2x([91], image("../public/merged-2-2/0091.jpg"), image("../public/translated-2-2/0091.jpg"))

#slide2x([92], image("../public/merged-2-2/0092.jpg"), image("../public/translated-2-2/0092.jpg"))

=== Way Prediction and Pseudo-Associative Cache

#slide2x([93], image("../public/merged-2-2/0093.jpg"), image("../public/translated-2-2/0093.jpg"), cb: 0.06)

#slide2x([94], image("../public/merged-2-2/0094.jpg"), image("../public/translated-2-2/0094.jpg"), cb: 0.01)

#slide2x([95], image("../public/merged-2-2/0095.jpg"), image("../public/translated-2-2/0095.jpg"), ct: 0.01, cb: 0.02)

== Reduce Miss Penalty/Rate via Parallelization

=== Hardware Prefetching of Inst. and Data | 硬件预取

#slide2x([97], image("../public/merged-2-2/0097.jpg"), image("../public/translated-2-2/0097.jpg"))

#slide2x([98], image("../public/merged-2-2/0098.jpg"), image("../public/translated-2-2/0098.jpg"))

=== Compiler-controlled Prefetch | 编译器控制的预取

#slide2x([99], image("../public/merged-2-2/0099.jpg"), image("../public/translated-2-2/0099.jpg"))

#slide2x([100], image("../public/merged-2-2/0100.jpg"), image("../public/translated-2-2/0100.jpg"))

#slide2x([101], image("../public/merged-2-2/0101.jpg"), image("../public/translated-2-2/0101.jpg"))

== Using HBM to extend the memory hierarchy

#slide2x([102], image("../public/merged-2-2/0102.jpg"), image("../public/translated-2-2/0102.jpg"))

#slide2x([103], image("../public/merged-2-2/0103.jpg"), image("../public/translated-2-2/0103.jpg"), ct: 0.18, cb: 0.25)

#slide2x([104], image("../public/merged-2-2/0104.jpg"), image("../public/translated-2-2/0104.jpg"), ct: 0.15, cb: 0.05)

#slide2x([105], image("../public/merged-2-2/0105.jpg"), image("../public/translated-2-2/0105.jpg"))

#slide2x([106], image("../public/merged-2-2/0106.jpg"), image("../public/translated-2-2/0106.jpg"))

#slide2x([107], image("../public/merged-2-2/0107.jpg"), image("../public/translated-2-2/0107.jpg"))

#note(title: [cache 流程总结])[
  #no-par-margin
  #align(center, image("images/2025-03-31-22-19-56.png", width: 50%))
]

= Virtual Memory

#slide2x([109], image("../public/merged-2-2/0109.jpg"), image("../public/translated-2-2/0109.jpg"), cb: 0.2)

#slide2x([110], image("../public/merged-2-2/0110.jpg"), image("../public/translated-2-2/0110.jpg"))

#slide2x([111], image("../public/merged-2-2/0111.jpg"), image("../public/translated-2-2/0111.jpg"))

#slide2x([112], image("../public/merged-2-2/0112.jpg"), image("../public/translated-2-2/0112.jpg"))

#slide2x([113], image("../public/merged-2-2/0113.jpg"), image("../public/translated-2-2/0113.jpg"))

#slide2x([114], image("../public/merged-2-2/0114.jpg"), image("../public/translated-2-2/0114.jpg"))

#slide2x([115], image("../public/merged-2-2/0115.jpg"), image("../public/translated-2-2/0115.jpg"), cb: 0.5)
