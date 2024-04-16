function output_video = open_a_video(folder_path,video_name_str,video_format,fps)

output_video_path = fullfile(folder_path, video_name_str);
output_video = VideoWriter(output_video_path, video_format);
output_video.FrameRate = fps;
open(output_video);

end