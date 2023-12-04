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
intensity_volume = intensity_of_a_volume(intensity,frame_per_volume);

% save mat
save_file_name = 'intensity_outlier_as_nan.mat';
save_full_path = fullfile(folder_path, save_file_name);
save(save_full_path, 'intensity');

save_file_name = 'intensity_volume.mat';
save_full_path = fullfile(folder_path, save_file_name);
save(save_full_path, 'intensity_volume');

end