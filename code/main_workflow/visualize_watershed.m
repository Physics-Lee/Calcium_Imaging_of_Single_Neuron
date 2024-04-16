% visualize watershed method
%
% 2023-12-13, Yixuan Li
%

function visualize_watershed(binary_frame)

% Step 1: Show the original binary image
figure;
imshow(binary_frame);
title('Original Binary Image');

% Step 2: Apply morphological opening to clean up the image
% se = strel('disk', 0);
% binary_frame_streled = imopen(binary_frame, se);
binary_frame_streled = binary_frame;

% Step 3: Compute the distance transform
D = -bwdist(~binary_frame_streled);

figure;
imshow(-D, []);
title('Distance Transform of Binary Image');

figure;
imshow(D, []);
title('Complement of Distance Transform of Binary Image');

% Step 4: Apply watershed transform to the distance transform
L = watershed(D);
% binary_frame_streled(L == 0) = 0;

% Step 5: Show the watershed lines on the original image
% Create an RGB version of the original image
RGB_label = label2rgb(L, 'jet', 'w', 'shuffle');
figure;
imshow(RGB_label);
title('Watershed Transform Lines on Original Image');

% Overlay the watershed lines on the original image
figure;
imshow(binary_frame);
hold on
h = imshow(RGB_label);
set(h, 'AlphaData', 0.3); % The alpha data determines the transparency
title('Watershed Lines Overlay on Original Image');

end