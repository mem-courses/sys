#import "./template.typ": *

#show: project.with(
	course: "Digital Logic Design",
	course_fullname: "Digital Logic Design",
	course_code: "211C0060",
	title: "Chapter 1. Digital Systems and Information",
	authors: ((
		name: "Yulun WU",
		email: "memset0@outlook.com",
		id: "3230104585"
	),),
	semester: "Spring-Summer 2024",
	date: "March 7, 2024",
)

#hw("1-3")[
	List the binary, octal, and hexadecimal numbers from 16 to 31.
][
	#table3(
		width: 50%,
		columns: (1fr, 1fr, 1fr, 1fr),
		stroke: 0.5pt,
		align: center,
		[*DEC*], [*BIN*], [*OCT*], [*HEX*],
		[16], [10000], [20], [10],
		[17], [10001], [21], [11],
		[18], [10010], [22], [12],
		[19], [10011], [23], [13],
		[20], [10100], [24], [14],
		[21], [10101], [25], [15],
		[22], [10110], [26], [16],
		[23], [10111], [27], [17],
		[24], [11000], [30], [18],
		[25], [11001], [31], [19],
		[26], [11010], [32], [1a],
		[27], [11011], [33], [1b],
		[28], [11100], [34], [1c],
		[29], [11101], [35], [1d],
		[30], [11110], [36], [1e],
		[31], [11111], [37], [1f],
	)
]

#hw("1-9")[
	Convert the following numbers from the given base to the other three bases listed in the table:
	#table3(
		width: 60%,
		columns: (1fr, 2fr, 1fr, 1fr),
		stroke: 0.5pt,
		align: center,
		[*DEC*], [*BIN*], [*OCT*], [*HEX*],
		[369.3125], [?], [?], [?],
		[?], [10111101.101], [?], [?],
		[?], [?], [326.5], [?],
		[?], [?], [?], [F3C7.A],
	)
][
	#table3(
		width: 60%,
		columns: (1fr, 2fr, 1fr, 1fr),
		stroke: 0.5pt,
		align: center,
		[*DEC*], [*BIN*], [*OCT*], [*HEX*],
		[369.3125], [101110001.0101], [561.24], [171.5],
		[189.625], [10111101.101], [275.5], [BD.A],
		[214.625], [11010110.101], [326.5], [D6.A],
		[62407.625], [1111001111000111.101], [171707.5], [F3C7.A],
	)
]

#hw("1-12")[
	Perform the following binary multiplications:
	
	(a) $1010 times 1100$

	(b) $0110 times 1001$

	(c) $1111001 times 011101$
][
	(a) $1111000$. (b) $110110$. (c) $110110110101$.
]

#hw("1-13")[
	Division is composed of multiplications and subtractions. Perform the binary division $1010110 div 101$ to obtain a quotient and remainder.
][
	$1010110 div 101 = 10001 dots.c dots.c 1$.
]

#hw("1-16")[
	In each of the following cases, determine the radix $r$:

	(a) $("BEE")_r = (2699)_(10)$

	(b) $(365)_r = (194)_(10)$
][
	(a) $r=15$. (b) $r=7$.
]

#hw("1-18")[
	Find the binary representations for each of the following BCD numbers:

	(a) 0100 1000 0110 0111

	(b) 0011 0111 1000.0111 0101
][
	(a) 4867 (b) 374.75
]

#hw("1-19")[
	Represent the decimal numbers 715 and 354 in BCD.
][
	715 in BCD Code is 0111 0001 0101. 354 in BCD Code is 0011 0101 0100.
]