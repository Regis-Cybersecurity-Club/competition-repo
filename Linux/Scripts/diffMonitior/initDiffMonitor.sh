#!/bin/bash
'''
Bash Script to monitor differences in critical log files
Parameter usage: 
   - $1: Path to file (but not the file name or extension itself)
   - $2: Log file name and extension to diffMonitor

--Suggested files to monitor:

	- auth.log - Tracks attempted logins
	- kern.log - Tracks kernel-level errors
	- faillog  - Tracks attempted logins
	- yum.log  - Tracks installation of packages and software
	- maillog  - Find info on mail logins
	- httpd
	- mysqld.log or mysql.log
	
@author Jayden Patton (Regis University)
@version 1.0 - November 8th, 2022
'''


NUM_ARGS=2
CURR_DIR=$(pwd)

#echo "CURR_DIR is: " 
#echo $CURR_DIR

if [ $# -ne $NUM_ARGS ]; 
	then 
	echo "\nIllegal number of parameters \tUsage: initDiffMonitor.sh *path/to/* *file* "

else
	mkdir "./diffMonitor"
	cd "diffMonitor"

	dirs=$(echo $1 | tr "/" "\n")

	for dir in $dirs
	do
		mkdir ./$dir
		cd $dir
	done

	#BEGIN DEBUG for cp paths
	echo "Source Path:"
	echo $1$2

	echo "Dest Path:"
	echo $CURR_DIR/"diffMonitor"/.$1$2
	#END DEBUG

	cp $1$2 $CURR_DIR/"diffMonitor"/.$1$2

	#BEGIN DEBUG for log file locations
	echo "Copy of Clean log file is: "
	echo $(pwd)/$2

	echo "Live Log File is: "
	echo $1$2
	#END DEBUG
	
	watch -n 20 bash $CURR_DIR/diffMonitor.sh $2 $1$2 
fi