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

// --- PROFESSIONAL EXPERIENCE ---

#cvsection("Professional Experience")

// Thespian Labs
#entry_header("Thespian Labs", "Somerville, MA")
#emph("AI Engineer") #h(1fr) Nov 2025 -- Present

#resume_list[
  - Managed the lifecycle of custom *Text2Motion* deep learning models from development, deployment, and monitoring, ensuring optimal performance and stability on *GCP*. Published an open-source library for MLOps: #link("https://github.com/ksd3/jobber")[Link].
  - Developed and maintained batch processing ETL pipelines for data processing of *5000+* hours of human performance data.
  - Collaborated with *cross-functional teams* to build a SOTA *foundation model* for *controllable digital human performance generation* on the frontier of *human-computer interaction*.
]

// Absentia Technologies
#entry_header("Absentia Technologies", "Boston, MA")
#emph("Founding Machine Learning Engineer") #h(1fr) Jan 2025 -- Nov 2025

#resume_list[
  - Architected and deployed a production-ready SaaS video analysis platform from the ground up on AWS, establishing core AI service infrastructure and a full CI/CD pipeline with Terraform and Docker, reducing deployment cycles from days to *\<2 hours*.
  - Built the core infrastructure and APIs enabling a fleet of autonomous *AI agents* to *read* video streams, *understand* complex events through a reasoning engine, and *act* by flagging anomalies in real-time using Python, PyTorch, and Kafka on Kubernetes (K8S).
  - Engineered the platform's high-performance inference service for computer vision models (ViM/SwinV2), achieving *\<10ms p99 latency* through model quantization and optimized data loaders.
  - Established a rigorous, automated *evaluation pipeline* to benchmark agent performance and API latency, reducing model regressions by 40%; improved system stability to *99.9%* by resolving a critical memory leak during on-call duties.
  - Developed a multimodal Video Question-Answering (VideoQA) system for complex temporal reasoning, improving answer accuracy by *25%*, and built a synthetic data pipeline with diffusion models to reduce false positives by *15%*.
]

// KeelWorks
#entry_header("The KeelWorks Foundation", "Oak Harbor, WA")
#emph("Software Engineer (Machine Learning Applications)") #h(1fr) July 2024 -- Jan 2025

#resume_list[
  - Engineered a production-scale *retrieval and reasoning system* using a RAG pipeline in TypeScript/Python with LangChain, delivering a search API with *\<5s p95* latency and *92% context relevance (MRR)* across 2,500+ documents on a PostgreSQL backend.
  - Executed an aggressive model optimization strategy for production deployment, reducing model size by *50%* and increasing inference speed by *80%* using *8-bit GPTQ quantization* and knowledge distillation while maintaining >90% task accuracy.
  - Pioneered a synthetic data generation workflow by fine-tuning *Mistral-7B*, expanding the training dataset for downstream tasks by *30%* and significantly improving model robustness; deployed all services via a Dockerized GitLab CI/CD workflow.
]

// Space Physics Lab
#entry_header("Space Physics Lab, Boston University", "Boston, MA")
#emph("Graduate Research Assistant (ML Applications)") #h(1fr) Oct 2022 -- May 2024

#resume_list[
  - Led R&D of a multimodal system to parse and reason over noisy, unstructured sensor data; Architected a high-throughput, distributed data ingestion system using Kafka, Dask, and AWS S3, slashing processing time for 3TB+ datasets from >24 hours to *\<3 hours*.
  - Developed a low-latency forecasting system achieving *\<80ms p90* latency at *25 predictions/sec* by implementing async processing and request batching, which cut initial latency by 40%.
  - Implemented *generative inpainting* and *SwinIR super-resolution* pipelines to reconstruct corrupted sensor data, improving data quality and signal-to-noise ratio for downstream predictive models by over 60%.
]

// --- PROJECTS ---


#cvsection("Projects")

// ArkOS
#entry_header("ArkOS (MIT)", "Jun 2025 -- Present")
#resume_list[
  - DevOps, documentation *(Mintlify)* and general development (frontend/backend) for ArkOS, an open source interface for a local LLM agent building utilizing long term memory for personalized requests

]

// Halo AI
#entry_header("Halo AI (Stealth startup incubated at Columbia University)", "Dec 2023 -- Aug 2024")
#resume_list[
  - Developed and deployed a federated learning pipeline and ensemble of LLMs for on-device *agentic conversational assistants*, cutting inference latency by *27%* to *\<1.5s*.
  - Architected a scalable MLOps pipeline on AWS (*EC2/S3/Lambda, SageMaker*), automating CI/CD for federated learning models and reducing data preparation time by *70%*.
  - Implemented an *evaluation pipeline* to monitor model performance, utilizing knowledge distillation and 8-bit quantization to improve inference speed by *80%* while preserving *90%* accuracy.
]


// BeatQraft
#entry_header("BeatQraft (MIT iQuHACK 2023 Hackathon)", "Jan 2023")
#resume_list[
  - Built a *distributed quantum generative AI* service at the MIT iQuHACK-23 hackathon, placing *2nd* out of 1000+ teams. #link("https://github.com/ksd3/beatqraft/")[Link]
]

// --- TECHNICAL SKILLS ---

#cvsection("Technical Skills")

#set grid(row-gutter: 0.5em)
// Set text size for skills to 9pt to match resumeItem
#set text(size: 9pt)

#skill_entry("Programming & Databases:", [Python, C++, TypeScript, SQL (Postgres), MongoDB, Redis])
#skill_entry("MLOps & Cloud Platforms:", [Docker, AWS, GCP, Kafka, Dask, Terraform, Kubernetes, Modal, MLflow])
#skill_entry("Machine Learning & Tools:", [PyTorch, GenAI, RAG, LLMs, Computer Vision, Retrieval Systems, Distributed Systems, AI Code Assistants])
#skill_entry("Core Concepts:", [Software Architecture, Product Intuition, High-Performance Computing, Scalability, Agile])

// Reset text size back to 10pt for headers/Education
#set text(size: 10pt)

// --- EDUCATION ---

#cvsection("Education")

#entry_header("Boston University", "Boston, MA")
Master of Science with Thesis in Electrical and Computer Engineering #h(1fr) Sep 2022 -- May 2024 \
GPA: 3.8/4

#entry_header("College of Engineering Pune", "Pune, India")
Bachelor of Technology in Electrical Engineering, Minor in CS #h(1fr) Aug 2018 -- June 2022 \
GPA: 3.83/4

// --- PUBLICATIONS ---

#cvsection("Publications")
#set text(size: 9pt) // Match resumeItem size
#set enum(spacing: 0.4em)

+ *Optimizing Solar Panel Tilt using Machine Learning Techniques*, #link("https://ieeexplore.ieee.org/document/9587892/")[GPECOM 2021]. \
  Proposes an XGBoost-based approach to maximize energy generation from solar plants.

+ *The Platonic Universe: Do Foundation Models See the Same Sky?*, #link("https://ml4physicalsciences.github.io/2025/")[NeurIPS ML4PS 2025 - Spotlight Paper]. \
  Investigates if different foundation models see the same underlying astrophysical phenomena and develops custom foundation models to better learn underlying astrophysics.
