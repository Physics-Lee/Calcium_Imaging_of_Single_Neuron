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
sensitivity_threshold = 0.2; % super-parameter
is_test = false;
algorithm_type = "Gauss_Adapt";

% main
tif_to_mask_and_mp4(folder_path_red,folder_path_green,template,sensitivity_threshold,is_test,algorithm_type);