% up-stream: from .tif to mask and .mp4
%
% 2023-12-04, Yixuan Li
%

dbstop if error;

clc;clear;close all;

% 
folder_path_red = uigetdir;
folder_path_green = uigetdir;
template = "red";
sense_red = 0.2; % super-parameter
sense_green = 0.2; % super-parameter
is_test = true;
algorithm_type = "Gauss_Adapt";

% main
tif_to_mask_and_mp4(folder_path_red,folder_path_green,template,sense_red,sense_green,is_test,algorithm_type);