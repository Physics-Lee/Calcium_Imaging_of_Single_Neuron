function plot_intensity(intensity_volume,folder_path)

if contains(folder_path,"Red")
    color_str = 'red';
    title_str = 'red channel';
elseif contains(folder_path,"Green")
    color_str = 'green';
    title_str = 'green channel';
end
plot(1:length(intensity_volume),intensity_volume,color_str);
xlabel("volume","FontSize",20);
ylabel("$I$","Interpreter","latex","FontSize",20);
title(title_str,"FontSize",20);

end