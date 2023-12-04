function draw_red_green_together(folder_path)

% Specify the folder path
% folder_path = uigetdir;

% Get a list of all .tif files in the folder
list = get_all_files_of_a_certain_name_pattern_in_a_rootpath(folder_path, 'intensity_volume.mat');

% error
if length(list) ~= 2
    error("The number of intensity_volume.mat is not 2!");
end

%% load data
I_1 = load_data_from_mat(list{1});
I_2 = load_data_from_mat(list{2});

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
histogram(I_1);
xlabel("I_1");
ylabel("count");
IQR_index = 1;
[~, ~, mask_up_1, mask_down_1, up_limit, down_limit, upper_bound, lower_bound] = Tukey_test(I_1, IQR_index);
Tukey_test_draw_lines(up_limit, down_limit, upper_bound, lower_bound);
saveas(gcf,fullfile(folder_path, 'Tukey_test_for_I_1'),'png');

figure;
histogram(I_2);
xlabel("I_2");
ylabel("count");
IQR_index = 1;
[~, ~, mask_up_2, mask_down_2, up_limit, down_limit, upper_bound, lower_bound] = Tukey_test(I_2, IQR_index);
Tukey_test_draw_lines(up_limit, down_limit, upper_bound, lower_bound);
saveas(gcf,fullfile(folder_path, 'Tukey_test_for_I_2'),'png');

mask_up = mask_up_1 | mask_up_2;
mask_down = mask_down_1 | mask_down_2;

is_outlier = mask_up | mask_down;
I_1(is_outlier) = nan;
I_2(is_outlier) = nan;

%% plot I
plot_3(I_1,I_2,I_1_info,list)
saveas(gcf,fullfile(folder_path, 'intensity'),'png');
saveas(gcf,fullfile(folder_path, 'intensity'),'fig');

%% plot normalized I
figure;

subplot(3,1,1)
I_1_normalized = plot_intensity_normalized(I_1,list{1});

subplot(3,1,2)
I_2_normalized = plot_intensity_normalized(I_2,list{2});

subplot(3,1,3)
if I_1_info == "Red"
    plot_ratio(I_1_normalized,I_2_normalized);
else
    plot_ratio(I_2_normalized,I_1_normalized);
end

set_full_screen;
saveas(gcf,fullfile(folder_path, 'intensity_normalized'),'png');
saveas(gcf,fullfile(folder_path, 'intensity_normalized'),'fig');

%% Corr
is_nan_1 = isnan(I_1);
is_nan_2 = isnan(I_2);
is_nan = is_nan_1 | is_nan_2;

I_1_filted = I_1(~is_nan);
I_2_filted = I_2(~is_nan);

% Pearson Corr
r = corrcoef(I_1_filted,I_2_filted);
fprintf("Pearson Corr = %.4f\n",r(1,2));

% slope of least square
p = polyfit(I_1_filted, I_2_filted, 1);
fprintf("slope of least square = %.4f\n",p(1));

% Visualize_as_X_and_Y
figure;
axis equal;
plot(I_1_filted,I_2_filted,'k-o');
xlabel(I_1_info);
ylabel(I_2_info);
title(sprintf("r = %.2f; b = %.2f",r(1,2),p(1)));
saveas(gcf,fullfile(folder_path, 'Visualize_as_X_and_Y'),'png');

%% close
close all;

end