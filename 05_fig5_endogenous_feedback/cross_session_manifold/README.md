# fig5_endogenous_feedback/cross_session_manifold

This folder contains Python code for cross-session manifold analysis of CA2MS population activity.

`git_iso_struc_CA2MS_process.ipynb` compares CA2MS population activity structure across behavioral sessions and zone types using pooled spatial activity maps. Example input data are provided in `git_folder/pool_zone_CA2pos_map.mat`.

The analysis was tested in a conda environment with Python 3.10.13. Required Python packages are listed in `requirements.txt`.

To run the example analysis, open and run `git_iso_struc_CA2MS_process.ipynb`. The expected output is a 3D manifold plot comparing CA2MS population activity structure across sessions and behavioral zones, saved in the `output/` folder.
