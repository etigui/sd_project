#!/bin/bash
: <<'TODO_before'
	1. Add somewhere in your computer the private key already generated in (sd_project/project_1/distributed/keys/id_rsa_sd)
	2. Login via ssh to each cloud node and check if the path (~/.ssh) exist, otherwise create it
		>ssh <username>@<ip_cloud_node>
		>mkdir -p ~/.ssh
	2. Copy the public key from (sd_project/project_1/distributed/keys/id_rsa_sd.pub), to each cloud node
		>scp -P <port> <id_rsa_sd.pub> <username>@<ip_cloud_node>:/root/.ssh
	3. On each cloud node add the public key to the authorized keys file
		>cat ~/.ssh/id_rsa_sd.pub >> ~/.ssh/authorized_keys
	4. In this bash script you must add or modify:
	 	- IP of each cloud node (the first position in the array is the root node !!!)
	 	- Private key file path
	 	- Neighbour directory path (the directory where are all the neighbour file)
	 	- The Python script file path with our algo
	 	- Maybe change the port or/and the username (SSH, SCP)
	5. You must change the ip in each neighbour file (voisin-x.txt)
	7. Have a look in our Python script (distributed_alg.py), it might have some error (change interface to get local IP ?)
	6. When all done, you can run this bash script
TODO_before

: <<'exemple_exec'
	Testing all SSH connection
	ssh -i ~/.ssh/id_rsa_sd -p 22 -q -o ConnectTimeout=3 ssh@init_node_ip_0 exit
	ssh -i ~/.ssh/id_rsa_sd -p 22 -q -o ConnectTimeout=3 ssh@wait_node_ip_1 exit
	ssh -i ~/.ssh/id_rsa_sd -p 22 -q -o ConnectTimeout=3 ssh@wait_node_ip_2 exit
	ssh -i ~/.ssh/id_rsa_sd -p 22 -q -o ConnectTimeout=3 ssh@wait_node_ip_3 exit
	ssh -i ~/.ssh/id_rsa_sd -p 22 -q -o ConnectTimeout=3 ssh@wait_node_ip_4 exit
	scp -P 22 -i ~/.ssh/id_rsa_sd /distributed_alg.py /voisin-0.txt ssh@init_node_ip_0:~
	scp -P 22 -i ~/.ssh/id_rsa_sd /distributed_alg.py /voisin-1.txt ssh@wait_node_ip_1:~
	scp -P 22 -i ~/.ssh/id_rsa_sd /distributed_alg.py /voisin-2.txt ssh@wait_node_ip_2:~
	scp -P 22 -i ~/.ssh/id_rsa_sd /distributed_alg.py /voisin-3.txt ssh@wait_node_ip_3:~
	scp -P 22 -i ~/.ssh/id_rsa_sd /distributed_alg.py /voisin-4.txt ssh@wait_node_ip_4:~
	ssh -i ~/.ssh/id_rsa_sd -p 22 -t ssh@wait_node_ip_1 python distributed_alg.py 1001 voisin-1.txt WAIT
	ssh -i ~/.ssh/id_rsa_sd -p 22 -t ssh@wait_node_ip_2 python distributed_alg.py 1002 voisin-2.txt WAIT
	ssh -i ~/.ssh/id_rsa_sd -p 22 -t ssh@wait_node_ip_3 python distributed_alg.py 1003 voisin-3.txt WAIT
	ssh -i ~/.ssh/id_rsa_sd -p 22 -t ssh@wait_node_ip_4 python distributed_alg.py 1004 voisin-4.txt WAIT
	ssh -i ~/.ssh/id_rsa_sd -p 22 -t ssh@init_node_ip_0 python distributed_alg.py 1000 voisin-0.txt INIT
	All cloud node deployed
exemple_exec

# Array IPs
declare -a ips=("init_node_ip_0" "wait_node_ip_1" "wait_node_ip_2" "wait_node_ip_3" "wait_node_ip_4")

username=ssh
port=22

# eg: ~/.ssh/id_rsa_sd
ssh_private_key_file_path="empty"

# eg: /home/<username>/Documents/git/sd_project/project_1/distributed/
neighbour_directory_path="empty"

# eg: /home/<username>/Documents/git/sd_project/project_1/distributed/distributed_alg.py
algo_file_path="empty"

# Check if all file are here
function check_files () {

		# Check if "voisin" file exist
		for i in {0..4}
		do
			file=$neighbour_directory_path'/voisin-'$i'.txt'
			if [ ! -f $file ]; then
			    return 1
			fi
		done

		# Check if algo script exist
		if [ ! -f $algo_file_path ]; then
			return 1
		fi

		# Check if private key exist
		if [ ! -f $ssh_private_key_file_path ]; then
			return 1
		fi

	return 0
}

# Check SSH connection
function test_ssh_connection () {

	# Go through IPs array
	for i in "${ips[@]}"
	do
		# Connect to computer
		ssh -i $ssh_private_key_file_path -p $port -q -o ConnectTimeout=3 $username@$i exit

		# If SSH return 0 => connection OK else if return 255 => connection NOK
		if [ $? -ne 0 ]
		then
			return 1
		fi
	done
	return 0
}

# Copy the algo with the neighbour file associate
function copy_node_files () {

	# Go through IPs array
	node=0
	for i in "${ips[@]}"
	do
		scp -P $port -i $ssh_private_key_file_path $algo_file_path $neighbour_directory_path"voisin-$((node++)).txt" $username@$i:~
	done

}
# Execute the algo with the neighbour file associate
function exec_node () {

	# Go through IPs array
	node=0
	for i in "${ips[@]}"
	do

		# Check if not the last element, cause the last element is the INIT
		if [ "$node" != "0" ]
		then

			# Execute all the WAIT node
			ssh -i $ssh_private_key_file_path -p $port -t $username@$i "python distributed_alg.py 100$node voisin-$node.txt WAIT"
		fi

		# Inc node
		((node++))
	done

	# Execute the INIT node
	sleep 2
	ssh -i $ssh_private_key_file_path -p $port -t $username@${ips[0]} "python distributed_alg.py 1000 voisin-0.txt INIT"
}

# Start here
if check_files $1 ; then
	echo "Testing all SSH connection"
	if test_ssh_connection $1 ; then
		copy_node_files
		exec_node
		echo "All cloud node deployed"
	else
		echo "Error: SSH connection"
	fi
else
	echo "Error: file dosen't existe"
fi