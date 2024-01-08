function plot_diff(I_red,I_green)

is_nan_1 = isnan(I_red);
is_nan_2 = isnan(I_green);
is_nan = is_nan_1 | is_nan_2;

I_diff = nan(length(I_green),1);
I_diff(~is_nan) = I_green(~is_nan) - I_red(~is_nan);

% Tukey
IQR_index = 100;
[~, ~, mask_up, mask_down, ~, ~, ~, ~] = Tukey_test(I_diff, IQR_index);
I_diff(mask_up | mask_down) = nan;

% plot
plot(1:length(I_diff),I_diff,'k');
xlabel("volume","FontSize",20);
ylabel("Green - Red","FontSize",10);
title("diff","FontSize",20);

end