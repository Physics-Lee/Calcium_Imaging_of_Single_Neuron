function intensity_volume = intensity_of_a_volume(intensity,frame_per_volume)

% Reshape intensity array to have 5 rows
n = numel(intensity);
num_groups = floor(n / frame_per_volume);
intensity_reshaped = reshape(intensity(1:num_groups*frame_per_volume), frame_per_volume, []);

% Calculate mean, treating columns with any NaN as NaN
intensity_volume = mean(intensity_reshaped, 1);
intensity_volume = intensity_volume';

end