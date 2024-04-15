% Define the video file
videoFile = 'F:\Desktop\新建文件夹\Demo.mp4';

% Create a VideoReader object to read video data
vidObj = VideoReader(videoFile);

% Prepare to write GIF
outputGif = 'output.gif';
delayTime = 1 / vidObj.FrameRate;  % Delay time between frames in seconds

% Initialize a variable to control GIF initialization
firstFrame = true;

% Read and write each frame
while hasFrame(vidObj)
    frame = readFrame(vidObj);  % Read a frame
    [imind, cm] = rgb2ind(frame, 256);  % Convert frame to indexed image
    
    % Write frame to GIF
    if firstFrame
        imwrite(imind, cm, outputGif, 'gif', 'Loopcount', inf, 'DelayTime', delayTime);
        firstFrame = false;  % Update flag after first frame is written
    else
        imwrite(imind, cm, outputGif, 'gif', 'WriteMode', 'append', 'DelayTime', delayTime);
    end
end