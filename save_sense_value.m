function save_sense_value(folder_path,sensitivity_threshold)

% Define the file name, you can change 'sensitivity_value.txt' to your preferred file name
file_name = fullfile(folder_path, 'sensitivity_threshold.txt');

% Open the file for writing
file_id = fopen(file_name, 'w');

% Check if the file is opened successfully
if file_id == -1
    error('Error opening file.');
end

% Write the sensitivity_threshold value to the file
fprintf(file_id, '%f', sensitivity_threshold);

% Close the file
fclose(file_id);

end