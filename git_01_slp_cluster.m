%% Unsupervised approach to cluster MS cells

clear; clc; close all;

%% Setup paths

addpath(genpath('srinivas.gs_mtools-master'));
addpath(genpath('CellSorter-master'));


%% Load data

load(fullfile('git_folder', 'SLP_input_table.mat'), 'SLP_input_table');


SLP_input_mat   = table2array(SLP_input_table);

%% Run t-SNE and clustering

cs = CellSorter;
cs.algorithm = 'tsne';

X = normalize(SLP_input_mat, 1, "scale");
Y = cs.dimred(X);

labels = cs.kcluster(Y);

%% Plot t-SNE clusters

clusterIDs = unique(labels);
numClusters = numel(clusterIDs);

C = colormaps.linspecer(numClusters);

figure;
hold on;
axis square;

for ii = 1:numClusters
    clusterID = clusterIDs(ii);

    plot(Y(labels == clusterID, 1), ...
         Y(labels == clusterID, 2), ...
         '.', ...
         'Color', C(ii, :), ...
         'MarkerSize', 40);
end

xlabel('t-SNE 1');
ylabel('t-SNE 2');
title('Cell clusters from t-SNE');
legend("Cluster " + string(clusterIDs), 'Location', 'best');

%% Split data by cluster

clusters = cell(numClusters, 1);

for ii = 1:numClusters
    clusterID = clusterIDs(ii);
    clusters{ii} = SLP_input_table(labels == clusterID, :);
end

%% Plot cluster proportions

clusterSizes = cellfun(@height, clusters);
clusterNames = "Cluster " + string(clusterIDs);

figure;
pie(clusterSizes);
legend(clusterNames, 'Location', 'bestoutside');
title('Cluster proportions');

%% Plot mean feature values for each cluster

numFeatures = width(SLP_input_table);

figure;

for ii = 1:numFeatures
    subplot(3, 5, ii);
    hold on;
    axis square;

    plot_data = nan(1, numClusters);

    for jj = 1:numClusters
        plot_data(jj) = nanmean(table2array(clusters{jj}(:, ii)));
    end

    bar(plot_data);
    title(SLP_input_table.Properties.VariableNames{ii}, 'Interpreter', 'none');
    xlabel('Cluster');
    ylabel('Mean value');
end





