folder_path = 'D:\RIA calcium imaging\Ctl_w2_2023-11-20_20-57-24';

%%
union_of_red_and_green_mask(folder_path);

%%
list = get_all_folders_of_a_certain_name_pattern_in_a_rootpath(folder_path, 'Red');
folder_path_Red = list{1};
intensity_and_mask_to_intensity(folder_path_Red);

list = get_all_folders_of_a_certain_name_pattern_in_a_rootpath(folder_path, 'Green');
folder_path_Green = list{1};
intensity_and_mask_to_intensity(folder_path_Green);

%%
pooling_method = "mean";
draw_red_green_together(folder_path,pooling_method);

pooling_method = "max";
draw_red_green_together(folder_path,pooling_method);