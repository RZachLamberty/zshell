#!/bin/bash
TSTART=$(date +%s)
MAX_FORKS=100
TODO_FILE=$1
DOWNLOAD_FOLDER="/tmp/hydra-curl"
NUM_URLS=${2:-$(wc -l < $TODO_FILE)}

echo "reading ${NUM_URLS} urls from file ${TODO_FILE}"

function curl_download {
    ANSWER_SIZE=0
    MIN_SIZE=10
    MAX_RETRIES=1
    ANSWER=""
    TRIES=0
    while [ "$TRIES" -lt "$MAX_RETRIES" ] && [ "$ANSWER_SIZE" -lt "$MIN_SIZE" ]
    do
        ANSWER=$(curl -s "$1" --max-time 10)
        ERR=$?
        if [ "$ERR" -ne "0" ]; then
            ANSWER=""
        else
            ANSWER_SIZE=${#ANSWER}
        fi
        let "TRIES += 1"
    done

    if [ "$ANSWER_SIZE" -ge "$MIN_SIZE" ]; then
        FNAME=$(mktemp -q $2/local.XXXXXXXXXXXXX)
        echo "$1" > $FNAME.url
        echo $ANSWER > $FNAME
    fi
}

export -f curl_download

mkdir -p $DOWNLOAD_FOLDER

head -n $NUM_URLS $TODO_FILE | xargs -P $MAX_FORKS -n 3 -I{} bash -c curl_download\ \{\}\ $DOWNLOAD_FOLDER

TEND=$(date +%s)

echo "start = ${TSTART}"
echo "end = ${TEND}"

exit $?
