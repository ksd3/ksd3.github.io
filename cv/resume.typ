// Full Resume - Kshitij Duraphe
// Compile with: quarto typst compile resume.typ resume.pdf

#let linkcolor = rgb("#800000") // Maroon
#let lightsep = text(fill: rgb("999999"))[ | ]

#set page(
  paper: "us-letter",
  // EXACT LATEX MARGINS: 0.4in sides, 0.3in top/bottom
  margin: (x: 0.4in, y: 0.3in),
  footer: context [
    #align(center)[
      #set text(size: 9pt)
    ]
  ]
)

#set text(
  font: "New Computer Modern",
  size: 10pt, // Base size 10pt
  lang: "en"
)

#show link: set text(fill: linkcolor)

// --- CUSTOM FUNCTIONS ---

// 1. CV Section Header (Size 12pt)
#let cvsection(title) = {
  v(3pt)
  block(sticky: true)[
    #text(size: 12pt, weight: "bold")[#smallcaps(title)]
    #v(-8pt)
    #line(length: 100%, stroke: 0.5pt)
  ]
  v(1pt)
}

// 2. Entry Layout
#let entry_header(title, location) = {
  grid(
    columns: (1fr, auto),
    strong(title), strong(location)
  )
}

// 3. Skills Grid Helper
#let skill_entry(category, skills) = {
  grid(
    columns: (2in, 1fr),
    gutter: 0pt,
    strong(category), skills
  )
}

// 4. Custom List Helper (Sets text to 9pt)
#let resume_list(body) = {
  set text(size: 9pt) // Force bullet points to 9pt
  v(-3pt) // Tighten space between job title and list
  list(indent: 0em, body-indent: 0.5em, spacing: 0.35em, marker: [], body)
  v(2pt) // Spacer after list
}

// --- CONTENT START ---

// Main Header
#align(center)[
  // NAME SIZE: 25pt
  #text(size: 25pt, weight: "bold")[#smallcaps("Kshitij Duraphe")] \
  #v(-6pt)
  Boston, MA |
  #link("mailto:kshitijduraphe5@gmail.com")[kshitijduraphe5\@gmail.com]
  #lightsep
  #link("https://www.linkedin.com/in/kshitij-duraphe/")[LinkedIn]
  #lightsep
  #link("https://github.com/ksd3")[Github]
  #lightsep
  #link("https://ksd3.github.io/")[Portfolio]
  #lightsep
  #link("tel:3148863066")[314-886-3066]
]

#v(-6pt)
#line(length: 100%, stroke: 0.5pt)
#v(-9pt)
#line(length: 100%, stroke: 0.5pt)
#v(-5pt)

// --- SUMMARY ---
#set text(size: 9pt)
Machine learning engineer working across the full model stack — custom *CUDA kernels* and GPU optimization,
*distributed training*, *RL post-training*, and edge inference — with a parallel research record in
*mechanistic interpretability* and *foundation-model evaluation*. First author on three 2026 interpretability
papers; co-first author on a #underline[NeurIPS ML4PS 2025 Spotlight] (top 1%); first author in
#emph[The Astrophysical Journal]. M.S. Boston University.
#set text(size: 10pt)

// --- PROFESSIONAL EXPERIENCE ---

#cvsection("Professional Experience")

// Position Imaging
#entry_header("Position Imaging", "Stratham, NH")
#emph("Machine Learning Engineer") #h(1fr) May 2026 -- Present

#resume_list[
  - Developed and productionized *graph neural networks* for RFID localization in multipath-dominated environments, owning the end-to-end stack: architecture, training, GPU optimization, edge deployment, and production monitoring.
  - Wrote custom *CUDA kernels* and GPU-level optimizations for performance-critical paths in GNN training and inference.
  - Built the team's internal *ML experimentation platform* (ClearML, Azure, Datadog) for reproducible training and evaluation, sustaining *30+ experiments/day*.
  - Designed training systems using *reinforcement learning* and *neural surrogate models* to cut the cost of computationally expensive GNN workloads, making large sweeps over architectures and training strategies affordable.
  - Built edge inference pipelines end to end — model compilation, graph/operator optimization, hardware-specific acceleration, and integration with custom inference runtimes.
  - Developed production *ML observability* infrastructure for model behaviour, inference performance, and system health, giving product and support teams tooling to diagnose deployed models.
]

// Thespian Labs
#entry_header("Thespian Labs", "Somerville, MA")
#emph[AI Engineer — Foundation Models and RL Post-Training] #h(1fr) Nov 2025 -- Feb 2026

#resume_list[
  - Trained *Text2Motion* foundation models with *VQ-VAE* tokenization; ran multimodal pre-training over 5000+ hours of human-performance time-series on GCP.
  - Implemented DARTControl-style *reinforcement-learning post-training* for controllable motion synthesis, including reward modeling and rollout infrastructure.
  - Released the open-source MLOps library #link("https://github.com/ksd3/jobber")[jobber] for programmatic research-job submission to cloud GPU platforms.
]

// Absentia Technologies
#entry_header("Absentia Technologies", "Boston, MA")
#emph("Founding Machine Learning Engineer") #h(1fr) Jan 2025 -- Nov 2025

#resume_list[
  - Implemented *distributed training* with PyTorch *FSDP* (multi-GPU, mixed precision, sharding, checkpointing, fault recovery) to train vision-language models beyond single-device memory.
  - Established an automated *evaluation pipeline* benchmarking model accuracy and API latency; reduced regressions *40%* and raised production stability to *99.9%*, including diagnosing a production memory leak on call.
  - Architected the production platform on AWS from scratch with Terraform and Docker CI/CD, cutting deployment cycles from days to *\<2 hours*; built a diffusion-based synthetic-data pipeline that reduced false positives *15%*.
]

// KeelWorks + Halo AI, compressed
#entry_header("The KeelWorks Foundation", "Oak Harbor, WA (Remote)")
#emph("Software Engineer, ML Applications") #h(1fr) Jul 2024 -- Jan 2025

#resume_list[
  - Reduced model size *50%* and improved inference speed *80%* via *8-bit GPTQ quantization* and knowledge distillation while holding *>90%* task accuracy; fine-tuned *Mistral-7B* for synthetic-data generation.
]

#entry_header("Halo AI (Columbia-incubated stealth)", "New York, NY (Remote)")
#emph("Founding AI Engineer") #h(1fr) Dec 2023 -- Aug 2024

#resume_list[
  - Researched on-device *federated* and *ensemble* LLMs under tight compute and memory budgets; systematic study of pruning, distillation, and post-training quantization trade-offs across latency, footprint, and accuracy.
]

// --- RESEARCH ---

#cvsection("Research")

#entry_header("UniverseTBD Collaboration", "Remote")
#emph[Researcher — Interpretability and Foundation-Model Evaluation] #h(1fr) Jul 2024 -- Present

#resume_list[
  - #underline[Co-first author] on #emph[The Platonic Universe] (#underline[*Spotlight*, top 1%] at NeurIPS ML4PS 2025; expanded version submitted to ICLR 2027). Designed the representational-alignment *evaluation framework* over eleven model families from 10M to 10B parameters across JWST, HSC, Legacy Survey imaging and DESI spectroscopy; showed physics performance tracks *local* embedding geometry (mutual #emph[k]-NN) but not *global* similarity (CKA).
  - #underline[First author] on two further interpretability papers (Sci-FM @ COLM 2026; NeurIPS Interpretability for Discovery 2026), establishing that model capabilities emerge in a fixed order tracking their physical difficulty, and separating layerwise where representations agree geometrically from where they agree physically.
  - Creator and maintainer of #link("https://github.com/UniverseTBD/platonic-universe")[platonic-universe]: survey-aware loaders, reproducible eval harness, configs, CI. Run on a *6,000 GPU-hour* NCSA DeltaAI allocation (PHY250286).
  - #underline[Outstanding Reviewer], ICML 2026 Mechanistic Interpretability Workshop. Invited talks at Harvard CfA (AstroAI, Jan 2026) and NeurIPS ML4PS (oral, Dec 2025).
]

#entry_header("Space Physics Lab, Boston University", "Boston, MA")
#emph("Graduate Research Assistant") #h(1fr) Oct 2022 -- May 2024

#resume_list[
  - Reconstructed corrupted sensor data with *generative inpainting* and *SwinIR super-resolution*, improving signal-to-noise for downstream models by over *60%*; M.S. thesis on deep learning over noisy all-sky imagery.
  - Architected distributed ingestion (Kafka, Dask, S3) cutting processing of 3 TB+ datasets from *>24 h* to *\<3 h*; built a forecasting service at *\<80 ms p90* and 25 predictions/sec via async batching.
]

// --- PUBLICATIONS ---

#cvsection("Selected Publications")
#set text(size: 9pt)
#set enum(spacing: 0.4em)

+ #strong[#emph[K. Duraphe]], et al. #emph[Shared Geometry Is Not Shared Physics: A Layerwise Test of the Platonic Representation Hypothesis in Astronomy.] #link("https://openreview.net/forum?id=Xw72C0uPBw")[NeurIPS Interpretability for Discovery Workshop], 2026.

+ #strong[#emph[K. Duraphe]], A. Kumar, S. Sourav, M. J. Smith. #emph[What AstroPT knows about galaxies, and what that can teach us about LLMs.] #link("https://arxiv.org/abs/2608.22614")[Sci-FM Workshop, COLM], 2026.

+ #strong[#emph[K. Duraphe]], M. J. Smith, J. F. Wu, S. Sourav #emph[(co-first)]. #emph[The Platonic Universe: Do Foundation Models See the Same Sky?] #link("https://arxiv.org/abs/2509.19453")[NeurIPS ML4PS Workshop], 2025 --- #underline[*Spotlight (top 1%)*]. Expanded version submitted to ICLR 2027.

+ #strong[#emph[K. Duraphe]], G. Bhatta, et al. #emph[State-Dependent X-ray Variability in Cygnus X-1: A 12-Year NuSTAR Timing Study.] #link("https://arxiv.org/abs/2510.10746")[The Astrophysical Journal], 2026.

#set text(size: 10pt)

// --- OPEN SOURCE ---

#cvsection("Open Source")
#set text(size: 9pt)
#skill_entry([#link("https://github.com/UniverseTBD/platonic-universe")[platonic-universe]], [Foundation-model representational-alignment evaluation framework for astronomy.])
#skill_entry([#link("https://github.com/ksd3/rinexpy")[rinexpy]], [Fast RINEX/GNSS reading and correction library; superset of `georinex`.])
#skill_entry([#link("https://github.com/ksd3/jobber")[jobber]], [Declarative job submission to cloud GPU providers.])
#skill_entry([#link("https://github.com/SGIARK/")[ArkOS] (MIT SIPB)], [DevOps and documentation for an open-source local-LLM agent platform.])
#set text(size: 10pt)

// --- TECHNICAL SKILLS ---

#cvsection("Technical Skills")

#set grid(row-gutter: 0.5em)
#set text(size: 9pt)

#skill_entry("Languages:", [Python (primary), C, C++, CUDA, TypeScript, SQL (Postgres)])
#skill_entry("ML systems:", [PyTorch, FSDP, distributed training, custom CUDA kernels, GPU profiling, quantization (GPTQ, 8-bit), distillation, edge inference and model compilation, RL post-training, VQ-VAE, GNNs, VLMs])
#skill_entry("Infrastructure:", [ClearML, MLflow, Slurm, Kubernetes, Docker, Terraform, Azure, AWS, GCP, Kafka, Dask, Datadog, GitHub Actions])
#skill_entry("Methods:", [Evaluation design and measurement, representational analysis (CKA, mutual #emph[k]-NN), Bayesian inference (MCMC), uncertainty quantification, time-series and spectral analysis, inverse problems])

#set text(size: 10pt)

// --- EDUCATION ---

#cvsection("Education")

#entry_header("Boston University", "Boston, MA")
Master of Science with Thesis in Electrical and Computer Engineering #h(1fr) Sep 2022 -- May 2024 #sym.dot.c GPA: 3.8/4

#entry_header("College of Engineering Pune", "Pune, India")
Bachelor of Technology in Electrical Engineering, Minor in CS #h(1fr) Aug 2018 -- June 2022 #sym.dot.c GPA: 3.83/4
