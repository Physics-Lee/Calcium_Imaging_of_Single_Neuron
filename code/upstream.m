% up-stream: from .tif to mask and .mp4
%
% 2023-12-04, Yixuan Li
%

clc;clear;close all;

dbstop if error;

my_add_path();

%% choose the path to the data
folder_path = uigetdir;
list_red = get_all_folders_of_a_certain_name_pattern_in_a_rootpath(folder_path, 'Red');
folder_path_red = list_red{1};
list_green = get_all_folders_of_a_certain_name_pattern_in_a_rootpath(folder_path, 'Green');
folder_path_green = list_green{1};

%% set parameters
binarization_method = "Gauss_Adapt";
sense_red = 0.2; % super-parameter
sense_green = 0.2; % super-parameter

all_template = "green";
soma_template = "red";
neurite_template = "opposite";
disk_size = 3; % super-parameter

is_test = true;
start_frame = 2000;
end_frame = 2500;

%% main
tif_to_mask_and_mp4(folder_path_red,folder_path_green, ...
    binarization_method,sense_red,sense_green,...
    all_template,soma_template,neurite_template,disk_size,...
    is_test,start_frame,end_frame);