% up-stream: from .tif to mask and .mp4
%
% binarization method: Direct Adapt or Guassian Adapt
%
% 2023-12-12, Yixuan Li
%

function tif_to_mask_and_mp4(folder_path_red,folder_path_green,template,sensitivity_threshold,is_test,algorithm_type)

%% init

% get paths
files_red = dir(fullfile(folder_path_red, '*.tif'));
n_frame_red = length(files_red);

files_green = dir(fullfile(folder_path_green, '*.tif'));
n_frame_green = length(files_green);

% error
if n_frame_red ~= n_frame_green
    error("The red and green channel contain different number of frames!");
end

% set the Gaussian filter
G_size = 3;
G_std = 3;
h = fspecial('gaussian',[G_size,G_size],G_std);

% set the opening size
disk_size = 3;

% if test
if is_test
    start_frame = 12000;
    end_frame = 12500;
    video_name_str = sprintf('%s_size_%d_std_%d_sense_%.4f___disk_%d___from_%d_to_%d.mp4',algorithm_type,G_size,G_std,sensitivity_threshold,disk_size,start_frame,end_frame);
else
    start_frame = 1;
    end_frame = n_frame_red;
    video_name_str = sprintf('%s_size_%d_std_%d_sense_%.4f___disk_%d.mp4',algorithm_type,G_size,G_std,sensitivity_threshold,disk_size);
end

% Init
n_bright_pixel = nan(n_frame_red, 1);
intensity_red = nan(n_frame_red,1);
intensity_soma_red = nan(n_frame_red,1);
intensity_axon_dendrite_red = nan(n_frame_red,1);
intensity_green = nan(n_frame_green,1);
intensity_soma_green = nan(n_frame_green,1);
intensity_axon_dendrite_green = nan(n_frame_green,1);

% Create VideoWriter
video_format = 'MPEG-4';
fps = 100; % Hz
output_video = open_a_video(folder_path_red,video_name_str,video_format,fps);
output_video_soma = open_a_video(folder_path_red,strrep(video_name_str,'.mp4','_soma.mp4'),video_format,fps);
output_video_neurite = open_a_video(folder_path_red,strrep(video_name_str,'.mp4','_neurite.mp4'),video_format,fps);

%% Loop through the files
for i = start_frame:end_frame

    % init
    binary_frame = [];

    % get full path
    full_path_red = fullfile(folder_path_red, files_red(i).name);
    full_path_green = fullfile(folder_path_green, files_red(i).name);

    % Load
    gray_frame_red = imread(full_path_red);
    gray_frame_green = imread(full_path_green);

    % Binarization
    switch algorithm_type
        case "Gauss_Adapt"
            binary_frame_red = Gauss_filter(gray_frame_red,h,sensitivity_threshold);
            binary_frame_green = Gauss_filter(gray_frame_green,h,sensitivity_threshold);
        case "Direct_Adapt"
            binary_frame_red = imbinarize(gray_frame_red, 'adaptive', 'Sensitivity', sensitivity_threshold);
            binary_frame_green = imbinarize(gray_frame_green, 'adaptive', 'Sensitivity', sensitivity_threshold);
    end

    % open
    switch template
        case "red"

            se = strel('disk', disk_size);
            binary_frame_opened = imopen(binary_frame_red, se);
        case "green"

            se = strel('disk', disk_size);
            binary_frame_opened = imopen(binary_frame_green, se);
    end

    % split
    cc = bwconncomp(binary_frame_opened,4);
    n_pixels = cellfun(@numel, cc.PixelIdxList);
    soma = false(size(binary_frame));
    if isempty(n_pixels)
        axon_dendrite = false(size(binary_frame));
    else
        % make the max to be soma
        [~, largest_idx] = max(n_pixels);
        soma(cc.PixelIdxList{largest_idx}) = true;
        % make the diff to be neurite
        axon_dendrite = binary_frame & ~soma;
    end

    % open
    se = strel('disk', 1);
    axon_dendrite_opened = imopen(axon_dendrite, se);

    % n
    n_bright_pixel(i) = sum(sum(binary_frame));

    % I
    intensity_red(i) = sum(gray_frame_red(binary_frame));
    intensity_soma_red(i) = sum(gray_frame_red(soma));
    intensity_axon_dendrite_red(i) = sum(gray_frame_red(axon_dendrite_opened));

    % Convert the binary frame to uint8 and write it to the video
    binary_frame_uint8 = uint8(binary_frame) * 255;
    writeVideo(output_video, binary_frame_uint8);

    binary_frame_uint8_soma = uint8(soma) * 255;
    writeVideo(output_video_soma, binary_frame_uint8_soma);

    binary_frame_uint8_neurite = uint8(axon_dendrite_opened) * 255;
    writeVideo(output_video_neurite, binary_frame_uint8_neurite);

end

% Close the VideoWriter object
close(output_video);
close(output_video_soma);
close(output_video_neurite);

% return
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
saveas(gcf,fullfile(folder_path_red, 'Tukey_test_of_n_of_bright_pixels'),'png');

% Calculate outliers
is_outlier_1 = mask_up | mask_down;

%% Tukey for I
IQR_index = 1;
figure;
histogram(intensity_red(~isnan(intensity_red)));
xlabel("intensity of bright pixels of certain binary frame");
ylabel("count");
[~, ~, mask_up, mask_down, up_limit, down_limit, upper_bound, lower_bound] = Tukey_test(intensity_red, IQR_index);
Tukey_test_draw_lines(up_limit, down_limit, upper_bound, lower_bound);
saveas(gcf,fullfile(folder_path_red, 'Tukey_test_of_I_of_bright_pixels'),'png');

% Calculate outliers
is_outlier_2 = mask_up | mask_down;

%% union
is_outlier = is_outlier_1 | is_outlier_2;

%% save
save(fullfile(folder_path_red, 'is_outlier.mat'), 'is_outlier_red');
save(fullfile(folder_path_red, 'intensity.mat'), 'intensity_red');
save(fullfile(folder_path_red, 'intensity_soma.mat'), 'intensity_soma_red');
save(fullfile(folder_path_red, 'intensity_axon_dendrite.mat'), 'intensity_axon_dendrite_red');

save(fullfile(folder_path_green, 'is_outlier.mat'), 'is_outlier_green');
save(fullfile(folder_path_green, 'intensity.mat'), 'intensity_green');
save(fullfile(folder_path_green, 'intensity_soma.mat'), 'intensity_soma_green');
save(fullfile(folder_path_green, 'intensity_axon_dendrite.mat'), 'intensity_axon_dendrite_green');

%% close
close all;

end