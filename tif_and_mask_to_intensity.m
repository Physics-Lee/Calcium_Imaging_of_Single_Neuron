clc; clear; close all;

% Specify the folder path
folder_path = 'F:\w11_2023-11-08_20-08-27\0_Camera-Red_VSC-10629';

% Get a list of all .tif files in the folder
files = dir(fullfile(folder_path, '*.tif'));

% Sensitivity threshold
sensitivity_threshold = 0.01;

%
load(fullfile(folder_path,'is_outlier.mat'));

% Loop through the files
for i = 1:length(files)
    % Full path to the current file
    full_path = fullfile(folder_path, files(i).name);

    % Read the image data from the TIFF file
    gray_frame = imread(full_path);

    % Convert to binary image using adaptive thresholding
    binary_frame = imbinarize(gray_frame, 'adaptive', 'Sensitivity', sensitivity_threshold);

    % Compute the number of bright pixels
    n_bright_pixel(i) = sum(sum(binary_frame));
end