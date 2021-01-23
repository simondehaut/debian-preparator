#!/bin/bash

OUTPUT_DIR="/home/dehaut/doc/captures_ecran"

mkdir -p $OUTPUT_DIR

TIME=$(date +%s%N)

scrot --quality 100 "$OUTPUT_DIR/capture_$TIME.png"
