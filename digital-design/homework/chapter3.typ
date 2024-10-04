#import "./template.typ": *

#show: project.with(
	course: "Digital Logic Design",
	course_fullname: "Digital Logic Design",
	course_code: "211C0060",
	title: "Chapter 3. Combinational Logic Design",
	authors: ((
		name: "Yulun WU",
		email: "memset0@outlook.com",
		id: "3230104585"
	),),
	semester: "Spring-Summer 2024",
	date: "April 29, 2024",
)

#let ng(x) = $overline(#x)$
#let sp = math.space.thin

#hw("3-7")[
	+A trafic light control at a simple intersection uses a binary counter to produce the following sequence of combinations on lines $A$, $B$, $C$, and $D$: 0000, 0001, 0011, 0010, 0110, 0111, 0101, 0100, 1100, 1101, 1111, 1110, 1010, 1011, 1001, 1000. After 1000, the sequence repeats, beginning again with 0000, forever. Each combination is present for 5 seconds before the next one appears. These lines drive combinational logic with outputs to lamps RNS (red—north/south), YNS (yellow—north/south), GNS (green—north/south),REW (red—east/west), YEW (yellow—east/west), and GEW (green—east/west). The lamp controlled by each output is ON for a 1 applied and OFF for a 0 applied. For a given direction, assume that green is on for 30 seconds, yellow for 5 seconds, and red for 45 seconds. (The red intervals overlap for 5 seconds.) Divide the 80 seconds available for the cycle through the 16 combinations into 16 intervals and determine which lamps should be lit in each interval based on expected driver behavior. Assume that, for interval 0000, a change has just occurred and that GNS = 1, REW = 1, and all other outputs are 0. Design the logic to produce the six outputs using AND and OR gates and inverters.
][
	We assgin the 16 time intervals to the following combinations of colors for the lamps:
	#table3(
		columns: 16,
		[*0000*], [*0001*], [*0011*], [*0010*], [*0110*], [*0111*], [*0101*], [*0100*], [*1100*], [*1101*], [*1111*], [*1110*], [*1010*], [*1011*], [*1001*], [*1000*],
		[R], [G], [G], [G], [G], [G], [G], [Y], [R], [R], [R], [R], [R], [R], [R], [R], 
		[R], [R], [R], [R], [R], [R], [R], [R], [R], [G], [G], [G], [G], [G], [G], [Y], 
	)
	Thus, the logic to produce the six outputs can be designed as follows:
	$
	"RNS" &= A + ng(B) sp ng(C) sp ng(D)\
	"YNS" &= ng(A) B ng(C) sp ng(D)\
	"GNS" &= ng(A) (C + D)\
	"REW" &= ng(A) + B ng(C) sp ng(D)\
	"YEW" &= A ng(B) sp ng(C) sp ng(D)\
	"GEW" &= A(C+D)\
	$
]

#hw("3-8")[
	Design a combinational circuit that accepts a 3-bit number and generates a 6-bit binary number output equal to the square of the input number.
][
	#grid(
		columns: (3fr, 1fr),
		column-gutter: 1em,
		[
			#table3(
				columns: 9,
				$bold(I_2)$, $bold(I_1)$, $bold(I_0)$, $bold(S_5)$, $bold(S_4)$, $bold(S_3)$, $bold(S_2)$, $bold(S_1)$, $bold(S_0)$,
				$0$, $0$, $0$, $0$, $0$, $0$, $0$, $0$, $0$,
				$0$, $0$, $1$, $0$, $0$, $0$, $0$, $0$, $1$,
				$0$, $1$, $0$, $0$, $0$, $0$, $1$, $0$, $0$,
				$0$, $1$, $1$, $0$, $0$, $1$, $0$, $0$, $1$,
				$1$, $0$, $0$, $0$, $1$, $0$, $0$, $0$, $0$,
				$1$, $0$, $1$, $0$, $1$, $1$, $0$, $0$, $1$,
				$1$, $1$, $0$, $1$, $0$, $0$, $1$, $0$, $0$,
				$1$, $1$, $1$, $1$, $1$, $0$, $0$, $0$, $1$,
			)
		],
		[
			$
			\ \ \
			S_0 &= I_0 \
			S_1 &= 0 \
			S_2 &= I_1 ng(I_0) \
			S_3 &= (ng(I_2) I_1 + I_2 ng(I_1)) I_0 \
			S_4 &= I_2(ng(I_1) + I_0) \
			S_5 &= I_2 I_1 \
			$
		]
	)
]

#hw("3-11")[
	A trafic metering system for controlling the release of trafic from an entrance ramp onto a superhighway has the following specifications for a part of its controller. There are three parallel metering lanes, each with its own stop (red)-go (green) light. One of these lanes, the car pool lane, is given priority for a green light over the other two lanes. Otherwise, a “round robin” scheme in which the green lights alternate is used for the other two (left and right) lanes. The part of the controller that determines which light is to be green (rather than red) is to be designed. The specifications for the controller follow:

	*Inputs*
	
	#idt[
		PS: Car pool lane sensor (car present—1; car absent—0)
	
		LS: Left lane sensor (car present—1; car absent—0)
		
		RS: Right lane sensor (car present—1; car absent—0)
		
		RR: Round robin signal (select left—1; select right—0)
	]

	*Outputs*

	#idt[
		PL: Car pool lane light (green—1; red—0)
		
		LL: Left lane light (green—1; red—0)
		
		RL: Right lane light (green—1; red—0)
	]

	*Operation*

	#idt[
		1.	If there is a car in the car pool lane, PL is 1.

		2.	If there are no cars in the car pool lane and the right lane, and there is a car in the left lane, LL is 1.

		3.	If there are no cars in the car pool lane and in the left lane, and there is a car in the right lane, RL is 1.

		4.	If there is no car in the car pool lane, there are cars in both the left and right lanes, and RR is 1, then LL = 1.

		5.	If there is no car in the car pool lane, there are cars in both the left and right lanes, and RR is 0, then RL = 1.

		6.	If any PL, LL, or RL is not speciied to be 1 above, then it has value 0.
	]

	#parts(
		a: [Find the truth table for the controller part.],
		b: [Find a minimum multiple-level gate implementation with minimum gate-input cost using AND gates, OR gates, and inverters.],
	)
][#parts(
	a: [
		The truth table of controller part is as follows:

		#table3(
			columns: 7,
			[*PS*], [*LS*], [*RS*], [*RR*], [*PL*], [*LL*], [*RL*],
			$0$, $0$, $0$, $0$, $0$, $0$, $0$,
			$0$, $0$, $0$, $1$, $0$, $0$, $0$,
			$0$, $0$, $1$, $0$, $0$, $0$, $1$,
			$0$, $0$, $1$, $1$, $0$, $0$, $1$,
			$0$, $1$, $0$, $0$, $0$, $1$, $0$,
			$0$, $1$, $0$, $1$, $0$, $1$, $0$,
			$0$, $1$, $1$, $0$, $0$, $0$, $1$,
			$0$, $1$, $1$, $1$, $0$, $1$, $0$,
			$1$, $0$, $0$, $0$, $1$, $0$, $0$,
			$1$, $0$, $0$, $1$, $1$, $0$, $0$,
			$1$, $0$, $1$, $0$, $1$, $0$, $0$,
			$1$, $0$, $1$, $1$, $1$, $0$, $0$,
			$1$, $1$, $0$, $0$, $1$, $0$, $0$,
			$1$, $1$, $0$, $1$, $1$, $0$, $0$,
			$1$, $1$, $1$, $0$, $1$, $0$, $0$,
			$1$, $1$, $1$, $1$, $1$, $0$, $0$,
		)
	],
	b: [
		$
		"PL" &= "PS"\
		"LL" &= ng("PS") "LS" (ng("RS") + "RR")\
		"RL" &= ng("PS") "RS" (ng("LS") + ng("RR"))\
		$
		#align(center, image("./circuits/3-11.svg", width: 52%))
	]
)]

#hw("3-13")[
	Design a circuit to implement the following pair of Boolean equations:
	$
	F&=A(C ng(E) + D E) + ng(A) D\
	G&=B(C ng(E) + D E) + ng(B) C\
	$
	To simplify drawing the schematic, the circuit is to use a hierarchy based on the factoring shown in the equation. Three instances (copies) of a single hierarchical circuit component made up of two AND gates, an OR gate, and an inverter are to be used. Draw the logic diagram for the hierarchical component and for the overall circuit diagram using a symbol for the hierarchical component.
][
	TBD
]

#hw("3-14")[
	A hierarchical component with the function is to be used along with inverters to implement the following equation:
	$
	H = ng(X) Y + X Z
	G = ng(A) sp ng(B) C + ng(A) B D + A ng(B) sp ng(C) + A B ng(D)
	$
	The overall circuit can be obtained by using Shannon’s expansion theorem,
	$
	F = ng(X) dot.c F_0 (X) + X dot.c F_1 (X)
	$
	where $F_0(X)$ is F evaluated with variable $X = 0$ and $F_1(X)$ is $F$ evaluated with variable $X = 1$. This expansion $F$ can be implemented with function $H$ by letting $Y = F_0$ and $Z = F_1$. The expansion theorem can then be applied to each of $F_0$ and $F_1$ using a variable in each, preferably one that appears in both true and complemented form. The process can then be repeated until all Fi ’s are single literals or constants. For $G$, use $X = A$ to ind $G_0$ and $G_1$ and then use $X = B$ for $G_0$ and $G_1$. Draw the top-level diagram for $G$ using $H$ as a hierarchical component.
][
	TBD
]

#hw("3-16")[
	Perform technology mapping to NAND gates for the circuit in Figure 3-54. Use cell types selected from: Inverter ($n = 1$), 2NAND, 3NAND, and 4NAND, as deined at the beginning of Section 3-2.

	#align(center, image("images/2024-04-30-00-05-14.png", width: 38%))
][
	TBD
]

#hw("3-24")[#parts(
	a: [
		Draw an implementation diagram for a constant vector function
		$
		F = (F_7, F_6, F_5, F_4, F_3, F_2, F_1, F_0) = (1, 0, 0, 1, 0, 1, 1, 0)
		$
		using the ground and power symbols in Figure 3-7(b).

		#align(center, image("images/2024-04-29-23-51-28.png", width: 60%))
	],
	b: [
		Draw an implementation diagram for a rudimentary vector function
		$
		G = (G_7, G_6, G_5, G_4, G_3, G_2, G_1, G_0) = (A, ng(A), 0, 1, ng(A), A, 1, 1)
		$
		using inputs $1$, $0$, $A$, and $ng(A)$.
	]
)][
	TBD
]

#hw("3-25")[#parts(
	a: [
		Draw an implementation diagram for rudimentary vector function
		$
		F = (F_7, F_6, F_5, F_4, F_3, F_2, F_1, F_0) = (A, ng(A), 1, ng(A), A, 0, 1, ng(A))
		$
		using the ground and power symbols in Figure 3-7(b) and the wire and inverter in Figures 3-7(c) and (d).
	],
	b: [
		Draw an implementation diagram for rudimentary vector function
		$
		G = (G_7, G_6, G_5, G_4, G_3, G_2, G_1, G_0) = (ng(F_0), ng(F_1), F_3, ng(F_2), 1, 0, 0, 1)
		$
		using the ground and power symbols and components of vector F.
	]
)][
	TBD
]

#hw("3-27")[
	A home security system has a master switch that is used to enable an alarm, lights, video cameras, and a call to local police in the event one or more of six sets of sensors detects an intrusion. In addition there are separate switches to enable and disable the alarm, lights, and the call to local police. The inputs, outputs, and operation of the enabling logic are specified as follows:

	*Inputs*

	#idt[
		$S_i$, $i$ = 0, 1, 2, 3, 4, 5 : signals from six sensor sets (0 = intrusion detected, 1 = no intrusion detected)
	
		$M$: master switch (0 = security system enabled, 1 = security system disabled)
		
		$A$: alarm switch (0 = alarm disabled, 1 = alarm enabled)
		
		$L$: light switch (0 = lights disabled, 1 = lights enabled)
		
		$P$: police switch (0 = police call disabled, 1 = police call enabled)
	]

	*Outputs*

	#idt[
		$A$: alarm (0 = alarm on, 1 = alarm off)

		$L$: lights (0 = lights on, 1 = lights off)

		$V$: video cameras (0 = video cameras off, 1 = video cameras on)

		$C$: call to police (0 = call off, 1 = call on)
	]

	*Operation*

	#idt[
		If one or more of the sets of sensors detect an intrusion and the secu- rity system is enabled, then outputs activate based on the outputs of the remaining switches. Otherwise, all outputs are disabled.
	]

	#align(center, image("images/2024-04-29-22-24-25.png", width: 60%))

	Find a minimum-gate-input cost realization of the enabling logic using AND and OR gates and inverters.
][
	TBD
]

#hw("3-28")[
	Design a 4-to-16-line decoder using two 3-to-8-line decoders and 16 2-input AND gates.
][
  _me: Do we really need this many AND gates?_

	#align(center, image("./circuits/3-28.svg", width: 44%))
]

#hw("3-29")[
	Design a 4-to-16-line decoder with enable using five 2-to-4-line decoders with enable as shown in Figure 3-16.

	#align(center, image("images/2024-04-29-22-40-13.png", width: 75%))
][
	TBD
]

#hw("3-37")[#parts(
	a: [Design an 8-to-1-line multiplexer using a 3-to-8-line decoder and an $8 times 2$ AND-OR.],
	b: [Repeat part (a), using two 4-to-1-line multiplexers and one 2-to-1-line multiplexer.]
)][
	TBD
]

#hw("3-44")[
	A combinational circuit is deined by the following three Boolean functions:
	$
	F_1 &= ng(X + Z) + X Y Z\
	F_2 &= ng(X + Z) + ng(X) Y Z\
	F_3 &= X ng(Y) Z + ng(X + Z)
	$
	Design the circuit with a decoder and external OR gates.
][
	#align(center, image("./circuits/3-44.svg", width: 50%))
]

#hw("3-47")[
	Implement the Boolean function
	$
	F(A,B,C,D) = Sigma m (1,3,4,11,12,13,14,15)
	$
	with a 4-to-1-line multiplexer and external gates. Connect inputs $A$ and $B$ to the selection lines. The input requirements for the four data lines will be a function of the variables $C$ and $D$. The values of these variables are obtained by expressing $F$ as a function of $C$ and $D$ for each of the four cases when $A B$ = 00, 01, 10, and 11. These functions must be implemented with external gates.
][
	TBD
]

#hw("3-50")[
	The logic diagram of the irst stage of a 4-bit adder, as implemented in integrated circuit type 74283, is shown in Figure 3-58. Verify that the circuit implements a full adder.

	#align(center, image("images/2024-04-29-22-40-46.png", width: 70%))
][
	By manually simulating the circuit, we can find that it satisfies the following logic functions:
	$
	C_1 &= A_0 B_0 + A_0 C_0 + B_0 C_0\
	S_0 &= A_0 plus.circle B_0 plus.circle C_0\
	$
	Therefore, we can assert that this circuit has implemented the function of a full adder.
]

#hw("3-51")[
	Obtain the 1s and 2s complements of the following unsigned binary numbers: 10011100, 10011101, 10101000, 00000000, and 10000000.
][
	#table3(
		columns: 3,
		[*Orginal*], [*1s complements*], [*2s complements*],
		$10011100$, $01100011$, $01100100$,
		$10011101$, $01100010$, $01100011$,
		$10101000$, $01010111$, $01011000$,
		$00000000$, $11111111$, $00000000$,
		$10000000$, $01111111$, $10000000$,
	)
]

#hw("3-52")[
	Perform the indicated subtraction with the following unsigned binary numbers by taking the 2s complement of the subtrahend:

	#parts(
		a: $11010 - 10001$,
		b: $11110 - 1110$,
		c: $1111110 - 1111110$,
		d: $101001 - 101$
	)
][
	#parts(
		a: $11010 - 10001 = 11010 + 01111 = 01001$,
		b: $11110 - 1110 = 11110 - 01110 = 11110 + 10010 = 10000$,
		c: $1111110 - 1111110 = 1111110 + 0000010 = 00000000$,
		d: $101001 - 101 = 101001 - 000101 = 101001 + 111011 = 100100$
	)
]

#hw("3-55")[
	The following binary numbers have a sign in the leftmost position and, if negative, are in 2s complement form. Perform the indicated arithmetic operations and verify the answers.

	#parts(
		a: $100111 + 111001$,
		b: $001011 + 100110$,
		c: $110001 - 010010$,
		d: $101110 - 110111$,
	)

	Indicate whether overflow occurs for each computation.
][#table3(
	columns: (1fr, 1fr, 1.5fr, 1fr, 1fr),
	[$bold(A)$], [$bold(B)$], [*2s complement of* $bold(B)$], [$bold(S)$], [*Overflow*],
	$100111$, $+ 111001$, [/], $100000$, $1$,
	$001011$, $+ 100110$, [/], $110001$, $0$,
	$110001$, $- 010010$, $101110$, $011111$, $1$,
	$101110$, $- 110111$, $001001$, $110111$, $0$,
)]

#pagebreak(weak: true)

#hw("3-59")[
	Design a combinational circuit that compares two 4-bit unsigned numbers $A$ and $B$ to see whether $B$ is greater than $A$. The circuit has one output $X$, so that $X$ = 1 if $A<B$ and $X$ = 0 if $A>=B$.
][
	#align(center, image("./circuits/3-59.svg", width: 46%))
]
