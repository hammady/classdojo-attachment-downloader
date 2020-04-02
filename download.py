#!/usr/bin/env python

import sys
import os
import json
import time
import subprocess
from datetime import datetime

def main():

  base_out = "/downloads"
  errors = 0
  skipped = 0
  total = 0

  # load from file
  with open('/feeds/singlefeed.json') as json_file:
    data = json.load(json_file)

    # iterate to get data
    for item in data:
      if item["senderName"] == "Mojo":
        continue
      # print(item)
      _post_id = item["_id"]
      _dt_str = item["time"]
      _class = item["headerSubtext"]
      _teacher = item["headerText"]
      _post_dir = os.path.join(base_out, _class, _teacher)
      for _att in item["contents"]["attachments"]:
        _type = _att["type"]
        _att_id = _att["_id"]
        _path = _att["path"]

        _, ext = os.path.splitext(_path)
        _filename = _att_id + ext
        _metadata = _att.get("metadata")
        if _metadata:
          if _metadata.get("filename"):
            _filename = _metadata.get("filename")
        _type_dir = os.path.join(_post_dir, _type)
        _file = os.path.join(_type_dir, _filename)
        total += 1

        if os.path.isfile(_file):
          print("Skipping", _file, "(exists)")
          skipped += 1
        else:
          # download attachment
          os.makedirs(_type_dir, exist_ok=True)
          print(_path, '->', _file)
          ret = subprocess.call(["curl", "-fsS", "--cookie", "/feeds/classdojo.cookie", "-o", str(_file), _path])
          if ret == 0:
            # set timestamp for downloaded file to post timestamp
            _dt = datetime.fromisoformat(_dt_str.replace("Z", "+00:00"))
            _ts = time.mktime(_dt.timetuple())
            os.utime(_file, times=(_ts, _ts))
          else:
            errors += 1
  print("Finished processing", total, "attachment(s) with", errors, "error(s) and",
        skipped, "skipped file(s)")

if __name__ == "__main__":
    main()
