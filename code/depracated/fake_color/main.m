full_path_red = "F:\1_learning\research\taxis of C.elegans\Calcium Imaging\data\WEN0234_check\w1_ND16_2024-04-10_22-57-56\0_Camera-Red_VSC-10629\00006265.tif";
full_path_green = "F:\1_learning\research\taxis of C.elegans\Calcium Imaging\data\WEN0234_check\w1_ND16_2024-04-10_22-57-56\1_Camera-Green_VSC-09321\00006264.tif";

% Step 1: Read the image files
red = imread(full_path_red);    % Read the red channel image
green = imread(full_path_green); % Read the green channel image

% Step 2: Horizontally flip the green channel image
green_flipped = fliplr(green);       % Flip the green image horizontally

% Step 3: Combine the red and flipped green images into a single image
% Create an empty 3-channel image of the same size
% Note: The blue channel remains zero, so where red and green overlap, the color will be yellow
combined = zeros(size(red, 1), size(red, 2), 3, 'uint8');

% Assign the red channel to the first channel of the RGB image
combined(:, :, 1) = red;

% Assign the flipped green channel to the second channel
combined(:, :, 2) = green_flipped;

imshow(combined);

% Step 4: Save the resultant image
imwrite(combined, 'combined_yellow.tif');