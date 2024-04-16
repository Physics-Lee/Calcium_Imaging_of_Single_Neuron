function [files_red, files_green, n_frames] = init_paths(folder_path_red, folder_path_green)
files_red = dir(fullfile(folder_path_red, '*.tif'));
files_green = dir(fullfile(folder_path_green, '*.tif'));
n_frames = length(files_red);

if n_frames ~= length(files_green)
    error("The red and green channel contain different number of frames!");
end
end