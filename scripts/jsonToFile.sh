#!/bin/bash


JSON_TEXT='''{
  "username": "test-lvmqwye7txkd@example.com",
  "password": "yNcg^x3nwppge",
  "instanceUrl": "https://java-innovation-3701.my.salesforce.com"
}'''

echo "${JSON_TEXT}" > cred.json

cat cred.json | jq -r '.username'