% perform opening on neurite after splitting to remove noise, which is
% typically a circle on the edge of the soma
%
% 2023-12-14, Yixuan Li
%

function axon_dendrite_opened = opening_for_neurite(axon_dendrite)
se = strel('disk', 1);
axon_dendrite_opened = imopen(axon_dendrite, se);
end