function sensitivity_threshold = get_sense_value(folder_path)

file_name = 'sensitivity_threshold.txt';
sensitivity_threshold = get_para_value_from_txt(folder_path,file_name);
fprintf('Sensitivity threshold: %f\n', sensitivity_threshold);

end