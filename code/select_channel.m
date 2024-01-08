% For multi worm .tif, select the channel which has more bright points for 
% certain worm.
%
% parameters:
% - binary_frame_red: binary frame for the red channel.
% - binary_frame_green: binary frame for the green channel.
% - region_prop_red: the rectangle in the red channel containing the 
% current worm. Should be 1*4 numerical array.
%
% 2024-01-08, Yixuan Li
%

function Brighter_Channel = select_channel(binary_frame_red,binary_frame_green,region_prop_red)
y_min = region_prop_red(1,1);
y_max = region_prop_red(1,2);
x_min = region_prop_red(1,3);
x_max = region_prop_red(1,4);

y_all = size(binary_frame_red,2);
n_bright_pixel_red = sum(sum(binary_frame_red(x_min:x_max,y_min:y_max)));
n_bright_pixel_green = sum(sum(binary_frame_green(x_min:x_max,y_all - y_max : y_all - y_min)));

if n_bright_pixel_red >= n_bright_pixel_green
    Brighter_Channel = "Red";
else
    Brighter_Channel = "Green";
end

end