%% Plot PSD curve for pre vs stim

clear; clc; close all;
addpath(genpath('chronux'));

%% Load sample PSD data

load(fullfile("git_folder", "sample_PSD_data.mat"), "PSD_sample");

%% Extract data

lfp_srate = PSD_sample.lfp_srate;
LFP_WBAND = PSD_sample.LFP_WBAND;
LFP_TS    = PSD_sample.LFP_TS;

GAP_laser_pre_w  = PSD_sample.GAP_laser_pre_w; % 2 sec before laser onset
GAP_laser_stim_w = PSD_sample.GAP_laser_stim_w; % 2 sec stim window

%% PSD parameters

params = struct();
params.tapers = [3 5];
params.fpass  = [0 100];
params.Fs     = lfp_srate;

%% Calculate PSD for pre period

PSD_curve_pre = cell(size(GAP_laser_pre_w, 1), 1);

for sid = 1:size(GAP_laser_pre_w, 1)

    time_idx = LFP_TS >= GAP_laser_pre_w(sid, 1) & ...
               LFP_TS <= GAP_laser_pre_w(sid, 2);

    lfp_segment = LFP_WBAND(time_idx);

    if isempty(lfp_segment)
        continue
    end

    [PSD_Pxx, PSD_Fxx] = mtspectrumc(lfp_segment, params);

    PSD_curve_pre{sid} = PSD_Pxx(:)';

end

%% Calculate PSD for stim period

PSD_curve_stim = cell(size(GAP_laser_stim_w, 1), 1);

for sid = 1:size(GAP_laser_stim_w, 1)

    time_idx = LFP_TS >= GAP_laser_stim_w(sid, 1) & ...
               LFP_TS <= GAP_laser_stim_w(sid, 2) ;

    lfp_segment = LFP_WBAND(time_idx);

    if isempty(lfp_segment)
        continue
    end

    [PSD_Pxx, PSD_Fxx] = mtspectrumc(lfp_segment, params);

    PSD_curve_stim{sid} = PSD_Pxx(:)';

end

%% Convert to matrices

PSD_curve_pre  = PSD_curve_pre(~cellfun('isempty', PSD_curve_pre));
PSD_curve_stim = PSD_curve_stim(~cellfun('isempty', PSD_curve_stim));

if isempty(PSD_curve_pre)
    error('No valid pre PSD segments found.');
end

if isempty(PSD_curve_stim)
    error('No valid stim PSD segments found.');
end

PSD_pre_mat  = cell2mat(PSD_curve_pre);
PSD_stim_mat = cell2mat(PSD_curve_stim);

%% Mean and SEM

PSD_pre_mean = mean(PSD_pre_mat, 1, 'omitnan');
PSD_pre_sem  = std(PSD_pre_mat, 0, 1, 'omitnan') ./ sqrt(size(PSD_pre_mat, 1));

PSD_stim_mean = mean(PSD_stim_mat, 1, 'omitnan');
PSD_stim_sem  = std(PSD_stim_mat, 0, 1, 'omitnan') ./ sqrt(size(PSD_stim_mat, 1));

%% Plot PSD curves with SEM shading

pre_color  = [0.2 0.2 0.2];
stim_color = [0.0 0.45 1.0];

freq = PSD_Fxx(:)';  % make row vector

figure;
hold on;

% Pre SEM shading
xx_pre = [freq, fliplr(freq)];
yy_pre = [PSD_pre_mean + PSD_pre_sem, ...
          fliplr(PSD_pre_mean - PSD_pre_sem)];

h1 = fill(xx_pre, yy_pre, pre_color);
set(h1, 'FaceAlpha', 0.25, 'EdgeColor', 'none');

% Stim SEM shading
xx_stim = [freq, fliplr(freq)];
yy_stim = [PSD_stim_mean + PSD_stim_sem, ...
           fliplr(PSD_stim_mean - PSD_stim_sem)];

h2 = fill(xx_stim, yy_stim, stim_color);
set(h2, 'FaceAlpha', 0.25, 'EdgeColor', 'none');

% Mean curves
plot(freq, PSD_pre_mean, ...
    'Color', pre_color, ...
    'LineWidth', 2);

plot(freq, PSD_stim_mean, ...
    'Color', stim_color, ...
    'LineWidth', 2);

xlim([1 10]);
xlabel('Frequency (Hz)');
ylabel('Power');
title('PSD: pre vs stim');

legend({'Pre SEM', 'Stim SEM', 'Pre mean', 'Stim mean'}, ...
    'Location', 'best');

box off;