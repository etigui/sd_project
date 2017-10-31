USR=AlwanNaores
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

# Unzip and execute the python script on child node
ssh -o StrictHostKeyChecking=no -i ./src/mykey.pem $NODE1 "unzip -o src.zip && cd src &&  python distributed_alg.py 2048 voisin-1.txt WAIT" &
ssh -o StrictHostKeyChecking=no -i ./src/mykey.pem $NODE2 "unzip -o src.zip && cd src &&  python distributed_alg.py 2048 voisin-2.txt WAIT" &
ssh -o StrictHostKeyChecking=no -i ./src/mykey.pem $NODE3 "unzip -o src.zip && cd src &&  python distributed_alg.py 2048 voisin-3.txt WAIT" &
ssh -o StrictHostKeyChecking=no -i ./src/mykey.pem $NODE4 "unzip -o src.zip && cd src &&  python distributed_alg.py 2048 voisin-4.txt WAIT" &
sleep 10;

# Unzip and execute the python script on root node
ssh -o StrictHostKeyChecking=no -i /home/ubuntu/src/mykey.pem $RACINE "cd /home/ubuntu/src && python distributed_alg.py 2048 voisin-0.txt INIT"
