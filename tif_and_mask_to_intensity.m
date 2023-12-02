clc; clear; close all;

% Specify the folder path
folder_path = 'F:\w11_2023-11-08_20-08-27\1_Camera-Green_VSC-09321';

% Get a list of all .tif files in the folder
files = dir(fullfile(folder_path, '*.tif'));

% Sensitivity threshold
sensitivity_threshold = 0.01;

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
intensity_volume = intensity_of_a_volume(intensity);

% plot
figure
new_index = (intensity_volume - mean(intensity_volume,'omitnan'))/mean(intensity_volume,'omitnan');
if contains(folder_path,"Red")
    color_str = 'red';
elseif contains(folder_path,"Green")
    color_str = 'green';
end
plot(1:length(intensity_volume),new_index,color_str);
xlabel("volume","FontSize",20);
ylabel("$\frac{I-<I>}{<I>}$","Interpreter","latex","FontSize",20);
set_full_screen;

% Save fig
saveas(gcf,fullfile(folder_path, 'intensity'),'png');
close;