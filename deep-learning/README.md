# Introduction to Deep Learning (SD-TSIA203) - 2023/2024

## Course Overview

This repository contains materials and resources for the course **SD-TSIA203: Introduction to Deep Learning**, part of the **Data & Artificial Intelligence** curriculum. The course focuses on deep learning, including its applications in regression, classification, and generative tasks. Students will gain theoretical knowledge of deep neural networks and practical experience with frameworks like PyTorch and Keras.

### Key Topics:

- Multi-Layer Perceptron (MLP): Fundamental architecture of deep neural networks.
- Convolutional Neural Networks (CNNs): Used for image processing tasks.
- Recurrent Neural Networks (RNNs): Applied to sequence data, with a focus on NLP.
- Generative Models: Generative Adversarial Networks (GANs) and Variational Autoencoders (VAEs).

## Prerequisites

Students are expected to have:
- Mathematics: Differential and matrix calculus.
- Programming: Proficiency in Python and Jupyter Notebooks.

## Course Structure

- Total Hours: 21 hours of in-person sessions (14 sessions), including:
  - 12 hours of lectures
  - 9 hours of practical exercises (Labs)
  - 2.5 hours of knowledge assessment
- Estimated Self-Study: 38.5 hours
- Credits: 2.5 ECTS
- Evaluation: Final written exam.

## Instructor

- Professor Geoffroy Peeters
- Professor Stéphane Lathuilière

## Installation and Setup

For practical exercises, you will need Python, PyTorch, and Keras. Follow the instructions below to set up your environment using `conda`:

1. Install Python:
   Download and install Python with Anaconda or Miniconda from [Conda Official Site](https://docs.conda.io/en/latest/).
2. Set Up the Environment:
   Create a new conda environment with the necessary deep learning libraries:
   ```bash
   conda create -n deep_learning python matplotlib numpy pandas scipy scikit-learn pytorch torchvision torchaudio keras jupyter tqdm -c pytorch
   ```
3. Activate the Environment:
   ```bash
   conda activate deep_learning
   ```
4. Launch Jupyter Notebook (if required for exercises): 
   ```bash
   jupyter notebook
   ```

This setup will allow you to implement and test various deep learning architectures covered in the course.

## How to Contribute

Feel free to contribute to the repository by:
- Submitting pull requests for corrections or improvements.
- Providing additional examples or extending the projects.
