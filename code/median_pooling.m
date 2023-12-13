function intensity_volume = median_pooling(intensity,frame_per_volume)

% Reshape
n = numel(intensity);
num_groups = floor(n / frame_per_volume);
intensity_reshaped = reshape(intensity(1:num_groups*frame_per_volume), frame_per_volume, []);

% Calculate median, treating columns with any NaN as NaN
intensity_volume = median(intensity_reshaped, 1);
intensity_volume = intensity_volume';

end