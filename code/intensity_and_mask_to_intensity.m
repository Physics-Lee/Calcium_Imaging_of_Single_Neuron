% intensity of frames and mask to intensity of volumes, using
% mean, max or median pooling
%
% 2023-12-13, Yixuan Li
%

function intensity_and_mask_to_intensity(folder_path,analyze_area)

% set frame per volume (5 for before 2023/10/30, 10 for after 2023/10/30)
frame_per_volume = 5;

% save
save_para_value_to_txt(folder_path, frame_per_volume)

% load
is_outlier_union = load_data_from_mat(fullfile(folder_path,'is_outlier_union.mat'));

switch analyze_area
    case "all"
        intensity = load_data_from_mat(fullfile(folder_path,'intensity.mat'));
    case "soma"
        intensity = load_data_from_mat(fullfile(folder_path,'intensity_soma.mat'));
    case "axon_dendrite"
        intensity = load_data_from_mat(fullfile(folder_path,'intensity_axon_dendrite.mat'));
end

% set outliers as nan
intensity(is_outlier_union) = nan;

% volume
intensity_volume_mean = mean_pooling(intensity,frame_per_volume);
intensity_volume_max = max_pooling(intensity, frame_per_volume);
intensity_volume_median = median_pooling(intensity, frame_per_volume);

% save
save_file_name = 'intensity_outlier_as_nan.mat';
save_full_path = fullfile(folder_path, save_file_name);
save(save_full_path, 'intensity');

save_file_name = 'intensity_volume_mean.mat';
save_full_path = fullfile(folder_path, save_file_name);
save(save_full_path, 'intensity_volume_mean');

save_file_name = 'intensity_volume_max.mat';
save_full_path = fullfile(folder_path, save_file_name);
save(save_full_path, 'intensity_volume_max');

save_file_name = 'intensity_volume_median.mat';
save_full_path = fullfile(folder_path, save_file_name);
save(save_full_path, 'intensity_volume_median');

% disp
disp('intensity_volume.mat saved successfully!')

end