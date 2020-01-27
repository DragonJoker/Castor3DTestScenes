#!/bin/bash

C3D_DIR=../../binaries/x64/Release/bin
DATA_DIR=./PBR_SpecularGlossiness

for file in $DATA_DIR/*.cscn
do
	echo "Testing $file"
	pids=()
	timeout -k 60s 60s $C3D_DIR/CastorTestLauncher -vk $file > /dev/null &
	pids+=($!)
	# timeout -k 60s 60s $C3D_DIR/CastorTestLauncher -gl $file > /dev/null &
	# pids+=($!)
	# timeout -k 60s 60s $C3D_DIR/CastorTestLauncher -d3d11 $file > /dev/null &
	# pids+=($!)
	wait "${pids[@]}"
	# echo "  Diffing"
	# $C3D_DIR/DiffImage gl d3d11 vk -f $file
done
