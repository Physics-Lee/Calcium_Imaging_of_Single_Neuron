% up-stream: from .tif to mask and .mp4
%
% binarization method: Direct Adapt or Guassian Adapt
%
% 2023-12-12, Yixuan Li
%

function tif_to_mask_and_mp4(folder_path_red,folder_path_green,template,sense_red,sense_green,disk_size,is_test,algorithm_type)

%% init

% get paths
[files_red, files_green, n_frame] = init_paths(folder_path_red, folder_path_green);

% set the Gaussian filter
G_size = 3;
G_std = 3;
h = fspecial('gaussian',[G_size,G_size],G_std);

% test or not
if is_test
    start_frame = 12000;
    end_frame = 12300;
    video_name_str_red = sprintf('%s_size_%d_std_%d_sense_%.4f___disk_%d___from_%d_to_%d___red.mp4',...
        algorithm_type,G_size,G_std,sense_red,disk_size,start_frame,end_frame);
    video_name_str_green = sprintf('%s_size_%d_std_%d_sense_%.4f___disk_%d___from_%d_to_%d___green.mp4',...
        algorithm_type,G_size,G_std,sense_green,disk_size,start_frame,end_frame);
else
    start_frame = 1;
    end_frame = n_frame;
    video_name_str_red = sprintf('%s_size_%d_std_%d_sense_%.4f___disk_%d___red.mp4',...
        algorithm_type,G_size,G_std,sense_red,disk_size);
    video_name_str_green = sprintf('%s_size_%d_std_%d_sense_%.4f___disk_%d___green.mp4',...
        algorithm_type,G_size,G_std,sense_green,disk_size);
end

% Init
n_bright_pixel = nan(n_frame, 1);
intensity_red = nan(n_frame,1);
intensity_soma_red = nan(n_frame,1);
intensity_axon_dendrite_red = nan(n_frame,1);
intensity_green = nan(n_frame,1);
intensity_soma_green = nan(n_frame,1);
intensity_axon_dendrite_green = nan(n_frame,1);

% Create VideoWriter
video_format = 'MPEG-4';
fps = 100; % Hz

output_video_red = open_a_video(folder_path_red,video_name_str_red,video_format,fps);
output_video_soma_red = open_a_video(folder_path_red,strrep(video_name_str_red,'_red.mp4','_soma_red.mp4'),video_format,fps);
output_video_neurite_red = open_a_video(folder_path_red,strrep(video_name_str_red,'_red.mp4','_neurite_red.mp4'),video_format,fps);

output_video_green = open_a_video(folder_path_green,video_name_str_green,video_format,fps);
output_video_soma_green = open_a_video(folder_path_green,strrep(video_name_str_green,'_green.mp4','_soma_green.mp4'),video_format,fps);
output_video_neurite_green = open_a_video(folder_path_green,strrep(video_name_str_green,'_green.mp4','_neurite_green.mp4'),video_format,fps);

%% Loop through the files
for i = start_frame:end_frame

    % init
    binary_frame_red = [];
    binary_frame_green = [];

    % get full path
    full_path_red = fullfile(folder_path_red, files_red(i).name);
    full_path_green = fullfile(folder_path_green, files_green(i).name);

    % Load
    gray_frame_red = imread(full_path_red);
    gray_frame_green = imread(full_path_green);

    % Binarization
    switch algorithm_type
        case "Gauss_Adapt"
            binary_frame_red = Gauss_filter(gray_frame_red,h,sense_red);
            binary_frame_green = Gauss_filter(gray_frame_green,h,sense_green);
        case "Direct_Adapt"
            binary_frame_red = imbinarize(gray_frame_red, 'adaptive', 'Sensitivity', sense_red);
            binary_frame_green = imbinarize(gray_frame_green, 'adaptive', 'Sensitivity', sense_green);
    end

    % open
    switch template
        case "red"
            [soma_red,axon_dendrite_red] = split_soma_and_neurite(binary_frame_red,disk_size);

            % open to remove the noise of the neurite
            axon_dendrite_red = opening_for_neurite(axon_dendrite_red);

            % flip
            soma_green = flip(soma_red, 2);
            axon_dendrite_green = binary_frame_green & ~soma_green;
            axon_dendrite_green = opening_for_neurite(axon_dendrite_green,2);

        case "green"
            [soma_green,axon_dendrite_green] = split_soma_and_neurite(binary_frame_green,disk_size);

            % open to remove the noise of the neurite
            axon_dendrite_green = opening_for_neurite(axon_dendrite_green);

            % flip
            soma_red = flip(soma_green, 2);
            axon_dendrite_red = binary_frame_red & ~soma_red;
            axon_dendrite_red = opening_for_neurite(axon_dendrite_red,2);

    end

    % n
    n_bright_pixel(i) = sum(sum(binary_frame_red));

    % I
    intensity_red(i) = sum(gray_frame_red(binary_frame_red));
    intensity_soma_red(i) = sum(gray_frame_red(soma_red));
    intensity_axon_dendrite_red(i) = sum(gray_frame_red(axon_dendrite_red));

    intensity_green(i) = sum(gray_frame_green(binary_frame_green));
    intensity_soma_green(i) = sum(gray_frame_green(soma_green));
    intensity_axon_dendrite_green(i) = sum(gray_frame_green(axon_dendrite_green));

    % write
    write_to_a_video(output_video_red,binary_frame_red)
    write_to_a_video(output_video_soma_red,soma_red)
    write_to_a_video(output_video_neurite_red,axon_dendrite_red)

    write_to_a_video(output_video_green,binary_frame_green)
    write_to_a_video(output_video_soma_green,soma_green)
    write_to_a_video(output_video_neurite_green,axon_dendrite_green)

end

% Close
close(output_video_red);
close(output_video_soma_red);
close(output_video_neurite_red);

close(output_video_green);
close(output_video_soma_green);
close(output_video_neurite_green);

% return
% if is_test
%     return
% end

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
save(fullfile(folder_path_red, 'is_outlier.mat'), 'is_outlier');
save(fullfile(folder_path_red, 'intensity.mat'), 'intensity_red');
save(fullfile(folder_path_red, 'intensity_soma.mat'), 'intensity_soma_red');
save(fullfile(folder_path_red, 'intensity_axon_dendrite.mat'), 'intensity_axon_dendrite_red');

save(fullfile(folder_path_green, 'is_outlier.mat'), 'is_outlier');
save(fullfile(folder_path_green, 'intensity.mat'), 'intensity_green');
save(fullfile(folder_path_green, 'intensity_soma.mat'), 'intensity_soma_green');
save(fullfile(folder_path_green, 'intensity_axon_dendrite.mat'), 'intensity_axon_dendrite_green');

%% close
close all;

end