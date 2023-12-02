function intensity_volume = intensity_of_a_volume(intensity)

% Reshape intensity array to have 5 rows
n = numel(intensity);
num_groups = floor(n / 5);
reshaped_intensity = reshape(intensity(1:num_groups*5), 5, []);

% Calculate mean, treating columns with any NaN as NaN
intensity_volume = mean(reshaped_intensity, 1);
intensity_volume = intensity_volume';

end