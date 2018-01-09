#!/bin/sh

set -e

#**************** DO NOT REMOVE THIS BLOCK ***************************
#        (sed replacements in start.sh) 
#PARAMS=
#DATA_PATH=
#S3_PATH=
#*********************************************************************

echo "Job started: $(date)"

/usr/bin/s3cmd sync $PARAMS "$DATA_PATH" "$S3_PATH"

echo "Job finished: $(date)"
