#!/bin/bash

shopt -s nullglob
banners=(/root/banners/*)

if (("${#banners[@]}" > 0)); then
    printf '\n'
    cat "${banners[RANDOM % ${#banners[@]}]}"
fi
