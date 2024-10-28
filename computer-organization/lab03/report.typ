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

- 复习二进制加减、乘除的基本法则；
- 掌握补码的基本原理和作用；
- 了解浮点数的表示方法及加法运算法则；
- 进一步了解计算机系统的复杂运算操作。

== 实验目标与任务

- *目标*：熟悉二进制原码补码的概念，了解二进制加减乘除的原理，掌握浮点加法的操作实现。
- *任务一*：设计实现乘法器；
- *任务二*：设计实现除法器；
- *任务三*：设计实现浮点加法器。

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

- 在 `user/sim/tb.v` 中填入给出的仿真代码。

- 通过 `vivado -mode tcl -source create_project.tcl` 指令创建并打开 Vivado 项目，并进行仿真测试。

- #[
    在仿真设置中，可将 Radix 设为 Unsigned Decimal，从而方便查看仿真结果。

    #align(center, image("images/2024-10-06-00-30-20.png", width: 50%))
  ]

== 实验结果与分析

- #[
    对于第一组数据，被乘数为 2，乘数为 3，所得乘积为 6，结果正确。且在得出结果后 finish 信号被置为 1，符合预期。注意到中间有一段信号图像类似于弹簧，这体现了乘积寄存器中不断发生右移的过程，即使被乘数和乘数的高位部分均为 0。

    #align(center, image("images/2024-10-06-00-32-35.png", width: 100%))
  ]

- #[
    对于剩下的几组数据 $10 times 8 = 80$, $9 times 9 = 81$, $50 times 6 = 300$, $6 times 60 = 360$，结果均正确。

    #align(center, image("images/2024-10-06-00-33-51.png", width: 100%))
  ]

== 实验讨论与心得

这里我的实现用到的所有赋值都是非阻塞赋值，只在时钟正边沿到来时统一进行赋值操作。注意到在硬件实现的层面，“加法”和“右移”的过程是同时发生的（具体可以在我的代码中体现），我们可以直接把加法的进位直接连到乘积寄存器的最高位，所以我们只需要一个 64 位的乘法寄存器而不需要额外的 1 位寄存器来储存进位。同时，我们这样的实现相比于基于阻塞赋值的实现拥有更高的性能。

#pagebreak(weak: true)

= 实验三 (2)：32 位无符号整数除法

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

- 在 `user/sim/tb.v` 中填入给出的仿真代码。

- 通过 `vivado -mode tcl -source create_project.tcl` 指令创建并打开 Vivado 项目，并进行仿真测试。

- 仿真时，可将 Radix 设为 Unsigned Decimal。

== 实验结果与分析

- #[
    对于第一组数据，被除数为 8，除数为 4，刚好整除；得到商为 2，余数为 0，结果正确。

    #align(center, image("images/2024-10-28-21-10-02.png", width: 100%))
  ]

- #[
    对于剩下的几组数据，程序运行结果均正确。

    #align(center, image("images/2024-10-28-21-11-56.png", width: 100%))
  ]


== 实验讨论与心得

这里我的实现与第一个小实验 32 位无符号乘法相同，所有用到的赋值操作都是非阻塞赋值，其好处如第一个小实验的“实验讨论与心得”部分所示。

#pagebreak(weak: true)

= 实验三 (3)：单精度浮点数加法

== 实验实现方法与步骤

- #[
    在 `create_project.tcl` 中填入以下代码：

    #codex(read("./float_add/create_project.tcl"), lang: "tcl")
  ]

- #[
    在 `user/src/float_add.v` 中填入以下代码：

    这里加入了一些 `$display` 语句用于调试，他们并不会对仿真结果产生影响。

    #codex(read("./float_add/user/src/float_add.v"), lang: "verilog")
  ]

- #[
    在 `user/sim/tb.v` 中填入以下仿真代码：

    #codex(read("./float_add/user/sim/tb.v"), lang: "verilog")
  ]


- 通过 `vivado -mode tcl -source create_project.tcl` 指令创建并打开 Vivado 项目，并进行仿真测试。

- #[
    仿真时，可将选中输入输出信号 `A`、`B` 和 `result`，在右键菜单中选择 Radix $->$ Real Settings，并选择 Floating point $->$ Single precision，从而方便查看仿真结果。

    #align(center, image("images/2024-10-28-23-44-08.png", width: 60%))

    #align(center, image("images/2024-10-28-23-44-13.png", width: 60%))
  ]

== 实验结果与分析

正确设置数据格式后，可以直观的验证仿真结果。如下图，本实验的仿真结果与预期一致。

#align(center, image("images/2024-10-28-23-45-22.png", width: 100%))

== 实验讨论与心得

- 这里因为浮点数加法的流程较为复杂，所以实现时没有使用非阻塞复制 + 时序逻辑的设计模式，而是直接使用阻塞赋值进行实现，因而代码较为简单。如果要求更本质的实现，可以使用严格的非阻塞赋值完成模块。
- 这里并没有实现 guard bit、round bit、sticky bit 和不同的舍入逻辑，有必要的话也可以实现这些功能。