#!/bin/bash

curl -X POST \
  http://EXTERNAL_IP:1026/v2/subscriptions/ \
  -H 'Content-Type: application/json' \
  -H 'Postman-Token: 59809db1-6950-4bd8-a877-efcadeca772b' \
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
  -H 'Content-Length: 222' \
  -H 'Content-Type: application/json' \
  -H 'Host: localhost:1026' \
  -H 'Postman-Token: 556172a0-241c-4c59-b7b6-e1a24e3280f1,a7611d83-d778-4b17-ada0-2d900fbf37fa' \
  -H 'User-Agent: PostmanRuntime/7.17.1' \
  -H 'cache-control: no-cache' \
  -d ' {
      "id":"urn:ngsi-ld:Sensor:010", "type":"Sensor",
      "location":{"type":"Text", "value":"u155krxyc78z"},
      "time_index":{"type":"date", "value": 1568369594485},
      "value":{"type":"Integer", "value": 99}
}'

