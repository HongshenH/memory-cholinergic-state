# memory-cholinergic-state

Custom MATLAB and Python code associated with the manuscript “Memory dynamically tunes cholinergic state based on ongoing experience”.

## Overview

This repository contains core custom analysis code used for the manuscript. Scripts are organized by figure and analysis type.

Source Data files containing the numerical values underlying the figures are provided with the manuscript. Representative demo data are included within the corresponding analysis folders to illustrate code execution. Full raw datasets are available from the corresponding authors upon reasonable request.

## Repository structure

* `fig1_septal_circuit/`: code related to septal cell classification
* `fig2_state_control/`: code related to hippocampal-state and LFP analyses
* `fig3_temporal_coding/`: code related to temporal coding and population analyses
* `fig4_behavior/`: code related to behavioral analyses
* `fig5_endogenous_feedback/`: code related to endogenous activity analyses

## System requirements

The code was developed and tested using MATLAB R2022b and Python. Statistical analyses were performed using MATLAB R2022b, SPSS Statistics v27 and GraphPad Prism 9. Spike sorting was performed using SpikeSort 3D v2.5.4.

No non-standard hardware is required to run the provided demo analyses. Neuralynx and Tucker-Davis Technologies systems were used for data acquisition but are not required to run the analysis code.

## Installation

Clone or download this repository and add the relevant code folders to the MATLAB path. For Python analyses, install the required packages listed in the corresponding `requirements.txt` files.

On Windows, if path-length errors occur when extracting the GitHub ZIP file, please extract the repository to a short directory path such as `C:\repo\`, or clone the repository using:

```bash
git clone https://github.com/HongshenH/memory-cholinergic-state.git
```

## Demo analyses

Each analysis folder contains example code, demo input data and folder-specific instructions. Demo input data are stored in the local `git_folder/` within each analysis folder. Expected results from the demo workflow are provided in the corresponding `output/` folder.

The demo analyses are intended to illustrate code execution and expected output format. Full reproduction of all manuscript analyses requires the complete datasets described in the Data Availability statement.

## Instructions for use

To run the analysis code on user data, place input files in the expected format described in each figure-specific folder and run the corresponding scripts or notebooks. Folder-specific README files describe the required input data, dependencies and expected outputs.

## License

This code is released under the MIT License.
