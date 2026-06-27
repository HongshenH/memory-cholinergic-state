# fig2_state_control/photometry

This folder contains MATLAB code for processing fiber-photometry data during optogenetic manipulation of CA2 terminals in the medial septum (MS).

`git_dff_process_example.m` shows an example analysis of CA1 acetylcholine sensor signals during CA2 terminal inhibition in the MS. The script processes 465-nm and 405-nm photometry signals, calculates ΔF/F, extracts peri-laser traces and plots the average response across laser trials.

Example input data are provided in `git_folder/sample_photometry_data.mat`. The script was tested in MATLAB R2022b.

