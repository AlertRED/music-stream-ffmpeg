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
fps=25

# while true;
# do
  for music_path in $music_folder/**/*.*;
  do
    file_name=$(basename "$music_path")
    file_name="${file_name%.*}"
    file_name=$(sed -r 's/^[0-9]+.//' <<< $file_name)

    ffmpeg -loop 1 -re -i "$image_path" -i "$music_path"  \
    -vf "format=yuv420p, scale=$video_w:$video_h, drawtext=text='$file_name':x=$offset_w:y=$video_h-$fontsize-$offset_h:fontsize=$fontsize:fontcolor=$fontcolor:bordercolor=$bordercolor:borderw=1:" \
    -c:v libx264 -b:v 2000k -maxrate 2000k -bufsize 4000k -g 3 -c:a aac -preset veryfast \
    -f flv rtmp://a.rtmp.youtube.com/live2/0f7g-ytdd-qv55-rcbm-drgw
  done
# done
