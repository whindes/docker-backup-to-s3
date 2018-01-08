#!/bin/sh

set -e

#**************** DO NOT REMOVE THIS BLOCK ***************************
#        (sed replacements in start.sh) 
#PARAMS=
#DATA_PATH=
#S3_PATH=
#*********************************************************************

echo "Job get started: $(date)"

umask 0
/usr/bin/s3cmd get -r $PARAMS  "$S3_PATH" "$DATA_PATH"

echo "Job get finished: $(date)"
