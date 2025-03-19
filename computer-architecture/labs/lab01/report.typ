#import "../../template.typ": *

#show: project.with(
  theme: "lab",
  title: "计算机体系结构 第一次实验报告",
  course: "计算机体系结构",
  semester: "2024-2025 Spring-Summer",
  author: "吴与伦",
  school_id: "3230104585",
  date: "2025-03-19",
  college: "计算机科学与技术学院",
  major: "计算机科学与技术",
  teacher: "陈文智",
)

#lab_header(name: [Lab1: Pipelined CPU supporting RISC-V RV32I Instructions], place: "紫金港 东4-511", date: "2025年3月11日")

#show heading.where(level: 2): it => {
  v(1em)
  it
  v(0.5em)
}
#show heading.where(level: 3): it => {
  it
  v(0.5em)
}

== 实验目的和要求

1. 理解 RV32I 指令。

2. 掌握执行 RV32I 指令的流水线 CPU 的设计方法。

3. 掌握流水线 forwarding 检测和旁路单元设计的方法。

4. 掌握预测不执行（predict not taken）分支设计的 stall 的方法。

5. 掌握执行 RV32I 指令的流水线 CPU 的程序验证方法。

== 实验内容和原理

#v(-0.5em)

=== 实验内容

- 设计执行 RV32I 指令的流水线 CPU：数据通路、旁路单元和 CPU 控制器。

- 用程序验证流水线 CPU，观察程序的执行。

=== 实验原理

#h(2em)流水线中，由于 WB 中的数据写回有时会晚于数据使用，会出现数据冲突，使用需要 forwarding 提前传输数据。forwarding 存在 4 种情况：

- 上条指令的 EXE 结果被这条指令的 EXE 用到。

- 上上条指令的 EXE 结果 (已到 MEM) 被这条指令的 EXE 用到。

- 上上条指令的 MEM 结果被这条指令的 EXE 用到。

- 上条指令的 MEM 结果被这条指令的 MEM 用到。

#h(2em)stall 是解决数据冲突和控制冲突的通解。stall 存在 2 种情况:

- 上条指令的 MEM 结果被这条指令的 EXE 用到，数据使用先于数据更新，需要在中间 stall 一周期，这样就转化为上上条指令的 MEM 结果被这条指令的 EXE 用到。

- ID 检测到跳转发生时，IF 已经在跑下一条指令了。这个时候就需要把 IF 正在跑的那条指令丢弃掉，再下一条就跑跳转后的指令，此时会产生一个一周期的 stall。

#h(2em)采用预测不执行（predict not taken）的分支策略时，有以下 2 种情况:

- 实际不执行时，无事发生。

- 实际执行时，把正在跑的 PC+4 指令给 flush 掉，然后跑正常跳转后的指令。

#align(center, figure(image("images/2025-03-19-21-42-38.png", width: 80%), caption: [流水线 CPU 原理图]))

== 实验过程和数据记录

#v(-0.5em)

=== CtrlUnit.v

#h(2em)`CtrlUnit` 模块的主要功能是解析指令类型，并且生成相应的控制信号，以确保正确的指令执行流程。指令类型的解析基于 `opcode`、`funct3` 和 `funct7` 的组合逻辑进行，实现了本实验中要求的部分 RV32I 指令集。

#h(2em)关于模块中的控制信号：

- `Branch`：标识是否发生跳转。在 B 类型指令执行分支，以及 `JAL`、`JALR` 这类强制跳转指令时，该信号为 1。
- `cmp_ctrl`：指示 B 类型指令的具体分支条件，该信号作为 `cmp_32` 模块的输入，并最终决定是否执行跳转。
- `ALUSrc_A`：当指令为 `AUIPC`、`JAL` 或 `JALR` 时，该信号为 1（表示选择 `PC` 作为 ALU 输入）。否则，该信号为 0（表示选择 `Reg[rs1]`）。
- `ALUSrc_B`：在 `I`、`L`、`S` 类型指令或 `LUI`、`AUIPC`、`JAL`、`JALR` 指令中，该信号为 1（表示选择立即数 `Imm`）。否则，该信号为 0（表示选择 `Reg[rs2]`）。
- `rs1use`：指示寄存器 `R[rs1]` 是否被使用，在 `R`、`I`、`B`、`L`、`S` 类型指令以及 `JALR` 指令中，该信号为 1。
- `rs2use`：指示寄存器 `R[rs2]` 是否被使用，在 `R`、`B` 和 `S` 类型指令中，该信号为 1。

#h(2em)此外，我们把可能发生的冲突分成四种类型，用 `hazard_optype` 表示：

1. 类别 0（无数据更新）：适用于 B 类型指令。
2. 类别 1（EXE 阶段有数据更新）：适用于 `R`、`I` 类型指令，以及 `LUI`、`AUIPC`、`JAL`、`JALR`。
3. 类别 2（MEM 阶段有数据更新）：适用于 `L` 类型指令。
4. 类别 3（MEM 阶段有数据需求）：适用于 `S` 类型指令。

#codex(read("./src/CtrlUnit.v"), lang: "verilog", size: 1em)

=== cmp_32.v

#h(2em)`cmp_32` 模块需要根据 branch 指令的类型和寄存器 `R[rs1]`、`R[rs2]` 的值，判断是否跳转。

#codex(read("./src/cmp_32.v"), lang: "verilog", size: 1em)

=== HazardDetectionUnit.v

#h(2em)`HazardDetectionUnit` 主要用于检测数据冲突，并决定是否进行数据转发（forwarding）或流水线暂停（stall）。

#h(2em)首先，我们需要将 `hazard_optype` 沿着流水线的进行传递，这样就有 `hazard_optype_ID`、`hazard_optype_EXE` 和 `hazard_optype_MEM` 三个信号。

- 数据转发机制：通过 `forward_ctrl_A` / `forward_ctrl_B` 该信号用于判断 `ID` 阶段的寄存器 `R[rs1]`、`R[rs2]` 数据是否需要转发
  - 若前一条指令 (`EXE` 阶段) 需要更新数据 (`hazard_optype_EXE = 1`)，设置 `forward_ctrl` 为 `1`。
  - 若前两条指令 (`MEM` 阶段) 需要更新数据 (`hazard_optype_MEM = 1`)，设置 `forward_ctrl` 为 `2`。
  - 若前两条指令 (`MEM` 阶段) 需要从 `MEM` 读取数据 (`hazard_optype_MEM = 2`)，设置 `forward_ctrl` 为 `3`。
  - 否则，`forward_ctrl` 置为 `0`（直接使用 `Regs` 读数）。
- 流水线暂停极值：
  - 类型一：
    - 当 `EXE` 阶段指令的 `MEM` 结果需要转发到 `ID` 阶段 `R[rs1]` 或 `R[rs2]`，但仍差一个周期，此时需要 `stall` 一周期：
    - `reg_FD` 需要 `stall` 信号，让 `IF` 阶段重新执行当前指令。
    - `reg_DE` 需要 `flush` 信号，清除该指令的影响。
    - 需要暂时禁用时钟，以延迟流水线一个周期。
  - 类型二：
    - 如果 `ID` 阶段的分支指令最终决定跳转，那么 `IF` 阶段已经取到了 `PC+4` 处的指令。
    - 需要对 `reg_FD` 施加 `flush` 信号，以清除该错误指令。

#codex(read("./src/HazardDetectionUnit.v"), lang: "verilog", size: 1em)

=== RV32core.v

#h(2em)核心模块 `RV32core` 负责数据流的选择和算术计算，是本流水线 CPU 设计的核心部分。

- PC 选择 (`mux_IF`)
  - 当 `Branch_ctrl = 0` 时，`PC = PC + 4`。
  - 当 `Branch_ctrl = 1` 时，跳转至新的 `PC`（目标地址）。
- `mux_A_EXE`
  - 当 `ALUSrc_A_EXE = 0`，选择 `R[rs1]` 作为 ALU 输入。
  - 否则，选择 `PC` 作为 ALU 输入。
- `mux_B_EXE`
  - 当 `ALUSrc_B_EXE = 0`，选择 `R[rs2]` 作为 ALU 输入。
  - 否则，选择 `Imm` 作为 ALU 输入。
- `mux_forward_EXE`
  - 当 `forward_ctrl_ls = 0`，选择 `R[rs2]` 作为存储数据。
  - 否则，选择 `MEM` 运算结果作为存储数据。
- forwarding 相关控制
  - `forward_ctrl_A/B = 0`：选择寄存器 `Regs` 数据。
  - `forward_ctrl_A/B = 1`：选择 EXE 阶段 ALU 结果。
  - `forward_ctrl_A/B = 2`：选择 MEM 阶段 ALU 结果。
  - `forward_ctrl_A/B = 3`：选择 MEM 阶段 `MEM` 结果。

#codex(read("./src/RV32core.v"), lang: "verilog", size: 1em)

== 实验结果分析

#note[
  这一部分直接复用了队友的照片和截图。
]

=== 仿真结果

#align(center, image("images/2025-03-19-21-45-51.png", width: 80%))

#align(center, image("images/2025-03-19-21-45-53.png", width: 80%))

#align(center, image("images/2025-03-19-21-45-55.png", width: 80%))

#align(center, image("images/2025-03-19-21-46-12.png", width: 80%))

#align(center, image("images/2025-03-19-21-46-16.png", width: 80%))

#h(2em)容易发现，仿真结果与实验预期结果完全一致。

=== 上板调试

#align(center, image("images/2025-03-19-21-49-05.png", width: 80%))

#h(2em)第一类 stall：

#align(center, image("images/2025-03-19-21-49-08.png", width: 80%))

#h(2em)branch 指令导致的第二类 stall：

#align(center, image("images/2025-03-19-21-49-18.png", width: 80%))

#align(center, image("images/2025-03-19-21-49-20.png", width: 80%))

#h(2em)强制跳转导致的第二类 stall：

#align(center, image("images/2025-03-19-21-50-16.png", width: 80%))

#align(center, image("images/2025-03-19-21-50-13.png", width: 80%))

== 讨论与心得

#h(2em)通过这次实验，我回顾了上学期中学到过的流水线 CPU 架构，并在体系结构的实验平台中实现了流水线的 CPU 的 stall 控制功能，让我对本学期体系结构课程的学期，奠定了一个良好的开端。
