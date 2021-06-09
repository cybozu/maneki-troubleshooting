#!/bin/sh
echo "reference:"
curl -w "@scripts/case4/curl-format.txt" -o /dev/null -s -H "Host: reference" $(whoami)/hoge.json

echo "\nstatic-server:"
curl -w "@scripts/case4/curl-format.txt" -o /dev/null -s -H "Host: static" $(whoami)/hoge.json
