#!/usr/bin/env bash
ffmpeg -i $1 -c:v libtheora -q:v 7 -c:a libvorbis -q:a 4 $2
