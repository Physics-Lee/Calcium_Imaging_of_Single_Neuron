% up-stream: from .tif to mask and .mp4
%
% method 1: imbinarize(gray_frame, 'adaptive', 'Sensitivity', sensitivity_threshold
%
% method 2: Guassian Adapt
%
% 2023-12-12, Yixuan Li
%

function tif_to_mask_and_mp4_new(folder_path,sensitivity_threshold,is_test,algorithm_type)

%% init
% Get a list of all .tif files in the folder
files = dir(fullfile(folder_path, '*.tif'));

% test the super-parameter
if is_test
    start_frame = 16000;
    end_frame = 16300;
    video_name_str = sprintf('%s_sense_%.4f_from_%d_to_%d.mp4',algorithm_type,sensitivity_threshold,start_frame,end_frame);
else
    start_frame = 1;
    end_frame = length(files);
    video_name_str = sprintf('%s_sense_%.4f.mp4',algorithm_type,sensitivity_threshold);

    % save info
    save_para_value_to_txt(folder_path, sensitivity_threshold)
end

% Initialize the n_bright_pixel array
n_bright_pixel = nan(length(files), 1);
intensity = nan(length(files),1);

% Create a VideoWriter object for the output video in the specified folder
video_format = 'MPEG-4';
fps = 100; % Hz
output_video = open_a_video(folder_path,video_name_str,video_format,fps);
output_video_soma = open_a_video(folder_path,strcat(video_name_str,'_soma'),video_format,fps);
output_video_neurite = open_a_video(folder_path,strcat(video_name_str,'_neurite'),video_format,fps);

% set h
h = fspecial('gaussian',[3,3],3);

%% Loop through the files
for i = start_frame:end_frame

    % Initialize binary_frame for this iteration
    binary_frame = [];

    % Full path to the current file
    full_path = fullfile(folder_path, files(i).name);

    % Read the image data from the TIFF file
    gray_frame = imread(full_path);

    % Binarization Method 1
    switch algorithm_type
        case "Gauss_Adapt"
            c_filtered=imfilter(gray_frame,h,'replicate');
            T = adaptthresh(c_filtered, sensitivity_threshold);
            binary_frame = imbinarize(c_filtered, T);
        case "Direct_Adapt"
            binary_frame = imbinarize(gray_frame, 'adaptive', 'Sensitivity', sensitivity_threshold);
    end

    % figure;
    % imshow(binary_frame);

    % Compute the number of bright pixels
    n_bright_pixel(i) = sum(sum(binary_frame));

    % Compute the number of bright pixels
    intensity(i) = sum(gray_frame(binary_frame));

    %
    % se = strel('disk', 3);
    % binary_frame_strel = imopen(binary_frame, se);

    % connectivity component
    cc = bwconncomp(binary_frame,4);

    % 
    n_pixels = cellfun(@numel, cc.PixelIdxList);
    if isempty(n_pixels)
        soma = false(size(binary_frame));
        neurite = false(size(binary_frame));
    else

        % make the max to be soma
        [~, largest_idx] = max(n_pixels);
        soma = false(size(binary_frame));
        soma(cc.PixelIdxList{largest_idx}) = true;

        % make the diff to be neurite
        neurite = binary_frame - soma;
        neurite(neurite < 0) = 0;
    end

    % Convert the binary frame to uint8 and write it to the video
    binary_frame_uint8 = uint8(binary_frame) * 255;
    writeVideo(output_video, binary_frame_uint8);

    binary_frame_uint8_soma = uint8(soma) * 255;
    writeVideo(output_video_soma, binary_frame_uint8_soma);

    binary_frame_uint8_neurite = uint8(neurite) * 255;
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

%% close
close all;

end