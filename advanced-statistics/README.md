# Kernel Methods and Support Vector Machines - TSiA 205

This repository contains a comprehensive Jupyter notebook exploring kernel methods, kernel PCA, and Support Vector Regression (SVR) with applications to contaminated data analysis.

## Overview

The notebook provides both theoretical foundations and practical implementations of:

- **Kernel Theory**: Introduction to Reproducing Kernel Hilbert Spaces (RKHS)
- **Kernel PCA**: Principal Component Analysis in kernel spaces
- **Support Vector Regression**: Robust regression with ε-insensitive loss
- **Contaminated Data Analysis**: Handling outliers and noisy observations

## Contents

### 1. Course Reminder & Basic Kernel Theory
- Motivation for kernel methods in machine learning
- Definition and properties of RKHS
- Proof of kernel validity (linear and Gaussian kernels)
- Universal kernels and their properties

### 2. Basic Kernel Manipulations
- Gram matrix operations and centering
- Implementation of kernel centering functions
- Train/test kernel matrix transformations

### 3. Kernel PCA
- Extension of PCA to infinite-dimensional feature spaces
- Eigenvalue decomposition in kernel space
- Projection of new data points
- Visualization of kernel PCA results with different parameters

### 4. Support Vector Regression
- Contaminated data generation and analysis
- ε-insensitive loss function
- Comparison between SVR and Kernel Ridge Regression (KRR)
- Robustness analysis under different contamination levels

## Key Features

### Theoretical Analysis
- Mathematical proofs for kernel validity
- Derivation of kernel PCA algorithm
- Representer theorem applications

### Practical Implementations
- Custom kernel centering functions
- Contaminated dataset generation
- Comprehensive visualization tools
- Performance comparison frameworks

### Robustness Studies
- Analysis of algorithm performance under contamination
- Parameter sensitivity studies
- Comparative robustness evaluation

## Dependencies

Install the required packages using:

```bash
pip install -r requirements.txt
```

Required packages:
- `numpy`: Numerical computations
- `matplotlib`: Data visualization  
- `pandas`: Data manipulation
- `scikit-learn`: Machine learning algorithms

## Usage

1. **Setup Environment**: Install dependencies and activate your Python environment
2. **Run Notebook**: Open `Antoine Prevost.ipynb` in Jupyter Lab or VS Code
3. **Execute Cells**: Run cells sequentially to reproduce all analyses
4. **Explore Parameters**: Modify contamination parameters and kernel settings

## Key Algorithms Implemented

### Kernel Centering
```python
def center_gram_matrix(Kxx):
    """Centers the Gram matrix in feature space"""
    n = Kxx.shape[0]
    M = np.eye(n) - 1/n*np.ones((n,n))
    return M @ Kxx @ M
```

### Contaminated Data Generation
```python
def gen_data(n, p, b, sigma=0.1):
    """Generates contaminated regression data"""
    # Implementation with mixture of Gaussian noise and uniform contamination
```

## Experimental Results

The notebook demonstrates:
- **Kernel PCA**: Effective dimensionality reduction with non-linear transformations
- **SVR Robustness**: Superior performance compared to KRR under heavy contamination
- **Parameter Sensitivity**: Optimal hyperparameter selection strategies

## Applications

This work is relevant for:
- Robust machine learning in noisy environments
- Dimensionality reduction for complex datasets  
- Outlier-resistant regression problems
- Sensor data analysis with potential malfunctions

## Author

Antoine Prevost - TSiA 205 Practical Session

## Academic Context

This notebook was developed as part of the TSiA (Technologies et Sciences de l'Information et de l'Automatique) program, focusing on advanced machine learning techniques and their theoretical foundations.