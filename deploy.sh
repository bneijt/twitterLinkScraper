#!/bin/bash
if [ -z "$1" ]; then
    echo "Require host as first argument"
    exit
fi
git archive --format tar --prefix=twitterLinkScraper/ HEAD | ssh $1 'tar -x'
scp credentials.py $1:twitterLinkScraper/credentials.py
