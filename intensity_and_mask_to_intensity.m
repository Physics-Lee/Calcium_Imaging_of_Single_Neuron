function intensity_and_mask_to_intensity(folder_path)

% Specify the folder path
% folder_path = uigetdir;

% set frame per volume (5 for before 2023/10/30, 10 for after 2023/10/30)
frame_per_volume = 10;

% save
save_para_value(folder_path, frame_per_volume)

% load
is_outlier_union = load_data_from_mat(fullfile(folder_path,'is_outlier_union.mat'));
intensity = load_data_from_mat(fullfile(folder_path,'intensity.mat'));

% set outliers as nan
intensity(is_outlier_union) = nan;

% volume
intensity_volume_mean = mean_pooling(intensity,frame_per_volume);
intensity_volume_max = max_pooling(intensity, frame_per_volume);

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

% disp
disp('intensity_volume.mat saved successfully!')

end