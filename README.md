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
2. Install kibana
    * See above
3. Install elasticdump
    * `npm install elasticdump -g`
    * -g is optional; installs for all users
1. Create index template

    ```
    todo
    ```
5. Install logstash
6. Configure logstash to listen to Twitter 
    * Set environment variables referenced in logstash.conf.template
    * `bash expand_template.sh logstash.conf.template > logstash.conf`
7. Start logstash
    * `bin/logstash -f logstash.conf`
8. Stop logstash after a while (Ctrl-C)
9. Use elasticdump to export tokenized fields and source data
    * TODO
10. Upload to s3
11. Ingest into Spark



### References
* http://stackoverflow.com/questions/13178550/elasticsearch-return-the-tokens-of-a-field/13182001#13182001
* http://stackoverflow.com/questions/14434549/how-to-expand-shell-variables-in-a-text-file
