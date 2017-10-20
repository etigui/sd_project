#!/bin/bash
# https://askubuntu.com/questions/46627/how-can-i-make-a-script-that-opens-terminal-windows-and-executes-commands-in-the
# konsole --help

# Check if all file are here
function check_files () {

		# Check if "voisin" file exist
		for i in {1..4}
		do
			file=$PWD'/voisin-'$i'.txt'
			if [ ! -f $file ]; then
			    return 1
			fi
		done

		# Check if kill pid script exist
		file=$PWD'/kill_pid.sh'
		if [ ! -f $file ]; then
			return 1
		fi

		# Check if algo script exist
		file=$PWD"/distributed_alg_v5.py"
		if [ ! -f $file ]; then
			return 1
		fi

	return 0
}

# Lunch all nodes
if check_files $1 ; then

	# Get algo path
	script=$PWD"/distributed_alg_v5.py"

	# Kill pid from TCP port with connection established
	konsole --hide-tabbar -e sudo kill_pid.sh

	# Lunch other node
	for i in {1..4}
	do
		konsole --hide-tabbar --separate --noclose -e sudo python $script 100$i voisin-$i.txt WAIT
		sleep 0.5
	done

	# Lunch root node
	sleep 2
	konsole --hide-tabbar --separate --noclose -e sudo python $script 1000 voisin-0.txt INIT
fi