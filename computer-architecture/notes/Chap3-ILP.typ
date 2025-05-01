/*
title: "III. Instruction-Level Parallelism"
create-date: "2025-04-29"
slug: /course/ca/note/3
blog-cssclasses:
  - m-mubu
*/

#import "../template-note.typ": *

#show: project.with(
  course: "Computer Architecture",
  course_fullname: "Computer Architecture",
  course_code: "CS2051M",
  title: link(
    "https://mem.ac",
    "Chapter 3. Instruction-Level Parallelism",
  ),
  authors: (
    (
      name: "memset0",
      email: "memset0@outlook.com",
      link: "https://mem.ac/",
    ),
  ),
  semester: "Spring-Summer 2025",
  date: "April 29, 2025",
)

#slide-width.update(x => 940)
#slide-height.update(x => 706)
#outline(title: [TOC], indent: 2em)

= Introduction to Instruction-Level Parallelism

#slide2x([2], image("../public/merged-3-0/0002.jpg"), image("../public/translated-3-0/0002.jpg"), ct: 0.01, cb: 0.02)

#slide2x([3], image("../public/merged-3-0/0003.jpg"), image("../public/translated-3-0/0003.jpg"), ct: 0.01, cb: 0.01)

#slide2x([4], image("../public/merged-3-0/0004.jpg"), image("../public/translated-3-0/0004.jpg"), cb: 0.27)

#slide2x([5], image("../public/merged-3-0/0005.jpg"), image("../public/translated-3-0/0005.jpg"), ct: 0.01)

== Terminologies

#slide2x([6], image("../public/merged-3-0/0006.jpg"), image("../public/translated-3-0/0006.jpg"), ct: 0.01, cb: 0.41)

- *时延(latency)*：单个指令从进入流水线开始，到它完成执行并可以写会结果所需要的时钟周期数。
  - *功能单元时间(function unit time)*：指指令在 EX/MEM 阶段的 latency。
  - $"latency" = "function unit time" - 1$。
- *启动间隔(initiation interval)*：一个功能单元需要经过多少个时钟周期才能被重新使用。
  - 对于 *完全流水线的(full pipelined)* 功能单元：$"initiation interval" = 1$。
  - 对于 *非流水线的(non-pipelined)* 功能单元：$"initiation interval" = "latency" + 1$。

#example(title: [浮点数流水线中功能单元的时延与启动间隔])[
  #align(center, image("images/2025-04-30-20-05-26.png", width: 40%))
  #no-par-margin

  这里 `FP add` 是四级流水线（$"latency" = "function unit time" - 1 = 3$），并且是完全流水线的（说明启动间隔为 $1$）功能模块。

  #no-par-margin
  #align(center, image("images/2025-04-30-21-06-00.png", width: 50%))
]

#slide2x([9], image("../public/merged-3-0/0009.jpg"), image("../public/translated-3-0/0009.jpg"), ct: 0.01, cb: 0.10)

#slide2x([2], image("../public/merged-3-1/0002.jpg"), image("../public/translated-3-1/0002.jpg"), ct: 0.01, cb: 0.12)

- *基本块(basic block)*：一段连续的、直线执行的代码。只有一个入口和一个出口，没有分支。

#slide2x([3], image("../public/merged-3-1/0003.jpg"), image("../public/translated-3-1/0003.jpg"), ct: 0.01, cb: 0.01)

#slide2x([4], image("../public/merged-3-1/0004.jpg"), image("../public/translated-3-1/0004.jpg"), ct: 0.01, cb: 0.27)

#slide2x([5], image("../public/merged-3-1/0005.jpg"), image("../public/translated-3-1/0005.jpg"), ct: 0.01, cb: 0.06)

#slide2x([6], image("../public/merged-3-1/0006.jpg"), image("../public/translated-3-1/0006.jpg"))

#slide2x([7], image("../public/merged-3-1/0007.jpg"), image("../public/translated-3-1/0007.jpg"), ct: 0.01, cb: 0.22)

#slide2x([8], image("../public/merged-3-1/0008.jpg"), image("../public/translated-3-1/0008.jpg"), ct: 0.01, cb: 0.07)

#slide2x([9], image("../public/merged-3-1/0009.jpg"), image("../public/translated-3-1/0009.jpg"), cb: 0.07)

#slide2x([10], image("../public/merged-3-1/0010.jpg"), image("../public/translated-3-1/0010.jpg"), cb: 0.10)

#slide2x([11], image("../public/merged-3-1/0011.jpg"), image("../public/translated-3-1/0011.jpg"), ct: 0.01, cb: 0.04)

#slide2x([12], image("../public/merged-3-1/0012.jpg"), image("../public/translated-3-1/0012.jpg"), ct: 0.02, cb: 0.17)

#slide2x([13], image("../public/merged-3-1/0013.jpg"), image("../public/translated-3-1/0013.jpg"), ct: 0.01, cb: 0.23)

#slide2x([14], image("../public/merged-3-1/0014.jpg"), image("../public/translated-3-1/0014.jpg"), cb: 0.12)

#slide2x([15], image("../public/merged-3-1/0015.jpg"), image("../public/translated-3-1/0015.jpg"), ct: 0.02, cb: 0.05)

#slide2x([16], image("../public/merged-3-1/0016.jpg"), image("../public/translated-3-1/0016.jpg"), ct: 0.01, cb: 0.17)

#slide2x([17], image("../public/merged-3-1/0017.jpg"), image("../public/translated-3-1/0017.jpg"), ct: 0.01, cb: 0.01)

#slide2x([18], image("../public/merged-3-1/0018.jpg"), image("../public/translated-3-1/0018.jpg"), ct: 0.01, cb: 0.06)

#slide2x([19], image("../public/merged-3-1/0019.jpg"), image("../public/translated-3-1/0019.jpg"), ct: 0.01, cb: 0.15)

= Dependencies & Hazards | 依赖与冒险

== Structural Hazards | 结构冒险

=== Structural Hazards for the FP Register Write Port | 浮点数寄存器写端口结构冒险

#slide2x([10], image("../public/merged-3-0/0010.jpg"), image("../public/translated-3-0/0010.jpg"))

- 浮点数流水线（顺序发射、顺序执行、*乱序完成(out-of-order complete)*）导致的结构冒险问题：
  - (1) 单个时钟周期内多个 WB 操作。
  - (2) 写回顺序被打乱导致冒险。

#slide2x([11], image("../public/merged-3-0/0011.jpg"), image("../public/translated-3-0/0011.jpg"), cb: 0.06)

#slide2x([12], image("../public/merged-3-0/0012.jpg"), image("../public/translated-3-0/0012.jpg"), ct: 0.01, cb: 0.03)

- 解决方法一：增加写端口的数量，从而允许一个时钟周期内执行多个 WB 操作。、
- 解决方法二：通过#mark[移位寄存器]，在#mark[指令译码阶段];跟踪写端口的使用——因为在静态调度流水线中，必定是顺序执行的，且在译码阶段已经可以计算需要 stall 几个周期，因此也可以直接结算处在什么时候写回。

#no-par-margin
#align(center, image("images/2025-04-30-20-31-09.png", width: 64%))
#no-par-margin

- 解决方法三：在指令试图进入 MEM 或 WB 阶段时进行 stall，在托马斯路等算法中可能再次用到。

#no-par-margin
#align(center, image("images/2025-04-30-20-30-02.png", width: 50%))


== Data Hazards | 数据冒险

#slide2x([13], image("../public/merged-3-0/0013.jpg"), image("../public/translated-3-0/0013.jpg"), ct: 0.01)

=== RAW Dependences

#slide2x([14], image("../public/merged-3-0/0014.jpg"), image("../public/translated-3-0/0014.jpg"), ct: 0.01, cb: 0.12)

- *读后写依赖(read-after-write dependency, RAW dependency)*，又称 *真数据依赖(true data dependency)*。
- 一般来说，只能通过 forwarding 或 stall 来解决。

#example(title: [通过 stall 解决 RAW 冒险])[
  #no-par-margin
  #align(center, image("images/2025-04-30-21-01-05.png", width: 80%))
]

=== WAW Dependences

#slide2x([15], image("../public/merged-3-0/0015.jpg"), image("../public/translated-3-0/0015.jpg"), ct: 0.01, cb: 0.06)

- *写后写依赖(write-after-write dependency, WAW dependency)*，又称 *输出依赖(output dependency)*，是 *命名依赖(name dependency)* 的一种。
- WAW 和 WAR 这两种命名依赖都可以通过重命名寄存器的方式解决。

#example(title: [通过 stall 解决 WAW 冒险])[
  #no-par-margin
  #align(center, image("images/2025-04-30-21-02-20.png", width: 70%))
]

#slide2x([19], image("../public/merged-3-0/0019.jpg"), image("../public/translated-3-0/0019.jpg"), ct: 0.01, cb: 0.13)

- 解决方法一：取消掉前一条指令的 WB 阶段，可以在 ID 阶段进行检测。
- 解决方法二：检测到冲突时阻滞在 ID 阶段（即后文小结的方法）。

=== WAR Dependences

#slide2x([16], image("../public/merged-3-0/0016.jpg"), image("../public/translated-3-0/0016.jpg"), ct: 0.01, cb: 0.5)

- *写后读依赖(write-after-read dependency, WAR dependency)* 又称 *反依赖(anti-dependency)*，是 *命名依赖(name dependency)* 的一种。

#no-par-margin
#align(center, image("images/2025-04-30-20-59-47.png", width: 42%))
#no-par-margin

- 在大部分顺序发射、顺序执行的流水线（称为 *顺序流水线(sequential pipeline)*）中，因为是顺序读取（一般都是尽可能早的读取出值），不会出现 WAR 冒险。

#slide2x([21], image("../public/merged-3-0/0021.jpg"), image("../public/translated-3-0/0021.jpg"), ct: 0.01)

#tip(title: [小结：顺序流水线解决结构冒险与数据冒险的方法])[
  一种简单且常用的方法是，对于结构冒险、RAW 冒险和 WAR 冒险，全都在 ID 阶段进行判断，如果不行就在 ID 阶段暂停，等到依赖解除后再进行发射。

  #no-par-margin
  #align(center, image("images/2025-04-30-20-50-00.png", width: 40%))
]

#slide2x([20], image("../public/merged-3-0/0020.jpg"), image("../public/translated-3-0/0020.jpg"), ct: 0.01, cb: 0.49)

#summary(title: [MIPS R4000 流水线])[
  - `| IF | IS | RF | EX | DF | DS | TC | WB |`

  #no-par-margin
  #align(center, image("images/2025-04-30-20-56-06.png", width: 60%))
]

#slide2x([25], image("../public/merged-3-0/0025.jpg"), image("../public/translated-3-0/0025.jpg"), ct: 0.01, cb: 0.26)

miss?

这里讲的冒险问题其实没听懂

#slide2x([26], image("../public/merged-3-0/0026.jpg"), image("../public/translated-3-0/0026.jpg"), ct: 0.01, cb: 0.03)

#slide2x([27], image("../public/merged-3-0/0027.jpg"), image("../public/translated-3-0/0027.jpg"), ct: 0.01, cb: 0.20)

#slide2x([28], image("../public/merged-3-0/0028.jpg"), image("../public/translated-3-0/0028.jpg"), ct: 0.01, cb: 0.27)

#slide2x([29], image("../public/merged-3-0/0029.jpg"), image("../public/translated-3-0/0029.jpg"), ct: 0.01, cb: 0.04)

== Controls Hazards | 控制冒险

#slide2x([30], image("../public/merged-3-0/0030.jpg"), image("../public/translated-3-0/0030.jpg"), ct: 0.01, cb: 0.01)

- 最常用的方法就是 stall（*延迟分支(delayed branch)*）。

== Hazards among FP Instructions

#slide2x([31], image("../public/merged-3-0/0031.jpg"), image("../public/translated-3-0/0031.jpg"), ct: 0.01, cb: 0.07)

#slide2x([32], image("../public/merged-3-0/0032.jpg"), image("../public/translated-3-0/0032.jpg"), ct: 0.01, cb: 0.10)

#slide2x([33], image("../public/merged-3-0/0033.jpg"), image("../public/translated-3-0/0033.jpg"), ct: 0.01, cb: 0.05)

mark

#slide2x([34], image("../public/merged-3-0/0034.jpg"), image("../public/translated-3-0/0034.jpg"), ct: 0.01, cb: 0.28)

#slide2x([35], image("../public/merged-3-0/0035.jpg"), image("../public/translated-3-0/0035.jpg"), ct: 0.01, cb: 0.05)

#slide2x([36], image("../public/merged-3-0/0036.jpg"), image("../public/translated-3-0/0036.jpg"), ct: 0.01, cb: 0.27)

#slide2x([37], image("../public/merged-3-0/0037.jpg"), image("../public/translated-3-0/0037.jpg"), ct: 0.01, cb: 0.06)

= Basic Compiler Techniques | 基本编译技术

#slide2x([20], image("../public/merged-3-1/0020.jpg"), image("../public/translated-3-1/0020.jpg"), ct: 0.01, cb: 0.12)

在本节中，我们考虑以下 C 代码：

```c
for (i = 999; i >= 0; i--)   // typeof i is long long
    x[i] += s;               // typeof x[i] is double
```

编译到 RISC-V 的结果如下：

```asm
Loop:
    fld     f0, 0(x1)
    fadd.d  f4, f0, f2
    fsd     f4, 0(x1)
    addi    x1, x1, -8
    bne     x1, x2, Loop
```

== Scheduling | 调度

#slide2x([21], image("../public/merged-3-1/0021.jpg"), image("../public/translated-3-1/0021.jpg"), cb: 0.02)

#slide2x([22], image("../public/merged-3-1/0022.jpg"), image("../public/translated-3-1/0022.jpg"), ct: 0.01, cb: 0.20)

#slide2x([23], image("../public/merged-3-1/0023.jpg"), image("../public/translated-3-1/0023.jpg"))

- 使用 *调度(scheduling)* 优化本节实例代码，可以减少一个时钟周期的停顿。

#no-par-margin
#table(
  columns: (1fr, 1fr),
  table.header(
    [*调度前*],
    [*调度后*],
  ),

  align(center, image("images/2025-05-01-00-21-28.png", width: 60%)), align(center, image("images/2025-05-01-00-21-43.png", width: 60%)),
)


== Loop Unrolling | 循环展开

#slide2x([24], image("../public/merged-3-1/0024.jpg"), image("../public/translated-3-1/0024.jpg"), cb: 0.01)

#slide2x([25], image("../public/merged-3-1/0025.jpg"), image("../public/translated-3-1/0025.jpg"), ct: 0.01, cb: 0.14)

- 使用 *循环展开(loop unrolling)* 并进行调度，可以进一步减少每次迭代的平均周期数。

#no-par-margin
#table(
  columns: (1fr, 1fr),
  table.header(
    [*循环展开四次的结果*],
    [*循环展开四次并调度的结果*],
  ),

  [
    平均每循环 6.5 个时钟周期
    #no-par-margin
    #align(center, image("images/2025-05-01-00-24-10.png", width: 100%))
  ],
  [
    平均每循环 3.5 个时钟周期
    #no-par-margin
    #align(center, image("images/2025-05-01-00-24-18.png", width: 60%))
  ],
)

- 这里假设了迭代次数是 $4$ 的倍数，如果不是的话需要再后面再补上单迭代的循环，以确保总迭代次数不变。

TBD: 具体方法论

= Dynamic Scheduling | 动态调度

#slide2x([26], image("../public/merged-3-1/0026.jpg"), image("../public/translated-3-1/0026.jpg"))

- 回顾（计组知识）：*静态调度(static scheduling)* 静态调度的流水线处理器在获取指令后会发射该指令，除非发现该指令存在数据依赖且无法通过 *前递(forwarding)* 来隐藏该指令，此时冒险检测硬件会暂停流水线，直到依赖清除后在获取新的指令。
- *动态调度(dynamic scheduling)*：通过硬件重排指令的执行阶段（允许 *顺序发射(in-order issue)* 但是 *乱序执行(out-of-order execution)*）以减少停顿，并且不改变 *数据流(data flow)* 和 *异常(exception behavior)*。
  - 优点：
    - 可以让在某个流水线上被编译的代码在其他流水线上也能高效运行。
    - 能够处理在编译时无法处理的依赖，比如内存引用或数据依赖分支，或者采用现代的动态链接或分派。
    - 能让处理器容忍无法预测的时延，比如对于高速缓存失效，可通过在等待失效解决时执行其他代码来实现这一点。

#slide2x([27], image("../public/merged-3-1/0027.jpg"), image("../public/translated-3-1/0027.jpg"), ct: 0.01, cb: 0.10)

#slide2x([28], image("../public/merged-3-1/0028.jpg"), image("../public/translated-3-1/0028.jpg"), cb: 0.02)

#slide2x([29], image("../public/merged-3-1/0029.jpg"), image("../public/translated-3-1/0029.jpg"), ct: 0.01, cb: 0.10)

#slide2x([30], image("../public/merged-3-1/0030.jpg"), image("../public/translated-3-1/0030.jpg"), cb: 0.12)

== The Scoreboard Algorithm | 记分牌算法

#slide2x([31], image("../public/merged-3-1/0031.jpg"), image("../public/translated-3-1/0031.jpg"), cb: 0.23)

#slide2x([32], image("../public/merged-3-1/0032.jpg"), image("../public/translated-3-1/0032.jpg"), cb: 0.05)

#slide2x([33], image("../public/merged-3-1/0033.jpg"), image("../public/translated-3-1/0033.jpg"))

#slide2x([34], image("../public/merged-3-1/0034.jpg"), image("../public/translated-3-1/0034.jpg"), ct: 0.01, cb: 0.19)

- 带记分牌的流水线阶段：`IF - IS - RO - EX - WB`。
  - 与 RISC-V 五级流水线的区别：
    - ID 阶段：分成了 *发射(issue)* 和 *读操作数(read operands)* 两个阶段。
    - MEM 阶段：省略，合并到 EX 阶段。

#slide2x([35], image("../public/merged-3-1/0035.jpg"), image("../public/translated-3-1/0035.jpg"), cb: 0.02)

#slide2x([36], image("../public/merged-3-1/0036.jpg"), image("../public/translated-3-1/0036.jpg"), cb: 0.03)

- 记分牌流水线各阶段原则：
  - IS
    - 当且仅当 (1) 功能单元可用 (2) 没有其他活跃指令占用了相同的目标寄存器 时，发射指令。
    - 可以避免结构冒险与 WAW 冒险。
  - RO
    - 直到#mark[两个源操作数都可用];时，才进行读取。
    - 可以动态地避免 RAW 冒险。

#slide2x([37], image("../public/merged-3-1/0037.jpg"), image("../public/translated-3-1/0037.jpg"), ct: 0.01, cb: 0.09)

#slide2x([38], image("../public/merged-3-1/0038.jpg"), image("../public/translated-3-1/0038.jpg"), ct: 0.01)

#slide2x([39], image("../public/merged-3-1/0039.jpg"), image("../public/translated-3-1/0039.jpg"), ct: 0.01)

#slide2x([40], image("../public/merged-3-1/0040.jpg"), image("../public/translated-3-1/0040.jpg"))

#slide2x([41], image("../public/merged-3-1/0041.jpg"), image("../public/translated-3-1/0041.jpg"))

#slide2x([42], image("../public/merged-3-1/0042.jpg"), image("../public/translated-3-1/0042.jpg"))

#slide2x([43], image("../public/merged-3-1/0043.jpg"), image("../public/translated-3-1/0043.jpg"))

#slide2x([44], image("../public/merged-3-1/0044.jpg"), image("../public/translated-3-1/0044.jpg"))

#slide2x([45], image("../public/merged-3-1/0045.jpg"), image("../public/translated-3-1/0045.jpg"))

#slide2x([46], image("../public/merged-3-1/0046.jpg"), image("../public/translated-3-1/0046.jpg"))

#slide2x([47], image("../public/merged-3-1/0047.jpg"), image("../public/translated-3-1/0047.jpg"))

#slide2x([48], image("../public/merged-3-1/0048.jpg"), image("../public/translated-3-1/0048.jpg"))

#slide2x([49], image("../public/merged-3-1/0049.jpg"), image("../public/translated-3-1/0049.jpg"), cb: 0.05)

#slide2x([50], image("../public/merged-3-1/0050.jpg"), image("../public/translated-3-1/0050.jpg"))

#slide2x([51], image("../public/merged-3-1/0051.jpg"), image("../public/translated-3-1/0051.jpg"))

#slide2x([52], image("../public/merged-3-1/0052.jpg"), image("../public/translated-3-1/0052.jpg"))

#slide2x([53], image("../public/merged-3-1/0053.jpg"), image("../public/translated-3-1/0053.jpg"))

#slide2x([54], image("../public/merged-3-1/0054.jpg"), image("../public/translated-3-1/0054.jpg"))

#slide2x([55], image("../public/merged-3-1/0055.jpg"), image("../public/translated-3-1/0055.jpg"))

#slide2x([56], image("../public/merged-3-1/0056.jpg"), image("../public/translated-3-1/0056.jpg"))

#slide2x([57], image("../public/merged-3-1/0057.jpg"), image("../public/translated-3-1/0057.jpg"))

#slide2x([58], image("../public/merged-3-1/0058.jpg"), image("../public/translated-3-1/0058.jpg"), ct: 0.02, cb: 0.02)

#slide2x([59], image("../public/merged-3-1/0059.jpg"), image("../public/translated-3-1/0059.jpg"), ct: 0.01)

#slide2x([60], image("../public/merged-3-1/0060.jpg"), image("../public/translated-3-1/0060.jpg"), ct: 0.01, cb: 0.15)

#slide2x([61], image("../public/merged-3-1/0061.jpg"), image("../public/translated-3-1/0061.jpg"), ct: 0.01, cb: 0.05)

#slide2x([62], image("../public/merged-3-1/0062.jpg"), image("../public/translated-3-1/0062.jpg"), ct: 0.01, cb: 0.10)

== Tomasulo Algorithm | 托马斯路算法

#slide2x([2], image("../public/merged-3-2/0002.jpg"), image("../public/translated-3-2/0002.jpg"), ct: 0.01, cb: 0.28)

#slide2x([3], image("../public/merged-3-2/0003.jpg"), image("../public/translated-3-2/0003.jpg"), cb: 0.04)

#slide2x([4], image("../public/merged-3-2/0004.jpg"), image("../public/translated-3-2/0004.jpg"), cb: 0.05)

#slide2x([5], image("../public/merged-3-2/0005.jpg"), image("../public/translated-3-2/0005.jpg"))

#slide2x([6], image("../public/merged-3-2/0006.jpg"), image("../public/translated-3-2/0006.jpg"), cb: 0.07)

#slide2x([7], image("../public/merged-3-2/0007.jpg"), image("../public/translated-3-2/0007.jpg"), cb: 0.14)

#slide2x([8], image("../public/merged-3-2/0008.jpg"), image("../public/translated-3-2/0008.jpg"), ct: 0.01, cb: 0.18)

#slide2x([9], image("../public/merged-3-2/0009.jpg"), image("../public/translated-3-2/0009.jpg"))

#slide2x([10], image("../public/merged-3-2/0010.jpg"), image("../public/translated-3-2/0010.jpg"), ct: 0.01)

#slide2x([11], image("../public/merged-3-2/0011.jpg"), image("../public/translated-3-2/0011.jpg"), ct: 0.03, cb: 0.03)

#slide2x([12], image("../public/merged-3-2/0012.jpg"), image("../public/translated-3-2/0012.jpg"), ct: 0.02)

#slide2x([13], image("../public/merged-3-2/0013.jpg"), image("../public/translated-3-2/0013.jpg"))

#slide2x([14], image("../public/merged-3-2/0014.jpg"), image("../public/translated-3-2/0014.jpg"), ct: 0.01, cb: 0.02)

#slide2x([15], image("../public/merged-3-2/0015.jpg"), image("../public/translated-3-2/0015.jpg"), ct: 0.01, cb: 0.02)

#slide2x([16], image("../public/merged-3-2/0016.jpg"), image("../public/translated-3-2/0016.jpg"), cb: 0.01)

#slide2x([17], image("../public/merged-3-2/0017.jpg"), image("../public/translated-3-2/0017.jpg"), ct: 0.01, cb: 0.07)

#slide2x([18], image("../public/merged-3-2/0018.jpg"), image("../public/translated-3-2/0018.jpg"), ct: 0.01)

#slide2x([19], image("../public/merged-3-2/0019.jpg"), image("../public/translated-3-2/0019.jpg"), ct: 0.01, cb: 0.05)

#slide2x([20], image("../public/merged-3-2/0020.jpg"), image("../public/translated-3-2/0020.jpg"), ct: 0.02, cb: 0.07)

#slide2x([21], image("../public/merged-3-2/0021.jpg"), image("../public/translated-3-2/0021.jpg"), ct: 0.02, cb: 0.07)

#slide2x([22], image("../public/merged-3-2/0022.jpg"), image("../public/translated-3-2/0022.jpg"), ct: 0.01, cb: 0.02)

#slide2x([23], image("../public/merged-3-2/0023.jpg"), image("../public/translated-3-2/0023.jpg"), ct: 0.01, cb: 0.02)

#slide2x([24], image("../public/merged-3-2/0024.jpg"), image("../public/translated-3-2/0024.jpg"), ct: 0.01, cb: 0.05)

#slide2x([25], image("../public/merged-3-2/0025.jpg"), image("../public/translated-3-2/0025.jpg"), ct: 0.01)

#slide2x([26], image("../public/merged-3-2/0026.jpg"), image("../public/translated-3-2/0026.jpg"), ct: 0.01, cb: 0.01)

#slide2x([27], image("../public/merged-3-2/0027.jpg"), image("../public/translated-3-2/0027.jpg"), ct: 0.01, cb: 0.06)

#slide2x([28], image("../public/merged-3-2/0028.jpg"), image("../public/translated-3-2/0028.jpg"), ct: 0.01, cb: 0.10)

#slide2x([29], image("../public/merged-3-2/0029.jpg"), image("../public/translated-3-2/0029.jpg"), ct: 0.01, cb: 0.01)

#slide2x([30], image("../public/merged-3-2/0030.jpg"), image("../public/translated-3-2/0030.jpg"), ct: 0.01)

#slide2x([31], image("../public/merged-3-2/0031.jpg"), image("../public/translated-3-2/0031.jpg"), cb: 0.18)

#slide2x([32], image("../public/merged-3-2/0032.jpg"), image("../public/translated-3-2/0032.jpg"), ct: 0.01, cb: 0.09)

#slide2x([33], image("../public/merged-3-2/0033.jpg"), image("../public/translated-3-2/0033.jpg"), cb: 0.05)

#slide2x([34], image("../public/merged-3-2/0034.jpg"), image("../public/translated-3-2/0034.jpg"), ct: 0.01, cb: 0.10)

#slide2x([35], image("../public/merged-3-2/0035.jpg"), image("../public/translated-3-2/0035.jpg"), ct: 0.01)

#slide2x([36], image("../public/merged-3-2/0036.jpg"), image("../public/translated-3-2/0036.jpg"), ct: 0.01, cb: 0.02)

#slide2x([37], image("../public/merged-3-2/0037.jpg"), image("../public/translated-3-2/0037.jpg"), ct: 0.01)

#slide2x([38], image("../public/merged-3-2/0038.jpg"), image("../public/translated-3-2/0038.jpg"), ct: 0.01)

#slide2x([39], image("../public/merged-3-2/0039.jpg"), image("../public/translated-3-2/0039.jpg"), ct: 0.02)

#slide2x([40], image("../public/merged-3-2/0040.jpg"), image("../public/translated-3-2/0040.jpg"), ct: 0.02)

#slide2x([41], image("../public/merged-3-2/0041.jpg"), image("../public/translated-3-2/0041.jpg"), ct: 0.02)

#slide2x([42], image("../public/merged-3-2/0042.jpg"), image("../public/translated-3-2/0042.jpg"), ct: 0.02)

#slide2x([43], image("../public/merged-3-2/0043.jpg"), image("../public/translated-3-2/0043.jpg"), ct: 0.01)

#slide2x([44], image("../public/merged-3-2/0044.jpg"), image("../public/translated-3-2/0044.jpg"), ct: 0.01)

#slide2x([45], image("../public/merged-3-2/0045.jpg"), image("../public/translated-3-2/0045.jpg"), ct: 0.02)

#slide2x([46], image("../public/merged-3-2/0046.jpg"), image("../public/translated-3-2/0046.jpg"), ct: 0.02)

#slide2x([47], image("../public/merged-3-2/0047.jpg"), image("../public/translated-3-2/0047.jpg"), ct: 0.01, cb: 0.02)

#slide2x([48], image("../public/merged-3-2/0048.jpg"), image("../public/translated-3-2/0048.jpg"), ct: 0.01)

#slide2x([49], image("../public/merged-3-2/0049.jpg"), image("../public/translated-3-2/0049.jpg"), ct: 0.02, cb: 0.02)

#slide2x([50], image("../public/merged-3-2/0050.jpg"), image("../public/translated-3-2/0050.jpg"), ct: 0.01)

#slide2x([51], image("../public/merged-3-2/0051.jpg"), image("../public/translated-3-2/0051.jpg"), ct: 0.01)

#slide2x([52], image("../public/merged-3-2/0052.jpg"), image("../public/translated-3-2/0052.jpg"), ct: 0.01)

#slide2x([53], image("../public/merged-3-2/0053.jpg"), image("../public/translated-3-2/0053.jpg"), ct: 0.01)

#slide2x([54], image("../public/merged-3-2/0054.jpg"), image("../public/translated-3-2/0054.jpg"), ct: 0.01, cb: 0.03)

#slide2x([55], image("../public/merged-3-2/0055.jpg"), image("../public/translated-3-2/0055.jpg"), ct: 0.01, cb: 0.15)

#slide2x([56], image("../public/merged-3-2/0056.jpg"), image("../public/translated-3-2/0056.jpg"), ct: 0.01)

#slide2x([57], image("../public/merged-3-2/0057.jpg"), image("../public/translated-3-2/0057.jpg"), ct: 0.01, cb: 0.04)

#slide2x([58], image("../public/merged-3-2/0058.jpg"), image("../public/translated-3-2/0058.jpg"), ct: 0.01, cb: 0.04)

#slide2x([59], image("../public/merged-3-2/0059.jpg"), image("../public/translated-3-2/0059.jpg"), ct: 0.02, cb: 0.05)

#slide2x([60], image("../public/merged-3-2/0060.jpg"), image("../public/translated-3-2/0060.jpg"), ct: 0.02, cb: 0.12)

#slide2x([61], image("../public/merged-3-2/0061.jpg"), image("../public/translated-3-2/0061.jpg"), cb: 0.14)

#slide2x([62], image("../public/merged-3-2/0062.jpg"), image("../public/translated-3-2/0062.jpg"), cb: 0.04)

#slide2x([63], image("../public/merged-3-2/0063.jpg"), image("../public/translated-3-2/0063.jpg"), cb: 0.01)

#slide2x([64], image("../public/merged-3-2/0064.jpg"), image("../public/translated-3-2/0064.jpg"))

#slide2x([65], image("../public/merged-3-2/0065.jpg"), image("../public/translated-3-2/0065.jpg"), cb: 0.22)

#slide2x([66], image("../public/merged-3-2/0066.jpg"), image("../public/translated-3-2/0066.jpg"))

#slide2x([67], image("../public/merged-3-2/0067.jpg"), image("../public/translated-3-2/0067.jpg"))

#slide2x([68], image("../public/merged-3-2/0068.jpg"), image("../public/translated-3-2/0068.jpg"))

#slide2x([69], image("../public/merged-3-2/0069.jpg"), image("../public/translated-3-2/0069.jpg"), cb: 0.01)

#slide2x([70], image("../public/merged-3-2/0070.jpg"), image("../public/translated-3-2/0070.jpg"), cb: 0.05)

#slide2x([71], image("../public/merged-3-2/0071.jpg"), image("../public/translated-3-2/0071.jpg"), cb: 0.01)

#slide2x([72], image("../public/merged-3-2/0072.jpg"), image("../public/translated-3-2/0072.jpg"))

#slide2x([73], image("../public/merged-3-2/0073.jpg"), image("../public/translated-3-2/0073.jpg"), cb: 0.02)

#slide2x([74], image("../public/merged-3-2/0074.jpg"), image("../public/translated-3-2/0074.jpg"), cb: 0.02)

#slide2x([75], image("../public/merged-3-2/0075.jpg"), image("../public/translated-3-2/0075.jpg"), cb: 0.01)

#slide2x([76], image("../public/merged-3-2/0076.jpg"), image("../public/translated-3-2/0076.jpg"))

#slide2x([77], image("../public/merged-3-2/0077.jpg"), image("../public/translated-3-2/0077.jpg"), cb: 0.02)

#slide2x([78], image("../public/merged-3-2/0078.jpg"), image("../public/translated-3-2/0078.jpg"))

#slide2x([79], image("../public/merged-3-2/0079.jpg"), image("../public/translated-3-2/0079.jpg"), cb: 0.01)

#slide2x([80], image("../public/merged-3-2/0080.jpg"), image("../public/translated-3-2/0080.jpg"), cb: 0.01)

#slide2x([81], image("../public/merged-3-2/0081.jpg"), image("../public/translated-3-2/0081.jpg"), cb: 0.02)

#slide2x([82], image("../public/merged-3-2/0082.jpg"), image("../public/translated-3-2/0082.jpg"), cb: 0.02)

#slide2x([83], image("../public/merged-3-2/0083.jpg"), image("../public/translated-3-2/0083.jpg"), cb: 0.02)

#slide2x([84], image("../public/merged-3-2/0084.jpg"), image("../public/translated-3-2/0084.jpg"), cb: 0.02)

#slide2x([85], image("../public/merged-3-2/0085.jpg"), image("../public/translated-3-2/0085.jpg"), cb: 0.02)

#slide2x([86], image("../public/merged-3-2/0086.jpg"), image("../public/translated-3-2/0086.jpg"), cb: 0.02)

#slide2x([87], image("../public/merged-3-2/0087.jpg"), image("../public/translated-3-2/0087.jpg"))

#slide2x([88], image("../public/merged-3-2/0088.jpg"), image("../public/translated-3-2/0088.jpg"), cb: 0.02)

#slide2x([89], image("../public/merged-3-2/0089.jpg"), image("../public/translated-3-2/0089.jpg"))

#slide2x([90], image("../public/merged-3-2/0090.jpg"), image("../public/translated-3-2/0090.jpg"), cb: 0.02)

#slide2x([91], image("../public/merged-3-2/0091.jpg"), image("../public/translated-3-2/0091.jpg"), ct: 0.01, cb: 0.13)

= References

- cwz、jxh 等老师的课件。
- lxr 等同学的笔记。
- https://note.noughtq.top/system/ca/3
- https://en.wikipedia.org/wiki/Data_dependency
- https://zhuanlan.zhihu.com/p/496078836
- https://zhuanlan.zhihu.com/p/499978902
