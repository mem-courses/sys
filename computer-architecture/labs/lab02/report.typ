#import "../../template.typ": *

#show: project.with(
  theme: "lab",
  title: "计算机体系结构 第二次实验报告",
  course: "计算机体系结构",
  semester: "2024-2025 Spring-Summer",
  author: "吴与伦",
  school_id: "3230104585",
  date: "2025-03-19",
  college: "计算机科学与技术学院",
  major: "计算机科学与技术",
  teacher: "陈文智",
)

#lab_header(name: [Lab2: Pipelined CPU supporting RISC-V RV32I Instructions], place: "紫金港 东4-511", date: "2025年3月11日")

== 实验目的和要求

1，理解CPU异常和中断的原理及其处理步骤。
2，掌握支持异常和中断的流水线CPU的设计方法。
3，掌握支持异常和中断的流水线CPU的程序验证方法。

== 实验内容和原理

#v(-0.5em)

=== 实验内容

- 设计支持异常和中断的流水线CPU（设计数据通路，设计协处理器和控制器）。
- 用程序验证流水线CPU，观察程序的执行。

=== 实验原理

RISC-V 架构中定义了多种特权模式，包括用户/应用模式（U-mode）、监督模式（S-mode）和机器模式（M-mode），其中机器模式拥有最高权限，用户模式权限最低。各模式的编码及权限等级如下图所示：

#align(center, image("images/2025-04-08-23-41-30.png", width: 50%))

#align(center, image("images/2025-04-08-23-41-37.png", width: 80%))

RISC-V中，存在一类CSR指令，它们与异常和中断有关。它们会对特定的CSR寄存器进行读写操作。比如：
- CSRRW：将对应CSR寄存器中的值写出到Reg[rd]，然后写入Reg[rs1]中的值。
- CSRRWI：将对应CSR寄存器中的值写出到Reg[rd]，然后写入zimm中的值。
- CSRRC：将对应CSR寄存器中的值写出到Reg[rd]，然后将Reg[rs1]中对应位的值置为0。
- CSRRCI：将对应CSR寄存器中的值写出到Reg[rd]，然后将zimm中对应位的值置为0。
- CSRRS：将对应CSR寄存器中的值写出到Reg[rd]，然后将Reg[rs1]中对应位的值置为1。
- CSRRSI：将对应CSR寄存器中的值写出到Reg[rd]，然后将zimm中对应位的值置为1。
其具体编码如下图所示：

#align(center, image("images/2025-04-08-23-41-45.png", width: 85%))

CSR寄存器用于存储一些与异常及中断有关的值，比如：
- mstatus：机器状态。
- mtvec：异常或中断发生时需要跳到的trap的PC。
- mepc：从异常或中断恢复时跳转的PC。
- mcause：异常或中断的原因。
- mtval：异常或中断的相关值。
以下是一些CSR寄存器的编码的用途：

#align(center, image("images/2025-04-08-23-41-54.png", width: 80%))

mstatus寄存器中值与机器状态有关，比如MIE为1时代表现在可以中断，MPIE则是记录着过去的MIE，MPP则记录着过去的权限模式。
以下是mstatus的分段：

#align(center, image("images/2025-04-08-23-42-07.png", width: 80%))

除了CSR指令，还有一些指令与异常和中断有关，比如环境调用的ECALL，设置断点的EBREAK，还有返回mepc的MRET，具体如下：

#align(center, image("images/2025-04-08-23-42-17.png", width: 80%))

#align(center, image("images/2025-04-08-23-42-25.png", width: 80%))

可能发生的异常有5种情况，本实验侧重于其中三种：

- *访问错误异常*：当物理内存存在的地址不支持访问类型时发生（例如尝试写入 ROM）。
- *环境调用异常*：在执行 ecall 指令时发生。
- *非法指令异常*：在译码阶段发现无效操作码时发生。

发生异常或中断时，硬件自动经历如下的状态转换：

异常或中断发生时，硬件自动执行以下处理流程：
1. 将当前指令的 PC（异常）或下一条指令的 PC（中断）保存至 `mepc`。
2. 设置 `mcause` 以标识异常或中断的类型，并将相关信息写入 `mtval`。
3. 清除 `mstatus` 中的 `MIE` 位以屏蔽中断，并将其原值保存至 `MPIE`。
4. 将当前特权模式保存至 `MPP`，并切换至机器模式（M-mode）以处理异常。

支持异常和中断的流水线 CPU 的原理图如下所示：

#align(center, image("images/2025-04-08-23-42-47.png", width: 90%))

== 实验过程和数据记录

先定义一个状态机。state为0时为正常状态，当检测的异常或中断时，state先后变成1，2和3，最后再变回0。

然后定义异常状态Exception和中断状态Interrupt。当检测到非法指令异常，访问错误异常（包括读和写）和环境调用异常时，Exception=1。当MIE=1并且中断控制信号为1时，Interrupt=1。

当检测到异常或中断时，我们需要存储恢复后的PC和异常或中断的原因。
异常时，存储当前PC；中断时，存储下一条PC。
异常即中断的原因对应编码如下：

#align(center, image("images/2025-04-08-23-43-29.png", width: 50%))

接下来定义不同state下的具体行为：
- 0：如果异常或中断发生，就更新mstatus的值，把MIE的值挪到MPIE中，然后把MIE设置为0以禁用中断，最后将state设置为1；如果是mret，就将mstatus中MPIE的值挪到MIE中以撤销对中断的禁用，同时将MPIE设置为1，还需要把mepc重定向到PC中；如果是CSR指令，那么根据其具体指令确定操作的CSR寄存器，输入的数据和输入的模式；如果以上都没有发生，那么禁用CSR寄存器。
- 1：把PC重定向到mtvec，然后把恢复后的PC存到mepc中，最后将state设置为2。
- 2：把异常或中断的成因存储到mcause中，设置state为3。
- 3：把异常或中断的信息字存储到mtval中，设置state为0。

然后我们还需要设置一些控制信息：
- RegWrite_cancel：Exception=1时为1，这样避免了当前异常指令对Reg的操作。
- PC_redirect：设置为CSR寄存器的输出即可。
- redirect_mux：只当需要重定向（state=1或mret）时设置为1即可。

最后是对flush信号的设置：
- 当异常或中断发生时，因为当前指令已经到WB了，所以把前面4个reg都给flush了。
- state=1时，此时才开始重定向，放跑了一个周期的指令，依旧需要把前面4个reg都给flush掉。
- mret时，因为是在MEM阶段检测出来的，所以要把前面3个reg都跟flush，唯独放过了reg_MW。


=== 代码（ExceptionUnit.v）

#codex(read("./src/code/core/ExceptionUnit.v"), lang: "verilog")

== 实验结果分析

#v(-0.5em)

=== 仿真结果

#align(center, image("images/2025-04-08-23-44-11.png", width: 80%))

#align(center, image("images/2025-04-08-23-44-14.png", width: 80%))

#align(center, image("images/2025-04-08-23-44-17.png", width: 80%))

#align(center, image("images/2025-04-08-23-44-20.png", width: 80%))

#align(center, image("images/2025-04-08-23-44-23.png", width: 80%))

#align(center, image("images/2025-04-08-23-44-26.png", width: 80%))

实验结果与预期结果基本一致。由于实验结果量太大，我们可以着重分析局部。由于4次异常后CPU的行为模式基本一致，所以我们挑前面的CSR指令和第一处异常来讲。

CSR指令：

#align(center, image("images/2025-04-08-23-44-38.png", width: 80%))

可以看到，csr的使能信号和立即数选择信号都非常正确。至于csr输出一段红X，是因为在PC=20时写入了Reg[x6]的值，即XXXXXXXX。

异常：

#align(center, image("images/2025-04-08-23-44-45.png", width: 80%))

PC=38时的ECALL，在运行到WB时才被检测出异常，与此同时取消RegWrite，同时跑一遍状态机内的异常处理。下一个周期，state=1，进行PC重定向。下下个周期，进入trap，PC=78。而这个周期和下个周期内，需要进行flush，此时发现PC出现对应特征。

#align(center, image("images/2025-04-08-23-44-51.png", width: 80%))

在trap中跑了一些指令，CSR对应控制信号出现对应特征。PC=94的mret是在MEM中被检测到的，于此同时进行重定向和flush，我们发现下个周期PC跑回了3c，并且PC出现明显的flush特征。

=== 上板测试结果

==== 异常

#align(center, image("images/2025-04-09-23-11-29.png", width: 80%))

PC=38处有ECALL。

#align(center, image("images/2025-04-09-23-11-52.png", width: 80%))

跑到WB时，检测到异常。

#align(center, image("images/2025-04-09-23-11-58.png", width: 80%))

下一个周期，出现明显的flush现象。

#align(center, image("images/2025-04-09-23-12-09.png", width: 80%))

再下个周期，跳转trap。

#align(center, image("images/2025-04-09-23-12-21.png", width: 80%))

PC_MEM=94时，检测到MRET。

#align(center, image("images/2025-04-09-23-12-26.png", width: 80%))

跳转回PC=3C。

==== 中断

#align(center, image("images/2025-04-09-23-12-56.png", width: 80%))

此时打开SW[12]，两个周期后，跳转trap。

#align(center, image("images/2025-04-09-23-13-18.png", width: 80%))

trap结束后，跳转回PC=40。

== 讨论与心得

通过这次实验，我熟悉了支持异常和中断的流水线CPU的结构，了解了它是如何实际操作的，以及学会了它的设计方法和程序验证方法，收获颇丰。
值得一提的是，这次实验中，出现了PC跑到后面时，指令变成XXXXXXXX的情况。调试后，发现是读取了错误的rom.hex的问题，于是把读取的相对路径改成了绝对路径（顺带把ram也改了），改完之后，指令便能正确读取了。
