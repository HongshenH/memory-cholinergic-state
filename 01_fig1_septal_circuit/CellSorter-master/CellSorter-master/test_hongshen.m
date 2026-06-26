% takes Fisher's iris dataset,
% performs dimensionality-reduction
% then clusters using k-means and plots the results
% clc
% clear
% close all

cd ../../
% Determine where your m-file's folder is.
% folder = fileparts(which()); 
% Add that folder plus all subfolders to the path.
addpath(genpath('RatCatcher-master'));
addpath(genpath('srinivas.gs_mtools-master'));
addpath(genpath('CMBHOME-master'));
addpath(genpath('CellSorter-master'));
addpath(genpath('FIt-SNE-master'));
addpath(genpath('umap-matlab-wrapper-master'));


cd ./CellSorter-master/CellSorter-master/





% load data
load fisheriris
% meas and species

% instantiate the object
cs = CellSorter;

% generate a figure
figure;
C = colormaps.linspecer(3);
% C = colormap(linspecer)';

for ii = 3:-1:1
  ax(ii) = subplot(1, 3, ii); hold on;
  axis square
end

% 
% % instantiate the CellSorter object
%   cs = CellSorter;
%   cs.algorithm = 't-SNE';
% %   cs.nClusters = 3;
% 
%   % perform dimensionality reduction and clustering
% Y = cs.dimred(meas);
% labels = cs.kcluster(Y);


% perform the dimensionality reduction and clustering
% once for each algorithm
alg = {'UMAP', 'FIt-SNE', 'PCA'};
% alg = {'UMAP', 't-SNE', 'PCA'};


for ii = 1:length(alg)
  cs.algorithm = alg{ii};
  Y = cs.dimred(meas);
  labels = cs.kcluster(Y);
  plot(ax(ii), Y(labels == 1, 1), Y(labels == 1, 2), 'o', 'Color', C(1, :))
  plot(ax(ii), Y(labels == 2, 1), Y(labels == 2, 2), 'o', 'Color', C(2, :))
  plot(ax(ii), Y(labels == 3, 1), Y(labels == 3, 2), 'o', 'Color', C(3, :))
  title(ax(ii), alg{ii})
end

figlib.pretty('PlotBuffer', 0.1);



%% hongshen testing 
%% PCA
figure;
for ii = 3:-1:1
  ax(ii) = subplot(1, 3, ii); hold on;
  axis square
end
for ii = 3 %1:length(alg)
  cs.algorithm = alg{ii};
  Y = cs.dimred(meas);
  labels = cs.kcluster(Y);
  plot(ax(ii), Y(labels == 1, 1), Y(labels == 1, 2), 'o', 'Color', C(1, :))
  plot(ax(ii), Y(labels == 2, 1), Y(labels == 2, 2), 'o', 'Color', C(2, :))
  plot(ax(ii), Y(labels == 3, 1), Y(labels == 3, 2), 'o', 'Color', C(3, :))
  title(ax(ii), alg{ii})
end



figure;
for ii = 3:-1:1
  ax(ii) = subplot(1, 3, ii); hold on;
  axis square
end
for ii = 3 %1:length(alg)
  cs.algorithm = alg{ii};
  Y = cs.dimred(meas);
  labels = cs.kcluster(meas);
  plot(ax(ii), Y(labels == 1, 1), Y(labels == 1, 2), 'o', 'Color', C(1, :))
  plot(ax(ii), Y(labels == 2, 1), Y(labels == 2, 2), 'o', 'Color', C(2, :))
  plot(ax(ii), Y(labels == 3, 1), Y(labels == 3, 2), 'o', 'Color', C(3, :))
  title(ax(ii), alg{ii})
end


%% tsne
figure;
for ii = 3:-1:1
  ax(ii) = subplot(1, 3, ii); hold on;
  axis square
end
for ii = 3 %1:length(alg)
  cs.algorithm = 'tsne';
  Y = cs.dimred(meas);
  labels = cs.kcluster(Y);
  plot(ax(ii), Y(labels == 1, 1), Y(labels == 1, 2), 'o', 'Color', C(1, :))
  plot(ax(ii), Y(labels == 2, 1), Y(labels == 2, 2), 'o', 'Color', C(2, :))
  plot(ax(ii), Y(labels == 3, 1), Y(labels == 3, 2), 'o', 'Color', C(3, :))
  title(ax(ii), alg{ii})
end



figure;
for ii = 3:-1:1
  ax(ii) = subplot(1, 3, ii); hold on;
  axis square
end
for ii = 3 %1:length(alg)
  cs.algorithm = 'tsne';
  Y = cs.dimred(meas);
  labels = cs.kcluster(meas);
  plot(ax(ii), Y(labels == 1, 1), Y(labels == 1, 2), 'o', 'Color', C(1, :))
  plot(ax(ii), Y(labels == 2, 1), Y(labels == 2, 2), 'o', 'Color', C(2, :))
  plot(ax(ii), Y(labels == 3, 1), Y(labels == 3, 2), 'o', 'Color', C(3, :))
  title(ax(ii), alg{ii})
end