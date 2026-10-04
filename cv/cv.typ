// Academic CV — compiled by the _quarto.yml pre-render hook into docs/cv/cv.pdf.

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
  lang: "en",
  hyphenate: true
)

#set par(leading: 0.75em, justify: true)

#set list(marker: text(size: 0.7em)[•], indent: 0.5em, body-indent: 0.5em, spacing: 0.9em)

#show link: set text(fill: linkcolor)

// --- CUSTOM FUNCTIONS ---
#let cvsection(title) = {
  v(3mm)
  block(sticky: true)[
    #text(size: 13pt, weight: "bold")[#smallcaps(title)]
    #v(-6pt)
    #line(length: 100%, stroke: 0.5pt)
  ]
  v(3mm)
}

#let entry_header(title, location) = {
  grid(
    columns: (1fr, auto),
    strong(title), strong(location)
  )
}

// --- CONTENT START ---
#place(
  top + right,
  dy: -20pt,
  text(fill: gray, size: 8pt, style: "italic")[
    Last updated: #datetime.today().display("[month repr:long] [day], [year]")
  ]
)

#align(center)[
  #text(size: 24pt, weight: "bold")[#smallcaps("Kshitij Duraphe")] \
  #v(-5pt)

  Boston, MA \
  #v(3pt)

  #link("mailto:kshitijd@bu.edu")[kshitijd\@bu.edu]
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

// --- EDUCATION ---
#cvsection("Education")

#entry_header("Boston University", "Boston, MA")
_M.S., Electrical and Computer Engineering (with Thesis)_ #h(1fr) Sep 2022 -- May 2024 \
Advisor: Prof. #link("https://www.bu.edu/eng/profile/joshua-semeter/")[Joshua Semeter] \
Degree GPA: 3.8/4.0 \
#text(size: 9.5pt)[#emph[Selected coursework:] Cosmic Plasma Physics #sym.dot.c Fourier Optics #sym.dot.c Quantum Mechanics and Semiconductor Physics #sym.dot.c Quantum Computing #sym.dot.c Signal Processing #sym.dot.c Machine Learning #sym.dot.c Advanced Algorithms #sym.dot.c Advanced Discrete Mathematics]

#v(2mm)

#entry_header("College of Engineering Pune", "Pune, India")
_B.Tech., Electrical Engineering (Minor: Computer Science)_ #h(1fr) Aug 2018 -- June 2022 \
Advisors: Prof. Archana Thosar, Prof. Suhas Kakade \
GPA: 9.11/10.0 (#underline[Department Bronze Medalist]) \
#text(size: 9.5pt)[#emph[Selected coursework:] Probability Theory and Statistical Inference #sym.dot.c Optics and Modern Physics #sym.dot.c Electromagnetism #sym.dot.c Numerical Methods #sym.dot.c Vector Calculus #sym.dot.c Partial Differential Equations #sym.dot.c Ordinary Differential Equations #sym.dot.c Complex Analysis]

// --- RESEARCH INTERESTS ---
#cvsection("Research Interests")

High-Energy Astrophysics; Foundation Models; Mechanistic Interpretability; Space Physics; Time-Domain Astrophysics.

// --- PUBLICATIONS ---
#cvsection("Publications")

#set enum(spacing: 1em)

+ *Shared Geometry Is Not Shared Physics: A Layerwise Test of the Platonic Representation Hypothesis in Astronomy* \
  #strong[#emph[K. Duraphe]], A. Kannappan, D. L. Chan, O. Famutimi, Y. Ejjagiri, M. J. Smith, J. F. Wu \
  #link("https://openreview.net/forum?id=Xw72C0uPBw&noteId=i1OgmXMjDM")[NeurIPS Interp4Discovery Workshop, 2026]


+ *State-Dependent X-ray Variability in Cygnus X-1: A 12-Year NuSTAR Timing Study of Accretion Flow Geometry* \
  #strong[#emph[K. Duraphe]], G. Bhatta, K. Mandar, C. Khanal, et al. \
  #link("https://arxiv.org/abs/2510.10746")[The Astrophysical Journal], 2026

+ *A NuSTAR Reflection-Spectroscopy Survey of Cygnus X-1 * \
  #strong[#emph[K. Duraphe]], G. Bhatta, et al. \
  Submitted to The Astrophysical Journal, 2026
 
+ *What AstroPT knows about galaxies, and what that can teach us about LLMs* \
  #strong[#emph[K. Duraphe]], A. Kumar, S. Sourav, M. J. Smith \
  #link("https://arxiv.org/abs/2608.22614")[COLM Sci-FM Workshop, 2026]

+ *Smartphone Carrier Phase TEC: A Study Across Ionospheric Spatio-Temporal Scales* \
  N. Servan-Schreiber, J. Semeter, #strong[#emph[K. Duraphe]], et al. \
  #link("https://essopenarchive.org/users/1006611/articles/1370630-smartphone-carrier-phase-tec-a-study-across-ionospheric-spatio-temporal-scales")[Space Weather], 2026

+ *The Platonic Universe: Do Foundation Models See the Same Sky?* \
  #strong[v1:] #strong[#emph[K. Duraphe]], M. J. Smith, J. F. Wu, S. Sourav #emph[(co-first author)] \
  #link("https://arxiv.org/abs/2509.19453v1")[NeurIPS ML4PS Workshop, 2025] — #underline[Spotlight (top 1%)]\
  #strong[v2:] T. Borrell, S. Dillmann, #strong[#emph[K. Duraphe]], F. Eris, K. Iyer, A. Khederlarian, A. Kumar, G. Marraffini, M. J. Smith, S. Sourav, R. Di Tella, J. F. Wu  (submitted to ICLR 2027 main track)

+ *Optimizing Solar Panel Tilt using Machine Learning Techniques* \
  #strong[#emph[K. Duraphe]], S. Kakade, et al. \
  #link("https://ieeexplore.ieee.org/document/9587892/")[GPECOM], 2021

// --- THESES ---
#cvsection("Theses")

+ *Data-Driven Techniques to Advance Our Understanding of the STEVE Phenomenon* \
  #strong[#emph[Kshitij Duraphe]], Joshua Semeter \
  M.S. Thesis, Department of Electrical and Computer Engineering, Boston University, 2024

+ *Design of an Automated Radio Telescope for Observing the 21 cm Hydrogen Line* \
  #strong[#emph[Kshitij Duraphe]], Archana Thosar \
  B.Tech. Thesis, Department of Electrical Engineering, College of Engineering Pune, 2022

// --- RESEARCH EXPERIENCE ---
#cvsection("Research Experience")

#entry_header("University of Zielona Góra", "Zielona Góra, Poland (Remote)")
#emph("Research Assistant") #h(1fr) Mar 2025 -- Present \
Advisor: Prof. #link("https://inspirehep.net/authors/1722470")[Gopal Bhatta]

- #underline[First-authored] a 12-year NuSTAR archival timing study of Cygnus X-1 (#emph[The Astrophysical Journal], 2026), mapping accretion-flow geometry across spectral states via hard X-ray spectral-timing analysis.
- Identified a previously unrecognized failed state transition and characterized state-dependent variability (power spectra, rms-flux relations, lag-frequency spectra), placing direct constraints on the corona–disk geometry near the black hole.
- Reduced and analyzed the complete public NuSTAR Cyg X-1 archive with HEASoft / NuSTARDAS / Stingray / AstroPy; led manuscript writing and referee response.
- Currently leading a follow-up multi-epoch *spectral* study of Cyg X-1 with submitted to #emph[The Astrophysical Journal] (#link("https://arxiv.org/pdf/2608.15902")[link]), characterizing coronal and reflection properties across spectral states and investigating the potential failed state transition.

#v(2mm)

#entry_header("UniverseTBD Collaboration", "Remote")
#emph("Researcher") #h(1fr) Jul 2024 -- Present \
Collaborators: Dr. #link("https://mjjsmith.com")[Michael J. Smith], Dr. #link("https://jwuphysics.github.io/")[John F. Wu]

- #underline[First author] on #emph[The Platonic Universe] (#underline[*Spotlight*, top 1%] at NeurIPS ML4PS 2025; expanded 12-author version submitted to ICLR 2027 main track). Designed the evaluation framework comparing foundation-model representations across eleven model families from 10M to 10B parameters on JWST, HSC, and Legacy Survey imaging and DESI spectroscopy under model and data scaling; showed that physics performance tracks #emph[local] embedding geometry (mutual #emph[k]-NN) but not #emph[global] similarity (CKA), motivating an #emph[Aristotelian] rather than Platonic Representation Hypothesis.
- #underline[First author] on #emph[What AstroPT knows about galaxies, and what that can teach us about LLMs] (Sci-FM Workshop, COLM 2026). Probed frozen AstroPT representations across checkpoints, depths, model sizes, and training objectives; found that galaxy properties emerge in a fixed order tracking their known physical difficulty — pixel-measurable properties early and shallow, inferred properties later and deeper — with the ordering stable across objectives and scales.
- #underline[First author] on #emph[Shared Geometry Is Not Shared Physics: A Layerwise Test of the Platonic Representation Hypothesis in Astronomy] (NeurIPS Interpretability for Discovery Workshop, 2026), separating layerwise where representations agree geometrically from where they agree physically. *Mentored 4 junior researchers* as part of #link("https://eleuther.ai")[EleutherAI]'s SOAR 2026 program.
- Earlier extension of the Platonic Universe work accepted to the ICML 2026 Mechanistic Interpretability Workshop, where I served as an #underline[Outstanding Reviewer].
- Creator of the open-source #link("https://github.com/UniverseTBD/platonic-universe")[platonic-universe] package (Python / PyTorch): data loaders, evaluation harness, reproducible configs, test infrastructure.
- Invited #link("https://www.youtube.com/watch?v=NIf-QQikukE")[AstroAI talk at the Harvard Center for Astrophysics] (Jan 2026) and #link("https://neurips.cc/virtual/2025/loc/san-diego/135877")[NeurIPS ML4PS oral presentation] (Dec 2025). Spotlight award (top 1% paper) NeurIPS ML4PS 2025.
- Used NCSA DeltaAI compute allocation *PHY250286* — _The Platonic Universe: Do Foundation Models See the Same Sky?_ — 6,000 GPU-hours (PI: M. J. Smith; Sep 2025 -- Sep 2026); actively running training and evaluation experiments under the allocation.

#v(2mm)

#entry_header("Space Physics Lab, Boston University", "Boston, MA")
#emph("Graduate Research Assistant") #h(1fr) Oct 2022 -- May 2024 \
Advisor: Prof. Joshua Semeter

#emph[MS Thesis: Data-Driven Techniques for STEVE] #h(1fr) Jul 2023 -- May 2024

- Characterized #link("https://en.wikipedia.org/wiki/STEVE")[STEVE] morphology and kinetics from high-resolution citizen-science imagery; developed computer-vision tracking methods that quantified distinct westward velocities for columnar (~13 km/s) and picket-fence (~1 km/s) features.
- Developed and contributed to various open-source Python and C++ libraries for high-cadence GNSS carrier-phase processing and Total Electron Content (TEC) analysis; identified a candidate two-stage TEC signature of STEVE passage distinct from typical substorms.
- Developed automated STEVE detection for noisy All-Sky Imager data by adapting faint-source astronomical algorithms and evaluating deep-learning models (ConvNeXt), with modular superresolution, inpainting, and time-series classification components.

#emph[NASA Life on Mars Initiative - BU Center for Computing and Data Sciences] #h(1fr) Jul 2023 -- Jan 2024

- Developed GPS-signal propagation models and spatiotemporal interpolation of sparse Martian-ionosphere TEC data (classical and deep-learning baselines) from MARSIS.

#emph[MS Project — Plasma Dynamics of STEVE] #h(1fr) Oct 2022 -- May 2023

- Ran 3D forward-modeling simulations of the ionospheric plasma regime conducive to STEVE formation using the open-source GEMINI3D fluid-electrodynamic model; analyzed density structures, temperature enhancements, and flow shears driven by STEVE-like conditions.

#v(2mm)

#entry_header("IIT Bombay", "Mumbai, India")
#emph("Research Intern — Bayesian Binary-Star Analysis") #h(1fr) May 2021 -- Aug 2021

- Performed Bayesian analysis of the eclipsing binary #link("https://arxiv.org/pdf/2107.10954")[QX Cas] using PHOEBE and MCMC; developed a custom 3-body dynamics simulator with a differential-evolution solver to constrain parameters of a hypothesized tertiary companion.

#v(2mm)

#entry_header("College of Engineering Pune", "Pune, India")
#emph("Undergraduate Research Assistant") #h(1fr) Jan 2021 -- May 2022 \
Advisors: Prof. Archana Thosar, Prof. Suhas Kakade

#block(breakable: false)[
  #emph[Signal Processing Lab — Data-Driven Solar Panel Tilt Optimization] #h(1fr) Jan 2021 -- Apr 2021 \
  Advisor: Prof. Suhas Kakade

  - Formulated optimal solar-panel tilt as a regression problem over multi-year irradiance and meteorological time-series; benchmarked gradient-boosted, kernel-based, and shallow-network estimators against the standard latitude-based heuristic.
  - Showed measurable energy-yield gains across heterogeneous Indian and American climatological zones; first-authored the resulting publication at #link("https://ieeexplore.ieee.org/document/9587892/")[IEEE GPECOM 2021].
]

#emph[B.Tech. Thesis: 21 cm Radio Telescope] #h(1fr) Aug 2021 -- May 2022

- Designed and built a high-gain (~20 dB) pyramidal horn radio telescope for 21 cm hydrogen-line observations (Ansys HFSS-simulated waveguide/feed).
- Integrated RTL-SDR + LNA front-end with *Python and C++* WOLA-FFT spectral-analysis software (#link("https://github.com/jobgeheniau/VIRGO")[VIRGO] spectrometer-based); recovered a partial galactic rotation curve from 21 cm emission.

#v(2mm)

#entry_header("Naxxatra Equinox Initiative", "Bangalore, India")
#emph("Research Intern — Stellar Structure and Compact Objects") #h(1fr) Jul 2020 -- Oct 2020

- Derived the equations of stellar structure incorporating hydrostatic equilibrium and relativistic electron-degeneracy pressure; numerically solved the coupled ODEs with a 4#super[th]-order Runge-Kutta scheme in Python to compute the white-dwarf mass-radius relation and determine the Chandrasekhar limit.

// --- TALKS ---
#cvsection("Selected Talks and Posters")

- _The Platonic Universe: Do Foundation Models See the Same Sky?_ (invited, long version) #h(1fr) #link("https://www.youtube.com/watch?v=NIf-QQikukE")[AstroAI, Harvard CfA, Jan 2026]
- _The Platonic Universe: Do Foundation Models See the Same Sky?_ (oral) #h(1fr) #link("https://neurips.cc/virtual/2025/loc/san-diego/135877")[NeurIPS ML4PS, Dec 2025]
- _Using high-rate dual-frequency cellphones to study the April 8#super[th] solar eclipse_ #h(1fr) #link("https://cedarscience.org/sites/default/files/2024-posters/IRRI-8-Nina-ServanSchreiber.pdf")[CEDAR Workshop, Jun 2024]
- _Optimizing Solar Panel Tilt using Machine Learning Techniques_ #h(1fr) GPECOM, Dec 2021

// --- AWARDS ---
#cvsection("Awards and Honors")

- NeurIPS ML4PS 2025 — #underline[*Spotlight Paper* (top 1%)] #h(1fr) 2025
- MS Ambassador, Boston University ECE Department #h(1fr) 2024
- 2#super[nd] / 100+ international teams, MIT iQuHack 2023 (IBM x Covalent Challenge) #h(1fr) 2023
- Bronze Medalist, Electrical Engineering Department, College of Engineering Pune #h(1fr) 2022

// --- TEACHING AND COMMUNITY ---
#cvsection("Teaching, Mentoring, and Open-Source Community")

#entry_header(link("https://www.cranephysics.org/")[Computational Research Access NEtwork (CRANE) Physics], "Winter 2024, 2025")
#emph("TA / Mentor")

- Topics: signal processing, Python, numerical methods, machine learning, PIC simulations. Wrote tutorial materials and supported students during hands-on sessions across both cohorts.

#v(2mm)

#entry_header("ENG EC520 Image Processing (Graduate Course), Boston University", "Spring 2023")
#emph("Grader") \
Instructor: Prof. #link("https://www.bu.edu/eng/profile/janusz-konrad/")[Janusz Konrad]

- Graded problem sets and projects on filtering, compression, reconstruction, and computer-vision algorithms for a graduate-level image-processing course.

#v(2mm)

#entry_header([#link("https://github.com/SGIARK/")[ArkOS] — MIT Student Information Processing Board (SIPB)], "Cambridge, MA")
#emph("Contributor — DevOps and Documentation") #h(1fr) 2025 -- Present

- Lead DevOps and documentation for an open-source local-LLM agent platform; maintain GitHub Actions CI/CD, contributor onboarding, and developer-facing documentation.

#v(2mm)

#entry_header([#link("https://github.com/ksd3/rinexpy")[rinexpy] — GNSS/RINEX processing library], "Boston, MA")
#emph("Author and Maintainer") #h(1fr) 2023 -- Present

- Python library for fast RINEX reading and access, written for high-cadence GNSS carrier-phase work and released as a superset of #link("https://github.com/geospace-code/georinex")[georinex]: merging and header/observation-type editing, automatic clock-jump detection and correction, higher-order ionospheric corrections, BINEX and RTCM conversion, and an interactive web-based file viewer.

#v(2mm)

#entry_header("COEP Astronomy Club", "Pune, India")
#emph("Head of Projects") #h(1fr) 2018 -- 2022

- Mentored 30 undergraduates on processing astronomical data, operating telescopes, and building reflector optics.
- Ran outreach sessions at schools for autistic children on identifying constellations in the night sky.

// --- KEY SKILLS ---
#cvsection("Key Skills")

*Astronomy tooling:* AstroPy, HEASoft, NuSTARDAS, Stingray, PHOEBE, GEMINI3D, FITS / HDF5 I/O

*Scientific Python ecosystem:* NumPy, SciPy, Matplotlib, pandas, PyTorch, scikit-learn

*Languages:* Python (primary), C, C++, SQL, MATLAB

*Statistical and numerical methods:* Bayesian inference (MCMC), spectral-timing analysis, time-series analysis, ODE/PDE numerical solvers, Runge–Kutta

*Software engineering:* Git / GitHub, GitHub Actions CI/CD, pytest, Sphinx-style documentation, open-source contribution and code review

*Instrumentation:* Ansys HFSS, radio receiver chains (RTL-SDR + LNA), antenna design

// --- INDUSTRY RESEARCH EXPERIENCE ---
#cvsection("Industry Research Experience")

#entry_header("Position Imaging", "Stratham, NH")
#emph("Machine Learning Engineer") #h(1fr) May 2026 -- Present

- Developed and productionized *graph neural networks* for RFID localization in multipath-dominated environments, owning the full stack from model architecture and training through GPU optimization, edge deployment, and production monitoring.
- Designed training systems using *reinforcement learning* and *neural surrogate models* to optimize computationally expensive GNN workloads and make large sweeps over architectures and training strategies affordable.
- Wrote custom *CUDA kernels* and GPU-level optimizations for performance-critical components of GNN training and inference; built edge inference pipelines covering model compilation, graph/operator optimization, hardware-specific acceleration, and integration with custom inference runtimes.
- Built the group's internal *ML experimentation platform* (ClearML, Azure, Datadog) for reproducible training, model evaluation, and rapid iteration, sustaining *30+ experiments/day*; added production observability for model behaviour, inference performance, and system health.

#v(2mm)

#entry_header("Thespian Labs", "Somerville, MA")
#emph("AI Engineer") #h(1fr) Nov 2025 -- Feb 2026

- Developed state-of-the-art *Text2Motion* foundation models using *VQ-VAE* motion tokenization; ran multimodal pre-training on 5000+ hours of human-performance time-series and DARTControl-style *reinforcement-learning post-training* for controllable motion synthesis.
- Released the open-source MLOps library #link("https://github.com/ksd3/jobber")[jobber] for programmatic research-job submission to cloud platforms.

#v(2mm)

#entry_header("Absentia Technologies", "Boston, MA")
#emph("Founding Machine Learning Engineer") #h(1fr) Jan 2025 -- Nov 2025

- Developed state-of-the-art *vision-language models (VLMs)* for multimodal video understanding; combined large-scale pre-training with *supervised fine-tuning and alignment post-training* on domain-specific data.
- Implemented distributed training pipelines with *PyTorch FSDP* (multi-GPU, mixed-precision) to train foundation models beyond single-device memory, handling sharding, checkpointing, and fault recovery.

#v(2mm)

#entry_header("Halo AI (Columbia-incubated stealth)", "New York, NY (Remote)")
#emph("Founding AI Engineer") #h(1fr) Dec 2023 -- Aug 2024

- Researched on-device *federated* and *ensemble* LLMs for agentic assistants under tight compute and memory constraints, including ablations on federated-aggregation strategies.
- Systematic study of *model-compression* techniques — pruning, knowledge distillation, and 8-bit post-training quantization — and their trade-offs for latency, memory footprint, and task accuracy (50% size reduction, 80% inference speedup, 90% accuracy retention).

#v(2mm)

#entry_header("Spatialise", "Noordwijk, The Netherlands (Remote)")
#emph("Geospatial Machine Learning Engineer") #h(1fr) Feb 2025 -- May 2025

- Developed a *multimodal spatiotemporal foundation model* over multispectral satellite imagery for soil-health remote sensing; combined deep learning with statistical priors (Gaussian-process regression, clustering) to produce calibrated predictions.

#v(2mm)

#entry_header("The KeelWorks Foundation", "Oak Harbor, WA (Remote)")
#emph("Software Engineer, ML Applications") #h(1fr) Jul 2024 -- Jan 2025

- Synthetic-data generation research via *Mistral-7B* fine-tuning (back-translation, sequential style representation); agentic LLM systems with RAG pipelines for large-scale document retrieval and question answering.

// --- ASTRONOMY SCHOOLS AND WORKSHOPS ---
#cvsection("Astronomy Schools and Workshops")

#entry_header("Inter-University Center for Astronomy and Astrophysics (IUCAA)", "Pune, India")
#emph("Introductory Summer School in Astronomy and Astrophysics") #h(1fr) May -- Jun 2020

// --- REVIEW EXPERIENCE ---
#cvsection("Review Experience")

- United States Research Software Engineer Conference (US-RSE) #h(1fr) 2025, 2026
