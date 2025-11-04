# Optimization for Machine Learning (SD-TSIA211) - 2023/2024

## Course Overview

This repository contains materials and resources for the course **SD-TSIA211: Optimization for Machine Learning**, part of the **Data & Artificial Intelligence** curriculum. The course focuses on optimization techniques used in machine learning, especially in the context of large-scale data. Students will learn both theoretical foundations and practical approaches to optimization, building on prior knowledge from earlier optimization courses.

### Key Topics:
- Empirical Risk Minimization: Formulating learning problems as optimization tasks.
- Optimization Techniques: Algorithms for solving large-scale learning problems, including gradient descent and stochastic methods.
- Theoretical Foundations: Building on fundamental optimization concepts from prior coursework.

## Prerequisites

Students are expected to have:
- Basic Optimization Knowledge: Equivalent to MDI210 (Optimization and Numerical Analysis).
- Familiarity with Machine Learning: Understanding of learning algorithms and statistical inference.

## Course Structure

- Total Hours: 24 hours of in-person sessions (16 sessions), including:
  - 9 hours of lectures
  - 6 hours of directed study
  - 6 hours of practical exercises
  - 2 hours of exams
- Estimated Self-Study: 38.5 hours
- Credits: 2.5 ECTS
- Evaluation: Final exam and practical assignments.

## Instructor

- Professor Olivier Fercoq

## Installation and Setup

Some exercises and projects require Python and relevant image processing libraries. You can follow the instructions below to set up your environment using `conda`:

1. Anaconda/Miniconda: Download and install Python with Anaconda or Miniconda from [Conda Official Site](https://docs.conda.io/en/latest/).
2. Create the Environment:
   Use the following command to create a conda environment with the necessary dependencies:
   ```bash
   conda create -n ml-tf python=3.9 matplotlib numpy scipy scikit-image ipykernel pandas scikit-learn seaborn jupyter tqdm cudatoolkit=11.2 cudnn=8.1.0 -c conda-forge
   ```
3. Activate the Environment:
   ```bash
   conda activate ml-tf
   ```
4. Install TensorFlow:
   Install TensorFlow using pip:
   ```bash
   pip install "tensorflow<2.11"
   ```
5. Launch Jupyter Notebook (if required for exercises):
   You can launch Jupyter Notebook for practical sessions:
   ```bash
   jupyter notebook
   ```

This setup will enable you to work on optimization problems for machine learning tasks covered in the course.

## How to Contribute

Feel free to contribute to the repository by:
- Submitting pull requests for corrections or improvements.
- Providing additional examples or extending the projects.
