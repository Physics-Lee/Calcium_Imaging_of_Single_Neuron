% integrate the Coefficient of Variation of different exp
%
% 2024-04-15, Yixuan Li
%

clc;clear;close all;
root_path = uigetdir;
file_name = 'CV_Green';
file_name_with_ext = strcat(file_name,'.txt');
list = get_all_files_of_a_certain_name_pattern_in_a_rootpath(root_path,file_name_with_ext);
for i = 1:length(list)
    folder_path = fileparts(list{i});
    para = get_para_value_from_txt(folder_path,file_name_with_ext);
    list{i,2} = para;
end

% Step 1: Convert the cell array to a table
table_data = cell2table(list);

% Step 2: Add column headers
table_data.Properties.VariableNames = {'folder_path', 'value'};

% Step 3: Output to a CSV file
output_filename = strcat(file_name,'.csv'); % Define the output file name
writetable(table_data, output_filename);