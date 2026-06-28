%% Plot all seqNMF chunks from saved example data

clear; clc; close all;

addpath(genpath('seqNMF-master'));

%% Load saved data

load(fullfile("git_folder", "seqNMF_example_data.mat"), ...
    "seqNMF_example_data");

W_filtered = seqNMF_example_data.W_filtered;
H_filtered = seqNMF_example_data.H_filtered;
normalized_spike_matrix = seqNMF_example_data.normalized_spike_matrix;
indSort = seqNMF_example_data.indSort;

chunk_bins = seqNMF_example_data.chunk_bins;
total_splits = seqNMF_example_data.total_splits;

%% Plot each chunk in a separate figure

outputFolder = "output/seqNMF_chunk_plots";

if ~exist(outputFolder, "dir")
    mkdir(outputFolder);
end

for k = 1:total_splits

    tstart = (k - 1) * chunk_bins + 1;
    tsend = min(k * chunk_bins, size(H_filtered, 2));

    figure;

    WHPlot( ...
        W_filtered(indSort, :, :), ...
        H_filtered(:, tstart:tsend), ...
        normalized_spike_matrix(indSort, tstart:tsend), ...
        1);

    title(sprintf('Chunk %d: bins %d-%d', k, tstart, tsend));

    saveas(gcf, fullfile(outputFolder, sprintf("seqNMF_chunk_%02d.jpg", k)));

    close;

end