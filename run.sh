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
fps=2
g=2
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

    ffmpeg -re -loop 1 -framerate $fps -i "$image_path" -i "$music_path" -shortest \
    -c:v libx264 -preset fast -tune zerolatency -b:v 4000k -minrate 3000k -maxrate 5000k -bufsize 2M -pix_fmt yuv420p -g $g \
    -vf "scale=$video_w:$video_h, drawtext=text='$file_name':x=$offset_w:y=$video_h-$fontsize-$offset_h:fontsize=$fontsize:fontcolor=$fontcolor:bordercolor=$bordercolor:borderw=1:" \
    -c:a aac -b:a 192k -ac 2 -ar 44100 \
    -f flv rtmp://a.rtmp.youtube.com/live2/fc25-t64w-zhka-pwth-693h \
    -loglevel info -hide_banner
  done
done
