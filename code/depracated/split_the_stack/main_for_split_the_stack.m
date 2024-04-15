% split a n*1 stack to n .tif files.
%
% 2024-04-15, Yixuan Li
%

clc;clear;close all;

full_path =  "F:\1_learning\research\taxis of C.elegans\Calcium Imaging\data\SAA_2023\20240109\w4\stk1\w4_red_stk1_361-1170.tif";
save_folder_path = "F:\1_learning\research\taxis of C.elegans\Calcium Imaging\data\SAA_2023\20240109\w4\stk1\0_Camera-Red_VSC-10629";
start_frame = 361;
end_frame = 1170;
split_the_stack(full_path,save_folder_path,start_frame,end_frame);