#!/bin/bash
HOST=http://localhost:9200
INDEX='election.tweets.2016.06.09'
TYPENAME=twitter

set -x
set -e

TMPFILE=$(mktemp /tmp/dump.XXXX)
# Temp file should not exist
rm "$TMPFILE"

# Back up the index data
# (see https://github.com/taskrabbit/elasticsearch-dump)
elasticdump --input "$HOST/$INDEX" --output "$TMPFILE" --type=data

curl -XDELETE "$HOST/$INDEX"

curl -XPUT "$HOST/_template/election_tweet_template" -d '{
    "template" : "election.tweets.*",
    "settings" : {
        "analysis" : {
            "filter" : {
                "tweet_filter" : {
                    "type" : "word_delimiter",
                    "type_table": ["# => ALPHA", "@ => ALPHA"]
                },
                "snowball_filter" : {
                    "type" : "snowball",
                    "language" : "English"
                },
                "bigram_filter" : {
                    "type" : "shingle",
                    "output_unigrams" : false
                }
            },
            "analyzer" : {
                "tweet_analyzer" : {
                    "type" : "custom",
                    "tokenizer" : "standard",
                    "filter" : ["tweet_filter", "lowercase", "snowball_filter"]
                },
                "tweet_bigram_analyzer" : {
                    "type" : "custom",
                    "tokenizer" : "standard",
                    "filter" : ["tweet_filter", "lowercase", "stop", "snowball_filter", "bigram_filter" ]
                }
            }
        }
    },
        "mappings": {
            "'$TYPENAME'": {
                "properties": {
                    "@timestamp": {
                        "format": "strict_date_optional_time||epoch_millis",
                        "type": "date"
                    },
                    "@version": {
                        "type": "string"
                    },
                    "client": {
                        "type": "string"
                    },
                    "hashtags": {
                        "properties": {
                            "indices": {
                                "type": "long"
                            },
                            "text": {
                                "type": "string"
                            }
                        }
                    },
                    "in-reply-to": {
                        "type": "long"
                    },
                    "message": {
                        "type": "string",
                        "analyzer" : "tweet_analyzer"
                    },
                    "raw_message": {
                        "type": "string",
                        "index":  "not_analyzed"
                    },
                    "bigram_message": {
                        "type": "string",
                        "analyzer" : "tweet_bigram_analyzer"
                    },
                    "retweeted": {
                        "type": "boolean"
                    },
                    "source": {
                        "type": "string"
                    },
                    "type": {
                        "type": "string"
                    },
                    "urls": {
                        "type": "string"
                    },
                    "user": {
                        "type": "string"
                    },
                    "user_mentions": {
                        "properties": {
                            "id": {
                                "type": "long"
                            },
                            "id_str": {
                                "type": "string"
                            },
                            "indices": {
                                "type": "long"
                            },
                            "name": {
                                "type": "string"
                            },
                            "screen_name": {
                                "type": "string"
                            }
                        }
                    }
                }
            }
    }
}'

# Reload the data which will recreate the index
elasticdump --input "$TMPFILE" --output "$HOST/$INDEX" --type=data
