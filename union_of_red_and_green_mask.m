clc; clear; close all;

% Specify the folder path
folder_path = 'F:\w11_2023-11-08_20-08-27';

% Get a list of all .tif files in the folder
list = get_all_files_of_a_certain_name_pattern_in_a_rootpath(folder_path, 'is_outlier.mat');

% error
if length(list) ~= 2
    error("The number of is_outlier.mat is not 2!");
end

% load data
is_outlier_1 = load_data_from_mat(list{1});
is_outlier_2 = load_data_from_mat(list{2});

% if not same length
if length(is_outlier_1) ~= length(is_outlier_2)
    min_size = min(length(is_outlier_1),length(is_outlier_2));
    is_outlier_1 = is_outlier_1(1:min_size);
    is_outlier_2 = is_outlier_2(1:min_size);
end

% union
is_outlier_union = is_outlier_1 | is_outlier_2;

% save
for i = 1:length(list)
    full_path = list{i};
    folder_path = fileparts(full_path);
    save_file_name = 'is_outlier_union.mat';
    save_full_path = fullfile(folder_path, save_file_name);
    save(save_full_path, 'is_outlier_union');
end