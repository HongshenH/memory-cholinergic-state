# fig2_state_control/PSD

This folder contains MATLAB code for LFP power spectral density (PSD) analysis during optogenetic manipulation of CA2 terminals in the medial septum (MS).

`git_PSD_calculate.m` shows an example analysis from one control mouse expressing DIO-mCherry in CA2. Fiber stimulation was delivered to CA2 terminals in the MS. The script calculates PSD during the pre-stimulation window (-2 to 0 s) and stimulation window (0 to 2 s), and plots the corresponding PSD curves.

Example input data are provided in `git_folder/sample_PSD_data.mat`. Before running the script, please keep the `chronux` toolbox folder in this directory. The script was tested in MATLAB R2022b.
