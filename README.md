# Machine Learning in Neuroscience Using Information Theory

## Overview
This project explores the application of machine learning techniques and information theory principles to neuroscience. It focuses on analyzing neural data, understanding encoding mechanisms, and simulating canonical neuroscience experiments to provide insights into brain function.

---

## Table of Contents
1. [Introduction](#introduction)
2. [Getting Started](#getting-started)
3. [System Design](#system-design)
4. [Key Features](#key-features)
5. [Installation and Setup](#installation-and-setup)
6. [Usage Guide](#usage-guide)
7. [Performance Analysis](#performance-analysis)
8. [Conclusion](#conclusion)
9. [Acknowledgments](#acknowledgments)

---

## Introduction
The project utilizes information theory tools to analyze neural systems' encoding, transmission, and processing of information. This includes models simulating single neurons, small neural networks, and canonical neuroscience experiments.

Key motivations include:
- Addressing nonlinear interactions and multivariate datasets.
- Providing model-independent quantification of neural data.

Objectives:
- Systematically analyze parameter variations.
- Quantify information flow in neural networks.
- Evaluate robustness and reproducibility of results.

---

## Getting Started
### Requirements
- **MATLAB** with the Neuroscience Information Theory Toolbox.
- Dependencies for machine learning and data visualization.

### Installation
1. Install the Neuroscience Information Theory toolbox by double-clicking the `.mltbx` file.
2. Add the main directory to the MATLAB search path.

---

## System Design
### Methodology
1. **Parameter Setup**: Configurable simulation parameters (e.g., noise scale, pulse size).
2. **Data Generation**: Simulate neuron activity with Izhikevich models.
3. **Data Conversion**: Prepare data for analysis using `DataRaster` and `StatesRaster` formats.
4. **Information Analysis**: Employ mutual information, transfer entropy, and partial information decomposition.
5. **Visualization**: Generate plots for neural activity and information flow.

### Tools
- MATLAB simulations.
- Python for auxiliary data analysis and visualization.

---

## Key Features
1. **Mutual Information Analysis**:
   - Measures how much information a neuron's spiking activity provides about a given stimulus.
   - Enables identification of neurons that encode sensory or behavioral signals.
   - Quantifies the statistical dependence between stimuli and neural responses across time bins.

2. **Transfer Entropy**:
   - Captures directed information flow between neural signals, identifying causality in neural interactions.
   - Useful for analyzing dynamic processes like feedback loops and synaptic communication.

3. **Partial Information Decomposition (PID)**:
   - Breaks down information shared by multiple variables into redundant, unique, and synergistic components.
   - Provides insights into cooperative and independent roles of neurons in encoding information.

4. **Comprehensive Simulations**:
   - Supports single-neuron, small network, and large-scale canonical experiment simulations.
   - Incorporates realistic parameters for noise, delay, and stimulation formats, enhancing model applicability.

5. **Customizable and Extensible Analysis**:
   - Users can configure parameters like bin sizes, temporal resolution, and network connectivity.
   - Designed for easy adaptation to various neural data types, including spike trains, BOLD signals, and EEG.

6. **Visualization Tools**:
   - Generate detailed plots for neural activity, spike trains, and information metrics.
   - Enables comparison of results across different experimental conditions and parameter settings.

---

## Installation and Setup
### Prerequisites
- MATLAB (tested on version R2023b).
- MATLAB Neuroscience Information Theory Toolbox.

### Steps
1. Clone the repository.
2. Navigate to the project folder in MATLAB.
3. Run `setup.m` to initialize paths and dependencies.

---

## Usage Guide
### Quick Start
1. Load raw data into MATLAB.
2. Convert data to `DataRaster` and `StatesRaster` formats.
3. Perform information analysis using `instinfo` and other toolbox functions.
4. Visualize results with provided plotting scripts.

### Detailed Usage
- **Single Neuron Analysis**:
  ```matlab
  data = load('neuro_demo1.mat');
  [StatesRaster, InfoResults] = analyze_neuron(data);
  plot_information(InfoResults);
  ```

- **Network Simulations**:
  ```matlab
  simulate_network(parameters);
  plot_network_activity;
  ```

---

## Performance Analysis
### Results
- **Single Neuron Encoding**: Demonstrated stimulus-state encoding using mutual information.
- **Small Network Analysis**: Quantified information flow between connected neurons.
- **Canonical Experiments**: Simulations aligned with real-world neuroscience studies.

### Metrics
- Accuracy of stimulus encoding.
- Information redundancy and synergy.

---

## Conclusion
This project successfully applies information theory to neuroscience data, providing a framework for understanding neural encoding, transmission, and processing. Key findings demonstrate the utility of metrics like mutual information, transfer entropy, and PID in analyzing neural systems.

For a detailed explanation of methods, results, and analyses, please refer to the [comprehensive project report](Machine%20Learning%20in%20Neuroscience%20using%20Information%20Theory_Project%20Report.pdf). This document includes in-depth descriptions, parameter configurations, and visualizations that further elucidate the findings and their implications.

---

## Acknowledgments
This project was developed by the team of:
- Aniruddha Bhattacharjee
- Devarsh Shah
- Khushboo Mittal
- Sivia Anzal
- Mariya Gracious

Special thanks to our guide, Dr. Mohammad Sultan Alam, and VIT Bhopal University for their support.

