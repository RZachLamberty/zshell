#!/bin/bash
TSTART=$(date +%s)
MAX_FORKS=100
TODO_FILE=$1
DOWNLOAD_FOLDER="/tmp/hydra-curl"
NUM_URLS=${2:-$(wc -l < $TODO_FILE)}

echo "reading ${NUM_URLS} urls from file ${TODO_FILE}"

function curl_download {
    curl -s "$1" --max-time 10 > $2/$(basename $1)
}

export -f curl_download

mkdir -p $DOWNLOAD_FOLDER

head -n $NUM_URLS $TODO_FILE | xargs -P $MAX_FORKS -n 3 -I{} bash -c curl_download\ \{\}\ $DOWNLOAD_FOLDER

TEND=$(date +%s)

echo "start = ${TSTART}"
echo "end = ${TEND}"

exit $?
