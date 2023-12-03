clc; clear; close all;

% Specify the folder path
folder_path = uigetdir;

% Get a list of all .tif files in the folder
list = get_all_files_of_a_certain_name_pattern_in_a_rootpath(folder_path, 'intensity_volume.mat');

% error
if length(list) ~= 2
    error("The number of intensity_volume.mat is not 2!");
end

%% load data
intensity_volume_1 = load_data_from_mat(list{1});
intensity_volume_2 = load_data_from_mat(list{2});

%% get channel info
if contains(list{1},"Red")
    I_1_info = "Red";
    I_2_info = "Green";
elseif contains(list{1},"Green")
    I_1_info = "Green";
    I_2_info = "Red";
end

%% Tukey
figure;
histogram(intensity_volume_1);
IQR_index = 1;
[~, ~, mask_up_1, mask_down_1, up_limit, down_limit, upper_bound, lower_bound] = Tukey_test(intensity_volume_1, IQR_index);
Tukey_test_draw_lines(up_limit, down_limit, upper_bound, lower_bound);
saveas(gcf,fullfile(folder_path, 'Tukey_test_for_I_1'),'png');

figure;
histogram(intensity_volume_2);
IQR_index = 1;
[~, ~, mask_up_2, mask_down_2, up_limit, down_limit, upper_bound, lower_bound] = Tukey_test(intensity_volume_2, IQR_index);
Tukey_test_draw_lines(up_limit, down_limit, upper_bound, lower_bound);
saveas(gcf,fullfile(folder_path, 'Tukey_test_for_I_2'),'png');

mask_up = mask_up_1 | mask_up_2;
mask_down = mask_down_1 | mask_down_2;

is_outlier = mask_up | mask_down;
intensity_volume_1(is_outlier) = nan;
intensity_volume_2(is_outlier) = nan;

%% plot I
figure;
subplot(2,1,1)
plot_intensity(intensity_volume_1,list{1})
subplot(2,1,2)
plot_intensity(intensity_volume_2,list{2});
set_full_screen;
saveas(gcf,fullfile(folder_path, 'intensity'),'png');

%% plot normalized I
figure;
subplot(2,1,1)
plot_intensity_normalized(intensity_volume_1,list{1})
subplot(2,1,2)
plot_intensity_normalized(intensity_volume_2,list{2});
set_full_screen;
saveas(gcf,fullfile(folder_path, 'intensity_normalized'),'png');

%% Corr
is_nan_1 = isnan(intensity_volume_1);
is_nan_2 = isnan(intensity_volume_2);
is_nan = is_nan_1 | is_nan_2;
intensity_volume_1_filted = intensity_volume_1(~is_nan);
intensity_volume_2_filted = intensity_volume_2(~is_nan);

% Pearson Corr
r = corrcoef(intensity_volume_1_filted,intensity_volume_2_filted);
fprintf("Pearson Corr = %.4f\n",r(1,2));

% slope of least square
p = polyfit(intensity_volume_1_filted, intensity_volume_2_filted, 1);
fprintf("slope of least square = %.4f\n",p(1));

% Visualize_as_X_and_Y
figure;
axis equal;
plot(intensity_volume_1_filted,intensity_volume_2_filted,'k-o');
xlabel(I_1_info);
ylabel(I_2_info);
title(sprintf("r = %.2f; b = %.2f",r(1,2),p(1)));
saveas(gcf,fullfile(folder_path, 'Visualize_as_X_and_Y'),'png');

%% close
close all;