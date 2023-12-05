% up-stream: from .tif to mask and .mp4
%
% 2023-12-04, Yixuan Li
%

clc;clear;close all;
folder_path = uigetdir;
sensitivity_threshold = 0.2;
is_test = false;
tif_to_mask_and_mp4_new(folder_path,sensitivity_threshold,is_test);