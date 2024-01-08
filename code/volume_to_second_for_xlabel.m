function volume_to_second_for_xlabel(n_volume,volume_per_second)

n_second = n_volume/volume_per_second;
n_divide = 10;
xticks(0:n_volume/n_divide:n_volume);
xticklabels(0:n_second/n_divide:n_second);

end