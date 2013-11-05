
import httplib
httplib.HTTPConnection.debuglevel = 1
import urllib2
import os
import codecs

import random
import time

def randomSleep():
    time.sleep(random.randint(1,20))

def downloadAndReturnRealUrl(url):
    request = urllib2.Request(url)
    opener = urllib2.build_opener()
    request.add_header('Accept-Encoding', 'gzip,deflate,sdch')
    request.add_header('Accept-Language', 'en-US,en;q=0.8,nl;q=0.6')
    request.add_header('User-Agent', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/28.0.1500.71 Chrome/28.0.1500.71 Safari/537.36')
    response = opener.open(request)
    #Read the response
    while True:
        chunk = response.read(10240)
        if not chunk:
            break
    return response


def main():
    while True:
        for inputCandidate in os.listdir("data"):
            if inputCandidate.endswith(".txt"):
                ifName = os.path.join("data", inputCandidate)
                print("Opening " + ifName)
                with codecs.open(ifName, "rb") as inputFile:
                    with codecs.open(ifName + ".clean", "wb") as outputFile:
                        for inputUrl in inputFile.xreadlines():
                            randomSleep()
                            try:
                                inputUrl = inputUrl.strip()
                                r = downloadAndReturnRealUrl(inputUrl)
                                outputFile.write(r.url + "\n")
                            except urllib2.URLError, e:
                                print("Failed on " + inputUrl)
                                pass

if __name__ == "__main__":
    main()