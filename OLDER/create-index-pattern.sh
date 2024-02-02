curl -X POST "http://localhost:5601/api/saved_objects/index-pattern/logstash-*" -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d'
 {
"attributes": {
 "title": "logstash-*"
 }
}'

curl -X PUT "localhost:9200/_ilm/policy/logstash_policy?pretty" -H 'Content-Type: application/json' -d'
{
   "policy" : {
      "phases" : {
        "hot" : {
          "min_age" : "0ms",
          "actions" : {
            "rollover" : {
              "max_size" : "500mb",
              "max_age" : "1d",
              "max_docs" : 5000
            },
            "set_priority" : {
              "priority" : 100
            }
          }
        }
      }
    }
}
'



curl -X PUT "localhost:9200/_template/logstash_template?pretty" -H 'Content-Type: application/json' -d'
{
  "index_patterns": ["logstash-*"],                 
  "settings": {
    "number_of_shards": 1,
    "number_of_replicas": 1,
    "index.lifecycle.name": "logstash_policy",      
    "index.lifecycle.rollover_alias": "logstash_policy"    
  }
}
'
