// --- CONFIGURATION ---
#let linkcolor = rgb("#800000") // Maroon
#let lightsep = text(fill: rgb("999999"))[ | ]

#set page(
  paper: "us-letter",
  margin: (x: 0.5in, y: 0.5in, top: 0.6in, bottom: 0.6in),
  footer: context [
    #align(center)[
      #set text(size: 10pt)
      Page #counter(page).display()
    ]
  ]
)

#set text(
  font: "New Computer Modern",
  size: 11pt,
  lang: "en"
)

#show link: set text(fill: linkcolor)

// --- CUSTOM FUNCTIONS ---

// 1. CV Section Header
#let cvsection(title) = {
  v(1em)
  block(sticky: true)[
    #text(size: 13pt, weight: "bold")[#smallcaps(title)]
    #v(-6pt)
    #line(length: 100%, stroke: 0.5pt)
  ]
  v(2mm)
}

// 2. Appointment/Education Entry Layout (Left/Right spread)
#let entry_header(title, location) = {
  grid(
    columns: (1fr, auto),
    strong(title), strong(location)
  )
}

// 3. Compact List (Optional helper if you want to wrap lists)
#let compact_list(body) = {
  set list(indent: 1em, body-indent: 0.5em, spacing: 0.6em)
  body
}

// --- CONTENT START ---

// Header: Last Updated Date
#place(
  top + right,
  dy: -20pt,
  text(fill: gray, size: 8pt, style: "italic")[
    Last updated: #datetime.today().display("[month repr:long] [day], [year]")
  ]
)

// Header: Name and Contact Info
#align(center)[
  #text(size: 24pt, weight: "bold")[#smallcaps("Your Name")] \
  #v(-5pt)

  123 Street Address, City, State ZIP, Country \
  #v(3pt)

  #link("mailto:email@example.com")[email\@example.com]
  #lightsep
  #link("tel:15555555555")[+1 (555) 555-5555]
  #lightsep
  #link("https://website.com")[website.com]
  #lightsep
  #link("https://github.com/username")[github.com/username]
]

#v(5pt)
#line(length: 100%, stroke: 0.5pt)
#v(-7pt)
#line(length: 100%, stroke: 0.5pt)
#v(10pt)

// --- BODY SECTIONS ---

// --- EXPERIENCE SECTION ---
#cvsection("Experience")

// Example Job Entry
#entry_header(link("https://company.com")[Company Name], "City, State")
#emph("Job Title") #h(1fr) Month Year -- Present

// Description List (Clean dash marker)
#list(indent: 1em, body-indent: 0.5em, spacing: 0.5em, marker: [--])[
  - Responsibility or achievement one.
  - Responsibility or achievement two.
  - Responsibility or achievement three.
]

#v(3mm) // Spacer

// Example Job Entry 2
#entry_header("Previous Company", "City, State")
#emph("Previous Title") #h(1fr) Month Year -- Month Year

#list(indent: 1em, body-indent: 0.5em, spacing: 0.5em, marker: [--])[
  - Responsibility or achievement one.
  - Responsibility or achievement two.
]

// --- EDUCATION SECTION ---
#cvsection("Education")

#entry_header("University Name", "City, State")
Ph.D. in Subject #h(1fr) Start Date -- End Date \
Thesis: #link("https://link-to-thesis")[_Title of Thesis_] \
Advisor: Name of Advisor

#v(3mm)

#entry_header("Undergraduate University", "City, State")
B.S. in Subject #h(1fr) Start Date -- End Date

// --- PAPERS SECTION ---
#cvsection("Papers")

// Links to profiles
#align(center)[
  #link("https://arxiv.org/")[arXiv] #lightsep
  #link("https://scholar.google.com/")[Google Scholar]
]

#v(2mm)

// Numbered List for Papers
#set enum(spacing: 0.6em)

+ Author One, #underline[Your Name], Author Three, _Title of Paper_, #link("https://doi.org")[Journal Name (Year)] #link("https://arxiv.org")[[arXiv]]

+ #underline[Your Name], Author Two, _Title of Another Paper_, #link("https://doi.org")[Conference Name (Year)]

// --- TALKS SECTION ---
#cvsection("Talks")

Invited talks:
#list(indent: 1em, body-indent: 0.5em, spacing: 0.6em)[
  - Name of Seminar or Talk #h(1fr) Date
  - Name of Seminar or Talk #h(1fr) Location, Date
]
