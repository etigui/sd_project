# Implémentation d’un algorithme distribué en utilisant des sockets	

## Construction d'un arbre	de	recouvrement en	largeur	d'abord		

Les messages sont transmis entre les nœuds du réseau via les sockets. Chaque nœud est serveur et client en même 
temps. Il est implémenté sur une machine différente de celles allouées aux autres nœuds.

Un nœud est représenté par : 
- Un numéro de port
- L’ensemble des voisins du nœud 

Ces informations sont stockées dans un fichier .txt (texte) ayant comme nom : voisin-x.txt. x étant le numéro du nœud. 

Exemple : 
Nom du fichier : voisin-01.txt. Ce fichier représente le nœud 1 
Contenu du fichier :   

  129.194.184.101 // identifiant du 1ervoisin 
  129.194.184.110 // identifiant du 2ème voisin 
  129.194.184.111 // identifiant du 3ème voisin 

Par souci de compatibilité, il est impératif de respecter ce format 
Le programme distributed_alg à écrire doit être appelé comme suit : 
distributed_alg num_port voisin-x.txt  INIT 
ou 
distributed_alg num_port voisin-x.txt  WAIT

  INIT : signifie que le nœud en question commence l’exécution sans attendre la réception du premier message. 
  WAIT : signifie que le nœud en question attend la réception du premier message avant de commencer à envoyer des messages. 
  
Le fichier **voisin-x.txt** doit être lu par le nœud concerné.

On vous demande d’écrire le programme distributed_alg (qui représente l’un des algorithmes cités en haut) et de le déployer sur un réseau d’ordinateurs en utilisant un script shell. Le développement de ce programme doit se faire en python ou Java. 
