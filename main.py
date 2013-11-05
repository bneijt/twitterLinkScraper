#!/usr/bin/env python
import tweepy
import re
import sys


import credentials

#Test for required auth credentials
assert credentials.consumer_key
assert credentials.consumer_secret
assert credentials.access_token
assert credentials.access_token_secret


urlRegex = re.compile("(http://[a-zA-Z0-9.-_]+\\.[a-zA-Z]{2,3}(/[a-zA-Z0-9.-_/:#$?]*)?)")

class StreamWatcherListener(tweepy.StreamListener):

    def on_status(self, status):
        try:
            urls = [m[0] for m in urlRegex.findall(status.text)]
            for u in urls:
                print u
        except Exception, e:
            sys.stderr.write("Caught: " + str(e) + "\n")
            pass

    def on_error(self, status_code):
        sys.stderr.write('An error has occured! Status code = %s\n' % status_code)
        return True  # keep stream alive

    def on_timeout(self):
        sys.stderr.write('Snoozing\n')


def main():
    # Prompt for login credentials and setup stream object
    auth = tweepy.OAuthHandler(credentials.consumer_key, credentials.consumer_secret)
    auth.set_access_token(credentials.access_token, credentials.access_token_secret)
    stream = tweepy.Stream(auth, StreamWatcherListener(), timeout=None)

    # Prompt for mode of streaming
    stream.sample()


if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        sys.stderr.write('Goodbye\n')
