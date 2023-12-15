% up-stream: from .tif to mask and .mp4
%
% 2023-12-04, Yixuan Li
%

dbstop if error;

clc;clear;close all;

% path
folder_path = uigetdir;
list_red = get_all_folders_of_a_certain_name_pattern_in_a_rootpath(folder_path, 'Red');
folder_path_red = list_red{1};
list_green = get_all_folders_of_a_certain_name_pattern_in_a_rootpath(folder_path, 'Green');
folder_path_green = list_green{1};

% para
template = "red";
sense_red = 0.2; % super-parameter
sense_green = 0.2; % super-parameter
disk_size = 3; % super-parameter
is_test = true;
algorithm_type = "Gauss_Adapt";

% main
tif_to_mask_and_mp4(folder_path_red,folder_path_green,template,sense_red,sense_green,disk_size,is_test,algorithm_type);