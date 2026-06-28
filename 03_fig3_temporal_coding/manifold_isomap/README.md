# fig3_temporal_coding/manifold_isomap

This folder contains Python code for Isomap analysis of hippocampal population activity.

`git_isomap_processing.ipynb` performs Isomap dimensionality reduction on normalized spike-rate data during movement periods and compares the resulting low-dimensional embedding with the animal’s spatial position. Example input data are provided in `git_folder/SPK_BHV_isomap_input_posBIN.mat`.

The Isomap analysis was tested in a conda environment with Python 3.10.13. Required Python packages are listed in `requirements.txt`.

To run the example analysis, open and run `git_isomap_processing.ipynb`. The expected output includes Isomap embedding plots, correlation-versus-rotation plots and the corresponding spatial-position plot, which are saved in the `output/` folder.
