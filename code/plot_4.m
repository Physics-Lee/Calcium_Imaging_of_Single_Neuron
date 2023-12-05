function plot_4(I_1,I_2,I_1_info,list)

figure;

subplot(4,1,1)
plot_intensity(I_1,list{1});

subplot(4,1,2)
plot_intensity(I_2,list{2});

subplot(4,1,3)
if I_1_info == "Red"
    plot_diff(I_1,I_2);
else
    plot_diff(I_2,I_1);
end

subplot(4,1,4)
if I_1_info == "Red"
    plot_ratio(I_1,I_2);
else
    plot_ratio(I_2,I_1);
end

set_full_screen;

end