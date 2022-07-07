#!/bin/bash

while true
do
  ps aux --sort -rss | head >> log.txt
  printf "\n" >> log.txt
  sleep 2m 30s
done
