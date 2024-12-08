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

    另外，我还在 `global.sv` 中实现了调试功能，调用时会将包含 `PC`、`inst` 的调试信息同时打印到文件和控制台中，这将大大提高我们调试的效率。

    #codex(read("./pcpu/user/src/global.sv"), lang: "systemverilog")
  ]

+ #[
    参考原理图完成 `Pipeline_CPU` 模块构建。

    为了方便实现上文所述的调试功能，我将在会将 `Debug_t` 随各阶段的控制信号一同传递，保证调试输出时可以得到这一阶段对应指令的 `PC` 和 `inst` 内容。

    另外，`MemRW_EX` 信号因为没有实际作用，我删除了实验文档中原定义的相应接口，而是转为封装到 `vga_singals` 中导出。

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

流水线 CPU 各功能正常工作，具体测试结果见 Lab05-3 的实验结果与分析部分。

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
    实现 `Pipeline_IF` 模块：由程序计数器获取PC值及PC值的更新，由PC值获取指令。

    我的理解是，我们的 Inst Fetch 的工作是直接通过读 ROM 实现的，而相关的接线部分在顶层模块 `CSSTE_Pipe` 中处理，所以这里只需要把 PC 的信号接出去即可。

    #codex(read("./pcpu/user/src/pipeline/Pipeline_IF.sv"), lang: "systemverilog")
  ]

+ #[
    实现 `IF_reg_ID` 模块，将控制信号分割并传递到下一阶段。

    #codex(read("./pcpu/user/src/pipeline/IF_reg_ID.sv"), lang: "systemverilog")
  ]

+ #[
    在 Lab04 的相应模块的基础上实现 `Regs` 模块。一方面，我们以 SystemVerilog 的 struct 类型替代了之前基于 Verilog Define 的导出；另一方面，我们按照流水线处理器的设计要求，只在时钟下降沿更新 `Regs` 的输出，且这一输出需要考虑到在同一阶段写入的数据。

    #codex(read("./pcpu/user/src/Regs.sv"), lang: "systemverilog")
  ]

+ #[
    实现 `Pipeline_ID` 模块：这一阶段主要将从指令存储器取指的指令进行翻译。译码之后将产生各种控制信号，同时寄存器堆根据所需操作数寄存器的索引读出操作数，立即数生成单元输出所需立即数。

    因为我用的是 Lab04 中 `SCPU_more` 的实现 `ImmSel` 和 `ALU_control` 我都多拓展了一位，这对于实现没有大的影响，同时也方便接入到 VGA 中进行输出。

    #codex(read("./pcpu/user/src/pipeline/Pipeline_ID.sv"), lang: "systemverilog")
  ]

+ #[
    实现 `ID_reg_Ex`，将控制信号分割并传递到下一阶段。

    #codex(read("./pcpu/user/src/pipeline/ID_reg_Ex.sv"), lang: "systemverilog")
  ]

== 实验结果与分析

流水线 CPU 各功能正常工作，具体测试结果见 Lab05-3 的实验结果与分析部分。

#pagebreak(weak: true)

= Lab05-3 流水线处理器—EX、MEM、WB设计与集成

== 实验目的

+ 理解流水线CPU的基本原理和组织结构；

+ 掌握五级流水线的工作过程和设计方法；

+ 理解流水线执行、存储器访问、写回的原理；

+ 设计流水线测试程序。

== 实验目标及任务

- *目标*：熟悉RISC-V 五级流水线的工作特点，了解执行、存储器访问、写回的原理，掌握IP核的使用方法，集成并测试CPU。

- *任务一*：设计执行（Ex）、存储器访问（Mem）、写回（WB）模块，替换lab04的流水线CPU并完成集成。
  - 设计执行模块，替换OExp05-2的执行模块并完成集成；
  - 设计访存模块，替换OExp05-2的访存模块并完成集成；
  - 设计写回模块，替换OExp05-2的写回模块并完成集成。

- *任务二*：设计流水线测试方案并完成测试。

== 实验实现方法与步骤

+ #[
    实现 `Pipeline_EX` 模块：对获取的操作数进行指令所指定的算数或逻辑运算。

    这里课件中的模块名是 `Pipeline_Ex`，有一点大小写的问题，我在自己实现时进行了修正。

    #codex(read("./pcpu/user/src/pipeline/Pipeline_EX.sv"), lang: "systemverilog")
  ]

+ #[
    实现 `EX_reg_Mem` 模块，将控制信号分割并传递到下一阶段。

    #codex(read("./pcpu/user/src/pipeline/EX_reg_Mem.sv"), lang: "systemverilog")
  ]

+ #[
    实现 `Pipeline_Mem` 模块：处理可能的存储器访问指令将数据从存储器读出，或者写入存储器。

    但是类似于 `Pipeline_IF`，相关连线主要在顶层模块 `CSSTE_Pipe` 中处理，所以这里要实现的功能其实只有对 `PC` 的选择。

    #codex(read("./pcpu/user/src/pipeline/Pipeline_Mem.sv"), lang: "systemverilog")
  ]

+ #[
    实现 `Mem_reg_WB` 模块，将控制信号分割并传递到下一阶段。

    #codex(read("./pcpu/user/src/pipeline/Mem_reg_WB.sv"), lang: "systemverilog")
  ]

+ #[
    实现 `Pipeline_WB` 模块：将指令执行的结果写回寄存器堆。如果是普通运算指令，该结果值来源于“执行”阶段计算的结果；如果是 load 指令，该结果来源于“访存”阶段从存储器读取出来的数据；如果是跳转指令，该结果来源于 `PC + 4`。

    #codex(read("./pcpu/user/src/pipeline/Pipeline_WB.sv"), lang: "systemverilog")
  ]

+ #[
    搭建 SOC 仿真平台，准备进行仿真测试：

    #codex(read("./pcpu/user/src/socTest_Pipe.sv"), lang: "systemverilog")
  ]

+ #[
    运行：

    ```bash
    vivado -mode tcl -source create_project.tcl
    ```

    创建 Vivado 项目，并进行仿真测试。
  ]

== 实验结果与分析

=== 程序 P 的仿真验证

如下图所示，程序 P 的仿真结果与预期一致。

#align(center, image("images/2024-12-08-22-55-29.png", width: 120%))

#pagebreak(weak: true)

= Lab05-4 流水线处理器—冒险与stall

== 实验目的

+ 理解流水线CPU的基本原理和组织结构；

+ 掌握五级流水线的工作过程和设计方法；

+ 理解流水线CPU停机的原理与解决办法；

+ 设计流水线测试程序。

== 实验目标及任务

- *目标*：熟悉 RISC-V 五级流水线的工作特点，了解流水线冒险的产生原因及解决办法，掌握 IP 核的使用方法，集成并测试 CPU。

- *任务一*：集成设计利用 stall 解决冒险的流水线 CPU，在 Lab05-3 的基础上完成：
  - 设计冒险检测及 stall 消除冒险的流水线 CPU；
  - 替换 Lab05-3 的 CPU 为本实验集成的带 stall 处理的流水线 CPU；

- *任务二*：设计流水线测试方案并完成测试。

== 实验实现方法与步骤

+ #[

  ]

== 实验结果与分析
