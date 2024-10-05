#import "../template.typ": *

#show: project.with(
  theme: "lab",
  title: "Computer Organization Lab 03",
  course: "计算机组成",
  name: "实验三：复杂操作实现",
  author: "吴与伦",
  school_id: "3230104585",
  major: "计算机科学与技术",
  place: "东四 509",
  teacher: "赵莎",
  date: "2024/10/05",
)

#show heading.where(level: 2): it => block(
  width: 100%,
  {
    v(0.85em)
    it
    v(0.15em)
  },
)

= 实验三：复杂操作实现

== 实验目的

- 复习二进制加减、乘除的基本法则
- 掌握补码的基本原理和作用
- 了解浮点数的表示方法及加法运算法则
- 进一步了解计算机系统的复杂运算操作

== 实验目标与任务

- *目标*：熟悉二进制原码补码的概念，了解二进制加减乘除的原理，掌握浮点加法的操作实现

- *任务一*：设计实现乘法器

- *任务二*：设计实现除法器

- *任务三*：设计实现浮点加法器

== 实验设备和环境

本次实验不需要用到开发板，只需要进行 Verilog 仿真。

#pagebreak(weak: true)

= 实验三 (1)：32 位无符号整数乘法

== 实验实现方法与步骤

- #[
    在 `create_project.tcl` 中填入以下代码：

    #codex(read("./mul32/create_project.tcl"), lang: "tcl")
  ]

- #[
    在 `user/src/mul32.v` 中填入以下代码：

    #codex(read("./mul32/user/src/mul32.v"), lang: "verilog")
  ]

- #[
    在 `user/src/add32.v` 中填入以下代码：

    #codex(read("./mul32/user/src/add32.v"), lang: "verilog")
  ]

- #[
    在 `user/sim/tb.v` 中填入以下代码：

    #codex(read("./mul32/user/sim/tb.v"), lang: "verilog")
  ]

- 通过 `vivado -mode tcl -source create_project.tcl` 指令创建并打开 Vivado 项目，并进行仿真测试。

== 实验结果与分析

仿真结果

== 实验讨论与心得

这里我的实现用到的所有赋值都是非阻塞赋值，只在时钟正边沿到来时统一进行赋值操作。注意到在硬件实现的层面，“加法”和“右移”的过程是同时发生的（具体可以在我的代码中体现），我们可以直接把加法的进位直接连到乘积寄存器的最高位，所以我们只需要一个 64 位的乘法寄存器而不需要额外的 1 位寄存器来储存进位。同时，我们这样的实现相比于基于阻塞赋值的实现拥有更高的性能。

#pagebreak(weak: true)

= 实验三 (2)：32 位无符号整数除法

== 实验设备和环境

本次实验不需要用到开发板，只需要进行 Verilog 仿真。

== 实验实现方法与步骤

- #[
    在 `create_project.tcl` 中填入以下代码：

    #codex(read("./div32/create_project.tcl"), lang: "tcl")
  ]

- #[
    在 `user/src/div32.v` 中填入以下代码：

    #codex(read("./div32/user/src/div32.v"), lang: "verilog")
  ]

- #[
    在 `user/src/sub32_nocarry.v` 中填入以下代码：

    #codex(read("./div32/user/src/sub32_nocarry.v"), lang: "verilog")
  ]

- #[
    在 `user/sim/tb.v` 中填入以下代码：

    #codex(read("./div32/user/sim/tb.v"), lang: "verilog")
  ]

- 通过 `vivado -mode tcl -source create_project.tcl` 指令创建并打开 Vivado 项目，并进行仿真测试。

== 实验结果与分析

== 实验讨论与心得

这里我的实现与第一个小实验 32 位无符号乘法相同，所有用到的赋值操作都是非阻塞赋值，其好处如第一个小实验的“实验讨论与心得”部分所示。

#pagebreak(weak: true)

= 实验三 (3)：单精度浮点数加法
