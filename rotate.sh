#!/bin/bash
#Download the urls from twitter and store them in files
set -e
cd "`dirname "$0"`"
. virtualenv/bin/activate
mkdir -p data
cd data

maxLineCount=10000
if [[ ! -e "logfifo" ]]; then
    mkfifo "logfifo"
fi

python ../main.py > logfifo &
PID=$!
echo "Kill $PID to stop"
while true;do
    for i in {1..50}; do
        currentFile="${i}.txt"
        head -n "${maxLineCount}" logfifo > "${currentFile}"
    done
done
kill "${PID}"
wait

