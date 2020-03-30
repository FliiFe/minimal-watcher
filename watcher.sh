#!/usr/bin/env bash

towatch=$(cat watchlist)

mkdir -p results
cd results

if ! command -v curl >/dev/null; then
    echo "curl is not available"
    exit
fi

interactive=false
if [[ -t 1 ]]; then
    interactive=true
fi

function color {
    if $interactive; then
        if [[ -z "$2" ]]; then
            echo -ne "\e[32m${1}\e[0;39m"
        else
            echo -ne "\e[${2}m${1}\e[0;39m"
        fi
    else
        echo -ne ${1}
    fi
}

function log {
    echo $(color "[$(date +%R:%S)]") "$*"
}

function fetchurl {
    url=$1
    nick=$2

    mostrecent=$(find -name "$nick-*" | tail -n 1)
    if [[ -z "$mostrecent" ]]; then
        mostrecent="/dev/null"
    fi

    tempfiledest="/tmp/watcher-$nick.txt"

    curl "$url" >"$tempfiledest" -s

    log "$(color $nick) fetched"

    if ! diff "$tempfiledest" "$mostrecent" -q >/dev/null; then
        log $(color "new version" "1;4") $(color "$nick" 92)
        ../newhook.sh
        cp "$tempfiledest" "$nick-$(date +%s).html"
    fi
}

function watchurl {
    nick=$1
    interval=$2
    url=$3
    log "Watching $(color $nick 33) at url $url with interval $(color $interval 33)"
    while true; do
        fetchurl $url $nick
        sleep $interval
    done;
}

for l in $towatch; do
    watchurl $(echo $l | sed s/,/\\n/g) &
done;

wait
