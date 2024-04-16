% Specify the video file
folderPath = 'F:\1_learning\research\taxis of C.elegans\Calcium Imaging\data\WEN0234_check\w3_ND16_2024-04-10_23-28-30\1_Camera-Green_VSC-09321';
fileName = "Gauss_Adapt_size_3_std_3_sense_0.2000___disk_3___green_after_applying_all_template.mp4";
videoFile = fullfile(folderPath,fileName);     

% Create a video reader object
vidObj = VideoReader(videoFile);

% Define the output folder for PNG files
outputFolder = 'F:\1_learning\research\taxis of C.elegans\Calcium Imaging\data\temp';
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder); % Create the folder if it doesn't exist
end

% Initialize a frame counter
frameCounter = 0;

% Read and write each frame
while hasFrame(vidObj)
    frame = readFrame(vidObj); % Read one frame
    frameCounter = frameCounter + 1; % Increment the frame counter
    % Create a filename for each output image
    filename = fullfile(outputFolder, sprintf('frame_%06d.png', frameCounter));
    imwrite(frame, filename); % Write the frame to a PNG file
end

% vidObj closes automatically when the function exits