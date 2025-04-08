#import "../template-note.typ": *

#show: project.with(
  course: "Computer Architecture",
  course_fullname: "Computer Architecture",
  course_code: "CS2051M",
  title: link(
    "https://mem.ac",
    "Labs",
  ),
  authors: (
    (
      name: "memset0",
      email: "memset0@outlook.com",
      link: "https://mem.ac/",
    ),
  ),
  semester: "Spring-Summer 2025",
  date: "March 31, 2025",
)

#slide-width.update(x => 940)
#slide-height.update(x => 530)

#outline(title: [TOC], indent: 2em)
// #let slide2x = (..) => par[]

= Lab2: Pipelined CPU Supporting Exception & Interrupt

#slide2x([3], image("../public/merged-lab-2/0003.jpg"), image("../public/translated-lab-2/0003.jpg"), ct: 0.08, cb: 0.15)

== RISC-V Privilege Levels | RISC-V 特权级别

#slide2x([5], image("../public/merged-lab-2/0005.jpg"), image("../public/translated-lab-2/0005.jpg"), ct: 0.18, cb: 0.02)

由于 #underline[程序运行的安全性不可充分信任]，为了确保系统的安全性，需要定义一些特权等级，每个特权模式对资源有不同的操作权限。RISC-V 架构中一共定义了 4 种特权模式，M, H, S, U；其中，M 是最高的特权模式, 它拥有对机器底层的一切访问。

#slide2x([6], image("../public/merged-lab-2/0006.jpg"), image("../public/translated-lab-2/0006.jpg"), ct: 0.25, cb: 0.23)

造成特权模式切换的一个重要原因是发生Trap。在用户下运行应用程序，直到发生某些trap（例如一个管理员调用或者一个定时器中断）强制切换到一个trap handler，这个trap handler通常运行在更高特权的模式下。然后这个线程将执行这个trap handler，执行完了之后，在引起trap的指令处或者之后的指令，继续线程执行。trap也不一定会发生特权模式切换，提升特权级别的trap称为垂直自陷（vertical trap），而保持在同样特权级别的trap称为horizontal trap。RISC-V特权体系结构提供了将trap灵活地路由到不同的特权层。

Trap包含两方面内容，一个是中断，一个是异常。
异常是在处理器顺序执行程序指令流的过程中突然遇到了异常的事情而中止执行当前的程序，转而去处理异常。
中断是在处理器顺序执行程序指令流的过程中突然被别的请求打断而中止执行当前的程序，转而去处理别的事情。
中断与异常的区别在于来源：中断往往是外因引起的，比如键盘，时钟，外设造成的中断，异常是由内因引起的，比如page fault, 非法指令，地址越界。

广义的异常包括中断，后面可能会用异常指代中断和异常

#slide2x([7], image("../public/merged-lab-2/0007.jpg"), image("../public/translated-lab-2/0007.jpg"), ct: 0.08, cb: 0.01)

中断异常的处理流程总体上可以概括为：
1. 保存中断异常信息
2. 跳转到中断异常处理程序
3. 处理完之后再跳转回原程序

但是其中有一个区别是，对于异常，跳回原程序会重新执行发生异常的指令，但是对于中断，是执行中断发生时那条指令的下一条指令。

异常是内因引起的，比如一条指令执行时遇到了page fault, 这条指令是不会完成的，进入异常处理完了page fault之后，再给这条指令第二次机会执行，因此是回到触发异常的那条指令
而中断是外因引起的，在进入中断处理程序时，我们会保证当前指令执行完成，因此中断处理完了之后，恢复下一条指令的执行就可以了


== Control Status Registers (CSR) | 控制状态寄存器

#slide2x([9], image("../public/merged-lab-2/0009.jpg"), image("../public/translated-lab-2/0009.jpg"), ct: 0.08)

CSR控制与状态寄存器是支撑 RISC-V 特权架构的一个重要概念。
CSR 是 CPU 中的一系列特殊的专用寄存器，这些寄存器能够反映和控制 CPU 当前的状态和执行机制。
我们实验中处理中断异常时需要读写CSR寄存器，获取和控制CPU状态

因为我们之前只用到了通用寄存器GPR, 现在对比来看CSR和GPR 
CSR和GPR就是不同用途的寄存器，如果我们还要支持浮点运算的话，还会用到FPR

我们实现的GRP是5位地址空间，一共是32个寄存器
而CSR 的地址空间有 12 位，因此理论上能够支持最多 4,096 个 CSR。但实际上，这个地址空间大部分是空的，访问不存在的 CSR 将触发无效指令异常。
在这12位CSR地址中，最高两位表明了读写权限，接下来两位表明哪个特权模式可以使用该CSR

#slide2x([10], image("../public/merged-lab-2/0010.jpg"), image("../public/translated-lab-2/0010.jpg"), ct: 0.08, cb: 0.29)

这里列出了一部分CSR，我们会介绍一些和实验相关的csr
这里给出了csr的地址，名称和一些简要描述，我们实验中不会全部用到，如果大家想要了解全貌，可以去读riscv privilege architecture
在我们这个实验里面只有机器模式，所以关心的都是机器模式下的csr, 所以看到都是m 也就是machine开头的
如果是关心supervisor模式下的csr的话，还有sstatus, sie等寄存器

#slide2x([11], image("../public/merged-lab-2/0011.jpg"), image("../public/translated-lab-2/0011.jpg"), ct: 0.08, cb: 0.20)

首先是mstatus寄存器
Mstatus记录了当前处理器的状态。可以看到这个寄存器有很多field
我们只关心其中几个field, 比如MIE, MPIE, MPP
xIE是某个特权模式下的中断使能
MIE是机器模式中断使能，MIE位1时机器模式中断打开，为0时中断关闭

xPIE保存了trap发生之前的中断使能位
xPP保存了trap发生之前的特权等级

#slide2x([12], image("../public/merged-lab-2/0012.jpg"), image("../public/translated-lab-2/0012.jpg"), ct: 0.08)

我们的处理器只有机器模式，在进入异常和退出异常的时候，mstatus寄存器会做这些操作
进入异常的时候，MPP会存储异常发生前的特权模式，不过我们在实验中可以忽略这一步，因为在实验里不会发生特权模式切换，都是机器模式；然后MPIE会存储异常发生前的机器模式中断使能，然后将MIE置0，也就是说全局中断被关闭，再发生的中断异常不会被响应

退出中断异常的时候，MIE恢复到MPIE的值，MPIE置1，特权模式恢复到MPP

#slide2x([13], image("../public/merged-lab-2/0013.jpg"), image("../public/translated-lab-2/0013.jpg"), ct: 0.08)
RISCV处理器进入中断异常后，要跳入中断异常处理程序。跳入的地址由mtvec这个CSR决定
Mtvec存储了异常入口基地址。
目前 RISC-V 支持两种类型的中断向量，这是根据最后两位mode位来决定的：

直接模式（direct），所有类型的中断异常均发送给同一个中断响应程序。也就是将PC赋值为base, 
在向量化模式下，中断 将根据 Cause 发送给不同的中断响应程序，但所有的 异常 仍然发送给 同一个异常响应程序
实验中采用的直接模式

#slide2x([14], image("../public/merged-lab-2/0014.jpg"), image("../public/translated-lab-2/0014.jpg"))

Mcause寄存器存储了异常发生的原因。在当 trap 进入机器模式后，将异常/中断事件产生的起因写入到该寄存器中
Mcause最高位表明这是不是一个中断还是异常
我们实验局关注标识出来的这几个
非法指令
ECALL
L/S 地址超范围

还有一个中断

#slide2x([15], image("../public/merged-lab-2/0015.jpg"), image("../public/translated-lab-2/0015.jpg"), ct: 0.08, cb: 0.12)

Mepc存储了异常程序的返回地址。
中断异常处理完了之后，仍然要回到中断异常发生的位置继续程序的执行
因此需要把返回的地址存下来。
在异常发生时，硬件会自动更新mepc的值到发生异常的指令
中断发生时mepc被更新为遇到中断的指令的下一条指令

异常发生时处理完之后需要重新执行发生异常的指令，返回到PC 而对于中断，对于中断发生之前的指令都已经执行结束，所以NPC

#slide2x([16], image("../public/merged-lab-2/0016.jpg"), image("../public/translated-lab-2/0016.jpg"), ct: 0.08, cb: 0.12)


Mepc存储了异常程序的返回地址。
中断异常处理完了之后，仍然要回到中断异常发生的位置继续程序的执行
因此需要把返回的地址存下来。
在异常发生时，硬件会自动更新mepc的值到发生异常的指令
中断发生时mepc被更新为遇到中断的指令的下一条指令

那为什么中断和异常是不一样的呢，这个原因我们前面已经说过了

其中还有一个问题是ecall这类指令，他们会触发异常，mepc会被设置为当前指令也就是ecall的pc, 如果异常处理完成之后再回到mepc, 也就是ecall指令的话，会无限循环
针对这个问题，其实是通过软件将mepc设置为下一条指令的pc


== CSR Instructions | CSR 指令

#slide2x([17], image("../public/merged-lab-2/0017.jpg"), image("../public/translated-lab-2/0017.jpg"), ct: 0.45, cb: 0.38)

#slide2x([18], image("../public/merged-lab-2/0018.jpg"), image("../public/translated-lab-2/0018.jpg"), ct: 0.08, cb: 0.11)

#slide2x([19], image("../public/merged-lab-2/0019.jpg"), image("../public/translated-lab-2/0019.jpg"), ct: 0.08, cb: 0.12)

#slide2x([20], image("../public/merged-lab-2/0020.jpg"), image("../public/translated-lab-2/0020.jpg"), ct: 0.38, cb: 0.29)

#slide2x([21], image("../public/merged-lab-2/0021.jpg"), image("../public/translated-lab-2/0021.jpg"), ct: 0.08, cb: 0.32)

#slide2x([22], image("../public/merged-lab-2/0022.jpg"), image("../public/translated-lab-2/0022.jpg"), ct: 0.08, cb: 0.01)

#slide2x([23], image("../public/merged-lab-2/0023.jpg"), image("../public/translated-lab-2/0023.jpg"), ct: 0.41, cb: 0.40)

#slide2x([24], image("../public/merged-lab-2/0024.jpg"), image("../public/translated-lab-2/0024.jpg"), ct: 0.08, cb: 0.11)

#slide2x([25], image("../public/merged-lab-2/0025.jpg"), image("../public/translated-lab-2/0025.jpg"), ct: 0.08, cb: 0.11)

#slide2x([26], image("../public/merged-lab-2/0026.jpg"), image("../public/translated-lab-2/0026.jpg"), ct: 0.08, cb: 0.32)

#slide2x([27], image("../public/merged-lab-2/0027.jpg"), image("../public/translated-lab-2/0027.jpg"), ct: 0.35, cb: 0.29)

#slide2x([28], image("../public/merged-lab-2/0028.jpg"), image("../public/translated-lab-2/0028.jpg"), ct: 0.08, cb: 0.30)

#slide2x([29], image("../public/merged-lab-2/0029.jpg"), image("../public/translated-lab-2/0029.jpg"), ct: 0.08, cb: 0.05)

#slide2x([30], image("../public/merged-lab-2/0030.jpg"), image("../public/translated-lab-2/0030.jpg"), ct: 0.08, cb: 0.29)

#slide2x([31], image("../public/merged-lab-2/0031.jpg"), image("../public/translated-lab-2/0031.jpg"), ct: 0.08, cb: 0.06)

#slide2x([32], image("../public/merged-lab-2/0032.jpg"), image("../public/translated-lab-2/0032.jpg"))

#slide2x([33], image("../public/merged-lab-2/0033.jpg"), image("../public/translated-lab-2/0033.jpg"), ct: 0.45, cb: 0.37)

#slide2x([34], image("../public/merged-lab-2/0034.jpg"), image("../public/translated-lab-2/0034.jpg"), ct: 0.08)

#slide2x([35], image("../public/merged-lab-2/0035.jpg"), image("../public/translated-lab-2/0035.jpg"), ct: 0.08)

#slide2x([36], image("../public/merged-lab-2/0036.jpg"), image("../public/translated-lab-2/0036.jpg"), ct: 0.08, cb: 0.14)

#slide2x([37], image("../public/merged-lab-2/0037.jpg"), image("../public/translated-lab-2/0037.jpg"), ct: 0.08, cb: 0.03)

#slide2x([38], image("../public/merged-lab-2/0038.jpg"), image("../public/translated-lab-2/0038.jpg"))

#slide2x([39], image("../public/merged-lab-2/0039.jpg"), image("../public/translated-lab-2/0039.jpg"))

#slide2x([40], image("../public/merged-lab-2/0040.jpg"), image("../public/translated-lab-2/0040.jpg"), ct: 0.08, cb: 0.12)

#slide2x([41], image("../public/merged-lab-2/0041.jpg"), image("../public/translated-lab-2/0041.jpg"), cb: 0.01)

#slide2x([42], image("../public/merged-lab-2/0042.jpg"), image("../public/translated-lab-2/0042.jpg"), ct: 0.08, cb: 0.14)

#slide2x([43], image("../public/merged-lab-2/0043.jpg"), image("../public/translated-lab-2/0043.jpg"), ct: 0.01)

#slide2x([44], image("../public/merged-lab-2/0044.jpg"), image("../public/translated-lab-2/0044.jpg"), ct: 0.01)

#slide2x([45], image("../public/merged-lab-2/0045.jpg"), image("../public/translated-lab-2/0045.jpg"), ct: 0.01)

#slide2x([46], image("../public/merged-lab-2/0046.jpg"), image("../public/translated-lab-2/0046.jpg"))

#slide2x([47], image("../public/merged-lab-2/0047.jpg"), image("../public/translated-lab-2/0047.jpg"), ct: 0.08, cb: 0.14)

#slide2x([48], image("../public/merged-lab-2/0048.jpg"), image("../public/translated-lab-2/0048.jpg"), ct: 0.03, cb: 0.14)

#slide2x([49], image("../public/merged-lab-2/0049.jpg"), image("../public/translated-lab-2/0049.jpg"), ct: 0.08, cb: 0.14)

#slide2x([50], image("../public/merged-lab-2/0050.jpg"), image("../public/translated-lab-2/0050.jpg"), ct: 0.08, cb: 0.12)

#slide2x([51], image("../public/merged-lab-2/0051.jpg"), image("../public/translated-lab-2/0051.jpg"), ct: 0.08, cb: 0.12)

#slide2x([52], image("../public/merged-lab-2/0052.jpg"), image("../public/translated-lab-2/0052.jpg"), ct: 0.08, cb: 0.12)

#slide2x([53], image("../public/merged-lab-2/0053.jpg"), image("../public/translated-lab-2/0053.jpg"), ct: 0.08, cb: 0.12)

#slide2x([54], image("../public/merged-lab-2/0054.jpg"), image("../public/translated-lab-2/0054.jpg"), ct: 0.08, cb: 0.12)

#slide2x([55], image("../public/merged-lab-2/0055.jpg"), image("../public/translated-lab-2/0055.jpg"), ct: 0.08, cb: 0.14)

#slide2x([56], image("../public/merged-lab-2/0056.jpg"), image("../public/translated-lab-2/0056.jpg"), ct: 0.48, cb: 0.32)

#slide2x([57], image("../public/merged-lab-2/0057.jpg"), image("../public/translated-lab-2/0057.jpg"), ct: 0.08, cb: 0.17)

#slide2x([58], image("../public/merged-lab-2/0058.jpg"), image("../public/translated-lab-2/0058.jpg"), ct: 0.50, cb: 0.50)

#slide2x([59], image("../public/merged-lab-2/0059.jpg"), image("../public/translated-lab-2/0059.jpg"), ct: 0.50, cb: 0.50)

#slide2x([60], image("../public/merged-lab-2/0060.jpg"), image("../public/translated-lab-2/0060.jpg"), ct: 0.50, cb: 0.50)

#slide2x([61], image("../public/merged-lab-2/0061.jpg"), image("../public/translated-lab-2/0061.jpg"), ct: 0.50, cb: 0.50)

#slide2x([62], image("../public/merged-lab-2/0062.jpg"), image("../public/translated-lab-2/0062.jpg"), ct: 0.50, cb: 0.50)

#slide2x([63], image("../public/merged-lab-2/0063.jpg"), image("../public/translated-lab-2/0063.jpg"), ct: 0.50, cb: 0.50)

#slide2x([64], image("../public/merged-lab-2/0064.jpg"), image("../public/translated-lab-2/0064.jpg"), ct: 0.50, cb: 0.50)

