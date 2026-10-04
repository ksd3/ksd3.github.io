// ============================================================================
//  Kshitij Duraphe — SINGLE SOURCE for both the academic CV and the resume.
//
//  Both PDFs are built from this one file by the _quarto.yml pre-render hook:
//      quarto typst compile                  cv/cv.typ docs/cv/cv.pdf
//      quarto typst compile --input mode=resume cv/cv.typ docs/cv/resume.pdf
//
//  HOW TO EDIT
//    PART 1 (DATA)    — everything you normally change lives here.
//    PART 2 (STYLE)   — fonts, spacing, helpers. Edit once, both docs update.
//    PART 3 (LAYOUT)  — what each document shows and in what order.
//
//  Per-entry control:
//    roles have `cv:` and `resume:` bullet lists. An empty tuple `()` omits
//    that entry from that document entirely.
//    publications/awards/talks have `key: true` to appear on the resume.
// ============================================================================

#let mode = sys.inputs.at("mode", default: "cv")
#let resume = mode == "resume"

// ============================================================================
//  PART 1 — DATA
// ============================================================================

#let me = strong(emph("K. Duraphe"))

#let contact = (
  name: "Kshitij Duraphe",
  location: if resume { "Boston, MA" } else { "Boston, MA" },
  email: if resume { "kshitijduraphe5@gmail.com" } else { "kshitijd@bu.edu" },
  phone: "+1 (314) 886-3066",
  phone-tel: "13148863066",
  site: "ksd3.github.io",
  github: "github.com/ksd3",
  linkedin: "linkedin.com/in/kshitij-duraphe",
)

// One-line pitch. Resume only.
#let summary = [
  Machine learning engineer and researcher working on foundation models,
  evaluation, and scientific inverse problems. Co-first author on a
  *NeurIPS ML4PS 2025 Spotlight* (top 1%); first author in
  _The Astrophysical Journal_. Builds the infrastructure and the measurements
  that show whether models actually work.
]

#let education = (
  (
    school: "Boston University", loc: "Boston, MA",
    degree: [M.S., Electrical and Computer Engineering (with Thesis)],
    dates: "Sep 2022 -- May 2024",
    gpa: "3.8/4.0",
    detail: [
      Advisor: Prof. #link("https://www.bu.edu/eng/profile/joshua-semeter/")[Joshua Semeter] \
    ],
    coursework: [Cosmic Plasma Physics #sym.dot.c Fourier Optics #sym.dot.c Quantum Mechanics and Semiconductor Physics #sym.dot.c Quantum Computing #sym.dot.c Signal Processing #sym.dot.c Machine Learning #sym.dot.c Advanced Algorithms #sym.dot.c Advanced Discrete Mathematics],
  ),
  (
    school: "College of Engineering Pune", loc: "Pune, India",
    degree: [B.Tech., Electrical Engineering (Minor: Computer Science)],
    dates: "Aug 2018 -- June 2022",
    gpa: "9.11/10.0 (Department Bronze Medalist)",
    detail: [Advisors: Prof. Archana Thosar, Prof. Suhas Kakade \ ],
    coursework: [Probability Theory and Statistical Inference #sym.dot.c Optics and Modern Physics #sym.dot.c Electromagnetism #sym.dot.c Numerical Methods #sym.dot.c Vector Calculus #sym.dot.c Partial Differential Equations #sym.dot.c Ordinary Differential Equations #sym.dot.c Complex Analysis],
  ),
)

#let research-interests = [
  High-Energy Astrophysics; Foundation Models; Mechanistic Interpretability;
  Space Physics; Time-Domain Astrophysics.
]

// `key: true` → also appears on the resume's shortened list.
#let publications = (
  (
    key: true,
    title: [State-Dependent X-ray Variability in Cygnus X-1: A 12-Year NuSTAR Timing Study of Accretion Flow Geometry],
    authors: [#me, G. Bhatta, K. Mandar, C. Khanal, et al.],
    venue: [#link("https://arxiv.org/abs/2510.10746")[The Astrophysical Journal], 2026],
  ),
  (
    key: false,
    title: [Multi-Epoch NuSTAR Spectral Analysis of Cygnus X-1: Coronal and Reflection Properties Across Spectral States],
    authors: [#me, G. Bhatta, A. A. Zdziarski, et al.],
    venue: [Submitted to The Astrophysical Journal, 2026],
  ),
  (
    key: true,
    title: [Cross-Modal Attention is Overparameterized: The Sufficiency of Modality-Level Alignment],
    authors: [#me, K. Mohamed, N. Morgan],
    venue: [Submitted to NeurIPS Main Track, 2026],
  ),
  (
    key: false,
    title: [Smartphone Carrier Phase TEC: A Study Across Ionospheric Spatio-Temporal Scales],
    authors: [N. Servan-Schreiber, J. Semeter, #me, et al.],
    venue: [#link("https://essopenarchive.org/users/1006611/articles/1370630-smartphone-carrier-phase-tec-a-study-across-ionospheric-spatio-temporal-scales")[Space Weather], 2026],
  ),
  (
    key: true,
    title: [The Platonic Universe: Do Foundation Models See the Same Sky?],
    authors: [#me, M. J. Smith, J. F. Wu, S. Sourav #emph[(co-first author)]],
    venue: [#link("https://arxiv.org/abs/2509.19453")[NeurIPS ML4PS Workshop, 2025] — #underline[*Spotlight (top 1%)*]; expanded follow-up submitted to NeurIPS 2026 main track],
  ),
  (
    key: false,
    title: [Optimizing Solar Panel Tilt using Machine Learning Techniques],
    authors: [#me, S. Kakade, et al.],
    venue: [#link("https://ieeexplore.ieee.org/document/9587892/")[GPECOM], 2021],
  ),
)

#let theses = (
  (
    title: [Data-Driven Techniques to Advance Our Understanding of the STEVE Phenomenon],
    authors: [*Kshitij Duraphe*, Joshua Semeter],
    venue: [M.S. Thesis, Dept. of Electrical and Computer Engineering, Boston University, 2024],
  ),
  (
    title: [Design of an Automated Radio Telescope for Observing the 21 cm Hydrogen Line],
    authors: [*Kshitij Duraphe*, Archana Thosar],
    venue: [B.Tech. Thesis, Dept. of Electrical Engineering, College of Engineering Pune, 2022],
  ),
)

// ---------------------------------------------------------------------------
//  ROLES.  `cv:` and `resume:` hold that document's bullets.
//  An empty tuple `()` drops the entry from that document.
// ---------------------------------------------------------------------------

#let research-roles = (
  (
    org: "University of Zielona Góra", loc: "Zielona Góra, Poland (Remote)",
    title: "Research Assistant", dates: "Mar 2025 -- Present",
    sub: [Advisor: Prof. #link("https://inspirehep.net/authors/1722470")[Gopal Bhatta]],
    cv: (
      [#underline[First-authored] a 12-year NuSTAR archival timing study of Cygnus X-1 (#emph[The Astrophysical Journal], 2026), mapping accretion-flow geometry across spectral states via hard X-ray spectral-timing analysis.],
      [Identified a previously unrecognized failed state transition and characterized state-dependent variability (power spectra, rms-flux relations, lag-frequency spectra), placing direct constraints on the corona–disk geometry near the black hole.],
      [Reduced and analyzed the complete public NuSTAR Cyg X-1 archive with HEASoft / NuSTARDAS / Stingray / AstroPy; led manuscript writing and referee response.],
      [Currently leading a follow-up multi-epoch #emph[spectral] study of Cyg X-1 with #link("https://www.camk.edu.pl/en/staff/aaz/")[Andrzej A. Zdziarski] (NCAC Warsaw), submitted to #emph[The Astrophysical Journal].],
    ),
    resume: (
      [#underline[First-authored] a 12-year NuSTAR archival timing study of Cygnus X-1 (#emph[ApJ], 2026); reduced and analyzed the complete public archive, led manuscript and referee response.],
    ),
  ),
  (
    org: "UniverseTBD Collaboration", loc: "Remote",
    title: "Researcher", dates: "Jul 2024 -- Present",
    sub: [Collaborators: Dr. #link("https://mjjsmith.com")[Michael J. Smith], Dr. #link("https://jwuphysics.github.io/")[John F. Wu]],
    cv: (
      [#underline[Co-first author] on #emph[The Platonic Universe] (NeurIPS ML4PS 2025 #underline[*Spotlight*, top 1%]; expanded follow-up submitted to NeurIPS 2026 main track). Designed the evaluation framework comparing foundation-model representations across SDSS, DESI, JWST, and other surveys under model and data scaling.],
      [Creator of the open-source #link("https://github.com/UniverseTBD/platonic-universe")[platonic-universe] package (Python / PyTorch): survey-aware data loaders, evaluation harness, reproducible configs, CI, test infrastructure.],
      [Invited #link("https://www.youtube.com/watch?v=NIf-QQikukE")[AstroAI talk at the Harvard Center for Astrophysics] (Jan 2026) and #link("https://neurips.cc/virtual/2025/loc/san-diego/135877")[NeurIPS ML4PS oral presentation] (Dec 2025).],
      [NCSA DeltaAI allocation *PHY250286* — 6,000 GPU-hours (PI: M. J. Smith; Sep 2025 -- Sep 2026); running distributed training and evaluation workloads under the allocation.],
    ),
    resume: (
      [#underline[Co-first author] on #emph[The Platonic Universe] — NeurIPS ML4PS 2025 #underline[*Spotlight*] (top 1%). Designed the cross-model representational-alignment *evaluation framework* spanning SDSS, DESI and JWST under model and data scaling.],
      [Creator and maintainer of open-source #link("https://github.com/UniverseTBD/platonic-universe")[platonic-universe]: survey-aware loaders, reproducible eval harness, configs, CI. Run on a 6,000 GPU-hour NCSA DeltaAI allocation.],
    ),
  ),
  (
    org: "Space Physics Lab, Boston University", loc: "Boston, MA",
    title: "Graduate Research Assistant", dates: "Oct 2022 -- May 2024",
    sub: [Advisor: Prof. Joshua Semeter],
    cv: (
      [#emph[M.S. thesis — Data-Driven Techniques for STEVE.] Characterized #link("https://en.wikipedia.org/wiki/STEVE")[STEVE] morphology and kinetics from high-resolution citizen-science imagery; computer-vision tracking quantified distinct westward velocities for columnar (~13 km/s) and picket-fence (~1 km/s) features.],
      [Developed and contributed to open-source Python and C++ libraries for high-cadence GNSS carrier-phase processing and Total Electron Content (TEC) analysis; identified a candidate two-stage TEC signature of STEVE passage distinct from typical substorms.],
      [Built automated STEVE detection for noisy All-Sky Imager data by adapting faint-source astronomical algorithms and evaluating deep-learning models (ConvNeXt), with modular super-resolution, inpainting, and time-series classification components.],
      [#emph[NASA Life on Mars (BU CDS).] GPS-signal propagation models and spatiotemporal interpolation of sparse Martian-ionosphere TEC data from MARSIS (classical and deep-learning baselines).],
      [#emph[M.S. project — Plasma dynamics of STEVE.] 3D forward-modeling simulations of the ionospheric regime conducive to STEVE formation with GEMINI3D; analyzed density structures, temperature enhancements, and flow shears.],
    ),
    resume: (
      [Architected a distributed ingestion pipeline (Kafka, Dask, S3) cutting processing of 3 TB+ sensor datasets from >24 h to *\<3 h*; built generative inpainting and super-resolution pipelines to reconstruct corrupted sensor data.],
      [Developed automated detection over noisy all-sky imagery by adapting faint-source astronomical algorithms and evaluating deep-learning models (ConvNeXt).],
    ),
  ),
  (
    org: "IIT Bombay", loc: "Mumbai, India",
    title: "Research Intern — Bayesian Binary-Star Analysis", dates: "May 2021 -- Aug 2021",
    sub: none,
    cv: (
      [Bayesian analysis of the eclipsing binary #link("https://arxiv.org/pdf/2107.10954")[QX Cas] using PHOEBE and MCMC; built a custom 3-body dynamics simulator with a differential-evolution solver to constrain a hypothesized tertiary companion.],
    ),
    resume: (),
  ),
  (
    org: "College of Engineering Pune", loc: "Pune, India",
    title: "Undergraduate Research Assistant", dates: "Jan 2021 -- May 2022",
    sub: [Advisors: Prof. Archana Thosar, Prof. Suhas Kakade],
    cv: (
      [#emph[Solar panel tilt optimization.] Formulated optimal tilt as regression over multi-year irradiance and meteorological time-series; benchmarked gradient-boosted, kernel-based, and shallow-network estimators against the latitude heuristic. First-authored the resulting #link("https://ieeexplore.ieee.org/document/9587892/")[IEEE GPECOM 2021] paper.],
      [#emph[B.Tech. thesis — 21 cm radio telescope.] Designed and built a high-gain (~20 dB) pyramidal horn radio telescope (Ansys HFSS-simulated waveguide/feed); integrated an RTL-SDR + LNA front-end with Python/C++ WOLA-FFT spectral analysis (#link("https://github.com/jobgeheniau/VIRGO")[VIRGO]-based) and recovered a partial galactic rotation curve.],
    ),
    resume: (),
  ),
  (
    org: "Naxxatra Equinox Initiative", loc: "Bangalore, India",
    title: "Research Intern — Stellar Structure and Compact Objects", dates: "Jul 2020 -- Oct 2020",
    sub: none,
    cv: (
      [Derived the equations of stellar structure with hydrostatic equilibrium and relativistic electron-degeneracy pressure; solved the coupled ODEs with 4#super[th]-order Runge–Kutta in Python to compute the white-dwarf mass–radius relation and the Chandrasekhar limit.],
    ),
    resume: (),
  ),
)

#let industry-roles = (
  (
    org: "Thespian Labs", loc: "Somerville, MA",
    title: "AI Engineer", dates: "Nov 2025 -- Feb 2026",
    sub: none,
    cv: (
      [Developed *Text2Motion* foundation models using *VQ-VAE* motion tokenization; multimodal pre-training on 5000+ hours of human-performance time-series and DARTControl-style *reinforcement-learning post-training* for controllable motion synthesis.],
      [Released the open-source MLOps library #link("https://github.com/ksd3/jobber")[jobber] for programmatic research-job submission to cloud platforms.],
    ),
    resume: (
      [Trained *Text2Motion* foundation models with *VQ-VAE* tokenization over 5000+ hours of human-performance time-series; implemented DARTControl-style *RL post-training* with reward modeling and rollout infrastructure on GCP.],
    ),
  ),
  (
    org: "Absentia Technologies", loc: "Boston, MA",
    title: "Founding Machine Learning Engineer", dates: "Jan 2025 -- Nov 2025",
    sub: none,
    cv: (
      [Developed *vision-language models* for multimodal video understanding; combined large-scale pre-training with supervised fine-tuning and alignment post-training on domain-specific data.],
      [Implemented distributed training with *PyTorch FSDP* (multi-GPU, mixed-precision) to train models beyond single-device memory, handling sharding, checkpointing, and fault recovery.],
    ),
    resume: (
      [Architected a production SaaS video-analysis platform on *AWS* from scratch — core AI service infrastructure plus Terraform/Docker CI/CD, cutting deployment cycles from days to *\<2 h*.],
      [Built the APIs and infrastructure for autonomous agents to read video streams, reason over events, and flag anomalies in real time (Python, PyTorch, Kafka, Kubernetes).],
      [Established an automated *evaluation pipeline* benchmarking agent accuracy and API latency; reduced regressions *40%* and raised stability to *99.9%*, including resolving a production memory leak on call.],
      [Implemented *distributed training* with PyTorch FSDP (sharding, mixed precision, checkpointing, fault recovery); built a diffusion-based synthetic-data pipeline that cut false positives *15%*.],
    ),
  ),
  (
    org: "Halo AI (Columbia-incubated stealth)", loc: "New York, NY (Remote)",
    title: "Founding AI Engineer", dates: "Dec 2023 -- Aug 2024",
    sub: none,
    cv: (
      [Researched on-device *federated* and *ensemble* LLMs for agentic assistants under tight compute and memory constraints, including ablations on federated-aggregation strategies.],
      [Systematic study of *model compression* — pruning, knowledge distillation, 8-bit post-training quantization — and the trade-offs for latency, memory, and task accuracy (50% size reduction, 80% inference speedup, 90% accuracy retention).],
    ),
    resume: (
      [Built a federated-learning pipeline and LLM ensemble for on-device agentic assistants, cutting inference latency *27%* to *\<1.5 s*.],
      [Architected an AWS MLOps pipeline (EC2, S3, Lambda, SageMaker) automating CI/CD and evaluation; reduced data-preparation time *70%*. Applied distillation and 8-bit quantization for *80%* faster inference at *90%* accuracy retention.],
    ),
  ),
  (
    org: "Spatialise", loc: "Noordwijk, Netherlands (Remote)",
    title: "Geospatial Machine Learning Engineer", dates: "Feb 2025 -- May 2025",
    sub: none,
    cv: (
      [Developed a *multimodal spatiotemporal foundation model* over multispectral satellite imagery for soil-health remote sensing; combined deep learning with statistical priors (Gaussian-process regression, clustering) to produce calibrated predictions.],
    ),
    resume: (),
  ),
  (
    org: "The KeelWorks Foundation", loc: "Oak Harbor, WA (Remote)",
    title: "Software Engineer, ML Applications", dates: "Jul 2024 -- Jan 2025",
    sub: none,
    cv: (
      [Synthetic-data generation research via *Mistral-7B* fine-tuning (back-translation, sequential style representation); agentic LLM systems with RAG pipelines for large-scale document retrieval and question answering.],
    ),
    resume: (
      [Engineered a production *RAG* retrieval-and-reasoning system (TypeScript/Python, LangChain) serving a search API at *\<5 s p95* with *92% context relevance (MRR)* over 2,500+ documents on PostgreSQL.],
      [Reduced model size *50%* and improved inference speed *80%* via *8-bit GPTQ quantization* and distillation while holding *>90%* task accuracy.],
    ),
  ),
)

#let projects = (
  (
    name: [#link("https://github.com/SGIARK/")[ArkOS] — MIT SIPB], dates: "Jun 2025 -- Present",
    body: [Open-source local-LLM agent platform with long-term memory. Lead DevOps and developer documentation (Mintlify): GitHub Actions CI/CD, contributor onboarding, frontend/backend development.],
    key: true,
  ),
  (
    name: [#link("https://github.com/ksd3/rinexpy")[rinexpy]], dates: "2023 -- Present",
    body: [Python library for fast RINEX GNSS reading, merging, clock-jump and higher-order ionospheric correction, and format conversion; a superset of `georinex`.],
    key: true,
  ),
  (
    name: [#link("https://github.com/ksd3/beatqraft/")[BeatQraft] — MIT iQuHACK 2023], dates: "Jan 2023",
    body: [Distributed quantum generative-AI music service; *2nd of 100+ teams* (IBM × Covalent Challenge).],
    key: false,
  ),
)

#let talks = (
  (body: [_The Platonic Universe: Do Foundation Models See the Same Sky?_ (invited, long version)], venue: [#link("https://www.youtube.com/watch?v=NIf-QQikukE")[AstroAI, Harvard CfA, Jan 2026]]),
  (body: [_The Platonic Universe: Do Foundation Models See the Same Sky?_ (oral)], venue: [#link("https://neurips.cc/virtual/2025/loc/san-diego/135877")[NeurIPS ML4PS, Dec 2025]]),
  (body: [_Using high-rate dual-frequency cellphones to study the April 8#super[th] solar eclipse_], venue: [#link("https://cedarscience.org/sites/default/files/2024-posters/IRRI-8-Nina-ServanSchreiber.pdf")[CEDAR Workshop, Jun 2024]]),
  (body: [_Optimizing Solar Panel Tilt using Machine Learning Techniques_], venue: [GPECOM, Dec 2021]),
)

#let awards = (
  (body: [NeurIPS ML4PS 2025 — #underline[*Spotlight Paper* (top 1%)]], year: "2025", key: true),
  (body: [Outstanding Reviewer, ICML 2026 Mechanistic Interpretability Workshop], year: "2026", key: true),
  (body: [MS Ambassador, Boston University ECE Department], year: "2024", key: false),
  (body: [2#super[nd] / 100+ international teams, MIT iQuHack 2023 (IBM × Covalent Challenge)], year: "2023", key: true),
  (body: [Bronze Medalist, Electrical Engineering Dept., College of Engineering Pune], year: "2022", key: false),
)

#let teaching = (
  (
    org: link("https://www.cranephysics.org/")[Computational Research Access NEtwork (CRANE) Physics],
    loc: "Winter 2024, 2025", title: "TA / Mentor", sub: none,
    body: [Signal processing, Python, numerical methods, machine learning, PIC simulations. Wrote tutorial materials and supported students across both cohorts.],
  ),
  (
    org: [ENG EC520 Image Processing (Graduate), Boston University],
    loc: "Spring 2023", title: "Grader",
    sub: [Instructor: Prof. #link("https://www.bu.edu/eng/profile/janusz-konrad/")[Janusz Konrad]],
    body: [Graded problem sets and projects on filtering, compression, reconstruction, and computer-vision algorithms.],
  ),
  (
    org: "COEP Astronomy Club", loc: "Pune, India",
    title: "Head of Projects", sub: none,
    body: [Mentored 30 undergraduates on processing astronomical data, operating telescopes, and building reflector optics. Ran outreach sessions at schools for autistic children.],
  ),
)

// Skills: the CV leads with scientific tooling, the resume with ML systems.
#let skills-cv = (
  ("Astronomy tooling", [AstroPy, HEASoft, NuSTARDAS, Stingray, PHOEBE, GEMINI3D, FITS / HDF5 I/O]),
  ("Scientific Python", [NumPy, SciPy, Matplotlib, pandas, PyTorch, scikit-learn]),
  ("Languages", [Python (primary), C, C++, SQL, MATLAB]),
  ("Statistical and numerical methods", [Bayesian inference (MCMC), spectral-timing analysis, time-series analysis, ODE/PDE solvers, Runge–Kutta]),
  ("Software engineering", [Git / GitHub, GitHub Actions CI/CD, pytest, Sphinx documentation, open-source contribution and code review]),
  ("Instrumentation", [Ansys HFSS, radio receiver chains (RTL-SDR + LNA), antenna design]),
)

#let skills-resume = (
  ("Languages", [Python (primary), C, C++, TypeScript, SQL (Postgres), MATLAB]),
  ("ML / AI", [PyTorch, FSDP, distributed training, RL post-training, VQ-VAE, foundation models / VLMs, RAG, LLM agents, evaluation systems, synthetic data, quantization and distillation]),
  ("Cloud and MLOps", [AWS (EC2, S3, Lambda, SageMaker, EKS), GCP, Docker, Kubernetes, Terraform, Kafka, Dask, Slurm, MLflow]),
  ("Python tooling", [`pyproject.toml`, uv, ruff, pytest, pre-commit, Sphinx, GitHub Actions]),
  ("Methods", [Bayesian inference (MCMC), time-series and spectral analysis, inverse problems, uncertainty quantification, numerical ODE/PDE solvers]),
)

// ============================================================================
//  PART 2 — STYLE
// ============================================================================

#let linkcolor = rgb("#800000")
#let lightsep = text(fill: rgb("999999"))[ | ]

#set page(
  paper: "us-letter",
  margin: if resume { (x: 0.45in, y: 0.4in) } else { (x: 0.5in, top: 0.6in, bottom: 0.6in) },
  footer: if resume { none } else {
    context align(center)[#set text(size: 10pt)
      Page #counter(page).display()]
  },
)

#set text(
  font: "New Computer Modern",
  size: if resume { 9.5pt } else { 11pt },
  lang: "en",
  hyphenate: true,
)

#set par(leading: if resume { 0.55em } else { 0.75em }, justify: not resume)
#show link: set text(fill: linkcolor)

#let sec(title) = {
  v(if resume { 1.5mm } else { 3mm })
  block(sticky: true)[
    #text(size: if resume { 11.5pt } else { 13pt }, weight: "bold")[#smallcaps(title)]
    #v(-6pt)
    #line(length: 100%, stroke: 0.5pt)
  ]
  v(if resume { 1mm } else { 3mm })
}

#let hdr(title, right) = grid(columns: (1fr, auto), strong(title), strong(right))

#let bullets(items) = {
  set text(size: if resume { 9pt } else { 11pt })
  v(-2pt)
  list(
    indent: 0em, body-indent: 0.5em,
    marker: text(size: 0.7em)[•],
    spacing: if resume { 0.4em } else { 0.9em },
    ..items,
  )
  v(if resume { 1pt } else { 2pt })
}

// Render a role block, picking the bullet list for this document.
#let role(r) = {
  let items = if resume { r.resume } else { r.cv }
  if items.len() == 0 { return }
  block(breakable: true)[
    #hdr(r.org, r.loc)
    #emph(r.title) #h(1fr) #r.dates
    #if r.sub != none [ \ #r.sub ]
    #bullets(items)
  ]
  v(if resume { 1mm } else { 2mm })
}

#let pubitem(p) = [
  *#p.title* \
  #p.authors \
  #p.venue
]

// ============================================================================
//  PART 3 — LAYOUT
// ============================================================================

#if not resume {
  place(top + right, dy: -20pt,
    text(fill: gray, size: 8pt, style: "italic")[
      Last updated: #datetime.today().display("[month repr:long] [day], [year]")
    ])
}

#align(center)[
  #text(size: if resume { 22pt } else { 24pt }, weight: "bold")[#smallcaps(contact.name)] \
  #v(-5pt)
  #if not resume [ #contact.location \ #v(3pt) ]
  #if resume [ #contact.location #lightsep ]
  #link("mailto:" + contact.email)[#contact.email]
  #lightsep #link("tel:" + contact.phone-tel)[#contact.phone]
  #lightsep #link("https://" + contact.site)[#contact.site]
  #lightsep #link("https://" + contact.github)[#contact.github]
  #lightsep #link("https://" + contact.linkedin)[LinkedIn]
]

#v(5pt)
#line(length: 100%, stroke: 0.5pt)
#v(-7pt)
#line(length: 100%, stroke: 0.5pt)
#v(if resume { 3pt } else { 10pt })

#if resume {
  // ------------------------------- RESUME -------------------------------
  set text(size: 9pt)
  summary
  set text(size: 9.5pt)

  sec("Experience")
  for r in industry-roles { role(r) }

  sec("Research")
  for r in research-roles { role(r) }

  sec("Selected Publications")
  set enum(spacing: 0.45em)
  for p in publications.filter(p => p.key) [ + #pubitem(p) ]

  sec("Open Source and Projects")
  for p in projects.filter(p => p.key) {
    hdr(p.name, p.dates)
    bullets((p.body,))
  }

  sec("Technical Skills")
  set text(size: 9pt)
  for (label, body) in skills-resume {
    grid(columns: (1.55in, 1fr), strong(label + ":"), body)
  }
  set text(size: 9.5pt)

  sec("Education")
  for e in education [
    #hdr(e.school, e.loc)
    #emph(e.degree) #h(1fr) #e.dates #sym.dot.c GPA: #e.gpa
  ]

  sec("Awards")
  bullets(awards.filter(a => a.key).map(a => [#a.body #h(1fr) #a.year]))

} else {
  // --------------------------------- CV ---------------------------------
  sec("Education")
  for e in education [
    #hdr(e.school, e.loc)
    #emph(e.degree) #h(1fr) #e.dates \
    #e.detail
    Degree GPA: #e.gpa \
    #text(size: 9.5pt)[#emph[Selected coursework:] #e.coursework]
    #v(2mm)
  ]

  sec("Research Interests")
  research-interests

  sec("Publications")
  set enum(spacing: 1em)
  for p in publications [ + #pubitem(p) ]

  sec("Theses")
  for t in theses [ + #pubitem(t) ]

  sec("Research Experience")
  for r in research-roles { role(r) }

  sec("Industry Research Experience")
  for r in industry-roles { role(r) }

  sec("Open Source and Projects")
  for p in projects {
    hdr(p.name, p.dates)
    bullets((p.body,))
  }

  sec("Selected Talks and Posters")
  bullets(talks.map(t => [#t.body #h(1fr) #t.venue]))

  sec("Awards and Honors")
  bullets(awards.map(a => [#a.body #h(1fr) #a.year]))

  sec("Teaching, Mentoring, and Open-Source Community")
  for t in teaching {
    hdr(t.org, t.loc)
    emph(t.title)
    if t.sub != none [ \ #t.sub ]
    bullets((t.body,))
    v(2mm)
  }

  sec("Key Skills")
  for (label, body) in skills-cv [
    *#label:* #body
    #v(1mm)
  ]

  sec("Schools and Workshops")
  hdr("Inter-University Center for Astronomy and Astrophysics (IUCAA)", "Pune, India")
  emph("Introductory Summer School in Astronomy and Astrophysics")
  h(1fr)
  [May -- Jun 2020]

  sec("Review Experience")
  bullets((
    [ICML 2026 Mechanistic Interpretability Workshop — #underline[Outstanding Reviewer]],
    [United States Research Software Engineer Conference (US-RSE) #h(1fr) 2025, 2026],
  ))
}
