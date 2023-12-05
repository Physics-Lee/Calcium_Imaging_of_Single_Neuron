function sensitivity_threshold = get_sense_value(folder_path)

% Define the file name
file_name = fullfile(folder_path, 'sensitivity_threshold.txt');

% Open the file for reading
file_id = fopen(file_name, 'r');

% Check if the file is opened successfully
if file_id == -1
    error('Error opening file.');
end

% Read the value from the file
file_content = fgetl(file_id);
sensitivity_threshold = str2double(file_content);

% Close the file
fclose(file_id);

% Display the value
fprintf('Sensitivity threshold: %f\n', sensitivity_threshold);

end