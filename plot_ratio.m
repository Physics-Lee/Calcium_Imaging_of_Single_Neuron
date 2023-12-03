function plot_ratio(I_red,I_green)

is_nan_1 = isnan(I_red);
is_nan_2 = isnan(I_green);
is_nan = is_nan_1 | is_nan_2;

I_ratio = nan(length(I_green),1);
I_ratio(~is_nan) = I_green(~is_nan) ./ I_red(~is_nan);

% Tukey
% histogram(I_ratio);
IQR_index = 3;
[~, ~, mask_up, mask_down, up_limit, down_limit, upper_bound, lower_bound] = Tukey_test(I_ratio, IQR_index);
% Tukey_test_draw_lines(up_limit, down_limit, upper_bound, lower_bound);
I_ratio(mask_up | mask_down) = nan;

% plot
plot(1:length(I_ratio),I_ratio,'k');
xlabel("volume","FontSize",20);
ylabel("$\frac{Green}{Red}$","Interpreter","latex","FontSize",20);
title("ratio","FontSize",20);

end