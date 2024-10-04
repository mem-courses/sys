#import "./template.typ": *

#show: project.with(
	course: "Digital Logic Design",
	course_fullname: "Digital Logic Design",
	course_code: "211C0060",
	title: "Chapter 2. Combinational Logic Circuits",
	authors: ((
		name: "Yulun WU",
		email: "memset0@outlook.com",
		id: "3230104585"
	),),
	semester: "Spring-Summer 2024",
	date: "April 2, 2024",
)

#let rev(x) = math.overline(x)
#let TT = math.bold(math.upright("T"))
#let FF = math.bold(math.upright("F"))

#hw("2-1(a)")[
	Demonstrate by means of truth tables the validity of the following identities:

	(a) DeMorgan’s theorem for three variables: $rev(X Y Z) = rev(X) + rev(Y) + rev(Z)$
][
	We can list the following truth table:

	#table3(
		width: 50%,
		columns: (1fr, 1fr, 1fr, 2fr, 2fr),
		$X$, $Y$, $Z$, $rev(X Y Z)$, $rev(X) + rev(Y) + rev(Z)$, 
		0, 0, 0, 1, 1,
		0, 0, 1, 1, 1,
		0, 1, 0, 1, 1,
		1, 0, 0, 1, 1,
		1, 0, 1, 1, 1,
		1, 1, 0, 1, 1,
		1, 1, 1, 0, 0,
	)

	Therefore, we can derived that $rev(X Y Z) = rev(X) + rev(Y) + rev(Z)$ from the truth table.
]

#hw("2-2(a)")[
	Prove the identity of each of the following Boolean equations, using algebraic manipulation:

	(a) $rev(X) " " rev(Y) + rev(X) Y + X Y = rev(X) + Y$
][
	$
	rev(X) " " rev(Y) + rev(X) Y + X Y
	&= rev(X) (rev(Y) + Y) + X Y
	&= rev(X) + X Y
	&= (rev(X) + X)(rev(X) + Y)
	&= rev(X) + Y
	$
]

#hw("2-3(a)")[
	Prove the identity of each of the following Boolean equations, using algebraic manipulation:

	(a) $A B rev(C) + B rev(C)" "rev(D) + B C + rev(C) D = B + rev(C) D$
][
	$
	A B rev(C) + B rev(C D) + B C + rev(C) D
	&= B(A rev(C) + rev(C D) + C) + rev(C) D
	= B(A rev(C) + rev(C) C + rev(D) C) + rev(C) D\
	&= B(A rev(C) + TT + rev(D) C) + rev(C) D
	= B + rev(C) D
	$
]

#hw("2-6(b,d)")[
	Simplify the following Boolean expressions to expressions containing a minimum number of literals:

	(b) $(rev(A+B+C)) dot rev(A B C)$

	(d) $rev(A)" "rev(B) D + rev(A)" "rev(C) D + B D$
][
	
	#parts(
		b: [
			$
			(rev(A + B + C)) dot rev(A B C)
			&= rev(A) dot rev(B) dot rev(C) dot (rev(A) + rev(B) + rev(C))\
			&= rev(A) dot rev(B) dot rev(C) dot rev(A) + rev(A) dot rev(B) dot rev(C) dot rev(B) + rev(A) dot rev(B) dot rev(C) dot rev(C)\
			&= rev(A) dot rev(B) dot rev(C)
			$
		],
		d: [
			$
			rev(A)" "rev(B) D + rev(A)" " rev(C) D + B D
			&= D(rev(A)" "rev(B) + B + rev(A)" "rev(C))\
			&= D(rev(A)B+rev(B)B + rev(A)" "rev(C))\
			&= D rev(A) (B+rev(C))
			$
		]
	)
]

#hw("2-10(a,c)")[
	Obtain the truth table of the following functions, and express each function in sum-of-minterms and product-of-maxterms form:

	(a) $(X Y + Z)(Y + X Z)$

	(c) $W X rev(Y) + W X rev(Z) + W X Z + Y rev(Z)$
][
	#parts(
		a: [
			Let $E$ denotes $(X Y + Z)(Y + X Z)$, here we list the truth table of $E$:
			
			#table3(
				width: 80%,
				columns: (1fr, 1fr, 1fr, 2fr, 2fr, 3.5fr),
				$X$, $Y$, $Z$, $X Y + Z$, $Y + X Z$, $(X Y + Z)(Y + X Z)$,
				0, 0, 0, 0, 0, 0,
				0, 0, 1, 1, 0, 0,
				0, 1, 0, 0, 1, 0,
				0, 1, 1, 1, 1, 1,
				1, 0, 0, 0, 0, 0,
				1, 0, 1, 1, 1, 1,
				1, 1, 0, 1, 1, 1,
				1, 1, 1, 1, 1, 1,
			)

			Therefore, we can obtain the SOM form of $E$:

			$
			E = rev(X) Y Z + X rev(Y) Z + X Y rev(Z) + X Y Z
			$
			
			and the POM form:

			$
			rev(E) = rev(X)" "rev(Y)" "rev(Z) + rev(X) rev(Y) Z + rev(X) Y rev(Z) + X rev(Y) rev(Z)\
			=> E = (X + Y + Z)(X + Y + rev(Z))(X + rev(Y) + Z)(rev(X) + Y + Z)
			$
		],
		c: [
			Let $F$ denotes $W X rev(Y) + W X rev(Z) + W X Z + Y rev(Z)$, here we list the truth table of $F$:

			#table3(
				columns: (1fr, 1fr, 1fr, 1fr, 2fr, 2fr, 2fr, 2fr, 7fr),
				$X$, $Y$, $Z$, $W$, $W X rev(Y)$, $W X rev(Z)$, $W X Z$, $Y rev(Z)$, $W X rev(Y) + W X rev(Z) + W X Z + Y rev(Z)$,
				0, 0, 0, 0, 0, 0, 0, 0, 0,
				0, 0, 0, 1, 0, 0, 0, 0, 0,
				0, 0, 1, 0, 0, 0, 0, 0, 0,
				0, 0, 1, 1, 0, 0, 0, 0, 0,
				0, 1, 0, 0, 0, 0, 0, 1, 1,
				0, 1, 0, 1, 0, 0, 0, 1, 1,
				0, 1, 1, 0, 0, 0, 0, 0, 0,
				0, 1, 1, 1, 0, 0, 0, 0, 0,
				1, 0, 0, 0, 0, 0, 0, 0, 0,
				1, 0, 0, 1, 1, 1, 0, 0, 1,
				1, 0, 1, 0, 0, 0, 0, 0, 0,
				1, 0, 1, 1, 1, 0, 1, 0, 1,
				1, 1, 0, 0, 0, 0, 0, 1, 1,
				1, 1, 0, 1, 0, 1, 0, 1, 1,
				1, 1, 1, 0, 0, 0, 0, 0, 0,
				1, 1, 1, 1, 0, 0, 1, 0, 1,
			)

			Therefore, we can obtain the SOM form of expression $F$:

			$
			F = inline(sum) m(4,5,9,11,12,13,15)
			$

			and its POM form:

			$
			F = inline(product) M(1,5,7,8,9,12,13,14,15)
			$
		]
	)
]

#hw("2-11(a,c,d)")[
	For the Boolean functions $E$ and $F$, as given in the following truth table:

	#table3(
		width: 40%,
		columns: (1fr, 1fr, 1fr, 1fr, 1fr),
		$X$, $Y$, $Z$, $E$, $F$,
		0, 0, 0, 0, 1,
		0, 0, 1, 1, 0,
		0, 1, 0, 1, 1,
		0, 1, 1, 0, 0,
		1, 0, 0, 1, 1,
		1, 0, 1, 0, 0,
		1, 1, 0, 1, 0,
		1, 1, 1, 0, 1,
	)

	(a) List the minterms and maxterms of each function.

	(c) List the minterms of $E+F$ and $E dot F$.

	(d) Express $E$ and $F$ in sum-of-minterms algebraic form.
][#parts(
	a: [
		- Minterms of $E$: $m(1,2,4,6)$;
		- Maxterms of $E$: $M(0,2,4,7)$;
		- Minterms of $F$: $m(0,2,4,7)$;
		- Maxterms of $F$: $M(1,2,4,6)$.
	],
	c: [
		- Minterms of $E + F$: $m(0,1,2,4,6,7)$;
		- Minterms of $E dot F$: $m(2,4)$.
	],
	d: [
		$
		E &= rev(X)" "rev(Y) Z+rev(X) Y rev(Z)+X rev(Y)" "rev(Z) + X Y rev(Z) \
		F &= rev(X)" "rev(Y)" "rev(Z) + rev(X) Y rev(Z) + X rev(Y)" "rev(Z) + X Y Z
		$
	],
)]

#hw("2-12(b)")[
	Convert the following expressions into sum-of-products and product-of-sums forms:

	(b) $rev(X) + X (X+ rev(Y)) (Y + rev(Z))$
][
	Convert into SOP:

	$
	rev(X) + X (X+ rev(Y)) (Y + rev(Z))
	&= rev(X) + (X + X rev(Y))(Y + rev(Z))
	= rev(X) + X Y + X rev(Y) Y+ X rev(Z) + X rev(Y)" "rev(Z)\
	&= rev(X) + X Y + X rev(Z) + X rev(Y)" "rev(Z)
	$

	Convert into POS:

	$
	rev(X) + X (X+ rev(Y)) (Y + rev(Z))
	&= (X + rev(X)) (rev(X) + X + rev(Y)) (rev(X) + Y + rev(Z))
	= rev(X) + Y + rev(Z)
	$
]

#hw("2-15")[
	Optimize the following Boolean expressions using a map:

	(a) $rev(X)" "rev(Z) + Y rev(Z) + X Y Z$

	(b) $rev(A) B + rev(B) C + rev(A)" "rev(B)" "rev(C)$

	(c) $rev(A)" "rev(B) + A rev(C) + rev(B) C + rev(A) B rev(C)$
][
	#align(center, image("./images/solution 2-15.jpg", width: 56%))
]

#hw("2-17(b)")[
	Optimize the following Boolean functions, using a map:

	(b) $F(A,B,C,D) = sum m (1,4,5,6,10,11,12,13,15)$
][
	#align(center, image("./images/solution 2-17.jpg", width: 84%))
]

#hw("2-19(a)")[
	Find all the prime implicants for the following Boolean functions, and determine which are essential:

	(a) $F(W,X,Y,Z) = sum m (0,2,5,7,8,10,12,13,14,15)$\
][
	#align(center, image("./images/solution 2-19.jpg", width: 72%))
]

#hw("2-22(a)")[
	Optimize the following expressions in (1) sum-of-products and (2) product-of-sums forms:

	(a) $A rev(C) + rev(B) D + rev(A) C D + A B C D$
][
	#align(center, image("./images/solution 2-22.jpg", width: 80%))
]

#hw("2-25(b)")[
	Optimize the following Boolean functions $F$ together with the don’ t-care conditions $d$. Find all prime implicants and essential prime implicants, and apply the selection rule.

	(b) $F(W,X,Y,Z) = sum m(0,2,4,5,8,14,15), space d(W, X,Y,Z) = sum m(7,10,13)$
][
	#align(center, image("./images/solution 2-25.jpg", width: 68%))
]

// #hw("2-29")[
// 	The NOR gates in Figure 2-39 have propagation delay $t_"pd"$ = 0.073 ns and the inverter has a propagation delay $t_"pd"$ = 0.048 ns. What is the propagation delay of the longest path through the circuit?

// 	#align(center, image("images/figure 2-39.png", width: 75%))
// ][
// ]

// #hw("2-30")[
// 	The waveform in Figure 2-40 is applied to an inverter. Find the output of the inverter, assuming that

// 	(a) It has no delay.

// 	(b) It has a transport delay of 0.06 ns

// 	(c) It has an inertial delay of 0.06 ns with a rejection time of 0.04 ns.

// 	#align(center, image("images/figure 2-40.png", width: 75%))
// ][]

// #hw("2-31(c)")[
// 	Assume that $t_"pd"$ is the _average_ of $t_"PHL"$ and $t_"PLH"$. Find the delay from each input to the ouput in Figure 2-41 by

// 	(a) Finding $t_"PHL"$ and $t_"PLH"$ for each path, assuming $t_"PHL"$ = 0.20 ns and $t_"PLH"$ = 0.36ns for each gate. From these values, find $t_"pd"$ for each path.

// 	(b) Using $t_"pd"$ = 0.28 ns for each gate.

// 	(c) Compare your answers from parts (a) and (b) and discuss any differences.
// ][]