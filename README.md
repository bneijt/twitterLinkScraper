Script to scrape and visit all Twitter sample stream urls
=========================================================

Simple script to scrape urls from the Twitter sample stream and resolve the urls to normal urls
in order to gather data for fun.

Start
-----

- Move to the root directory (next to `bootstrap.sh`)
- Run `./bootstrap.sh`
- Place your app credentials in `credentials.py`


rotate.sh
---------
Creates a data directory where it will rotate the sample stream into separate txt files.

deploy.sh
---------
Script to copy HEAD and credentials.py to the host given as first argument.

linkResolver.py
---------------
Script that reads `data/*.txt` and creates `data/same_name.clean` with the resolved (follow redirects) urls
of the given txt file. To keep the script from being considered a bot, I randomly sleep some.

