folder_path = 'F:\Nut_Store\RIA calcium imaging\Or_w2_2023-11-27_20-26-51';

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
draw_red_green_together(folder_path);