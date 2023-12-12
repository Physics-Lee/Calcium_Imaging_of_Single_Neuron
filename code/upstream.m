% up-stream: from .tif to mask and .mp4
%
% 2023-12-04, Yixuan Li
%

dbstop if error;
clc;clear;close all;
% folder_path = uigetdir;
folder_path = 'D:\Nut_store\Calcium Imaging\data\NT_w1_2023-11-25_20-32-06\1_Camera-Green_VSC-09321';
sensitivity_threshold = 0.2;
is_test = false;
algorithm_type = "Gauss_Adapt";
tif_to_mask_and_mp4_new(folder_path,sensitivity_threshold,is_test,algorithm_type);