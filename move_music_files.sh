#!/bin/bash

# Check if the source and destination directories are provided
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <source_directory> <destination_directory>"
  exit 1
fi

# Assign command-line arguments to variables
SOURCE_DIR="$1"
DEST_DIR="$2"

# Ensure source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
  echo "Error: Source directory $SOURCE_DIR does not exist."
  exit 1
fi

# Create the destination directory if it doesn't exist
if [ ! -d "$DEST_DIR" ]; then
  echo "Creating destination directory: $DEST_DIR"
  mkdir -p "$DEST_DIR"
fi

# Define an array of music file extensions
MUSIC_EXTENSIONS=("mp3" "wav" "flac" "aac" "m4a" "ogg" "wma")

# Initialize file count
file_count=0

# Count total music files to process
echo "Counting music files in $SOURCE_DIR..."
for ext in "${MUSIC_EXTENSIONS[@]}"; do
  count=$(find "$SOURCE_DIR" -type f -iname "*.$ext" | wc -l)
  file_count=$((file_count + count))
done

# If no music files are found, skip moving
if [ "$file_count" -eq 0 ]; then
  echo "No music files found in $SOURCE_DIR."
else
  echo "Found $file_count music files to move."

  # Navigate through all subdirectories and move music files
  moved_count=0
  for ext in "${MUSIC_EXTENSIONS[@]}"; do
    find "$SOURCE_DIR" -type f -iname "*.$ext" | while read -r file; do
      mv -v "$file" "$DEST_DIR"
      moved_count=$((moved_count + 1))
      echo "Progress: $moved_count / $file_count files moved."
    done
  done
fi

# Delete all remaining files and folders in the source directory
echo "Cleaning up remaining files and folders in $SOURCE_DIR..."
rm -rf "$SOURCE_DIR"/* "$SOURCE_DIR"/.??*
echo "Cleanup completed."

echo "All music files have been moved and source directory cleaned up successfully!"
