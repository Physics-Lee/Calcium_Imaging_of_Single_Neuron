% down-stream
%
% 2023-12-04, Yixuan Li
%

clc;clear;close all;
root_path = uigetdir;
analyze_area = "soma";
if root_path ~= 0
    root_list = get_all_folders_of_a_certain_name_pattern_in_a_rootpath(root_path,'w');
    [indx,tf] = listdlg('ListString',root_list,'ListSize',[800,600],'Name','Chose files');
    if tf==1
        for i = indx
            folder_path = root_list{i};

            %% is_outlier to is_outlier_union
            union_of_red_and_green_mask(folder_path);

            %% I_frame and is_outlier_union to I_volume 
            frame_per_volume = 1;
            
            list = get_all_folders_of_a_certain_name_pattern_in_a_rootpath(folder_path, 'Red');
            folder_path_Red = list{1};
            intensity_and_mask_to_intensity(folder_path_Red,analyze_area,frame_per_volume);

            list = get_all_folders_of_a_certain_name_pattern_in_a_rootpath(folder_path, 'Green');
            folder_path_Green = list{1};
            intensity_and_mask_to_intensity(folder_path_Green,analyze_area,frame_per_volume);

            %% I_volume to figures
            pooling_method = "mean";
            draw_red_green_together(folder_path,pooling_method,analyze_area);

            pooling_method = "max";
            draw_red_green_together(folder_path,pooling_method,analyze_area);

            pooling_method = "median";
            draw_red_green_together(folder_path,pooling_method,analyze_area);
        end
    end
end