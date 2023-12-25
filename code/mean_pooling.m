function intensity_volume = mean_pooling(intensity,frame_per_volume)

% Reshape
n = numel(intensity);
num_groups = floor(n / frame_per_volume);
intensity_reshaped = reshape(intensity(1:num_groups*frame_per_volume), frame_per_volume, []);

% Calculate mean, omit nan
intensity_volume = mean(intensity_reshaped, 1, 'omitnan');
intensity_volume = intensity_volume';

end