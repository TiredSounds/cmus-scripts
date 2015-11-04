#!/bin/bash
## Upload current track from Cmus to file host (in this case transfer.sh).
## Passing -t will transcode from FLAC to mp3 if applicable.
## Requires curl and ffmpeg.

if ! cmus-remote -Q &>/dev/null; then
	echo "Cmus is not running."
	exit
fi

# Get path
NP=$( cmus-remote -Q | grep "file" | sed "s/file //" )
echo -e "PATH: '$NP'\n"

# If .flac AND if -t option passed, transcode to mp3
if [[ "$1" == "-t" ]]; then
	if echo "$NP" | grep -q ".flac"; then
		echo -e "Transcoding FLAC to mp3...\n"
		ffmpeg -loglevel quiet -i "$NP" -qscale:a 0 "${NP[@]/%flac/mp3}"
		NP="${NP[@]/%flac/mp3}"
		MP3="1"
	fi
fi

# Get target
NAME=$( echo "$NP"| rev | cut -d"/" -f1 | rev | sed "s| |%20|g" )
echo -e "TARGET: '$NAME'\n"

# Upload
curl --globoff --upload-file "$NP" "https://transfer.sh/$NAME"

if [[ "$MP3" == "1" ]]; then
	printf "\nRemoving temporary file..."
	rm "$NP"
	printf " Done."
fi

exit