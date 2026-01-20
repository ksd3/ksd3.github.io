// CV - Kshitij Duraphe
// Compile with: quarto typst compile cv.typ cv.pdf

#import "cv-template.typ": *

#show: cv

#cv_header(
  name: "Kshitij Duraphe",
  address: "Boston, MA",
  email: "kshitijduraphe5@gmail.com",
  site: "ksd3.github.io",
  github: "ksd3",
)

#cv_section(icon: "🏛", title: "Appointments")

#position_item(
  institution: "Thespian Labs",
  location: "Somerville, MA",
  department: "",
  role: "AI Engineer",
  date: "Nov 2025 -- Present",
)

#position_item(
  institution: "Absentia Technologies",
  location: "Boston, MA",
  department: "",
  role: "Founding Machine Learning Engineer",
  date: "Jan 2025 -- Nov 2025",
)

#position_item(
  institution: "The KeelWorks Foundation",
  location: "Oak Harbor, WA",
  department: "",
  role: "Software Engineer (ML Applications)",
  date: "July 2024 -- Jan 2025",
)

#position_item(
  institution: "Boston University",
  location: "Boston, MA",
  department: "Space Physics Lab",
  role: "Graduate Research Assistant (ML Applications)",
  date: "Oct 2022 -- May 2024",
)

#cv_section(icon: "🎓", title: "Education")

#edu_item(
  institution: "Boston University",
  location: "Boston, MA",
  degree: "Master of Science with Thesis in Electrical and Computer Engineering (GPA: 3.8/4)",
  date: "Sep 2022 -- May 2024",
)

#edu_item(
  institution: "College of Engineering Pune",
  location: "Pune, India",
  degree: "Bachelor of Technology in Electrical Engineering, Minor in CS (GPA: 3.83/4)",
  date: "Aug 2018 -- June 2022",
)

#cv_section(icon: "📄", title: "Publications")

#pub_item(
  number: 2,
  authors: [K. Duraphe et al.],
  title: "The Platonic Universe: Do Foundation Models See the Same Sky?",
  venue: "NeurIPS ML4PS 2025",
  arxiv: "",
  paper_url: "https://ml4physicalsciences.github.io/2025/",
)

#pub_item(
  number: 1,
  authors: [K. Duraphe et al.],
  title: "Optimizing Solar Panel Tilt using Machine Learning Techniques",
  venue: "GPECOM 2021",
  arxiv: "",
  paper_url: "https://ieeexplore.ieee.org/document/9587892/",
)

#cv_section(icon: "💻", title: "Projects")

#position_item(
  institution: "Halo AI",
  location: "",
  department: "Stealth startup incubated at Columbia University",
  role: "Federated learning and LLM ensemble for on-device agentic assistants",
  date: "Dec 2023 -- Aug 2024",
)

#position_item(
  institution: "BeatQraft",
  location: "",
  department: "MIT iQuHACK 2023 Hackathon",
  role: "Distributed quantum generative AI service -- 2nd place out of 1000+ teams",
  date: "Jan 2023",
)

#cv_section(icon: "🛠", title: "Technical Skills")

*Programming & Databases:* Python, C++, TypeScript, SQL (Postgres), MongoDB, Redis

*MLOps & Cloud Platforms:* Docker, AWS, GCP, Kafka, Dask, Terraform, Kubernetes, Modal, MLflow

*Machine Learning & Tools:* PyTorch, GenAI, RAG, LLMs, Computer Vision, Retrieval Systems, Distributed Systems

*Core Concepts:* Software Architecture, High-Performance Computing, Scalability, Agile
