clc; clear; close all;

% Specify the folder path
folder_path = 'F:\Calcium_Imaing_of_RIA\Orw2\Green';

% Get a list of all .tif files in the folder
files = dir(fullfile(folder_path, '*.tif'));

% Initialize the n_bright_pixel array
n_bright_pixel = zeros(length(files), 1);

% Sensitivity threshold
sensitivity_threshold = 0.01;

% Create a VideoWriter object for the output video in the specified folder
output_video_path = fullfile(folder_path, 'output_video.mp4');
output_video = VideoWriter(output_video_path, 'MPEG-4');
output_video.FrameRate = 30; % Set the frame rate to 30 fps

% Open the VideoWriter
open(output_video);

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

    % Convert the binary frame to uint8 and write it to the video
    binary_frame_uint8 = uint8(binary_frame) * 255;
    writeVideo(output_video, binary_frame_uint8);
end

% Close the VideoWriter object
close(output_video);

% Histogram
figure;
histogram(n_bright_pixel);
xlabel("number of bright pixels of certain binary frame");
ylabel("count");

% Tukey
IQR_index = 1;
[~, ~, mask_up, mask_down, up_limit, down_limit, upper_bound, lower_bound] = Tukey_test(n_bright_pixel, IQR_index);
Tukey_test_draw_lines(up_limit, down_limit, upper_bound, lower_bound);

% Calculate outliers
is_outlier = mask_up | mask_down;

% Save the is_outlier data to a .mat file in the specified folder
save(fullfile(folder_path, 'is_outlier.mat'), 'is_outlier');

% Save fig
saveas(gcf,fullfile(folder_path, 'Tukey_test'),'png');
close;