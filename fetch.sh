#!/usr/bin/env bash
set -e
lasttime=
login="$CLASSDOJO_LOGIN"
password="$CLASSDOJO_PASSWORD"
pages=${CLASSDOJO_PAGES:-3}

if [ "$login" == "" ]; then
  echo "Must set CLASSDOJO_LOGIN environment variable"
  exit 1
fi

if [ "$password" == "" ]; then
  echo "Must set CLASSDOJO_PASSWORD environment variable"
  exit 1
fi

# login first
echo "Trying to login to ClassDojo..."
curl -fsS -o /dev/null "https://home.classdojo.com/api/session" \
-H "Content-Type: application/json;charset=utf-8" \
--data '{"login":"'$login'","password":"'$password'","resumeAddClassFlow":false}' \
--cookie-jar /feeds/classdojo.cookie
echo "Login succeeded"

# fetch storyfeeds
echo "Now fetching up to $pages pages..."
max=$[pages-1]
for i in `seq 0 $max`; do
  echo "($i/$max) lasttime=$lasttime"
  feed="/feeds/feed$i.json"

  curl -fsS "https://home.classdojo.com/api/storyFeed?includePrivate=true&before=$lasttime" \
  --cookie /feeds/classdojo.cookie > $feed

  lasttime=`cat $feed | jq -r '._items[] | select (.senderName != "Mojo").time' | tail -1`
  if [ "$lasttime" == "" ]; then
    rm $feed
    break
  fi
done

# concat all feeds into 1 feed
jq -s '[.[]._items]|add' /feeds/feed*.json > /feeds/singlefeed.json
rm /feeds/feed*.json