NODE1=10.0.0.13
NODE2=10.0.0.10
NODE3=10.0.0.4
NODE4=10.0.0.5
RACINE=10.0.0.7

# Send all file to each child node
scp -o StrictHostKeyChecking=no -i ./src/mykey.pem src.zip $NODE1:.
scp -o StrictHostKeyChecking=no -i ./src/mykey.pem src.zip $NODE2:.
scp -o StrictHostKeyChecking=no -i ./src/mykey.pem src.zip $NODE3:.
scp -o StrictHostKeyChecking=no -i ./src/mykey.pem src.zip $NODE4:.
sleep 10;

# Unzip and execute the script on each node
ssh -o StrictHostKeyChecking=no -i ./src/mykey.pem $NODE1 "unzip -o src.zip && cd src && kill.sh" &
ssh -o StrictHostKeyChecking=no -i ./src/mykey.pem $NODE2 "unzip -o src.zip && cd src && kill.sh" &
ssh -o StrictHostKeyChecking=no -i ./src/mykey.pem $NODE3 "unzip -o src.zip && cd src && kill.sh" &
ssh -o StrictHostKeyChecking=no -i ./src/mykey.pem $NODE4 "unzip -o src.zip && cd src && kill.sh" &
ssh -o StrictHostKeyChecking=no -i /home/ubuntu/src/mykey.pem $RACINE "cd /home/ubuntu/src && kill.sh"