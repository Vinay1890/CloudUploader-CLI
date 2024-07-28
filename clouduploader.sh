kk#!/bin/bash

# Check if at least one argument is provided
if [ $# -lt 1 ]; then
    echo "Usage: clouduploader /path/to/file [target_directory]"
    exit 1
fi

FILE=$1
TARGET_DIR=$2
BUCKET_NAME="clouduploaderfile"
REGION="ap-south-1"  

# Check if the file exists
if [ ! -f "$FILE" ]; then
    echo "File not found!"
    exit 1
fi

# Set TARGET_DIR if not provided
if [ -z "$TARGET_DIR" ]; then
    TARGET_DIR=""
else
    TARGET_DIR="${TARGET_DIR%/}/"
fi

# Display the variables for debugging
echo "File: $FILE"
echo "Target Directory: $TARGET_DIR"
echo "Bucket Name: $BUCKET_NAME"
echo "Region: $REGION"

# Use pv for progress bar and upload the file
pv "$FILE" | aws s3 cp - "s3://${BUCKET_NAME}/${TARGET_DIR}$(basename "$FILE")" --region ${REGION}
if [ $? -ne 0 ]; then
    echo "Upload failed!"
    exit 1
fi

echo "File uploaded successfully!"

# Generate a shareable link
SHARE_LINK=$(aws s3 presign "s3://${BUCKET_NAME}/${TARGET_DIR}$(basename "$FILE")" --region ${REGION})
echo "Shareable link: $SHARE_LINK"

