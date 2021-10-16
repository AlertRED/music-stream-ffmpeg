#!/bin/bash

music_folder="m"
image_path="images/1.jpg"
video_path="output.mp4"

fontsize=36
video_w=640
video_h=480
offset_w=15
offset_h=15
fontcolor="#ffffff@1.0"
bordercolor="#000000@1.0"
fps=25

# ffmpeg -loop 1 -framerate 24 \
# -i "$image_path" -c:v libx264 -preset veryslow -tune stillimage -pix_fmt yuv420p -t 5 -crf 24 -movflags +faststart "$video_path"

echo "Clip prepared"

while true;
do
  for music_path in $music_folder/**/*.*;
  do
    file_name=$(basename "$music_path")
    file_name="${file_name%.*}"
    file_name=$(sed -r 's/^[0-9]+.//' <<< $file_name)

    echo $file_name


    ffmpeg \
    -loop 1 \
    -re \
    -framerate $fps \
    -i "$video_path" \
    -thread_queue_size 512 \
    -i "$music_path" \
    -c:v libx264 -preset ultrafast -b:v 1500k \
    -c:a aac -threads $(nproc) -ar 44100 -b:a 192k -bufsize 512k -pix_fmt yuv420p \
    -f flv rtmp://a.rtmp.youtube.com/live2/kj5h-3mkp-gsxh-xw7s-3emz
  done
done
