#!/bin/bash

music_folder="music"
image_path="images/1.jpg"
fontsize=36
video_w=1920
video_h=1080
offset_w=15
offset_h=15
fontcolor="#ffffff@1.0"
bordercolor="#000000@1.0"
fps=24

ffmpeg -loop 1 -framerate 24 \
-i "$image_path" -c:v libx264 -preset veryslow -tune stillimage -crf 24 -r 24 -pix_fmt yuv420p -t 10 -movflags +faststart output.mp4
