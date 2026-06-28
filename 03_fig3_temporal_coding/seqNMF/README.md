# fig3_temporal_coding/seqNMF

This folder contains MATLAB code for visualizing seqNMF results from hippocampal population activity.

`git_plot_seqNMF_example.m` plots saved seqNMF factors and the corresponding normalized spike matrix across time chunks. Example input data are provided in `git_folder/seqNMF_example_data.mat`. In this example dataset, the recording is divided into 200-s chunks, with 50 bins per second and 10,000 bins per chunk.

Before running the script, please keep the `seqNMF-master` toolbox folder in this directory. The expected output is a set of seqNMF chunk plots saved in `output/seqNMF_chunk_plots/`. The script was tested in MATLAB R2022b.
