function I_ratio = plot_3(I_1,I_2,I_1_info,list)

figure;

subplot(3,1,1)
plot_intensity(I_1,list{1});

subplot(3,1,2)
plot_intensity(I_2,list{2});

subplot(3,1,3)
if I_1_info == "Red"
    I_ratio = plot_ratio(I_1,I_2);
else
    I_ratio = plot_ratio(I_2,I_1);
end

set_full_screen;

end