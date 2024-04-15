function intensity_volume = cherry_pick_pooling(intensity, frame_per_volume)

% Select a frame from a volume. This is extremely useful when you use a large scan range on the z-axis, 
% as is the case with Qi Liu's confocal microscope.
%
% 2024-04-15, Yixuan Li
%

% Reshape
n = numel(intensity);
num_groups = floor(n / frame_per_volume);
intensity_reshaped = reshape(intensity(1:num_groups*frame_per_volume), frame_per_volume, []);

% Calculate max, omitnan
intensity_volume = intensity_reshaped(2,:);

end