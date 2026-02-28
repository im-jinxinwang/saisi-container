#!/bin/bash

VERSION=$(curl -s -H "Cache-Control: no-cache" https://downloads.apache.org/tomcat/tomcat-9/ | grep -oE 'v9\.0\.[0-9]+' | sort -V | tail -1 | sed 's/v//')

[ -z "$VERSION" ] && echo "Error: Get version failed" && exit 1

BASE_URL="https://dlcdn.apache.org/tomcat/tomcat-9/v$VERSION/bin"
FILE="apache-tomcat-$VERSION.tar.gz"

echo "Downloading $FILE..."
curl -L -O "$BASE_URL/$FILE"
