clc; clear; close all;

% set frame per volume (5 for before 2023/10/30, 10 for after 2023/10/30)
frame_per_volume = 5;

% Specify the folder path
folder_path = uigetdir;

% Get a list of all .tif files in the folder
files = dir(fullfile(folder_path, '*.tif'));

% Sensitivity threshold
sensitivity_threshold = 0.2;

% load mask
is_outlier_union = load_data_from_mat(fullfile(folder_path,'is_outlier_union.mat'));

% init
intensity = nan(length(is_outlier_union),1);

% Loop through the files
for i = 1:length(is_outlier_union)

    if is_outlier_union(i)
        continue;
    end

    % Full path to the current file
    full_path = fullfile(folder_path, files(i).name);

    % Read the image data from the TIFF file
    gray_frame = imread(full_path);

    % Convert to binary image using adaptive thresholding
    binary_frame = imbinarize(gray_frame, 'adaptive', 'Sensitivity', sensitivity_threshold);

    % Compute the number of bright pixels
    intensity(i) = sum(gray_frame(binary_frame));

end

% volume
intensity_volume = intensity_of_a_volume(intensity,frame_per_volume);

% save mat
save_file_name = 'intensity.mat';
save_full_path = fullfile(folder_path, save_file_name);
save(save_full_path, 'intensity');

save_file_name = 'intensity_volume.mat';
save_full_path = fullfile(folder_path, save_file_name);
save(save_full_path, 'intensity_volume');