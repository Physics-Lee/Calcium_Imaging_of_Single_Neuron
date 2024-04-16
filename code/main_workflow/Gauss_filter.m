function binary_frame_red = Gauss_filter(gray_frame_red,h,sensitivity_threshold)

c_filtered_red = imfilter(gray_frame_red,h,'replicate');
T_red = adaptthresh(c_filtered_red, sensitivity_threshold);
binary_frame_red = imbinarize(c_filtered_red, T_red);

end