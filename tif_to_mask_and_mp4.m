clc; clear; close all;

% Specify the folder path
folder_path = uigetdir;

% Get a list of all .tif files in the folder
files = dir(fullfile(folder_path, '*.tif'));

% Sensitivity threshold (super-parameter)
sensitivity_threshold = 0.2;

% test the super-parameter
is_test = false;
if is_test
    start_frame = 16000;
    end_frame = 16300;
    video_name_str = sprintf('output_video_sense_%.4f_from_%d_to_%d.mp4',sensitivity_threshold,start_frame,end_frame);
else
    start_frame = 1;
    end_frame = length(files);
    video_name_str = sprintf('output_video_sense_%.4f.mp4',sensitivity_threshold);
    
    % save info
    save_para_value(folder_path, sensitivity_threshold)
end

% Initialize the n_bright_pixel array
n_bright_pixel = nan(length(files), 1);
intensity = nan(length(files),1);

% Create a VideoWriter object for the output video in the specified folder
output_video_path = fullfile(folder_path, video_name_str);
output_video = VideoWriter(output_video_path, 'MPEG-4');
output_video.FrameRate = 100; % Set the frame rate to 30 fps

% Open the VideoWriter
open(output_video);

% Loop through the files
for i = start_frame:end_frame
    % Full path to the current file
    full_path = fullfile(folder_path, files(i).name);
    
    % Read the image data from the TIFF file
    gray_frame = imread(full_path);
    
    % Convert to binary image using adaptive thresholding
    binary_frame = imbinarize(gray_frame, 'adaptive', 'Sensitivity', sensitivity_threshold);
    
    % Compute the number of bright pixels
    n_bright_pixel(i) = sum(sum(binary_frame));
    
    % Compute the number of bright pixels
    intensity(i) = sum(gray_frame(binary_frame));
    
    % Convert the binary frame to uint8 and write it to the video
    binary_frame_uint8 = uint8(binary_frame) * 255;
    writeVideo(output_video, binary_frame_uint8);
end

% Close the VideoWriter object
close(output_video);

if is_test
    return
end

%% Tukey for n
IQR_index = 1;
figure;
histogram(n_bright_pixel(~isnan(n_bright_pixel)));
xlabel("number of bright pixels of certain binary frame");
ylabel("count");
[~, ~, mask_up, mask_down, up_limit, down_limit, upper_bound, lower_bound] = Tukey_test(n_bright_pixel, IQR_index);
Tukey_test_draw_lines(up_limit, down_limit, upper_bound, lower_bound);
saveas(gcf,fullfile(folder_path, 'Tukey_test_of_n_of_bright_pixels'),'png');

% Calculate outliers
is_outlier_1 = mask_up | mask_down;

%% Tukey for I
IQR_index = 1;
figure;
histogram(intensity(~isnan(intensity)));
xlabel("intensity of bright pixels of certain binary frame");
ylabel("count");
[~, ~, mask_up, mask_down, up_limit, down_limit, upper_bound, lower_bound] = Tukey_test(intensity, IQR_index);
Tukey_test_draw_lines(up_limit, down_limit, upper_bound, lower_bound);
saveas(gcf,fullfile(folder_path, 'Tukey_test_of_I_of_bright_pixels'),'png');

% Calculate outliers
is_outlier_2 = mask_up | mask_down;

%% union
is_outlier = is_outlier_1 | is_outlier_2;

%% Save
save(fullfile(folder_path, 'is_outlier.mat'), 'is_outlier');
save(fullfile(folder_path, 'intensity.mat'), 'intensity');

%%
close all;