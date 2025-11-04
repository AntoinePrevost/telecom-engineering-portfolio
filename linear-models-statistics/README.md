# Statistics: Linear Models (SD-TSIA204) - 2023/2024

## Course Overview

This repository contains materials and resources for the course **SD-TSIA204: Statistics: Linear Models**, part of the **Mathematics** curriculum. The course introduces linear statistical models, starting from the simple least squares model and progressing to more complex models like logistic regression. Topics include estimation, hypothesis testing, and variable selection using methods such as L1 regularization (Lasso) and greedy selection techniques.

### Key Topics:

- Simple Linear Model: Least squares estimation for linear models.
- Logistic Regression: Generalizing linear models for binary outcomes.
- Estimation and Hypothesis Testing: Techniques for parameter estimation and testing.
- Variable Selection: Methods for selecting relevant variables, including Lasso and greedy algorithms.

## Prerequisites

Students are expected to have:
- Basic knowledge of statistics and inference (similar to MDI220).
- Familiarity with programming in Python.

## Course Structure

- Total Hours: 24 hours of in-person sessions (16 sessions), including:
  - 12 hours of lectures
  - 6 hours of practical exercises
  - 3 hours of directed study
  - 3 hours of exams
- Estimated Self-Study: 38.5 hours
- Credits: 2.5 ECTS
- Evaluation: Final exam and practical assignments.

## Instructor

- Professor Ekhine Irurozki Arrieta

## Installation and Setup

Some exercises and projects require Python and relevant image processing libraries. You can follow the instructions below to set up your environment using `conda`:

1. Anaconda/Miniconda: Download and install Python with Anaconda or Miniconda from [Conda Official Site](https://docs.conda.io/en/latest/).
2. Image Processing Libraries: Create a new conda environment with the necessary packages:
   ```bash
   conda create -n stats python numpy pandas matplotlib scipy scikit-learn statsmodels jupyter ipykernel
   ```
3. Activate the environment:
   ```bash
   conda activate stats
   ```
4. Launch Jupyter Notebook (if required for exercises):
   ```bash
   jupyter notebook
   ```

This setup will allow you to complete practical exercises related to linear models and variable selection.

## How to Contribute

Feel free to contribute to the repository by:
- Submitting pull requests for corrections or improvements.
- Providing additional examples or extending the projects.
