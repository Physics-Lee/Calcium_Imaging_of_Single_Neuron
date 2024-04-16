function intensity_normalized = plot_intensity_normalized(intensity_volume,folder_path)

intensity_normalized = normalization_dividing_by_the_mean(intensity_volume);
if contains(folder_path,"Red")
    color_str = 'red';
    title_str = 'red channel';
elseif contains(folder_path,"Green")
    color_str = 'green';
    title_str = 'green channel';
end
plot(1:length(intensity_normalized),intensity_normalized,color_str);
xlabel("volume","FontSize",20);
ylabel("$\frac{I-<I>}{<I>}$","Interpreter","latex","FontSize",20);
title(title_str,"FontSize",20);

end