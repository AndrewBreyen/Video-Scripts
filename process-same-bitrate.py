#!/usr/bin/env python

import argparse
import json
import subprocess
import sys
import os
from pathlib import Path
from typing import NamedTuple
from ffmpeg import FFmpeg, Progress

class FFProbeResult(NamedTuple):
    return_code: int
    json: str
    error: str

def ffprobe(file_path) -> FFProbeResult:
    command_array = ["ffprobe",
                     "-v", "quiet",
                     "-print_format", "json",
                     "-show_format",
                     "-show_streams",
                     file_path]
    result = subprocess.run(command_array, stdout=subprocess.PIPE, stderr=subprocess.PIPE, universal_newlines=True)
    return FFProbeResult(return_code=result.returncode,
                         json=result.stdout,
                         error=result.stderr)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='View ffprobe output')
    parser.add_argument('-i', '--input', help='File Name', required=True)
    args = parser.parse_args()
    
    if not Path(args.input).is_file():
        print("could not read file: " + args.input)
        exit(1)

    print('File:       {}'.format(args.input))
    ffprobe_result = ffprobe(file_path=args.input)
    
    if ffprobe_result.return_code == 0:
        # Print the raw json string
        # print(ffprobe_result.json)

        # or print a summary of each stream
        d = json.loads(ffprobe_result.json)
        streams = d.get("streams", [])
        video_bitrate = None  # Initialize to None
        audio_bitrate = None  # Initialize to None
        for stream in streams:
            if stream.get("codec_type", "unknown") == "video":
                video_bitrate = stream.get("bit_rate")
            if stream.get("codec_type", "unknown") == "audio":
                audio_bitrate = stream.get("bit_rate")

        print('Input File:  {}'.format(args.input))
        # Generate the output file name
        input_file_name, input_file_extension = os.path.splitext(args.input)
        output_file = input_file_name + "-reencoded" + input_file_extension
        print('Output File: {}'.format(output_file))        

        print("video: " + str(video_bitrate))  # Convert to str for printing
        print("audio: " + str(audio_bitrate))  # Convert to str for printing

        if video_bitrate is not None:
            # Use ffmpeg-python to transcode the video
            ffmpeg = (
                FFmpeg()
                .input(args.input)
                .output(
                    output_file,
                    {"codec:v": "h264_videotoolbox", "codec:a": "aac"},
                    b="{}k".format(int(video_bitrate) // 1000)  # Set video bitrate
                )
            )

            ffmpeg.execute()
            print("Video conversion completed.")

    else:
        print("ERROR")
        print(ffprobe_result.error, file=sys.stderr)
