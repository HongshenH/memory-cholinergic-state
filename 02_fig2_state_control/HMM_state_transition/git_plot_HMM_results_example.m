%% Plot example HMM emission and transition matrices

clear; clc; close all;

%% Load HMM result

target = fullfile( ...
    "git_output_data", ...
    "._FP_Data_OrangeStim_v1-191203-165334_181-2133-211128-145512");

target_data = load(fullfile(target, "HMM_result.mat"));

%% Plot emission matrix table

Emission = target_data.emission_df_with_markers;
Emission_table = Emission(1:3, :)';

feature_labels = {'Theta Power', 'Ripple Power', 'Ripple Occ.'};
state_labels   = {'Idle state', 'Ripple state', 'Theta state'};

figure;

uitable( ...
    'Data', Emission_table, ...
    'RowName', state_labels, ...
    'ColumnName', feature_labels, ...
    'Units', 'Normalized', ...
    'Position', [0, 0, 1, 1]);

title('Emission Table');

%% Plot emission pie charts

theta_color      = [0.0000 0.0000 1.0000];
ripple_color     = [0.3010 0.7450 0.8330];
ripple_occ_color = [0.8500 0.3250 0.0980];

pie_colors = [theta_color; ripple_color; ripple_occ_color];

figure;

for state_idx = 1:3

    subplot(1, 3, state_idx);

    values = cell2mat(Emission_table(state_idx, :));
    percent_values = values * 100;

    pie_labels = cell(1, numel(feature_labels));
    for i = 1:numel(feature_labels)
        pie_labels{i} = sprintf('%s (%.1f%%)', feature_labels{i}, percent_values(i));
    end

    pie(values, pie_labels);
    colormap(gca, pie_colors);

    title(state_labels{state_idx});
    legend(feature_labels, 'Location', 'best');

end

%% Plot transition matrices for laser off and laser on

trans_pre  = target_data.transmat_condition1_ordered;
trans_stim = target_data.transmat_condition2_ordered;
trans_pre(1:size(trans_pre, 1)+1:end) = NaN;
trans_stim(1:size(trans_stim, 1)+1:end) = NaN;

figure;

subplot(1, 2, 1);
plotTransitionMatrix(trans_pre, 'Jaws Transition Matrix (Pre)');

subplot(1, 2, 2);
plotTransitionMatrix(trans_stim, 'Jaws Transition Matrix (Stim)');

%% Local function

function plotTransitionMatrix(trans_mat, plot_title)

    state_tick_labels = {'Theta\_state', 'Idle\_state', 'Ripple\_state'};

    black = [0.3, 0.3, 0.3];
    grey = [0.7, 0.7, 0.7];
    custom_color = [0.0000, 0.7569, 0.7098];

    custom_colormap = [ ...
        linspace(black(1), grey(1), 64)', ...
        linspace(black(2), grey(2), 64)', ...
        linspace(black(3), grey(3), 64)'; ...
        linspace(grey(1), custom_color(1), 64)', ...
        linspace(grey(2), custom_color(2), 64)', ...
        linspace(grey(3), custom_color(3), 64)' ...
    ];

    h = imagesc(trans_mat);
    set(h, 'AlphaData', ~isnan(trans_mat));

    colormap(gca, custom_colormap);
    colorbar;
    caxis([0.05 1]);

    xticks(1:3);
    yticks(1:3);
    xticklabels(state_tick_labels);
    yticklabels(state_tick_labels);

    set(gca, 'XAxisLocation', 'top');
    xtickangle(90);

    xlabel('To');
    ylabel('From');
    title(plot_title);

    hold on;

    n_states = size(trans_mat, 1);

    for i = 1:n_states+1
        plot([0.5, n_states+0.5], [i-0.5, i-0.5], ...
            'k', 'LineWidth', 1.5);

        plot([i-0.5, i-0.5], [0.5, n_states+0.5], ...
            'k', 'LineWidth', 1.5);
    end

    box on;

end