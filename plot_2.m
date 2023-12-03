function plot_2(I_1,I_2,list)

figure;
subplot(2,1,1)
plot_intensity(I_1,list{1});

subplot(2,1,2)
plot_intensity(I_2,list{2});

set_full_screen;

end