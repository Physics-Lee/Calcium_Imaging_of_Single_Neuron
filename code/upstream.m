% up-stream
%
% For binarization:
% binarization method: "Direct_Adapt", "Gauss_Adapt".
% sensitivity threshold: higher, more bright pixels.
%
% For opening:
% template: use which channel's binarization result as the template.
% disk_size: larger, open more heavily.
%
% For test:
% is_test: "true", "false".
% You can set it as "true" with setting the start frame and the end frame 
% to test the super-parameter.
%
% Open for all:
% You can increase sensation threshold and then use opening for all.
%
% 2023-12-19, Yixuan Li
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
sense_red = 0.5; % super-parameter
sense_green = 0.5; % super-parameter

all_template = "green";
soma_template = "red";
neurite_template = "opposite";
disk_size = 3; % super-parameter

is_test = false;
start_frame = 1500;
end_frame = 2000;

use_open_for_all = true;

%% main
tif_to_mask_and_mp4(folder_path_red,folder_path_green, ...
    binarization_method,sense_red,sense_green,...
    all_template,soma_template,neurite_template,disk_size,...
    is_test,start_frame,end_frame,...
    use_open_for_all);