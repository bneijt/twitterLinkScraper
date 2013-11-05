#!/bin/bash
set -e
if [ ! -d "virtualenv" ]; then
    virtualenv -p `which python2` virtualenv
fi

. virtualenv/bin/activate

pip install tweepy

echo '. virtualenv/bin/activate'

