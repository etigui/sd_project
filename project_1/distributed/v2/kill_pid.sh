# Copy all the file to the root node
scp -i mykey.pem -P 10216 src.zip ubuntu@hepiacloud.hesge.ch:.
ssh -i mykey.pem -p 10216 ubuntu@hepiacloud.hesge.ch "unzip -o src.zip && ./src/kill_pid_cloud.sh"
