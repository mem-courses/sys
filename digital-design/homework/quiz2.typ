#import "./template.typ": *

#show: project.with(
  course: "Digital Logic Design",
  course_fullname: "Digital Logic Design",
  course_code: "211C0060",
  title: "Quiz #2",
  authors: (
    (
      name: "Yulun WU",
      email: "memset0@outlook.com",
      id: "3230104585",
    ),
  ),
  semester: "Spring-Summer 2024",
  date: "June 13, 2024",
)

#let prob(x) = {
  x
  v(1fr)
}

#prob[
  *1.* Design a circuit which implements 4-bit incrementing/decrementing use a 4-bits full adder: when the input S=0, the circuit performs increment, when S=1, the circuit performs decrement.
]

#prob[
  *2.* Design a counter, when the control signal C=1, the counting sequence is 000 $->$ 100 $->$ 110 $->$ 111 $->$ 011 $->$ 000; when C=0, the counting sequence is 000 $->$ 100 $->$ 110 $->$ 010 $->$ 011 $->$ 000. Please write the state diagram, state table, next state function, output function and draw the circuit.
]

#pagebreak()
#prob[
  *3.* Given a circuit in figure (a):

  (1) write down its state table and state diagram.

  (2) Assume the initial state is 0 and input X waveform is shown in (b), write down the waveform of Q and Z.

  #align(center, image("images/2024-06-13-12-15-57.png", width: 80%))
]

#prob[
  *4.* Design a counter, when the control signal C=1, the counting sequence is 000 $->$ 100 $->$ 110 $->$ 111 $->$ 011 $->$ 000; when C=0, the counting sequence is 000 $->$ 100 $->$ 110 $->$ 010 $->$ 011 $->$ 000. Please write the state diagram, state table, next state function, output function and draw the circuit.
]

#pagebreak()
#prob[
  *5.* Use two 4-bit synchronous binary counters and logic gates to implement a 2-bits date counter that counts from decimal “01” through decimal “31”.

  #align(center, image("images/2024-06-13-12-16-39.png", width: 30%))
]

#prob[
  *6.* Use two 4-bit synchronous binary counters and logic gates to implement a 2-bits date counter that counts from decimal “01” through decimal “28”.

  #align(center, image("images/2024-06-13-12-16-39.png", width: 30%))
]

#pagebreak()
#prob[
  *7.* Give two register transfer operations (R1 unchanged except for the following cases):

  - C1: R1 $<-$ R1 + R2
  - (\~C1)C2: R1 $<-$ R1 - 1

    Use two 4-bits registers, one 4-bit adder, and other necessary gates to implement the above operations.
]