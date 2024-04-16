% perform opening on neurite after splitting to remove noise, which is
% typically a circle on the edge of the soma
%
% 2023-12-14, Yixuan Li
%

function axon_dendrite_opened = opening_for_neurite(axon_dendrite,disk_size)

if nargin < 2
    disk_size = 1;
end

se = strel('disk', disk_size);
axon_dendrite_opened = imopen(axon_dendrite, se);

end