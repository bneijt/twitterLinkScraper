#!/bin/bash
#Download the urls from twitter and store them in files
cd "`dirname "$0"`"
mkdir -p data
cd data

maxLineCount=10000
if [[ ! -e "logfifo" ]]; then
    mkfifo "logfifo"
fi

../dist/build/twitterLinkScraper/twitterLinkScraper > logfifo &
PID=$!

while true;do
    for i in {1..50}; do
        currentFile="${i}.txt"
        head -n "${maxLineCount}" logfifo > "${currentFile}"
    done
done
kill "${PID}"
wait

