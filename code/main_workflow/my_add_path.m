% add the path of this folder and all subfolder
%
% 2023-12-17, Yixuan Li
%

function my_add_path()

cdpath = mfilename('fullpath');
cdpath = fileparts(cdpath);
cd(cdpath); % enter .m filepath
addpath(genpath(cdpath)); % add path

end