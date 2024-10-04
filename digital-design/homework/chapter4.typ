#import "./template.typ": *

#show: project.with(
  course: "Digital Logic Design",
  course_fullname: "Digital Logic Design",
  course_code: "211C0060",
  title: "Chapter 4. Sequential Circuits",
  authors: (
    (
      name: "Yulun WU",
      email: "memset0@outlook.com",
      id: "3230104585",
    ),
  ),
  semester: "Spring-Summer 2024",
  date: "May 26, 2024",
)

#hw("4-7")[
  A sequential circuit has three D flip-flops $A$, $B$, and $C$, and one input $X$. The circuit is described by the following input equations:

  #align(center, image("images/2024-05-26-21-48-17.png", width: 60%))

  #align(center, image("images/2024-05-26-21-49-12.png", width: 40%))

  #parts(
    a: [Derive the state table for the circuit.],
    b: [Draw two state diagrams, one for $X$ = 0 and the other for $X$ = 1.],
  )
][
  #parts(
    a: [
      State table:

      - Present state: $A$, $B$, $C$
      - Input: $X$
      - Next state: $A'$, $B'$, $C'$

      #table3(
        width: 60%,
        columns: 7,
        [$bold(A)$],
        [$bold(B)$],
        [$bold(C)$],
        [$bold(X)$],
        [$bold(A')$],
        [$bold(B')$],
        [$bold(C')$],
        .."0000100".split("").slice(1, -1),
        .."0001000".split("").slice(1, -1),
        .."0010000".split("").slice(1, -1),
        .."0011100".split("").slice(1, -1),
        .."0100001".split("").slice(1, -1),
        .."0101101".split("").slice(1, -1),
        .."0110101".split("").slice(1, -1),
        .."0111001".split("").slice(1, -1),
        .."1000110".split("").slice(1, -1),
        .."1001010".split("").slice(1, -1),
        .."1010010".split("").slice(1, -1),
        .."1011010".split("").slice(1, -1),
        .."1100110".split("").slice(1, -1),
        .."1101011".split("").slice(1, -1),
        .."1110111".split("").slice(1, -1),
        .."1111111".split("").slice(1, -1),
      )
    ],
    b: [
      State diagram:

      \/\/ Typst 画图太麻烦就不画了好吗（求求助教哥哥力），和下一题没有本质区别，只不过边是直接连。
    ],
  )
]

#hw("4-8")[
  A sequential circuit has one flip-flop $Q$, two inputs $X$ and $Y$, and one output $S$. The circuit consists of a D flip-flop with $S$ as its output and logic implementing the function
  $
    D=X plus.circle Y plus.circle S
  $
  with $D$ as the input to the D flip-flop. Derive the state table and state diagram of the sequential circuit.
][

  - State table:

  #table3(
    columns: 5,
    width: 40%,
    $bold(Q)$,
    $bold(X)$,
    $bold(Y)$,
    $bold(Q')$,
    $bold(S)$,
    .."00000".split("").slice(1, -1),
    .."00110".split("").slice(1, -1),
    .."01010".split("").slice(1, -1),
    .."01100".split("").slice(1, -1),
    .."10011".split("").slice(1, -1),
    .."10101".split("").slice(1, -1),
    .."11001".split("").slice(1, -1),
    .."11111".split("").slice(1, -1),
  )

  - State diagram:

  #align(center, image("images/2024-05-26-22-18-54.png", width: 50%))
]

#hw("4-58")[
  A set of waveforms applied to two D flip-flops is shown in Figure 4-56. These waveforms are applied to the flip-flops shown along with the values of their timing parameters.

  #parts(
    a: [List the time(s) at which there are timing violations in signal D1 for flip-flop 2.],
    b: [List the time(s) at which there are timing violations in signal D2 for flip-flop 2.],
  )

  #align(center, image("images/2024-05-26-21-51-17.png", width: 70%))
][
  #parts(
    a: [
      During 27 ns to 28 ns.

      \/\/ 注意 27 ns 时输入为 0，但在 27 ns 到 28 ns 之间跳变为 1。而下一个上升沿在 28 ns 到来，故不满足 $t_s=1.0 "ns"$ 的条件。
    ],
    b: [
      There is an setup timing violation during 24 ns to 25 ns, and there is another hold timing violation during 16 ns to 16.5 ns.
    ],
  )
]

#hw("4-59")[
  A sequential circuit is shown in Figure 4-49. The timing parameters for the gates and flip-flops are as follows:

  #indent-box[
    Inverter: $t_"pd"$ = 0.01 ns

    XOR gate: $t_"pd"$ = 0.04 ns

    Flip-flop: $t_"pd"$ = 0.08 ns, $t_s$ = 0.02 ns, and $t_h$ = 0.01 ns
  ]

  #align(center, image("images/2024-05-26-22-26-24.png", width: 80%))

  #parts(
    a: [Find the longest path delay from an external circuit input passing through gates only to an external circuit output.],
    b: [Find the longest path delay in the circuit from an external input to positive clock edge.],
    c: [Find the longest path delay from positive clock edge to output.],
    d: [Find the longest path delay from positive clock edge to positive clock edge.],
    e: [Determine the maximum frequency of operation of the circuit in megahertz (MHz).],
  )
][
  #parts(
    a: $
      t_"delay" = 2 t_"pd (XOR)" = 0.08 "ns"
    $,
    b: $
      t_"delay" = t_"pd (XOR)" + t_"pd (Inverter)" + t_"s" = 0.07 "ns"
    $,
    c: $
      t_"delay" = t_"pd (XOR)" + t_"pd (Flip-flop)" + t_"pd (XOR)" = 0.16 "ns"
    $,
    d: $
      t_"delay" = t_"pd (Flip-flop)" + t_"pd (XOR)" + t_"pd (Inverter)" + t_s = 0.15 "ns"
    $,
    e: [
      From part (d) we can derived that the frequency is
      $
        1 / (0.15 "ns") = 6667 "MHz"
      $
    ],
  )
]

#hw("4-13")[
  Design a sequential circuit with two D flip-flops $A$ and $B$ and one input $X$. When $X = 0$, the state of the circuit remains the same. When $X = 1$, the circuit goes through the state transitions from 00 to 10 to 11 to 01, back to 00, and then repeats.
][
  $
    D'_A &= D_A X + overline(D_B) overline(X)\
    D'_B &= D_A X + D_B overline(X)\
  $

  #align(center, image("images/2024-05-26-22-42-04.png", width: 70%))
]

#hw("4-21")[
  A Universal Serial Bus (USB) communication link requires a circuit that produces the sequence 01111110. You are to design a synchronous sequential circuit that starts producing this sequence for input $E = 1$. Once the sequence starts, it completes. If $E = 1$, during the last output in the sequence, the sequence repeats. Otherwise, if $E = 0$, the output remains constant at 1.

  #parts(
    a: [Draw the Moore state diagram for the circuit.],
    b: [Find the state table and make a state assignment.],
    c: [Design the circuit using D flip-flops and logic gates. A reset should be included to place the circuit in the appropriate initial state at which $E$ is examined to determine if the sequence of constant 1s is to be produced.],
  )
][
  #parts(
    a: [
      #align(center, image("images/2024-05-26-22-55-32.png", width: 60%))
    ],
    b: [
      State table (not strict):

      #table3(
        columns: (0.8fr, 1fr, 1fr),
        $bold(D_2 D_1 D_0)$,
        $bold(D'_2 D'_1 D'_0)$,
        $bold(O)$,
        $000$,
        $001$,
        $0$,
        $001$,
        $010$,
        $1$,
        $010$,
        $011$,
        $1$,
        $011$,
        $100$,
        $1$,
        $100$,
        $101$,
        $1$,
        $101$,
        $110$,
        $1$,
        $110$,
        $111$,
        $1$,
        $111$,
        [$000$ (iff $E=1$); $111$ (iff $E=0$)],
        [$0$ (iff $E=1$); $1$ (iff $E=0$)],
      )
    ],
    c: [
      \/\/ 好难画啊咕咕咕QAQ
    ],
  )
]

#hw("4-22")[
  The sequence in Problem 4-21 is a lag used in a communication network that represents the beginning of a message. This lag must be unique. As a consequence, at most ive 1s in sequence may appear anywhere else in the message. Since this is unrealistic for normal message content, a trick called zero insertion is used. The normal message, which can contain strings of 1s longer than 5, enters input X of a sequential zero- insertion circuit. The circuit has two outputs, Z and S. When a ifth 1 in sequence appears on X, a 0 is inserted in the stream of outputs appearing on Z and the output S = 1, indicating to the circuit supplying the zero- insertion circuit with inputs that it must stall and not apply a new input for one clock cycle. This is necessary because the insertion of 0s in the output sequence causes it to be longer than the input sequence without the stall. Zero insertion is illustrated by the following example sequences:

  #align(center, image("images/2024-05-26-21-56-16.png", width: 70%))

  #parts(
    a: [Find the state diagram for the circuit.],
    b: [Find the state table for the circuit and make a state assignment.],
    c: [Find an implementation of the circuit using D flip-flops and logic gates.],
  )
][
  #align(center, image("images/2024-05-26-23-03-00.png", width: 40%))
]

#hw("4-25")[
  A pair of signals Request ($R$) and Acknowledge ($A$) is used to coordinate transactions between a CPU and its I/O system. The interaction of these signals is often referred to as a “handshake.” These signals are synchronous with the clock and, for a transaction, are to have their transitions always appear in the order shown in Figure 4-53. A handshake checker is to be designed that will verify the transition order. The checker has inputs, $R$ and $A$, asynchronous reset signal, RESET, and output, Error ($E$). If the transitions in a handshake are in order, $E = 0$. If the transitions are out of order, then $E$ becomes 1 and remains at 1 until the asynchronous reset signal (RESET = 1) is applied to the CPU.

  #align(center, image("images/2024-05-26-21-56-56.png", width: 75%))

  #parts(
    a: [Find the state diagram for the handshake checker.],
    b: [Find the state table for the handshake checker.],
  )
][
  \/\/ 没看懂要求的顺序是什么？？？
]

#hw("4-29")[
  The state table for a 3-bit twisted ring counter is given in Table 4-15. This circuit has no inputs, and its outputs are the uncomplemented outputs of the flip-flops. Since it has no inputs, it simply goes from state to state whenever a clock pulse occurs. It has an asynchronous reset that initializes it to state 000.

  #parts(
    a: [Design the circuit using D flip-flops and assuming that the unspeciied next states are don’ t-care conditions.],
    b: [Add the necessary logic to the circuit to initialize it to state 000 on power-up master reset.],
    c: [In the subsection “Designing with Unused States” of Section 4-5, three techniques for dealing with situations in which a circuit accidentally enters an unused state are discussed. If the circuit you designed in parts (a) and (b) is used in a child’s toy, which of the three techniques given would you apply? Justify your decision.],
    d: [Based on your decision in part (c), redesign the circuit if necessary.],
    e: [Repeat part (c) for the case in which the circuit is used to control engines on a commercial airliner. Justify your decision.],
    f: [Repeat part (d) based on your decision in part (e). ],
  )
][
  #parts(
    a: [
      $
        A &= overline(C) \
        B &= A \
        C &= B \
      $,
    ],
    b: [
      $
        A &= overline("RESET") space.thin overline(C) \
        B &= overline("RESET") A \
        C &= overline("RESET") B \
      $
    ],
    c: [
      We can use Method 1, just define the output when the circuit enters an unused state.
    ],
    d: [
      It's OK if we just keep the circuit unchanged by the method in part (c).
    ],
    e: [
      We can use Method 2, add an extra output to indicate the circuit enters an unused state.
    ],
    f: [
      $
        "UNUSED" = A (B overline(C) + overline(B) C)
      $
    ],
  )
]