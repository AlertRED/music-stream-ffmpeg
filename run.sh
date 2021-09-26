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

    ffmpeg \
    -re \
    -loop 1\
    -vsync 1\
    -i "$image_path" \
    -i "$music_path" \
    -framerate $fps\
    -s "$video_w"x"$video_h" \
    -vf "realtime, scale=$video_w:$video_h, drawtext=text='$file_name':x=$offset_w:y=$video_h-$fontsize-$offset_h:fontsize=$fontsize:fontcolor=$fontcolor:bordercolor=$bordercolor:borderw=1:" \
    -c:v libx264 \
    -ar 44100 -c:a aac -ab 128k\
    -crf 21 \
    -pix_fmt yuv420p \
    -preset ultrafast \
    -maxrate 2048k -bufsize 2048k \
    -fflags nobuffer \
    -flags low_delay \
    -strict experimental \
    -af arealtime \
    -f flv rtmp://a.rtmp.youtube.com/live2/0f7g-ytdd-qv55-rcbm-drgw
    break
  done
# done
