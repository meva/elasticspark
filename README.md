# Tokenized Tweets 

## Setup - overview
1. Install elasticsearch
2. Install kibana
3. Install elasticdump
4. Create index template (TODO paste here)
5. Install logstash
6. Configure logstash to listen to Twitter 
7. Start logstash
8. Stop logstash after a while
9. Use elasticdump to export tokenized fields and source data
10. Upload to s3
11. Ingest into Spark

## Setup - details
1. Install elasticsearch
    * Download from elastic.co
    * Unzip
    * bin/elasticsearch
1. Install kibana
    * See above
1. Install elasticdump
    * `npm install elasticdump -g`
    * -g is optional; installs for all users
1. Create index template

    ```
    bash es_create_mapping_template.sh 
    ```
1. Install logstash
1. Configure logstash to listen to Twitter 
    * Go to apps.twitter.com and set up a new app, and get consumer key/secret, and oauth key/secret
    * Set the environment variables referenced in logstash.conf.template
    * `bash expand_env.sh logstash.conf.template > logstash.conf`
1. Start logstash
    * `bin/logstash -f logstash.conf`
1. Stop logstash after a while (Ctrl-C). Optional if you don't mind your disk filling up.
1. Use elasticdump to export both tokenized fields and source data
   
   ```
    rm /tmp/data1.txt
    
    elasticdump --input http://localhost:9200/election.tweets.2016.06.09 \
    --output /tmp/data1.txt --searchBody '{
    "query" : {
        "exists" : { "field" : "bigram_message" }
    },
    "script_fields": {
        "bigrams" : {
            "script": { "inline" : "doc[field].values",
            "params": {
                "field": "bigram_message"
            }}
        },
        "tokens" : {
            "script": { "inline" : "doc[field].values",
            "params": {
                "field": "message"
            }}
        }
    }, "fields" : ["_source"]
}'
   ```

1. Upload to s3
1. Ingest into Spark



## Remaining work
1. Refine tokenizers & filters



## References
* http://stackoverflow.com/questions/13178550/elasticsearch-return-the-tokens-of-a-field/13182001#13182001
* http://stackoverflow.com/questions/14434549/how-to-expand-shell-variables-in-a-text-file
