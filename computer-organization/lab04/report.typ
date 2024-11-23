#import "../template.typ": *

#show: project.with(
  theme: "lab",
  title: "Computer Organization Lab 04",
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

= Lab04-0：CPU 核集成设计

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

#pagebreak(weak: true)

= Lab04-1：CPU设计之数据通路

== 实验目的

+ 运用寄存器传输控制技术；

+ 掌握CPU的核心：数据通路组成与原理；

+ 设计数据通路；

+ 学习测试方案的设计；

+ 学习测试程序的设计。

== 实验目标与任务

- *目标*：熟悉RISC-V RV32I的指令特点，了解数据通路的原理，设计并测试数据通路。

- *任务一*：设计实现数据通路（采用RTL实现）：
  - ALU和Regs调用Lab01设计的模块（可直接加RTL）；
  - PC寄存器设计及PC通路建立；
  - ImmGen立即数生成模块设计；
  - 此实验在Lab4-0的基础上完成，替换Lab4-0的数据通路核。

- *任务二*：设计数据通路测试方案并完成测试：
  - 通路测试：I-格式通路、R-格式通路；
  - 部件测试：ALU、Register Files。

== 实验实现方法与步骤

+ #[
    完成立即数生成模块 Imm Gen 的剩余实现：。

    #codex(read("./cpu/user/src/ImmGen.v"), lang: "verilog")

    这里的实现主要是根据 RISC-V 的指令格式来得到的，如下图：

    #align(center, figure(image("images/2024-11-21-15-21-02.png", width: 90%), caption: "RISC-V Instruction Formats"))

    如 `addi` 指令，其立即数部分的 `imm[11:0]` 对应了指令的 `inst[31:25]`，对于高位只需要通过符号拓展得到即可。
  ]

+ #[
    设计 REG32 模块实现 32 位寄存器，这将用于 PC 寄存器的硬件实现中：

    #codex(read("./cpu/user/src/REG32.v"), lang: "verilog")
  ]

+ #[
    参考原理图@datapath_diagram（见附录）完成数据通路顶层设计：

    #codex(read("./cpu/user/src/DataPath.v"), lang: "verilog")
  ]

+ #[
    利用后面在 Lab04-2 中实现的 SCPU 仿真模块进行程序的仿真测试。

    其中选用的测试程序为 Lab04-1 课件 P74 给出的 Demo 程序，内容如下：

    #codex(read("./cpu/user/data/test_add.s"), lang: "asm")

    *注意*：这里的注释部分仅是课件中给出的结果，其从 `x17=000006D3` 开始的输出均有问题。
  ]

+ #[
    为了方便地将 RV32 汇编代码转化为机器码，这里在 claude-3.5-sonnet 的帮助下编写了一个简单的 Python 脚本 `assembly.py`，详见@assembly_script。
  ]

+ #[
    在 Vivado 中进行仿真测试，可以得到仿真结果为：

    #grid(
      columns: (1fr, 1fr),
      align(center, image("images/2024-11-21-16-21-44.png", height: 16em)),
      align(center, image("images/2024-11-21-16-24-47.png", height: 16em)),
    )

    说明实验结果正确。
  ]

+ #[
    替换 Lab02 的对应 SCPU 部分，并运行 Demo 程序，进行物理验证。

    TODO：来张照片
  ]

// *注：测试过程与结果详见Lab04-2的实验报告。*

#pagebreak(weak: true)

= Lab04-2：CPU设计之控制器

== 实验目的

+ 运用寄存器传输控制技术；

+ 掌握CPU的核心：指令执行过程与控制流关系；

+ 设计控制器；

+ 学习测试方案的设计；

+ 学习测试程序的设计。

== 实验目标与任务

- *目标*：熟悉RISC-V RV32I的指令特点，了解控制器的原理，设计并测试控制器。

- *任务一*：用硬件描述语言设计实现控制器：
  - 根据Lab04-1数据通路及指令编码完成控制信号真值表；
  - 此实验在Lab04-1的基础上完成，替换Lab04-1的控制器核。

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
    为 `SCPU_ctrl` 模块编写专门的仿真代码 `SCPU_ctrl_tb.v`：

    #codex(read("./cpu/user/sim/SCPU_ctrl_tb.v"), lang: "verilog")
  ]

+ #[
    替换 Lab02 的对应部分并进行测试。

    实际上，这里我们只需要使用 `create_project.tcl` 脚本重新构建项目即可。
  ]

+ #[
    对控制器模块的单独的仿真测试，通过在 Scope 窗口中添加观察信号，可以得到控制器输出的控制信号：

    #align(center, image("images/2024-11-20-20-14-23.png", width: 100%))

    经过对比可以验证，这些控制信号均输出正确。
  ]

// + #[
//     利用给定的 Testbench 代码进行功能仿真：

//     // #codex(read("./cpu/user/sim/SCPU_ctrl_tb.v"), lang: "verilog")

//     注意：可以在 Scope 窗口中添加观察信号。
//   ]

+ #[
    上板进行物理验证，测试 Demo 程序能否成功运行。

    TODO：来张图片
  ]

+ #[
    用表格的形式记录 Demo 程序的 VGA 输出：
  ]

#pagebreak(weak: true)


= 附录

#set heading(numbering: (..args) => {
  let nums = args.pos()
  if nums.len() == 1 {
    return none
  } else if nums.len() == 2 {
    return numbering("附录 (1) ", ..nums.slice(1))
  }
})

#figure(
  align(center, image("images/2024-11-20-15-56-00.png", width: 100%)),
  caption: "Datapath 原理图",
) <datapath_diagram>

== RV32 汇编脚本 <assembly_script>

#codex(read("./cpu/assembly.py"), lang: "python")