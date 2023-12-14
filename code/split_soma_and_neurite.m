function [soma,axon_dendrite] = split_soma_and_neurite(binary_frame,disk_size)

% open
se = strel('disk', disk_size);
binary_frame_opened = imopen(binary_frame, se);

% find connected regions
cc = bwconncomp(binary_frame_opened, 4);
n_pixels = cellfun(@numel, cc.PixelIdxList);

% init
soma = false(size(binary_frame));

% split
if isempty(n_pixels)
    axon_dendrite = false(size(binary_frame));
else

    % make the biggest connected region to be the soma
    [~, largest_idx] = max(n_pixels);
    soma(cc.PixelIdxList{largest_idx}) = true;

    % make the diff to be the neurite
    axon_dendrite = binary_frame & ~soma;
end

end