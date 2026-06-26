# memory-cholinergic-state

Custom MATLAB and Python code associated with the manuscript “Memory dynamically tunes cholinergic state based on ongoing experience”.

## Overview

This repository contains custom analysis code used for the manuscript. Scripts are organized by figure and analysis type.

Source Data files containing the numerical values underlying the figures are provided with the manuscript. A small demo dataset is included in this repository to illustrate code execution. Full raw datasets are available from the corresponding authors upon reasonable request.

## Repository structure

* `fig1_septal_circuit/`: code related to septal circuit classification and CA2–MS analyses
* `fig2_state_control/`: code related to cholinergic-state and LFP analyses
* `fig3_temporal_coding/`: code related to temporal coding and population analyses
* `fig4_behavior/`: code related to behavioral analyses
* `fig5_endogenous_feedback/`: code related to endogenous CA2MS activity analyses
* `demo_data/`: representative example data for code demonstration
* `demo/`: demo scripts and example outputs

## System requirements

The code was developed and tested using MATLAB R2022b and Python. Statistical analyses were performed using MATLAB R2022b, SPSS Statistics v27 and GraphPad Prism 9. Spike sorting was performed using SpikeSort 3D v2.5.4.

No non-standard hardware is required to run the provided demo analyses. Neuralynx and Tucker-Davis Technologies systems were used for data acquisition but are not required to run the analysis code.

## Installation

Clone or download this repository and add the relevant code folders to the MATLAB path. For Python analyses, install the required packages listed in `requirements.txt`.

Typical installation time on a standard desktop computer is less than 10 min, excluding MATLAB or Python installation.

## Demo

Representative demo scripts are provided in the `demo/` folder and can be run using the example data in `demo_data/`.

Expected output includes example analysis results and/or figures saved to the output folder. Expected runtime for the demo analyses is less than 10 min on a standard desktop computer.

## Instructions for use

To run the analysis code on user data, place input files in the expected format described in each figure-specific folder and run the corresponding scripts. Full reproduction of all manuscript analyses requires the complete datasets. Source Data files are provided with the manuscript, and full raw anatomical imaging, electrophysiology, photometry and video-recording data are available from the corresponding authors upon reasonable request.

## License

This code is released under the MIT License.
