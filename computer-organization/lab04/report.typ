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

    #codex(read("./scpu/create_project.tcl"), lang: "tcl")
  ]

+ #[
    参考原理图完成 SCPU 模块构建。

    #codex(read("./scpu/user/src/SCPU.v"), lang: "verilog")
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

    #codex(read("./scpu/user/src/ImmGen.v"), lang: "verilog")

    这里的实现主要是根据 RISC-V 的指令格式来得到的，如下图：

    #align(center, figure(image("images/2024-11-21-15-21-02.png", width: 90%), caption: "RISC-V Instruction Formats"))

    如 `addi` 指令，其立即数部分的 `imm[11:0]` 对应了指令的 `inst[31:25]`，对于高位只需要通过符号拓展得到即可。
  ]

+ #[
    设计 REG32 模块实现 32 位寄存器，这将用于 PC 寄存器的硬件实现中：

    #codex(read("./scpu/user/src/REG32.v"), lang: "verilog")
  ]

+ #[
    参考原理图 @datapath_diagram 完成数据通路顶层设计：

    #codex(read("./scpu/user/src/DataPath.v"), lang: "verilog")
  ]

+ #[
    利用后面在 Lab04-2 中实现的 SCPU 仿真模块进行程序的仿真测试。

    其中选用的测试程序为 Lab04-1 课件 P74 给出的 Demo 程序，内容如下：

    #codex(read("./scpu/user/data/test_add.s"), lang: "asm")

    *注意*：这里的注释部分仅是课件中给出的结果，其从 `x17=000006D3` 开始的输出均有问题。

    为了方便地将 RV32 汇编代码转化为机器码，这里在 claude-3.5-sonnet 的帮助下编写了一个简单的 Python 脚本 `assembly.py`，详见 @assembly_script 。
  ]

+ #[
    在 Vivado 中进行仿真测试。
  ]

+ #[
    替换 Lab02 的对应 SCPU 部分，并运行 Demo 程序，进行物理验证。
  ]

== 实验结果与分析

=== Demo 程序的仿真结果

#grid(
  columns: (1fr, 1fr),
  align(center, image("images/2024-11-21-16-21-44.png", height: 16em)), align(center, image("images/2024-11-21-16-24-47.png", height: 16em)),
)

说明实验结果正确。

=== Demo 程序的上板结果

通过单步调试，可以发现寄存器中的值逐个被 ALU 的运算结果覆盖（这里通过对 VGA 模块进行修改实现，相关代码见 @vga_module）：

#align(center, image("images/2024-11-23-16-45-59.png", width: 80%))

当整个程序运行完成后，可以发现所有寄存器的值都被覆盖，且构成了 16 进制下的斐波那契序列，可以初步验证 Datapath 的实现正确。

#align(center, image("images/2024-11-23-16-46-28.png", width: 80%))

更详细的测试可以参考 Lab04-2 的测试部分。

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

    #codex(read("./scpu/user/src/SCPU_ctrl.v"), lang: "verilog")
  ]

+ #[
    为 `SCPU_ctrl` 模块编写仿真代码 `SCPU_ctrl_tb.v`（根据 Lab04-2 课件 P35-36 给出的代码）：

    #codex(read("./scpu/user/sim/SCPU_ctrl_tb.v"), lang: "verilog")
  ]

+ #[
    用本实验中编写的控制器模块替换 Lab04-0 的对应部分并进行测试。

    实际上，我们只需要使用 `create_project.tcl` 脚本重新构建项目即可。
  ]

+ #[
    对控制器模块的单独的仿真测试，通过在 Scope 窗口中添加观察信号，可以得到控制器输出的控制信号：

    #align(center, image("images/2024-11-20-20-14-23.png", width: 100%))

    经过对比可以验证，这些控制信号均输出正确。
  ]

// + #[
//     利用给定的 Testbench 代码进行功能仿真：

//     // #codex(read("./scpu/user/sim/SCPU_ctrl_tb.v"), lang: "verilog")

//     注意：可以在 Scope 窗口中添加观察信号。
//   ]

+ #[
    上板进行物理验证，测试 Lab04-1 中的 Demo 程序能否成功运行。

    #align(center, image("images/2024-11-23-16-46-28.png", width: 80%))
  ]

+ #[
    根据课件 P47 的要求编写汇编程序进行对 ALU 指令的测试：

    #codex(read("./scpu/user/data/test_alu.s"), lang: "asm")

    先使用 socTest 模块进行仿真测试，然后上板进行物理验证，并用表格记录实验结果。
  ]

// + #[
//     根据课件 P48 的要求编写汇编程序完成对动态 Load & Store 指令的测试：

//     #codex(read("./scpu/user/data/test_load_store.s"), lang: "asm")

//     先使用 socTest 模块进行仿真测试，然后上板进行物理验证。
//   ]

+ #[
    自行编写更为复杂的程序，对 SCPU 的正确性进行验证。

    #codex(read("./scpu/user/data/demo.s"), lang: "asm")

    先使用 socTest 模块进行仿真测试，然后上板进行物理验证。
  ]

== 实验结果与分析

=== ALU 指令测试

仿真测试的结果为：

#align(center, image("images/2024-11-25-00-57-42.png", width: 75%))

#align(center, image("images/2024-11-25-00-58-01.png", width: 90%))

上板进行物理验证，得到的结果为：

#align(center, image("images/2024-11-25-00-56-16.png", width: 80%))

可以发现，这些结果与我们在 Venus 模拟器中得到的如下结果一致，这可以说明我们在 Lab04-0/1/2 中的 CPU 实现是正确的。

#grid(
  columns: (1fr, 1fr),
  align(center, image("images/2024-11-25-00-48-26.png", height: 24em)), align(center, image("images/2024-11-25-00-48-31.png", height: 24em)),
)

// === 动态 Load & Store 测试
//

=== 复杂程序测试

仿真测试的结果为：

#align(center, image("images/2024-11-25-02-59-56.png", width: 100%))

#align(center, image("images/2024-11-25-03-00-31.png", width: 100%))

上板进行物理验证，得到的结果为：

#align(center, image("images/2024-11-25-02-47-43.png", width: 80%))

可以发现，这些结果与我们在 Venus 模拟器中得到的如下结果一致，这可以说明我们在 Lab04-0/1/2 中的 CPU 实现是正确的。

#grid(
  columns: (1fr, 1fr),
  align(center, image("images/2024-11-25-02-30-48.png", height: 24em)), align(center, image("images/2024-11-25-02-30-56.png", height: 24em)),
)

#pagebreak(weak: true)

= Lab04-2：CPU设计之指令集扩展

== 实验目的

+ 运用寄存器传输控制技术；

+ 掌握CPU的核心：指令执行过程与控制流关系；

+ 设计数据通路和控制器；

+ 设计测试程序。

== 实验目标及任务

- *目标*：熟悉RISC-V RV32I的指令特点，了解控制器和数据通路的原理，扩展实验lab4-2 CPU指令集，设计并测试CPU。

- *任务一*：重新设计数据通路和控制器，在lab4-2的基础上完成：
  - 兼容lab4-1、lab4-2的数据通路和控制器；
  - 替换lab4-1、lab4-2的数据通路控制器核；
  - 扩展不少于下列指令
    - R-Type：sltu, sra, sll；
    - I-Type：addi, andi, ori, xori, slti, sltiu, srli, srai, slli, lw, jalr；
    - S-Type：sw；
    - B-Type：beq, bne；
    - J-Type：jal；
    - U-Type：lui。

- *任务二*：设计指令集测试方案并完成测试。

== 实验实现方法与步骤

+ #[
    为了实现更多运算，同时方便二级译码的过程，我们对 ALU 进行了功能扩充和操作编码的修改，修改后的 ALU 模块 `ALU_more` 模块如下：

    #codex(read("./scpu_ex/user/src/ALU_more.v"), lang: "verilog")
  ]

+ #[
    实现扩展后的控制器模块 `SCPU_ctrl_more`：
    #codex(read("./scpu_ex/user/src/SCPU_ctrl_more.v"), lang: "verilog")
  ]

+ #[
    为了给新增的 `lui` 语句实现立即数生成，我们需要拓展一位 `ImmSel` 并重写 `ImmGen` 模块为 `ImmGen_more`：

    #codex(read("./scpu_ex/user/src/ImmGen_more.v"), lang: "verilog")
  ]

+ #[
    实现扩展后的数据通路模块 `DataPath_more`：
    #codex(read("./scpu_ex/user/src/DataPath_more.v"), lang: "verilog")
  ]

+ #[
    将拓展后的模块装入新的 CPU 模块 `ExtSCPU` 中。
    #codex(read("./scpu_ex/user/src/ExtSCPU.v"), lang: "verilog")
  ]

+ #[
    为了调用拓展后的 SCPU 模块，同时也为了能在 VGA 上显示更多输出信息，我们对 `CSSTE` 顶层模块也进行了修改：

    #codex(read("./scpu_ex/user/src/CSSTE.v"), lang: "verilog")
  ]

+ #[
    导入课件 P36 中给出的 `I_mem.coe` 文件：

    #codex(read("./scpu_ex/user/data/I_mem.coe"), lang: "text")
  ]

+ #[
    上板测试能否正常运行，并用表格的形式记录运行结果。将得到的运行结果与实验文档中给出的表格进行对比，可以验证 ExtSCPU 的正确性。
  ]

== 实验结果与分析

=== Demo 程序测试

仿真测试的结果为（限于篇幅原因只展示了部分，但可以发现结果正确）：

#align(center, image("images/2024-11-25-13-28-20.png", width: 100%))

#align(center, image("images/2024-11-25-13-27-59.png", width: 100%))

上板进行物理验证，可以正常运行，限于篇幅原因在下面用表格的形式呈现数据。可以发现和验收文档中给定的数据一致，由于记录的位置略微不同，`dmem_i_data` 等数据可能存在一个时钟周期的偏差，但是不影响实验结果是正确的。

TODO：表格

// =================================================================

#pagebreak(weak: true)

= 附录

#set heading(numbering: (..args) => {
  let nums = args.pos()
  if nums.len() == 1 {
    return none
  } else if nums.len() == 2 {
    return numbering("附录1:", ..nums.slice(1))
  }
})

== Datapath 原理图 <datapath_diagram>

#align(center, image("images/2024-11-20-15-56-00.png", width: 95%))
#pagebreak(weak: true)

== 修改后的 VGA 模块 <vga_module>

=== VGA.v

#codex(read("../public/VGA/VGA.v"), lang: "verilog")
#pagebreak(weak: true)

=== VgaDebugger.v

#codex(read("../public/VGA/VgaDebugger.v"), lang: "verilog")
#pagebreak(weak: true)

== RV32 汇编脚本 <assembly_script>

#codex(read("./scpu/assembly.py"), lang: "python")
#pagebreak(weak: true)

== CSSTE 仿真 <csste_tb>

#codex(read("./scpu/user/sim/CSSTE_tb.v"), lang: "verilog")
#pagebreak(weak: true)
