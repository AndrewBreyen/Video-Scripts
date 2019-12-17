#!/bin/bash
# Takes one command line input, the file to be converted to .mp4

ffmpeg -i $1 -codec copy $1.mp4
