# Machine Learning (SD-TSIA210) - 2023/2024

## Course Overview

This repository contains materials and resources for the course **SD-TSIA210: Machine Learning**, part of the **Mathematics** curriculum. The course focuses on statistical learning for pattern recognition, prediction, and diagnosis within a probabilistic and statistical framework. It covers supervised learning models, optimization techniques, and introduces unsupervised learning approaches.

### Key Topics:
- Supervised Learning: Formulating classification and regression as optimization problems.
- Learning Algorithms: Implementing learning algorithms for tasks such as perceptron, SVM/SVR, decision trees, and ensemble methods.
- Evaluation Techniques: Assessing model performance for classification and regression.
- Unsupervised Learning: A brief introduction to clustering and other unsupervised techniques.

## Prerequisites

Students are expected to have:
- Basic knowledge of linear models and regularization (similar to SD204).
- Familiarity with Python programming and machine learning libraries.

## Course Structure

- Total Hours: 24 hours of in-person sessions (16 sessions), including:
  - 12 hours of lectures
  - 9 hours of practical exercises
  - 1.5 hours of exams
- Estimated Self-Study: 38.5 hours
- Credits: 2.5 ECTS
- Evaluation: Final exam and practical assignments.

## Instructor

- Professor Florence D'Alché

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

This setup will enable you to run machine learning models and perform practical exercises related to the course content.


## How to Contribute

Feel free to contribute to the repository by:
- Submitting pull requests for corrections or improvements.
- Providing additional examples or extending the projects.
