#import "../template.typ": *

#show: project.with(
  theme: "lab",
  title: "Computer Organization Exp 04",
  course: "计算机组成",
  name: "实验四：单周期 CPU 设计",
  author: "吴与伦",
  school_id: "3230104585",
  major: "计算机科学与技术",
  place: "东四 509",
  teacher: "赵莎",
  date: "2024/11/20",
)

#show heading.where(level: 2): it => block(
  width: 100%,
  {
    v(0.85em)
    it
    v(0.15em)
  },
)

= Exp04-0：CPU 核集成设计

== 实验目的

+ 复习寄存器传输控制技术；

+ 掌握CPU的核心组成：数据通路与控制器；

+ 设计数据通路的功能部件；

+ 进一步了解计算机系统的基本结构；

+ 熟练掌握IP核的使用方法。

== 实验目标与任务

- *目标*：熟悉SOC系统的原理，掌握IP核集成设计CPU的方法。

- *任务*：利用数据通路和控制器两个IP核集成设计CPU。

== 实验实现方法与步骤

+ #[
    在 `create_project.tcl` 中填入以下代码：

    #codex(read("./cpu/create_project.tcl"), lang: "tcl")
  ]

+ #[
    参考原理图完成 SCPU 模块构建。

    #codex(read("./cpu/user/src/SCPU.v"), lang: "verilog")
  ]

+ #[
    接入给定的数据通路和控制器软核进行调试。
  ]

*注：测试过程与结果详见Lab04-2的实验报告。*

#pagebreak(weak: true)

= Exp04-1：CPU设计之数据通路

== 实验目的

+ 运用寄存器传输控制技术；

+ 掌握CPU的核心：数据通路组成与原理；

+ 设计数据通路；

+ 学习测试方案的设计；

+ 学习测试程序的设计。

== 实验目标与任务

- *目标*：熟悉RISC-V RV32I的指令特点，了解数据通路的原理，设计并测试数据通路。

- *任务一*：设计实现数据通路（采用RTL实现）：
  - ALU和Regs调用Exp01设计的模块（可直接加RTL）；
  - PC寄存器设计及PC通路建立；
  - ImmGen立即数生成模块设计；
  - 此实验在Exp4-0的基础上完成，替换Exp4-0的数据通路核。

- *任务二*：设计数据通路测试方案并完成测试：
  - 通路测试：I-格式通路、R-格式通路；
  - 部件测试：ALU、Register Files。

== 实验实现方法与步骤

+ #[
    完成立即数生成模块 Imm Gen 的剩余实现，注意是进行符号拓展。

    #codex(read("./cpu/user/src/ImmGen.v"), lang: "verilog")
  ]

+ #[
    设计 REG32 模块实现 32 位寄存器：

    #codex(read("./cpu/user/src/REG32.v"), lang: "verilog")
  ]

+ #[
    参考原理图 @datapath_diagram 完成数据通路顶层设计：

    #codex(read("./cpu/user/src/DataPath.v"), lang: "verilog")
  ]

+ #[
    替换 Lab02 的对应 SCPU 部分，并运行 Demo 程序。
  ]

*注：测试过程与结果详见Lab04-2的实验报告。*

#pagebreak(weak: true)

= Exp04-2：CPU设计之控制器

== 实验目的

+ 运用寄存器传输控制技术；

+ 掌握CPU的核心：指令执行过程与控制流关系；

+ 设计控制器；

+ 学习测试方案的设计；

+ 学习测试程序的设计。

== 实验目标与任务

- *目标*：熟悉RISC-V RV32I的指令特点，了解控制器的原理，设计并测试控制器。

- *任务一*：用硬件描述语言设计实现控制器：
  - 根据Exp04-1数据通路及指令编码完成控制信号真值表；
  - 此实验在Exp04-1的基础上完成，替换Exp04-1的控制器核。

- *任务二*：设计控制器测试方案并完成测试：
  - OP译码测试：R-格式、访存指令、分支指令，转移指令；
  - 运算控制测试：Function译码测试。

== 实验实现方法与步骤

+ #[
    根据实验文档中给出的主控制器信号真值表来完成控制器 `SCPU_ctrl` 的一级译码：

    #align(center, image("images/2024-11-20-16-07-03.png", width: 100%))
  ]

+ #[
    在二级译码阶段，我们需要得到具体的 `ALU_Control` 信号来传给 ALU，可以参考理论课课件中的相应表格：

    #align(center, image("images/2024-11-20-16-08-51.png", width: 100%))
  ]

+ #[
    综上可以得到完整的 `SCPU_ctrl.v` 代码：

    #codex(read("./cpu/user/src/SCPU_ctrl.v"), lang: "verilog")
  ]

+ #[
    替换 Exp02 的对应部分并进行测试。

    实际上，这里我们只需要使用 `create_project.tcl` 脚本重新构建项目即可。
  ]

+ #[
    利用给定的 Testbench 代码进行功能仿真：

    #codex(read("./cpu/user/sim/tb.v"), lang: "verilog")

    注意：可以在 Scope 窗口中添加观察信号。
  ]

+ #[
    上板进行物理验证，测试 Demo 程序能否成功运行。

		TODO：来张图片
  ]

#pagebreak(weak: true)

= 附录

#figure(
  align(center, image("images/2024-11-20-15-56-00.png", width: 100%)),
  caption: "Datapath 原理图",
) <datapath_diagram>