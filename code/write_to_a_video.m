function write_to_a_video(output_video,binary_frame_red)

binary_frame_uint8 = uint8(binary_frame_red) * 255;
writeVideo(output_video, binary_frame_uint8);

end