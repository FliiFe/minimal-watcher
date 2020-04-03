#!/usr/bin/env bash

mkdir -p results
# cd results

if ! command -v curl >/dev/null; then
    echo "curl is not available"
    exit
fi

interactive=false
if [[ -t 1 ]]; then
    interactive=true
fi

quiet=$([[ "$*" == *-q* ]] && echo true || echo false)

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
    preprocessor="${@:3}"

    mostrecent=$(find results/ -name "$nick-*" | sort | tail -n 1)
    if [[ -z "$mostrecent" ]]; then
        mostrecent="/dev/null"
    fi

    tempfiledest="/tmp/watcher-$nick.txt"

    fl=$(curl "$url" -s | $preprocessor | tee "$tempfiledest" | wc -c)

    $quiet || log "$(color $nick) fetched, file length $(color $fl)"

    if [[ "$fl" -ne 0 ]]; then
        if ! diff "$tempfiledest" "$mostrecent" -q >/dev/null; then
            log $(color "new version" "1;4") $(color "$nick" 92)
            cp "$tempfiledest" "results/$nick-$(date +%s).html"
            ./newhook.sh "$nick" &
        fi
    fi
}

function watchurl {
    nick=$1
    interval=$2
    url=$3
    preprocessor="${@:4}"
    if [[ -z "$preprocessor" ]]; then
        preprocessor="cat -"
    fi
    log "Watching $(color $nick 33) at url $url with interval $(color $interval 33). Preprocessor: "$(color "$preprocessor" 33)
    while true; do
        fetchurl $url $nick "$preprocessor"
        sleep $interval
    done;
}

while read l ; do
    watchurl $(echo $l | sed s/,/\\n/g) &
done <watchlist

wait
