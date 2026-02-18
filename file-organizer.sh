#!/bin/env bash

VERBOSE=false
DRY_RUN=false
TARGET_DIR="."

usage() {
    echo "usage: $0 [-d directory] [-v] [-n] [-h]"
    echo "  -d : specify directory to organize (default: current folder)"
    echo "  -n : dry run (preview changes without moving files)"
    echo "  -v : verbose mode (show every file moved)"
    echo "  -h : show this help message"
    exit 1
}

while getopts "d:nvh" opt; do
    case "$opt" in
        d) TARGET_DIR="$OPTARG" ;;
        v) VERBOSE=true ;;
        n) DRY_RUN=true ;;
        h) usage ;;
        *) usage ;;
    esac
done

if [[ ! -d "$TARGET_DIR" ]]; then
    echo "error: directory '$TARGET_DIR' doesn't exist"
    exit 1
fi

echo "organizing $TARGET_DIR"
if [[ "$DRY_RUN" = true ]]; then
    echo "----- dry run -----"
fi

cd "$TARGET_DIR" || exit 2

for file in *; do
    if [[ -f "$file" && "$file" != "file-organizer.sh" ]]; then
        fileExt="${file##*.}"
        fileExt=$(echo "$fileExt" | tr '[:upper:]' '[:lower:]')

        case "$fileExt" in
            jpg|jpeg|png|gif|svg) folder="images" ;;
            pdf|doc|docx|txt|rtf) folder="documents" ;;
            mpv|mkv|mov|mp4|avi) folder="videos" ;;
            mp3|wav|flac) folder="music" ;;
            zip|tar|gz|7z) folder="archives" ;;
            deb) folder="apps" ;;
            *) folder="others" ;;
        esac

        if [[ "$DRY_RUN" = true ]]; then
        echo "would move: $file -> $folder"
        else
            mkdir -p "$folder"
            mv "$file" "$folder"

            if [[ "$VERBOSE" = true ]]; then
                echo "moved: $file -> $folder"
            fi
        fi
    fi
done