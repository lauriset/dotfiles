#!/bin/bash
pkill n30f
	MUSIC_DIR=~/Musica/
	COVER=/tmp/cover.png
	bg=/tmp/begron.png
    back="~/home/lauri/pop-up/cover.png"
    
{	album="$(mpc -p 6600 --format %album% current)"
    file="$(mpc -p 6600 --format %file% current)"
    album_dir="${file%/*}"
    [[ -z "$album_dir" ]] && exit 1
    album_dir="$MUSIC_DIR/$album_dir"
    covers="$(find "$album_dir" -type d -exec find {} -maxdepth 1 -type f -iregex ".*/.*\(${album}\|cover\|folder\|artwork\|front\).*[.]\(jpe?g\|png\|gif\|bmp\)" \; )"
    src="$(echo -n "$covers" | head -n1)"
    rm -f "$COVER" 
    convert "$src" -resize 150 "$COVER"
      convert "$src" -resize 150 -bordercolor "#0B222A" -border 7x7 "$COVER"
	n30f -x 540 -y 800 -d ${COVER} -c "pkill n30f"
} &
