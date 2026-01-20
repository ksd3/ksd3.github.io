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
  #text(size: 24pt, weight: "bold")[#smallcaps("Kshitij Duraphe")] \
  #v(-5pt)

  Boston, MA \
  #v(3pt)

  #link("mailto:kshitijduraphe5@gmail.com")[kshitijduraphe5\@gmail.com]
  #lightsep
  #link("tel:13148863066")[+1 (314) 886-3066]
  #lightsep
  #link("https://ksd3.github.io")[ksd3.github.io]
  #lightsep
  #link("https://github.com/ksd3")[github.com/ksd3]
  #lightsep
  #link("https://linkedin.com/in/kshitij-duraphe")[LinkedIn]
]

#v(5pt)
#line(length: 100%, stroke: 0.5pt)
#v(-7pt)
#line(length: 100%, stroke: 0.5pt)
#v(10pt)

// --- BODY SECTIONS ---

// --- EDUCATION SECTION ---
#cvsection("Education")

#entry_header("Boston University", "Boston, MA")
Master of Science in Electrical and Computer Engineering #h(1fr) Sep 2022 -- May 2024 \
Advisor: Prof. Joshua Semeter \
GPA: 3.8/4.0

#v(3mm)

#entry_header("College of Engineering Pune", "Pune, India")
B.Tech. in Electrical Engineering with Minor in Computer Science and Engineering #h(1fr) Aug 2018 -- June 2022 \
Advisors: Prof. Archana Thosar, Prof. Suhas Kakade \
GPA: 9.11/10.0

// --- RESEARCH INTERESTS ---
#cvsection("Research Interests")

Astrophysics, Plasma Physics, Scientific Machine Learning, Remote Sensing

// --- THESES ---
#cvsection("Theses")

#entry_header([Data Driven Techniques to Advance Our Understanding of the STEVE Phenomenon], [])
#emph[#underline[Kshitij Duraphe], Joshua Semeter] \
Master's Thesis, Electrical and Computer Engineering, Boston University, 2024

#v(3mm)

#entry_header([Design of an Automated Radio Telescope for Observing the 21 cm Hydrogen Line], [])
#emph[#underline[Kshitij Duraphe], Archana Thosar] \
Bachelor's Thesis, Electrical Engineering, College of Engineering Pune, 2021

// --- RESEARCH EXPERIENCE ---
#cvsection("Research Experience")

#entry_header("University of Zielona Góra", "Zielona Góra, Poland")
#emph("Research Assistant (Remote)") #h(1fr) Mar 2025 -- Sep 2025 \
Advisor: Prof. Gopal Bhatta

#list(indent: 1em, body-indent: 0.5em, spacing: 0.5em, marker: [--])[
  - Analyzed a decade of NuSTAR hard X-ray observations of Cygnus X-1, employing spectral-timing analysis and fitting techniques to investigate accretion flow properties — #link("https://arxiv.org/abs/2510.10746")[The Astrophysical Journal (under review)]
  - Characterizing the system's behavior in different spectral states to advance the understanding of accretion physics near stellar-mass black holes, revealing a failed state transition
]

#v(3mm)

#entry_header("UniverseTBD Collaboration", "")
#emph("Researcher") #h(1fr) Jul 2024 -- Present \
Advisors: Dr. Ioana Ciucă, Dr. Michael Smith, Dr. John Wu

#list(indent: 1em, body-indent: 0.5em, spacing: 0.5em, marker: [--])[
  - Led the first empirical test of the *Platonic Representation Hypothesis* in astronomy, showing foundation models converge on shared representations with scale — #link("https://arxiv.org/abs/2509.19453")[NeurIPS ML4PS 2025]
  - Engineered a cross-modal framework to evaluate foundation models on premier astronomical surveys, validating the use of general-purpose architectures for computationally-efficient AI
]

#v(3mm)

#entry_header("Space Physics Lab, Boston University", "Boston, MA")
#emph("Graduate Research Assistant") #h(1fr) Oct 2022 -- May 2024 \
Advisor: Prof. Joshua Semeter

#emph("MS Thesis") #h(1fr) Jul 2023 -- May 2024

#list(indent: 1em, body-indent: 0.5em, spacing: 0.5em, marker: [--])[
  - Characterized STEVE morphology and kinetics using high-resolution citizen science imagery, developing computer vision tracking methods to quantify fine-scale dynamics, revealing distinct westward velocities for columnar (~13 km/s) and picket fence (~1 km/s) features
  - Investigated STEVE's impact on the ionosphere by analyzing Total Electron Content (TEC) variations using high-cadence GNSS data processed via custom ETL pipelines, identifying potential two-stage TEC increases linked to STEVE passage distinct from typical substorm
  - Developed automated STEVE detection capabilities for noisy All-Sky Imager data by adapting faint-source astronomical algorithms and evaluating deep learning models (ConvNeXt), enhanced by custom image superresolution, inpainting, and time-series classification modules
]

#emph("Hariri Center for Computing, Boston University") #h(1fr) Jul 2023 -- Jan 2024

#list(indent: 1em, body-indent: 0.5em, spacing: 0.5em, marker: [--])[
  - Developed GPS propagation models for ionospheres of Mars for the NASA Life on Mars initiative
  - Developed classical and deep learning models for spatiotemporal interpolation of sparse Total Electron Content (TEC) data of the Martian ionosphere
]

#emph("MS Project") #h(1fr) Oct 2022 -- May 2023

#list(indent: 1em, body-indent: 0.5em, spacing: 0.5em, marker: [--])[
  - Investigated ionospheric plasma dynamics conducive to STEVE formation by configuring and executing 3D forward modeling simulations using the GEMINI3D fluid-electrodynamic model
  - Analyzed simulation outputs to identify key plasma parameter variations (density structures, temperature enhancements, flow shears) and dynamical features driven by modeled STEVE-like conditions
]

#v(3mm)

#entry_header("College of Engineering Pune", "Pune, India")
#emph("Undergraduate Research Assistant") #h(1fr) Jan 2021 -- May 2022 \
Advisors: Prof. Archana Thosar, Prof. Suhas Kakade

#emph("B.Tech. Thesis") #h(1fr) Aug 2021 -- May 2022

#list(indent: 1em, body-indent: 0.5em, spacing: 0.5em, marker: [--])[
  - Developed a high-gain (~20dB) pyramidal horn radio telescope for 21cm line observations, including waveguide/feed design simulated and verified using Ansys HFSS
  - Integrated COTS hardware (RTL-SDR, LNA) and created C++/Python spectral analysis software (implementing WOLA FFT based on VIRGO) to detect galactic 21cm emission and derive a partial rotation curve
]

#emph("Signal Processing Lab") #h(1fr) Jan 2021 -- May 2021

#list(indent: 1em, body-indent: 0.5em, spacing: 0.5em, marker: [--])[
  - Developed machine learning models to predict optimal photovoltaic panel tilt angles for maximum power generation by incorporating environmental and seasonal factors, achieving predicted output increases of 8.44%-11.8% and validating results against the SMARTS2 analytical model. #link("https://ieeexplore.ieee.org/document/9587892")[Presented] at GPECOM-21
]

#v(3mm)

#entry_header("IIT Bombay", "Mumbai, India")
#emph("Research Intern") #h(1fr) May 2021 -- Aug 2021

#list(indent: 1em, body-indent: 0.5em, spacing: 0.5em, marker: [--])[
  - Performed Bayesian analysis of the eclipsing binary QX Cas, using PHOEBE/MCMC for light curve fitting and developing a custom 3-body dynamics simulator with a differential evolution solver to investigate variability drivers and constrain parameters of a hypothesized tertiary companion
]

#v(3mm)

#entry_header("Naxxatra Equinox Initiative", "Bangalore, India")
#emph("Research Intern") #h(1fr) Jul 2020 -- Oct 2020

#list(indent: 1em, body-indent: 0.5em, spacing: 0.5em, marker: [--])[
  - Derived the equations of stellar structure incorporating hydrostatic equilibrium and relativistic electron degeneracy pressure; numerically solved the resulting ODEs using a 4th-order Runge-Kutta method in Python to compute the white dwarf mass-radius relationship and determine the Chandrasekhar limit
]

// --- INDUSTRY EXPERIENCE ---
#cvsection("Industry Experience")

#entry_header("Absentia Technologies", "Boston, MA")
#emph("Machine Learning Engineer") #h(1fr) Jan 2025 -- Present

#list(indent: 1em, body-indent: 0.5em, spacing: 0.5em, marker: [--])[
  - Implemented distributed training pipelines (PyTorch FSDP) for deep learning models applied to astronomical image denoising and real-time scene understanding using content-aware architectures
  - Configured and managed automated CI/CD workflows (Docker, Jenkins, AWS) for model versioning, integration, and deployment
]

#v(3mm)

#entry_header("Spatialise", "Noordwijk, The Netherlands (Remote)")
#emph("Geospatial Machine Learning Engineer") #h(1fr) Feb 2025 -- May 2025

#list(indent: 1em, body-indent: 0.5em, spacing: 0.5em, marker: [--])[
  - Developed a multimodal spatiotemporal foundation model using multispectral satellite data, informed by statistical modeling (GPR, clustering) of soil properties for remote sensing predictions and soil health monitoring
  - Engineered a scalable cloud pipeline (GCP, DVC, Dask) for processing large geospatial datasets and training foundation models
]

#v(3mm)

#entry_header("The KeelWorks Foundation", "Oak Harbor, WA")
#emph("Software Engineer (Machine Learning Applications)") #h(1fr) Jul 2024 -- Jan 2025

#list(indent: 1em, body-indent: 0.5em, spacing: 0.5em, marker: [--])[
  - Architected complex agentic LLM systems (LangChain, Idefics-3) and optimized RAG pipelines (Pinecone) for QA, contextual summarization, and efficient information retrieval over large document corpora (85% QA accuracy, under 500ms retrieval)
  - Engineered a synthetic data generation framework by fine-tuning language models (Mistral) using techniques like back-translation and sequential style representation for specific data augmentation tasks
]

#v(3mm)

#entry_header("Halo AI (Stealth startup incubated at Columbia University)", "New York, NY")
#emph("Founding AI Engineer") #h(1fr) Dec 2023 -- Aug 2024

#list(indent: 1em, body-indent: 0.5em, spacing: 0.5em, marker: [--])[
  - Developed and optimized (via pruning, distillation, quantization) on-device federated/ensemble LLMs for real-time, multimodal agentic assistants, leveraging TF LiteRT and ONNX for deployment (latency cut by 27%, inference under 1.5s)
  - Engineered cloud data pipelines (AWS) and a microservice-based MLOps framework (Kubeflow) to support distributed federated learning experiments and continuous integration (reducing data preparation time by 70%)
]

// --- PAPERS SECTION ---
#cvsection("Papers")

// Numbered List for Papers
#set enum(spacing: 0.6em)

+ K. Duraphe, R. Baviskar, S. Shingade, A. Thosar, _Optimizing Solar Panel Tilt using Machine Learning Techniques_, #link("https://ieeexplore.ieee.org/document/9587892/")[GPECOM 2021]

+ N. Servan-Schreiber, J. Semeter, K. Duraphe, et al., _Smartphone Carrier Phase TEC: A Study Across Ionospheric Spatio-Temporal Scales_, #link("https://essopenarchive.org/users/1006611/articles/1370630-smartphone-carrier-phase-tec-a-study-across-ionospheric-spatio-temporal-scales")[ESS Open Archive (2024)]

+ K. Duraphe et al., _The Platonic Universe: Do Foundation Models See the Same Sky?_, #link("https://ml4physicalsciences.github.io/2025/")[NeurIPS ML4PS 2025 - *Spotlight Paper*] #link("https://arxiv.org/abs/2509.19453")[\[arXiv\]] \
  Investigates if foundation models see the same underlying astrophysical phenomena and develops custom foundation models to better learn underlying astrophysics

+ G. Bhatta, S. Markowitz, K. Duraphe et al., _Hard X-ray Variability from Cygnus X-1: Spectral-Timing Analysis with NuSTAR_, #link("https://arxiv.org/abs/2510.10746")[The Astrophysical Journal (under review)]

// --- SELECTED PROJECTS ---
#cvsection("Selected Projects")

#entry_header([Using high-rate dual-frequency cellphones to study the April 8#super[th] total solar eclipse], "Ogunquit, ME")
2024 #h(1fr) #link("https://cedarscience.org/sites/default/files/2024-posters/IRRI-8-Nina-ServanSchreiber.pdf")[Poster] | #link("https://essopenarchive.org/users/1006611/articles/1370630-smartphone-carrier-phase-tec-a-study-across-ionospheric-spatio-temporal-scales")[Paper]

#v(2mm)

#entry_header("Comparative Optimization of Photonic QGANs using Quandela Perceval", "MIT iQuHack 2024")
2024 #h(1fr) #link("https://github.com/ksd3/biqermicefrommars")[Code]

#v(2mm)

#entry_header("BeatQraft: QCBM-Based Rhythmic Pattern Generation", "MIT iQuHack 2023")
2023 #h(1fr) #link("https://github.com/ksd3/BeatQraft")[Code]

// --- TALKS SECTION ---
#cvsection("Talks and Presentations")

#list(indent: 1em, body-indent: 0.5em, spacing: 0.6em)[
  - _The Platonic Universe: Do Foundation Models See the Same Sky?_ (long version) #h(1fr) #link("https://www.youtube.com/watch?v=NIf-QQikukE")[AstroAI, 2025]
  - _The Platonic Universe: Do Foundation Models See the Same Sky?_ #h(1fr) #link("https://neurips.cc/virtual/2025/loc/san-diego/135877")[NeurIPS ML4PS Workshop, Dec 2025]
  - _Using high-rate dual-frequency cellphones to study the April 8th total solar eclipse_ #h(1fr) CEDAR Workshop, Jun 2024
  - _Optimizing Solar Panel Tilt using Machine Learning Techniques_ #h(1fr) GPECOM, Dec 2021
]

// --- REVIEW EXPERIENCE ---
#cvsection("Review Experience")

#list(indent: 1em, body-indent: 0.5em, spacing: 0.6em)[
  - United States Research Software Engineer Conference (US-RSE) #h(1fr) 2025
]

// --- AWARDS AND HONORS ---
#cvsection("Selected Awards and Honors")

#list(indent: 1em, body-indent: 0.5em, spacing: 0.6em)[
  - MS Ambassador, Boston University ECE Department #h(1fr) 2024
  - 2#super[nd] out of 100+ international teams at MIT iQuHack-2023, IBM x Covalent Challenge #h(1fr) 2023
  - 3#super[rd] in class of 81 at College of Engineering Pune #h(1fr) 2022
]

// --- KEY SKILLS ---
#cvsection("Key Skills")

*Programming:* Python, C, C++, SQL, MATLAB, Octave

*ML Libraries & Frameworks:* PyTorch, TensorFlow, scikit-learn, pandas, NumPy, Matplotlib, AstroPy

*ML Techniques:* Deep Learning, Statistical & Bayesian Modeling (MCMC), Spectral Analysis, Time-Series Analysis, Computer Vision (Scientific Data), LLM Applications (RAG, Fine-tuning)

*Astrophysics & Simulation:* GEMINI3D, PHOEBE, Ansys HFSS, HEASoft, Numerical Methods

*Cloud, MLOps & Tools:* AWS, GCP, Docker, Kubeflow/MLflow, CI/CD (Jenkins), SQL/NoSQL DBs, Dask/PySpark, Git

// --- TEACHING EXPERIENCE ---
#cvsection("Teaching Experience")

#entry_header("Computational Research Access NEtwork (CRANE) Physics", "Winter 2024")
#emph("TA/Mentor")

#list(indent: 1em, body-indent: 0.5em, spacing: 0.5em, marker: [--])[
  - Topics: Signal Processing, Introduction to Python, Numerical Methods, Machine Learning, PIC Simulations
]

// --- ASTRONOMY SCHOOLS AND WORKSHOPS ---
#cvsection("Astronomy Schools and Workshops Attended")

#entry_header("Inter-University Center for Astronomy and Astrophysics (IUCAA)", "Pune, India")
#emph("Introductory Summer School in Astronomy and Astrophysics") #h(1fr) May -- Jun 2020

#list(indent: 1em, body-indent: 0.5em, spacing: 0.5em, marker: [--])[
  - Daily lectures on different introductory topics in astronomy and astrophysics
]

// --- OUTREACH AND VOLUNTEERING ---
#cvsection("Outreach and Volunteering")

#entry_header("COEP Astronomy Club", "Pune, India")
#emph("Project Head") #h(1fr) 2018 -- 2022

#list(indent: 1em, body-indent: 0.5em, spacing: 0.5em, marker: [--])[
  - Led projects on antenna design for low-frequency observations of the universe, deep learning methods to detect neutral hydrogen galaxies, telescope operation
  - Gave talks at schools for autistic children on identifying constellations in the night sky
  - Mentored 30 undergraduates on how to process astronomical data and build reflector telescopes
]

#v(3mm)

#entry_header("COEP Mathematics Club", "Pune, India")
#emph("Member") #h(1fr) 2018 -- 2020
