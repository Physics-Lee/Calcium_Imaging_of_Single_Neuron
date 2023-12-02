clc; clear; close all;

% Specify the folder path
folder_path = 'F:\w11_2023-11-08_20-08-27';

% Get a list of all .tif files in the folder
files = dir(fullfile(folder_path, 'is_outlier.mat'));