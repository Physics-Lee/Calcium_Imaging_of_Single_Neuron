% up-stream: from .tif to mask and .mp4
%
% 2023-12-04, Yixuan Li
%

dbstop if error;
clc;clear;close all;
folder_path = uigetdir;
sensitivity_threshold = 0.2;
is_test = true;
algorithm_type = "Gauss_Adapt";
tif_to_mask_and_mp4(folder_path,sensitivity_threshold,is_test,algorithm_type);