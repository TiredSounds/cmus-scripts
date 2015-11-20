#!/usr/bin/env bash
## Download cover art for currently playing album in Cmus music player.

## Requires glyr

ARTIST=$( cmus-remote -Q | grep "tag artist " | sed "s/tag artist //" )
ALBUM=$( cmus-remote -Q | grep "tag album " | sed "s/tag album //" )
FOLDER=$( cmus-remote -Q | grep "file" | sed "s/file //" | rev | \
cut -d"/" -f2- | rev )

glyrc cover -w "$FOLDER" -F "jpeg;png;jpg" --artist "$ARTIST" --album "$ALBUM"
