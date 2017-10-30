USR=AlwanNaores
NODE1=10.0.0.13
NODE2=10.0.0.10
NODE3=10.0.0.4
NODE4=10.0.0.5
RACINE=10.0.0.7

scp src.zip $USR@$RACINE:
scp src.zip $USR@$NODE1:
scp src.zip $USR@$NODE2:
scp src.zip $USR@$NODE3:
scp src.zip $USR@$NODE4:
sleep 15;
xterm -hold -title "NODE1" -e ssh -l $USR $NODE1 "unzip src.zip && cd src &&  python distributed_alg.py 2048 voisin-1.txt WAIT" &
xterm -hold -title "NODE2" -e ssh -l $USR $NODE1 "unzip src.zip && cd src &&  python distributed_alg.py 2048 voisin-2.txt WAIT" &
xterm -hold -title "NODE3" -e ssh -l $USR $NODE1 "unzip src.zip && cd src &&  python distributed_alg.py 2048 voisin-3.txt WAIT" &
xterm -hold -title "NODE4" -e ssh -l $USR $NODE1 "unzip src.zip && cd src &&  python distributed_alg.py 2048 voisin-4.txt WAIT" &
sleep 30;
xterm -hold -title "NODE1" -e ssh -l $USR $NODE1 "unzip src.zip && cd src &&  python distributed_alg.py 2048 voisin-0.txt INIT;"
