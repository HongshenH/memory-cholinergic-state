%% Average peri-laser photometry trace from one sample dataset

clear; clc; close all;

%% Parameters

PRE_TIME  = 3;   % seconds before laser onset
POST_TIME = 11;  % seconds after laser onset
DOWNSAMPLE_N = 20;

jaws_duration = 5;  % laser duration, seconds

%% Load sample data

load(fullfile("git_folder", "sample_photometry_data.mat"), "sampleData");

data = sampleData;

%% Create laser event field

Laser_EVENT = 'Laser_Event';
data.epocs.(Laser_EVENT).name   = Laser_EVENT;
data.epocs.(Laser_EVENT).onset  = data.epocs.PC2_.onset;
data.epocs.(Laser_EVENT).offset = data.epocs.PC2_.offset;

%% Remove beginning artifact

time = (1:length(data.streams.x465G.data)) / data.streams.x465G.fs;

artifact_time = 2;
start_idx = find(time > artifact_time, 1);

time_rmove = time(start_idx:end);
signal_465 = data.streams.x465G.data(start_idx:end);
signal_405 = data.streams.x405G.data(start_idx:end);

%% Match signal lengths

min_len = min([length(signal_465), length(signal_405), length(time_rmove)]);

signal_465 = signal_465(1:min_len);
signal_405 = signal_405(1:min_len);
time_rmove = time_rmove(1:min_len);

%% Downsample by local averaging

signal_465 = arrayfun(@(i) mean(signal_465(i:i+DOWNSAMPLE_N-1)), ...
    1:DOWNSAMPLE_N:length(signal_465)-DOWNSAMPLE_N+1);

signal_405 = arrayfun(@(i) mean(signal_405(i:i+DOWNSAMPLE_N-1)), ...
    1:DOWNSAMPLE_N:length(signal_405)-DOWNSAMPLE_N+1);

time_rmove = time_rmove(1:DOWNSAMPLE_N:end);
time_rmove = time_rmove(1:length(signal_465));

fs = data.streams.x465G.fs / DOWNSAMPLE_N;

%% Filter signals

bandpassFilter = designfilt('bandpassfir', ...
    'FilterOrder', 12, ...
    'CutoffFrequency1', 0.01, ...
    'CutoffFrequency2', 3, ...
    'SampleRate', fs);

signal_465 = filtfilt(bandpassFilter, double(signal_465));
signal_405 = filtfilt(bandpassFilter, double(signal_405));

%% Calculate dFF

fit_405_to_465 = polyfit(signal_405, signal_465, 1);
fitted_405 = fit_405_to_465(1) .* signal_405 + fit_405_to_465(2);

dF  = signal_465 - fitted_405;
dFF = 100 * dF ./ fitted_405;

%% Extract peri-laser snippets

TRANGE = [-PRE_TIME * floor(fs), POST_TIME * floor(fs)];

trials = numel(data.epocs.Laser_Event.onset);
dFF_snips = cell(trials, 1);

for i = 1:trials

    if data.epocs.Laser_Event.onset(i) < PRE_TIME
        continue
    end

    onset_idx = find(time_rmove > data.epocs.Laser_Event.onset(i), 1);

    pre_idx  = onset_idx + TRANGE(1);
    post_idx = onset_idx + TRANGE(2);

    if pre_idx > 0 && post_idx <= length(dFF)
        dFF_snips{i} = dFF(pre_idx:post_idx);
    end
end

dFF_snips = dFF_snips(~cellfun('isempty', dFF_snips));

if isempty(dFF_snips)
    error('No valid laser snippets found.');
end

%% Make snippets same length

minLength = min(cellfun(@length, dFF_snips));
dFF_snips = cellfun(@(x) x(1:minLength), dFF_snips, 'UniformOutput', false);

trace_mat = cell2mat(dFF_snips);
peri_time = (1:minLength) / fs - PRE_TIME;

%% Baseline correction for each trial

baseline_idx = peri_time < 0;
baseline_corrected = zeros(size(trace_mat));

for i = 1:size(trace_mat, 1)
    baseline_mean = mean(trace_mat(i, baseline_idx), 'omitnan');
    baseline_corrected(i, :) = trace_mat(i, :) - baseline_mean;
end

trace_mat = baseline_corrected;

%% Average across trials

mean_trace = mean(trace_mat, 1, 'omitnan');
sem_trace  = std(trace_mat, 0, 1, 'omitnan') ./ sqrt(size(trace_mat, 1));

%% Smooth traces for visualization only, optional

SPAN = 2;

mean_trace_smooth = movmean(mean_trace, SPAN);
sem_trace_smooth  = movmean(sem_trace, SPAN);

%% Plot trials and average trace

jaws_color = [0.0000 0 1];

% Convert normalized/fractional trace to percent
mean_trace_plot = mean_trace_smooth * 100;
sem_trace_plot  = sem_trace_smooth * 100;

figure;

ax1 = subplot(1, 1, 1);
hold on;

xx = [peri_time, fliplr(peri_time)];
yy = [mean_trace_plot + sem_trace_plot, ...
      fliplr(mean_trace_plot - sem_trace_plot)];

hh = fill(xx, yy, jaws_color);
set(hh, 'FaceAlpha', 0.3, 'EdgeColor', 'none');

plot(peri_time, mean_trace_plot, ...
    'Color', jaws_color, ...
    'LineWidth', 2);

axis tight;

line([0 0], ylim, ...
    'Color', 'k', ...
    'LineStyle', '--', ...
    'LineWidth', 0.5);

line([jaws_duration jaws_duration], ylim, ...
    'Color', 'k', ...
    'LineStyle', '--', ...
    'LineWidth', 0.5);

line(xlim, [0 0], ...
    'Color', 'k', ...
    'LineStyle', '--', ...
    'LineWidth', 0.5);

xticks([peri_time(1), 0, jaws_duration, peri_time(end)]);
xlabel('Time (s)');
ylabel('Normalized \DeltaF/F (%)');
title('Average across laser trials');

