#!/bin/bash

C3D_DIR=../../binaries/x64/Release/bin
DATA_DIR=./Legacy

for file in $DATA_DIR/Compare/Fail/*.png
do
	rm $file
	file=${file/_ref.png/.cscn}
	file=${file/'/Compare/Fail'/''}
	echo "Regenerating $file"
	pids=()
	timeout -k 60s 60s $C3D_DIR/CastorTestLauncher.exe --generate $file > /dev/null &
	pids+=($!)
	wait "${pids[@]}"
done
