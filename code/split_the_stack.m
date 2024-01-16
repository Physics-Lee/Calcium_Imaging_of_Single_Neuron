function split_the_stack(full_path,save_folder_path,start_frame,end_frame)

n_frame = end_frame - start_frame + 1;
image_stack = zeros(1024, 1024, end_frame - start_frame + 1, 'uint16'); % Adjust 'uint8' if your images have a different data type

for i = 1:n_frame
    image_stack(:,:,i) = imread(full_path, i);
end

for i = 1:size(image_stack, 3)
    save_file_name = sprintf('%d.tif', i + start_frame - 1);
    imwrite(image_stack(:,:,i), fullfile(save_folder_path,save_file_name));
end

end