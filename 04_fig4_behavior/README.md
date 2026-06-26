# Fig4_behavior

This folder contains MATLAB code related to behavioral analyses in Fig. 4.

`git_plot_heatmap.m` generates a representative trajectory plot and spatial exploration heatmap from behavioral tracking data. The script uses x/y position and speed information, filters movement periods above 3 cm/s, and plots the filtered trajectory and smoothed occupancy heatmap.

Example input data are provided in `git_folder/DATA.mat`. The script was tested in MATLAB R2022b and requires the Image Processing Toolbox.

