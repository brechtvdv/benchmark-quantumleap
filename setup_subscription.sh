#!/bin/bash

curl -X POST \
  http://EXTERNAL_IP:1026/v2/subscriptions/ \
  -H 'Content-Type: application/json' \
  -H 'cache-control: no-cache' \
  -d '{
  "description": "Notify QuantumLeap of all Sensor changes",
  "subject": {
    "entities": [
      {
        "idPattern": ".*",
        "type": "Sensor"
      }
    ],
    "condition": {
      "attrs": [
        "value"
      ]
    }
  },
  "notification": {
    "http": {
      "url": "http://EXTERNAL_IP:8668/v2/notify"
    },
    "attrs": [
      "value"
    ],
    "metadata": ["dateCreated", "dateModified"]
  }
}'

curl -X POST \
  http://EXTERNAL_IP:1026/v2/entities/ \
  -H 'Accept: */*' \
  -H 'Accept-Encoding: gzip, deflate' \
  -H 'Cache-Control: no-cache' \
  -H 'Connection: keep-alive' \
  -H 'Content-Type: application/json' \
  -H 'Host: EXTERNAL_IP:1026' \
  -H 'cache-control: no-cache' \
-d ' {
      "id":"urn:ngsi-ld:Sensor:123", "type":"Sensor",
      "location":{"type":"Text", "value":"u155krxyc78z"},
      "time_index":{"type":"date", "value": 1568369594485},
      "value":{"type":"Number", "value": 99.20}
}'