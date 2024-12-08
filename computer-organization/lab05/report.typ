#import "../template.typ": *

#show: project.with(
  theme: "lab",
  title: "Computer Organization Lab 04",
  course: "计算机组成",
  name: "实验五：流水线 CPU 设计",
  author: "吴与伦",
  school_id: "3230104585",
  major: "计算机科学与技术",
  place: "东四 509",
  teacher: "赵莎",
  date: "2024/12/08",
)

#show ref: it => {
  let eq = math.equation
  let el = it.element
  if el != none and el.func() == eq {
    // Override equation references.
    link(
      el.location(),
      numbering(
        el.numbering,
        ..counter(eq).at(el.location()),
      ),
    )
  } else {
    set text(fill: blue)
    if (el.supplement.text == "Section") {
      it + " " + el.body
    } else {
      it
    }
  }
}

#show heading.where(level: 2): it => block(
  width: 100%,
  {
    v(0.85em)
    it
    v(0.15em)
  },
)

= Lab05-1：流水线处理器集成

== 实验目的

+ 理解流水线CPU的基本原理和组织结构；

+ 掌握五级流水线的工作过程和设计方法；

+ 理解流水线CPU停机的原理；

+ 设计流水线测试程序。

== 实验目标与任务

- *目标*：熟悉RISC-V 五级流水线的工作特点，了解流水线处理器的原理，掌握IP核的使用方法，集成并测试CPU。

- *任务一*：集成设计流水线CPU，在Lab04的基础上完成：
  - 利用五级流水线各级封装模块集成CPU；
  - 替换 Lab04 的单周期CPU为本实验集成的五级流水线CPU。

- *任务二*：设计流水线测试方案并完成测试。

== 实验实现方法与步骤

+ #[
    在 `create_project.tcl` 中填入以下代码用于创建 Vivado 项目：

    #codex(read("./pcpu/create_project.tcl"), lang: "tcl")
  ]

+ #[
    为了方便接出寄存器内容和中间各阶段信号，使用 systemverilog 语言的 struct 功能对寄存器内容和各阶段信号进行封装，放在 `global.sv` 的 `pcpu` 包中，其余文件只需要通过 `import pcpu::*` 导入即可。

    #codex(read("./pcpu/user/src/global.sv"), lang: "systemverilog")
  ]

+ #[
    参考原理图完成 `Pipeline_CPU` 模块构建。

    #codex(read("./pcpu/user/src/CSSTE_Pipe.sv"), lang: "systemverilog")
  ]

+ #[
    参考原理图完成 `CSSTE_Pipe` 顶层模块的构建。

    #codex(read("./pcpu/user/src/CSSTE_Pipe.sv"), lang: "systemverilog")
  ]

+ #[
    其余流水线相关模块使用下发的 edf 文件进行构建。
  ]

+ #[
    将 ROM 软核的初始内容替换为下发的 `p_mem.coe` 文件并进行调试：

    #codex(read("./requirements/P.coe"), lang: "text")
  ]

== 实验结果与分析

流水线 CPU 各功能正常工作，具体测试结果见 Lab05-4 的报告部分。

#pagebreak(weak: true)

= Lab05-2 流水线处理器—IF、ID设计与集成

== 实验目的

+ 理解流水线CPU的基本原理和组织结构；

+ 掌握五级流水线的工作过程和设计方法；

+ 理解流水线取指、译码的设计原理；

+ 设计流水线测试程序。

== 实验目标与任务

- *目标*：熟悉RISC-V 五级流水线的工作特点，了解取指、译码的原理，掌握IP核的使用方法，集成并测试CPU

- *任务一*：设计取指（IF）、译码（ID）模块，替换 Lab05-1 的流水线CPU并完成集成。
  - 设计取指模块，替换Lab05-1的取指模块并完成集成；
  - 设计译码模块，替换Lab05-1的译码模块并完成集成。

- *任务二*：设计流水线测试方案并完成测试。

== 实验实现方法与步骤

+ #[
    从 Lab04 中导入可以复用的 `REG32`、`MUX2T1_32`、`ImmGen` 等模块。
  ]

+ #[
    实现 `IF_reg_ID` 模块：这一模块用于寄存IF级的输出指令，分割IF级和ID级的指令或控制信号，防止相互干扰，在IF级执行结束时将指令的控制信号传递至下一级。


    #codex(read("./pcpu/user/src/pipeline/IF_reg_ID.sv"), lang: "systemverilog")
  ]

+ #[
    在 Lab04 的相应模块的基础上实现 `Regs` 模块。一方面，我们以 SystemVerilog 的 struct 类型替代了之前基于 Verilog Define 的导出；另一方面，我们按照流水线处理器的设计要求，只在时钟下降沿更新寄存器堆的输出，且这一输出需要考虑到在同一阶段写入的数据。

    #codex(read("./pcpu/user/src/Regs.sv"), lang: "systemverilog")
  ]

+ #[
    实现 `ID_reg_Ex` 模块：

    #codex(read("./pcpu/user/src/pipeline/ID_reg_Ex.sv"), lang: "systemverilog")
  ]

+ #[
  实现 `Pipeline_IF` 模块：由程序计数器获取PC值及PC值的更新，由PC值获取指令。

    我的理解是，我们的 Inst Fetch 的工作是直接通过读 ROM 实现的，而相关的接线部分在顶层模块 `CSSTE_Pipe` 中处理，所以这里只需要把 PC 的信号接出去即可。

    #codex(read("./pcpu/user/src/pipeline/Pipeline_IF.sv"), lang: "systemverilog")
  ]