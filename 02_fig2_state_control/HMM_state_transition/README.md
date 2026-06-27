# fig2_state_control/HMM

This folder contains Python and MATLAB code for hidden Markov model (HMM) analysis of state transitions during CA2 terminal inhibition in the medial septum (MS).

The HMM analysis was tested using Python 3.10. Required Python packages are listed in `requirements.txt`.

Input CSV files should be placed in `git_input_data/`, and output files are saved to `git_output_data/`. These folders are provided in `git_data.zip`; please unzip this file before running the analysis.

To run the example analysis, first open and run `git_Jaws_HMM_processing_example.ipynb`. This notebook calls the helper function `data_mkv_hmm_plot.py` and exports the results to `git_output_data/`. Each processed dataset generates an output folder containing `HMM_result.mat`.

After generating `HMM_result.mat`, run `git_plot_HMM_results_example.m` in MATLAB to plot the HMM emission matrix and transition matrices. The expected output includes HMM emission summaries and transition matrices comparing pre-stimulation and stimulation periods. In this example dataset, CA2 terminal inhibition is associated with an increased transition probability from the ripple state to the theta state.
