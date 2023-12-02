clc; clear; close all;

% Specify the folder path
folder_path = uigetdir;

% Get a list of all .tif files in the folder
list = get_all_files_of_a_certain_name_pattern_in_a_rootpath(folder_path, 'intensity_volume.mat');

% error
if length(list) ~= 2
    error("The number of intensity_volume.mat is not 2!");
end

% load data
intensity_volume_1 = load_data_from_mat(list{1});
intensity_volume_2 = load_data_from_mat(list{2});

% plot
figure;
subplot(2,1,1)
plot_intensity(intensity_volume_1,list{1});

subplot(2,1,2)
plot_intensity(intensity_volume_2,list{2});

set_full_screen;

% save fig
saveas(gcf,fullfile(folder_path, 'intensity'),'png');
close;