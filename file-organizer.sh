#!/bin/env bash

for file in ~/Downloads/*; do
    if [[ -f "$file" ]]; then
        fileExt="${file##*.}"
        case "$fileExt" in
            jpg|jpeg|png|gif)
                folder=~/Downloads/images ;;
            pdf|doc|docx|txt)
                folder=~/Downloads/documents ;;
            mpv|mkv|mov)
                folder=~/Downloads/videos ;;
            zip|tar|gz)
                folder=~/Downloads/archives ;;
            *)
                folder=~/Downloads/others ;;
        esac
        mkdir -p "$folder"
        mv "$file" "$folder"
    fi
done