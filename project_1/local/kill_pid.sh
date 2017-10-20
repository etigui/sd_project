#!/bin/bash
pids=$(sudo netstat -tlp | grep localhost | grep python | awk '{ print $7; }' | awk -F/ '{print $1}')
for pid in $pids
do
    kill $pid
done