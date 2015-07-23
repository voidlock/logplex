#!/bin/bash

# Create a free papertrail account and obtain the Host,Port combinations for our syslog endpoint. Make sure you have a local papertrail CLI

HOST=""
PORT=""

source logplex.env
IP_ADDRESS=`(type boot2docker >/dev/null 2>&1 && boot2docker ip) || 127.0.0.1`
curl -H "Authorization: Basic ${LOGPLEX_AUTH_KEY}" -X GET "http://${IP_ADDRESS}:8001/healthcheck"
