#!/bin/bash
set -e
if [ ! -d "virtualenv" ]; then
    virtualenv -p `which python2` virtualenv
fi
if [ ! -f credentials.py ]; then
cat > credentials.py <<EOF
consumer_key = ""
consumer_secret = ""
access_token = ""
access_token_secret = ""
EOF
fi
. virtualenv/bin/activate

pip install tweepy

echo '. virtualenv/bin/activate'

