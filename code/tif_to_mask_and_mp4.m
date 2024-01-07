% up-stream: from .tif to mask and .mp4
%
% 2023-12-19, Yixuan Li
%

function tif_to_mask_and_mp4(folder_path_red,folder_path_green, ...
    binarization_method,sense_red,sense_green,...
    all_template,soma_template,neurite_template,disk_size,...
    is_test,start_frame,end_frame,...
    use_open_for_all, ...
    region_prop, ...
    frame_per_second)

%% init

% get paths
[files_red, files_green, n_frame] = init_paths(folder_path_red, folder_path_green);

% set the Gaussian filter
G_size = 3;
G_std = 3;
h = fspecial('gaussian',[G_size,G_size],G_std);

%% test or not
if is_test
    video_name_str_red = sprintf('%s_size_%d_std_%d_sense_%.4f___disk_%d___from_%d_to_%d___red.mp4',...
        binarization_method,G_size,G_std,sense_red,disk_size,start_frame,end_frame);
    video_name_str_green = sprintf('%s_size_%d_std_%d_sense_%.4f___disk_%d___from_%d_to_%d___green.mp4',...
        binarization_method,G_size,G_std,sense_green,disk_size,start_frame,end_frame);
else
    start_frame = 1;
    end_frame = n_frame;
    video_name_str_red = sprintf('%s_size_%d_std_%d_sense_%.4f___disk_%d___red.mp4',...
        binarization_method,G_size,G_std,sense_red,disk_size);
    video_name_str_green = sprintf('%s_size_%d_std_%d_sense_%.4f___disk_%d___green.mp4',...
        binarization_method,G_size,G_std,sense_green,disk_size);
end

%% Init
n_bright_pixel = nan(n_frame, 1);
intensity_red = nan(n_frame,1);
intensity_soma_red = nan(n_frame,1);
intensity_axon_dendrite_red = nan(n_frame,1);
intensity_green = nan(n_frame,1);
intensity_soma_green = nan(n_frame,1);
intensity_axon_dendrite_green = nan(n_frame,1);

%% Create VideoWriter
video_format = 'MPEG-4';

output_video_red = open_a_video(folder_path_red,video_name_str_red,video_format,frame_per_second);
output_video_soma_red = open_a_video(folder_path_red,strrep(video_name_str_red,'_red.mp4','_red_soma.mp4'),video_format,frame_per_second);
output_video_neurite_red = open_a_video(folder_path_red,strrep(video_name_str_red,'_red.mp4','_red_neurite.mp4'),video_format,frame_per_second);

output_video_green = open_a_video(folder_path_green,video_name_str_green,video_format,frame_per_second);
output_video_soma_green = open_a_video(folder_path_green,strrep(video_name_str_green,'_green.mp4','_green_soma.mp4'),video_format,frame_per_second);
output_video_neurite_green = open_a_video(folder_path_green,strrep(video_name_str_green,'_green.mp4','_green_neurite.mp4'),video_format,frame_per_second);

%% multi worm

if ~isempty(region_prop)
    % init red
    n_worm = size(region_prop,1);
    intensity_red_split_worm = cell(n_worm,1);
    for i = 1:n_worm
        intensity_red_split_worm{i} = nan(n_frame, 1);
    end

    % init green
    intensity_green_split_worm = intensity_red_split_worm;
end

%% Loop through the files
for i = start_frame:end_frame

    %% init
    binary_frame_red = [];
    binary_frame_green = [];

    %% get full path
    full_path_red = fullfile(folder_path_red, files_red(i).name);
    full_path_green = fullfile(folder_path_green, files_green(i).name);

    %% Load
    gray_frame_red = imread(full_path_red);
    gray_frame_green = imread(full_path_green);

    %% Binarization
    switch binarization_method
        case "Gauss_Adapt"
            binary_frame_red = Gauss_filter(gray_frame_red,h,sense_red);
            binary_frame_green = Gauss_filter(gray_frame_green,h,sense_green);
        case "Direct_Adapt"
            binary_frame_red = imbinarize(gray_frame_red, 'adaptive', 'Sensitivity', sense_red);
            binary_frame_green = imbinarize(gray_frame_green, 'adaptive', 'Sensitivity', sense_green);
    end

    %% open for all
    switch use_open_for_all
        case true
            disk_size_all = 1;
            binary_frame_red = opening_for_neurite(binary_frame_red,disk_size_all);
            binary_frame_green = opening_for_neurite(binary_frame_green,disk_size_all);
        case false
    end

    %% open
    switch soma_template
        case "red"
            % split the template
            [soma_red,axon_dendrite_red] = split_soma_and_neurite(binary_frame_red,disk_size);

            % split the other
            soma_green = flip(soma_red, 2);
            axon_dendrite_green = binary_frame_green & ~soma_green;
            axon_dendrite_green = opening_for_neurite(axon_dendrite_green,2);

            % neurite template
            switch neurite_template
                case "same"
                    axon_dendrite_red = opening_for_neurite(axon_dendrite_red,2);
                case "opposite"
                    axon_dendrite_red = flip(axon_dendrite_green, 2);
            end

        case "green"
            % split the template
            [soma_green,axon_dendrite_green] = split_soma_and_neurite(binary_frame_green,disk_size);

            % split the other
            soma_red = flip(soma_green, 2);
            axon_dendrite_red = binary_frame_red & ~soma_red;
            axon_dendrite_red = opening_for_neurite(axon_dendrite_red,2);

            % neurite template
            switch neurite_template
                case "same"
                    axon_dendrite_green = opening_for_neurite(axon_dendrite_green,2);
                case "opposite"
                    axon_dendrite_green = flip(axon_dendrite_red, 2);
            end

    end

    %% write to the video before applying all_template
    write_to_a_video(output_video_red,binary_frame_red)
    write_to_a_video(output_video_soma_red,soma_red)
    write_to_a_video(output_video_neurite_red,axon_dendrite_red)

    write_to_a_video(output_video_green,binary_frame_green)
    write_to_a_video(output_video_soma_green,soma_green)
    write_to_a_video(output_video_neurite_green,axon_dendrite_green)

    %% for all template
    switch all_template
        case "red"
            binary_frame_green = flip(binary_frame_red,2);
        case "green"
            binary_frame_red = flip(binary_frame_green,2);
    end

    %% save to numerical arrays

    % save n
    n_bright_pixel(i) = sum(sum(binary_frame_red));

    % save I
    intensity_red(i) = sum(gray_frame_red(binary_frame_red));
    intensity_soma_red(i) = sum(gray_frame_red(soma_red));
    intensity_axon_dendrite_red(i) = sum(gray_frame_red(axon_dendrite_red));

    intensity_green(i) = sum(gray_frame_green(binary_frame_green));
    intensity_soma_green(i) = sum(gray_frame_green(soma_green));
    intensity_axon_dendrite_green(i) = sum(gray_frame_green(axon_dendrite_green));

    %% multi worms
    if ~isempty(region_prop)
        for k = 1:n_worm

            % get region (figure in MATLAB is down for x and right for y, while in Image-J is down for y and right for x)
            y_min = region_prop(k,1);
            y_max = region_prop(k,2);
            x_min = region_prop(k,3);
            x_max = region_prop(k,4);

            % get musk
            mask = false(size(binary_frame_red));
            mask(x_min:x_max,y_min:y_max) = true;

            % get Intensity
            binary_frame_red_for_current_worm = binary_frame_red & mask;
            intensity_red_for_current_worm = sum(gray_frame_red(binary_frame_red_for_current_worm));

            binary_frame_green_for_current_worm = binary_frame_green & mask;
            intensity_green_for_current_worm = sum(gray_frame_green(binary_frame_green_for_current_worm));

            % save to a cell array
            intensity_red_split_worm{k}(i) = intensity_red_for_current_worm;
            intensity_green_split_worm{k}(i) = intensity_green_for_current_worm;
        end
    end

end

%% Close
close(output_video_red);
close(output_video_soma_red);
close(output_video_neurite_red);

close(output_video_green);
close(output_video_soma_green);
close(output_video_neurite_green);

%% Tukey for n
IQR_index = 1.5;
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
IQR_index = 1.5;
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
save(fullfile(folder_path_red, 'intensity_red_split_worm.mat'), 'intensity_red_split_worm');

save(fullfile(folder_path_green, 'is_outlier.mat'), 'is_outlier');
save(fullfile(folder_path_green, 'intensity.mat'), 'intensity_green');
save(fullfile(folder_path_green, 'intensity_soma.mat'), 'intensity_soma_green');
save(fullfile(folder_path_green, 'intensity_axon_dendrite.mat'), 'intensity_axon_dendrite_green');
save(fullfile(folder_path_green, 'intensity_green_split_worm.mat'), 'intensity_green_split_worm');

%% close
close all;

end