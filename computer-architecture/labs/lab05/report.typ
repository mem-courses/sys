#import "../../template.typ": *

#show: project.with(
  theme: "lab",
  title: "计算机体系结构 第五次实验报告",
  course: "计算机体系结构",
  semester: "2024-2025 Spring-Summer",
  author: "吴与伦",
  school_id: "3230104585",
  date: "2025-05-07",
  college: "计算机科学与技术学院",
  major: "计算机科学与技术",
  teacher: "陈文智",
)

#lab_header(name: [Lab5: 多周期流水线], place: "紫金港 东4-511", date: "2025年5月7日")

== 实验目的和要求

- 了解支持多周期操作的流水线的原理。
- 掌握支持多周期操作的流水线的设计方法。
- 掌握支持多周期操作的流水线 CPU 的验证方法。

== 实验内容和原理

=== 实验内容

- 重新设计带有 IF/ID/FU/WB 阶段，以及 FU 阶段支持多周期操作的流水线。
- 重新设计 CPU 控制器。
- 用程序验证流水线 CPU，观察程序的执行。

=== 实验原理

在这个实验中，我们重新把流水线 CPU 分成 4 个阶段：IF、ID、FU 和 WB （某种意义上，相当于把 EX 和 MEM 合成了一个阶段 FU）。在这个实验中，有 5 个 FU，其中 `FU_ALU` 是算术逻辑单元，负责基础的单周期运算；`FU_mem` 是内存操作单元，负责内存的读写，需要两个周期；`FU_mul` 是乘法器，需要多个周期；`FU_div` 是除法器，需要的周期数是最多的；`FU_jump` 是指令跳转单元，负责单周期计算跳转和写回的 PC。以下是该流水线 CPU 的原理图：

#align(center, image("images/2025-05-07-21-08-17.png", width: 100%))

鉴于该流水线 CPU 未实现 forwarding 机制，为避免数据冒险，必须确保在前一条指令完成 WB 阶段写回操作之前，后续指令不能结束其 ID 阶段。对于多周期 FU 操作，在其完成并进入 WB 阶段前，紧随其后的指令必须暂停在 ID 阶段，而再下一条指令则需暂停在 IF 阶段，以防止冲突。时序关系示意图如下：

#align(center, image("images/2025-05-07-21-09-25.png", width: 80%))

本实验采用 predict-not-taken 策略。即在遇到分支指令时，流水线按顺序继续执行后续指令。若分支实际上发生了跳转，则 flush 掉流水线中已错误取指和译码的指令，并从跳转目标地址重新取指。在此设计中，若分支发生跳转，需要废除紧随分支指令后的两条已进入流水线的指令。其处理流程示意图如下：

#align(center, image("images/2025-05-07-21-09-54.png", width: 80%))

== 实验过程和数据记录

=== 功能单元（FU）设计

各功能单元的设计遵循统一模式：操作开始时，将输入数据锁存入内部寄存器；操作执行期间，使用寄存器中的数据进行运算；操作结束时，产生相应的完成信号。

对于 ALU：首先，将操作数 A、B 及控制信号锁存；其次，执行 ALU 运算；最后，发出完成信号。由于前两个步骤可在同一时钟周期内完成，因此 ALU 的 FU 阶段仅需一个周期，加上 WB 阶段，共经历两个状态。

#codex(read("./code/FU_ALU.v"), lang: "verilog")

对于 mem：首先，锁存写使能信号、数据类型、源寄存器数据及立即数；其次，由 R[rs1] 与立即数计算目标地址，并将相关信号送入内存模块以获取或写入数据；最后，发出完成信号。内存操作的 FU 阶段需要两个周期，加上 WB 阶段，共经历三个状态。

#codex(read("./code/FU_mem.v"), lang: "verilog")

对于 mul：首先，锁存两个操作数；其次，将锁存数据送入乘法模块进行运算；最后，发出完成信号。本设计中乘法器 FU 阶段设置为 7 个周期，加上 WB 阶段，共经历 8 个状态。

#codex(read("./code/FU_mul.v"), lang: "verilog")

对于 div：首先，锁存两个操作数；其次，将锁存数据送入除法模块进行运算；最后，发出完成信号。值得注意的是，该除法器的执行周期数可变，其内部会在运算完成时产生结果有效信号。FU_div 在检测到结果有效的首个周期即发出完成信号。

#codex(read("./code/FU_div.v"), lang: "verilog")

对于 jump：首先，锁存 JALR 信号、分支类型、源寄存器数据、立即数及当前 PC 值；其次，计算 PC + 4 作为顺序执行时的下一条指令地址（用于 JAL/JALR 的链接地址），并根据指令类型计算跳转目标 PC (通过 R[rs1] 或 PC 与立即数相加)，同时根据源寄存器数据和分支类型判断分支是否发生；最后，发出完成信号。前两个步骤合并为一个 FU 周期，加上 WB 周期，共经历两个状态。

#codex(read("./code/FU_jump.v"), lang: "verilog")

=== 多周期流水线 CPU 设计

- 立即数生成：在 ID 阶段，根据指令中的立即数类型字段从指令码中抽取出相应的立即数。
- 操作数选择：在 ID 阶段，根据指令需求，第一个操作数从寄存器 R[rs1] 或 PC 中选择；第二个操作数从寄存器 R[rs2] 或立即数中选择。
- 数据写回：在 WB 阶段，通过多路选择器从五个 FU 的输出结果中选择正确的写回数据，选择信号由控制单元根据当前指令动态产生，确保与 FU 的输入数据来源一致。

#codex(read("./code/RV32core.v"), lang: "verilog")

== 实验结果分析

=== 仿真结果

#align(center, image("images/2025-05-07-21-16-31.png", width: 80%))

仿真波形显示，ALU 相关指令的执行经历 FU 和 WB 共两个周期，而内存相关指令则经历三个周期 (两个 FU 周期和一个 WB 周期)，符合设计预期。

#align(center, image("images/2025-05-07-21-16-37.png", width: 80%))

当 `PC_IF` 为 `0x30` 时，`PC_FU` 处 `0x28` 的分支指令 predict-not-taken 而实际上也是 not-taken，所以该指令执行占用两个周期 (FU 和 WB)。当 `PC_IF` 为 `0x34` 时，`PC_FU` 处 `0x2c` 的分支指令实际发生跳转。流水线 flush 掉后续已错误加载的指令，并在下一周期从目标地址 `0x40` 重新取出。当 `PC_IF` 为 `0x4c` 时，`PC_FU` 处 `0x44` 的跳转指令执行无条件跳转。流水线同样需要 flush，并在下一周期跳转至目标地址 `0x58`。

#align(center, image("images/2025-05-07-21-16-48.png", width: 80%))

如图所示，示例中的除法操作耗时 46 个 FU 周期，乘法操作耗时 7 个 FU 周期（$8-1=7$），与设计一致。

#align(center, image("images/2025-05-07-21-16-54.png", width: 80%))

当 `PC_IF` 为 `0x74` 时，`PC_FU` 处 `0x6c` 的指令再次执行无条件跳转，发出 `flush` 信号后，下一周期从目标地址 `0x00` 开始执行。

综上所述，仿真结果与预期结果一致，验证了我们实现的正确性。

=== 上板测试结果

#align(center, image("images/2025-05-07-21-17-13.png", width: 80%))

可以看到，运行结束后，寄存器的最终状态与预期结果完全一致。

#align(center, image("images/2025-05-07-21-19-43.png", width: 80%))

当执行至地址 `0x34` 的分支指令时，程序计数器 (PC) 成功跳转至 `0x40`，与仿真结果吻合。

#align(center, image("images/2025-05-07-21-19-59.png", width: 80%))

如图所示，除法指令执行了多个周期。

综上所述，上板测试结果与预期结果一致，验证了我们实现的正确性。

== 讨论与心得

通过本次实验，我体验到了《计算机体系结构》课程相对于《计算机组成》课程中的一个重大难点——多周期流水线的设计。因为 EX/MEM 阶段（FU 阶段）变为了多周期，我们需要处理的问题相应的多了好多。通过这次实验，我对多周期流水线处理器的理解也变得更加深刻了。
