#!/bin/bash

C3D_DIR=../../binaries/x64/Release/bin
DATA_DIR=./PBR_SpecularGlossiness

for file in $DATA_DIR/*.cscn
do
	echo "Testing $file"
	pids=()
	timeout -k 60s 60s $C3D_DIR/CastorTestLauncher.exe -vk $file > /dev/null &
	pids+=($!)
	wait "${pids[@]}"
	$C3D_DIR/DiffImage.exe vk -f $file
done
