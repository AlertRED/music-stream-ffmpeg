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

while true;
do
  for music_path in $music_folder/**/*.*;
  do
    file_name=$(basename "$music_path")
    file_name="${file_name%.*}"
    file_name=$(sed -r 's/^[0-9]+.//' <<< $file_name)

    ffmpeg \
    -loop 1 \
    -re \
    -framerate $fps \
    -i "$image_path" \
    -thread_queue_size 512 \
    -i "$music_path" \
    -loop -1 \
    -c:v libx264 -tune stillimage -pix_fmt yuv420p -preset ultrafast -r $fps -g $(($fps *2)) -b:v 10M \
    -c:a aac -threads $(nproc) -ar 44100 -b:a 192k -bufsize 512k -pix_fmt yuv420p \
    -f flv rtmp://a.rtmp.youtube.com/live2/0f7g-ytdd-qv55-rcbm-drgw
  done
done
