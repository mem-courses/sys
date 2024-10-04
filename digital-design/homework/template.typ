#import "@preview/tablex:0.0.8": tablex, colspanx, rowspanx, hlinex, vlinex, cellx

#let font_song = ("New Computer Modern", "Source Han Serif SC", "Simsun", "STSong")
#let font_fangsong = ("FangSong", "STFangSong")
#let font_hei = ("Calibri", "Source Han Sans SC", "Source Han Sans HW SC", "SimHei", "Microsoft YaHei", "STHeiti")
#let font_kai = ("KaiTi_GB2312", "KaiTi", "STKaiti")

#let definition_counter = state("definition_counter", 0)
#let theorem_counter = state("theorem_counter", 0)
#let problem_counter = state("problem_counter", 0)

#let indent = 0em
#let force-indent = 2em
#let par-margin = 0.8em
#let fake_par = [#text()[#v(0pt, weak: true)];#text()[#h(0em)]]

#let project(
  course: "", title: "", authors: (), date: none, body,
  course_fullname: "", semester: "", course_code: "",
) = {
  if (course_fullname == "") {
    course_fullname = course
  }
  if (course_code != "") {
    course_fullname = course_fullname + " (" + course_code + ")"
  }

  // 文档基本信息
  set document(author: authors.map(a => a.name), title: title)
  set page(
    paper: "a4",
    margin: (left: 12mm, right: 12mm, top: 20mm, bottom: 20mm),
    numbering: "1",
    number-align: center,
  )
  
  // 页眉
  set page(
    header: {
      locate(loc => {
        if (counter(page).at(loc).at(0) == 1) {
          return none
        }

        set text(font: font_song, 10pt, baseline: 8pt, spacing: 3pt)

        grid(
          columns: (1fr, 1fr, 1fr),
          align(left, course),
          []/* align(center, title)*/,
          align(right, date),
        )
        
        line(length: 100%, stroke: 0.5pt)
      })
    }
  )



  // 页脚
  set page(
    footer: {
      set text(font: font_song, 10pt, baseline: 8pt, spacing: 3pt)
      set align(center)
      
      grid(
        columns: (1fr, 1fr),
        align(left, authors.map(a => a.name).join(", ")),
        align(right, counter(page).display("1/1", both: true)),
      )
    }
  )

  set text(font: font_song, lang: "en", size: 12pt)
  show math.equation: set text(weight: 400)

  // Set paragraph spacing.
  show par: set block(above: par-margin, below: par-margin)

  // set heading(numbering: "1.1)")
  set par(leading: 0.75em)

  block(
    below: 4em, stroke: 0.5pt + black, radius: 2pt,
    width: 100%, inset: 1em, outset: -0.2em
  )[
    #text(size: 0.84em)[#grid(
      columns: (auto, 1fr, auto),
      align(left, strong(course_fullname)),
      [],
      align(right, strong(semester)),
    )]
    #v(0.75em)
    #align(center)[#text(size: 1.5em)[#title]]
    #v(0.75em)
    #block(..authors.map(author => align(center)[
      #text(size: 0.84em)[#grid(
        columns: (auto, 1fr, auto),
        align(left, author.name + " (" + author.id +")"),
        [],
        align(right, author.email),
      )]
    ]))
  ]

  // Main body.
  set par(justify: true)

  show "。": "．"

  show heading.where(level: 1): it => [
    #definition_counter.update(x => 0)
    #theorem_counter.update(x => 0)
    #set text(size: 1.2em)
    #it
    #v(0.15em)
  ]

  show heading.where(level: 2): it => [
    #theorem_counter.update(x => 0)
    #it
  ]

  set par(first-line-indent: indent)
  set table(inset: 5pt, stroke: 0.5pt, align: horizon + center)

  body
}

#let song(it) = text(it, font: font_song)
#let fangsong(it) = text(it, font: font_fangsong)
#let hei(it) = text(it, font: font_hei)
#let kai(it) = text(it, font: font_kai)

#let bb = (it) => [#strong[#it]]

#let hw(name, it, jt) = {block(width: 100%)[
  #let hl(x) = strong(text(x, font: ("Cambria", ..font_hei), number-type: "old-style"))
  #v(0.4em)
  #problem_counter.update(x => (x + 1))
  #hl[Exercise #name:]
  #it#fake_par#fake_par
  #v(0.2em)
  #h(-indent)#hl[Solution:]
  #jt
  #v(0.8em)
]}

#let named_block(it, name: "", color: red, inset: 11pt) = block(
  below: 1em, stroke: 0.5pt + color, radius: 3pt,
  width: 100%, inset: inset
)[
  #place(
    top + left,
    dy: -6pt - inset, // Account for inset of block
    dx: 8pt - inset,
    block(fill: white, inset: 2pt)[
			#set text(font: "Noto Sans", fill: color)
			#strong[#name]
		]
  )
  #let fontcolor = color.darken(20%)
  #set text(fill: fontcolor)
  #set par(first-line-indent_width: 0em)
  #it
]

#let example(it) = named_block(it, name: "Example", color: gray.darken(60%))
#let proof(it) = named_block(it, name: "Proof", color: rgb(120, 120, 120))
#let abstract(it) = named_block(it, name: "Abstract", color: rgb(0, 133, 143))
#let summary(it) = named_block(it, name: "Summary", color: rgb(0, 133, 143))
#let info(it) = named_block(it, name: "Info", color: rgb(68, 115, 218))
#let note(it) = named_block(it, name: "Note", color: rgb(68, 115, 218))
#let tip(it) = named_block(it, name: "Tip", color: rgb(0, 133, 91))
#let hint(it) = named_block(it, name: "Hint", color: rgb(0, 133, 91))
#let success(it) = named_block(it, name: "Success", color: rgb(62, 138, 0))
#let help(it) = named_block(it, name: "Help", color: rgb(153, 110, 36))
#let warning(it) = named_block(it, name: "Warning", color: rgb(184, 95, 0))
#let attention(it) = named_block(it, name: "Attention", color: rgb(216, 58, 49))
#let caution(it) = named_block(it, name: "Caution", color: rgb(216, 58, 49))
#let failure(it) = named_block(it, name: "Failure", color: rgb(216, 58, 49))
#let danger(it) = named_block(it, name: "Danger", color: rgb(216, 58, 49))
#let error(it) = named_block(it, name: "Error", color: rgb(216, 58, 49))
#let bug(it) = named_block(it, name: "Bug", color: rgb(204, 51, 153))
#let quote(it) = named_block(it, name: "Quote", color: rgb(132, 90, 231))
#let cite(it) = named_block(it, name: "Cite", color: rgb(132, 90, 231))

#let table3-global-align = align
#let table3(
	..args,
	inset: 0.5em,
	stroke: 0.5pt,
  width: 100%,
	align: center + horizon,
	columns: 1
) = {
  set table3-global-align(center)
  if type(columns) == int {
    let new_columns = ()
    for i in range(columns) {
      new_columns.push(1fr)
    }
    columns = new_columns
  }
  box(
    width: width,
    clip: true,
    stack(
      tablex(
        ..args,
        inset: inset,
        stroke: stroke,
        align: align,
        columns: columns,
        map-hlines: h => {
          if (h.y == 0) {
            (..h, stroke: (stroke * 2) + black)
          } else if (h.y == 1) {
            (..h, stroke: stroke + black)
          } else {
            (..h, stroke: 0pt)
          }
        },
        auto-vlines: false,
      ),
      line(stroke: (stroke * 2) + black, length: 100%)
    )
  )
}

#let parts(columns: 1, ..it) = {
	let buffer = ()
	for (id, sol) in it.named() {
    buffer.push([#h(force-indent / 2);*#id)*])
    buffer.push(box(width: 100%, sol))
	}
  grid(
    columns: 2 * columns,
    column-gutter: 0.25em,
    row-gutter: 1em,
    ..buffer,
  )
}

#let indent-box(it, radio: 1) = grid(
  columns: (force-indent * radio, 1fr),
  column-gutter: 0pt,
  [], it,
)
#let idt = indent-box