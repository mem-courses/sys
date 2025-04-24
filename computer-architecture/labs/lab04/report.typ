#import "../../template.typ": *

#show: project.with(
  theme: "lab",
  title: "计算机体系结构 第四次实验报告",
  course: "计算机体系结构",
  semester: "2024-2025 Spring-Summer",
  author: "吴与伦",
  school_id: "3230104585",
  date: "2025-04-21",
  college: "计算机科学与技术学院",
  major: "计算机科学与技术",
  teacher: "陈文智",
)

#lab_header(name: [Lab4: CMU], place: "紫金港 东4-511", date: "2025年4月21日")

== 实验目的和要求

- 理解缓存管理单元（CMU）和CMU状态机的原理
- 掌握CMU的设计方法并将其集成到CPU中。
- 掌握CMU的验证方法并比较有缓存和无缓存时CPU的性能。

== 实验内容和原理

=== 实验内容

- 缓存管理单元的设计并将其集成到CPU中。
- 观察并分析仿真的波形。
- 比较CPU有缓存和没有缓存时的性能。

=== 实验原理

cache management unit (CMU)，或称 cache controller 是联系 cache 与 CPU 的桥梁。它从 CPU 接收读写请求，然后访问 cache，根据 hit / miss 情况读写 cache 或内存。如果cache hit了，controller就会把数据返回给 CPU；如果cache miss了，controller就需要请求下一级内存，将数据取回到 cache 中再返还给 CPU（取决于具体策略，本实验中是需要取回的），并输出 stall 信号暂停 CPU 流水工作，直到数据被成功取出。

== 实验过程和数据记录

=== 状态机

#align(center, image("images/2025-04-23-23-47-19.png", width: 80%))

下图是本次实验的状态机，由于我们在 Lab 2 中已经学习了状态机的设计方法，这里就不再赘述。

=== 时序逻辑设计

完整过程刚好在验收的时候讲过一遍了，这里简要复述一下。IDLE 阶段是 controller 的空闲状态，没有 cache 请求或者 cache hit 的时候都处于这个状态，说明 controller 不需要工作。

而当 cache miss 的时候我们分成两种情况讨论。

- 如果 valid 并且 dirty，说明我们需要将这个块写回到下一级内存中，这就要求我们首先把块给写到内存，这需要 17 个始终周期，然后自动进入到 `S_FILL` 状态。
- 否则，说明不需要写回，只需要从内存中取出，这就直接进入 `S_FILL` 状态然后花费 17 个周期取出就可以了，之后在回到 `S_IDLE` 状态并结束 stall 信号以告诉 CPU 可以正常工作了。

=== 完整代码

cache 的代码已经在 Lab 3 报告中体现，这里仅给出 CMU 的代码。

#codex(read("./src/code/cache/cmu.v"), lang: "verilog")

== 实验结果分析

=== 仿真结果

#align(center, image("images/2025-04-23-23-52-27.png", width: 60%))

正如实验文档中的这个结果，我们可以在仿真中看到每次操作需要的始终周期。发生 miss 的时候需要 17 个始终周期来从内存中读出，如果 valid 且 dirty 就再需要 17 个周期来写回内存。

#align(center, image("images/2025-04-23-23-53-30.png", width: 100%))

#align(center, image("images/2025-04-23-23-53-35.png", width: 100%))

#align(center, image("images/2025-04-23-23-53-39.png", width: 100%))

#align(center, image("images/2025-04-23-23-53-44.png", width: 100%))

#align(center, image("images/2025-04-23-23-53-48.png", width: 100%))

#align(center, image("images/2025-04-23-23-53-53.png", width: 100%))

#align(center, image("images/2025-04-23-23-53-58.png", width: 100%))

=== 上板测试结果

`CMU_RAM` 这个信号分别记录了 CMU 和 RAM 内部的状态（就是状态机的这个状态），下面的照片演示了一次 cache 操作中 `CMU_RAM` 这个信号的变化。其他的上板流程就没什么可说的了，与前两个实验类似。

#align(center, image("images/2025-04-23-23-54-59.png", width: 60%))

#align(center, image("images/2025-04-23-23-55-03.png", width: 60%))

#align(center, image("images/2025-04-23-23-55-06.png", width: 60%))

#align(center, image("images/2025-04-23-23-55-09.png", width: 60%))

#align(center, image("images/2025-04-23-23-55-11.png", width: 60%))

== 讨论与心得

和上一次的实验一样，本次实验还是较为简单的，以及因为在《计算机组成》课程中已经实现过 cache，因此完成本实验新学到的东西也并不是很多。验收通过之后倒是刚好和同学讨论了一下为什么 `S_PRE_BACK` 要放在前面 `S_WAIT` 要放在后面的问题。其实就是分需不需要等 RAM 读/写出结果。经过这么一个讨论，对本实验的理解也更为深刻了。