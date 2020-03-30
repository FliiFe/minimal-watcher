#!/usr/bin/env bash
#
# Usage: fetch.sh <url> <nickname>

mkdir -p results


if [ $# -lt 2 ]; then
    echo "Not enough arguments."
    exit
fi

if ! command -v curl >/dev/null; then
    echo "curl is not available"
    exit
fi

url=$1
nick=$2

cd results

mostrecent=$(find -iname "*$nick*" | tail -n 1)
if [[ -z "$mostrecent" ]]; then
    mostrecent="/dev/null"
fi

tempfiledest="/tmp/watcher-$nick.txt"

curl "$url" >"$tempfiledest" -s

if ! diff "$tempfiledest" "$mostrecent" -q >/dev/null; then
    cp "$tempfiledest" "$nick-$(date +%s)"
fi
