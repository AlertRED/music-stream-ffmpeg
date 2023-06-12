#!/bin/bash

music_folder="$1"
image_path="$2"
fontfile="$3"

title="lofi ambient"
fontsize=72
video_w=1920
video_h=1080
offset_w=$video_w/2-4*$fontsize/2
offset_h=$fontsize
fontcolor="#ffffff@1.0"
bordercolor="#000000@1.0"
fps=2
g=2


function main() {
	music_paths=()
	while true;
	do
    	for music_path in $music_folder/**/*.*;
	    do
	        file_name=$(basename "$music_path")
        	file_name="${file_name%.*}"
	        file_name=$(sed -r 's/^[0-9]+.//' <<< $file_name)

	        music_paths+=("$music_path")
	    done

	    music_paths_str=$(printf "%s|" "${music_paths[@]}")

	    # https://stackoverflow.com/questions/33684845/using-ffmpeg-to-stream-my-webcams-video-to-youtube

	    ffmpeg -hide_banner -re -loop 1 -framerate $fps -i "$image_path" -i "concat:$music_paths_str" -shortest \
	    -c:v libx264 -preset fast -tune zerolatency -b:v 4000k -minrate 3000k -maxrate 5000k -bufsize 2M -pix_fmt yuv420p -g $g \
	    -vf "scale=$video_w:$video_h, drawtext=text='$title':x=$offset_w:y=$video_h-$fontsize-$offset_h:fontsize=$fontsize:fontfile=$fontfile:fontcolor=$fontcolor:bordercolor=$bordercolor:borderw=1:" \
	    -c:a aac -b:a 192k -ac 2 -ar 44100 \
	    -f flv rtmp://a.rtmp.youtube.com/live2/fc25-t64w-zhka-pwth-693h \
	    -loglevel info
	done
}

main
