# classdojo attachment downloader

A tool to download all attachments from ClassDojo parent accounts.

## DISCLAIMER

THIS TOOLS IS FOR PERSONAL USE ONLY AND IS NOT INTENDED FOR COMMERCIAL USE.
DO NOT USE TO OVERWHELM CLASSDOJO SERVERS OR GAIN ACCESS TO UNAUTHROIZED RESOURCES.
USE IT AT YOUR OWN RISK.

## Motivation

[Classdojo](https://www.classdojo.com) is an amazing platform for schools to
share posts with parents organized by class/teacher. Parents can like and comment
on posts that can contain photos, videos or any attachments. With heavy usage,
you start feeling drown in many posts and you cannot easily access older attachments
or search for them by type, class, teacher or date. If this sounds familiar, this
tool is for you. It downloads all attachments and organizes them in a folder-like
structure so that you can find any file easily. Files are time-stamped, so you
can sort them by date and see a chronological order where new files come earlier.

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

This output is stored in the directory `./downloads` as per the above example.
