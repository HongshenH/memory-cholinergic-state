
clc
clear
load(fullfile("git_folder", "DATA.mat"))

% timestamps = data.("Time (s)");
% x_positions = data.("Centre position X");
% y_positions = data.("Centre position Y");

% Calculate speed
speed = speed_m_s *100;  % transform m/s  to cm/s

start_idx = find(speed>0);
start_idx_x = x_positions(start_idx);
start_idx_y = y_positions(start_idx);
start_idx_speed = speed(start_idx);

speed_threshold = 3;
% Filter data based on speed
filtered_x = start_idx_x(1:end);
filtered_x = filtered_x(start_idx_speed > speed_threshold);
filtered_y = start_idx_y(1:end);
filtered_y = filtered_y(start_idx_speed > speed_threshold);

% Plot the filtered trajectory of the mouse
figure;
subplot(1,2,1)
plot(filtered_x, filtered_y, 'b', 'LineWidth', 1.5);
xlabel('X Position');
ylabel('Y Position');
xticks([])
yticks([])

% Generate heatmap for filtered data
nbins = 100;
heatmap = histcounts2(filtered_x, filtered_y, nbins);

% Apply Gaussian smoothing for better visualization
heatmap = imgaussfilt(heatmap, 10);

% Plot heatmap for filtered data
subplot(1,2,2)
imagesc(heatmap');
colormap(jet);
colorbar;
xlabel('X Position');
ylabel('Y Position');
title('Heatmap of Mouse exploration');
xticks([])
yticks([])
axis xy;
colorrange = caxis;
caxis([min(colorrange), max(colorrange)]);
close all;
