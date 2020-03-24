# classdojo attachment downloader

A tool to download all attachments from ClassDojo parent accounts.

## Disclaimer

This tools is for personal use only and is not intended for commercial use.
Do not use to overwhelm classdojo servers or gain access to unauthroized resources.
Use it at your own risk.

## Requirements

- [Docker](https://docs.docker.com/install/)
- A classdojo.com account

## Usage

```bash
# build
docker build . -t hammady/classdojo:1
```

```bash
# fetch storyfeed
docker run -it --rm \
  -v $PWD/feeds:/feeds \
  -e CLASSDOJO_LOGIN=<ENTER_VALUE> \
  -e CLASSDOJO_PASSWORD=<ENTER_VALUE> \
  -e CLASSDOJO_PAGES=<ENTER_VALUE_DEFAULT_IS_3> \
  hammady/classdojo:1 ./fetch.sh
```

It works by first signing in to classdojo.com, then listing the storyfeed
until it is consumed, or it reaches the maximum configured pages (default = 3).

```bash
# download all attachments from fetched storyfeed
docker run -it --rm \
  -v $PWD/feeds:/feeds \
  -v $PWD/downloads:/downloads \
  hammady/classdojo:1 ./download.py
```

This reads the storyfeed fetched in the previous step, iterates on all the posts
then downloads all attachments in a tree like structure as below. It can be
invoked any number of times as it will only download files that do not exist.

```
Class Name
  Teacher Name
    photo
      photo1.jpg
      photo2.jpg
    video
      video1.mp4
    file
      attachment1.docx
      slides1.ppt
```

This output is stored on the directory `./downloads` as per the above example.
