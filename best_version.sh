#!/bin/bash

music_folder="music"
image_path="images/1.jpg"
video_path="output.mp4"

fontsize=36
video_w=1920
video_h=1080
offset_w=15
offset_h=15
fontcolor="#ffffff@1.0"
bordercolor="#000000@1.0"
fps=24
g=24
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

    # https://stackoverflow.com/questions/33684845/using-ffmpeg-to-stream-my-webcams-video-to-youtube
    
    ffmpeg -re -loop 1 -i "$image_path" -i "$music_path" \
    -c:v libx264 -preset ultrafast -tune zerolatency -b:v 5000k -minrate 4500k -maxrate 6000k -bufsize 2M -pix_fmt yuv420p -g $g \
    -vf "scale=$video_w:$video_h, drawtext=text='$file_name':x=$offset_w:y=$video_h-$fontsize-$offset_h:fontsize=$fontsize:fontcolor=$fontcolor:bordercolor=$bordercolor:borderw=1:" \
    -c:a aac -b:a 192k -ac 2 -ar 44100 \
    -f flv rtmp://a.rtmp.youtube.com/live2/5f68-6rp4-g6gy-8cc7-ae11
  done
done
