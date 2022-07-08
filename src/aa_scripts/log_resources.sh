#!/bin/bash

while true
do
  date >> log.txt
  ps aux --sort -rss | head -6 >> log.txt
  printf "\n" >> log.txt
  sleep 2m 30s
done
