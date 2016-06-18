#!/bin/bash
HOST=http://localhost:9200

set -x
set -e
DIR=$(dirname "$0")
cd "$DIR"

curl -XPUT "$HOST/_template/election_tweet_template" -d @tweet_template.json

echo ""
