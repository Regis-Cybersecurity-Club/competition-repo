#!/bin/bash
#Makes a path to a certain file. Used to create nested directories
function MakePath 
{
	#echo "MakePath arg: $1"
	
	origDir=$PWD
	cd monitor 
	dirArr=($(echo $1 | tr "/" "\n"))
	
	dirNum=1
	numDirs="${#dirArr[@]}"
	#echo "$numDirs"
	for dir in "${dirArr[@]}"
	do
		if [ "$dirNum" != "$numDirs" ];
		then
		
			#echo -e "\tdir is $dir"
			#echo ""
			mkdir $dir 2>/dev/null
			cd $dir
			dirNum=$((dirNum+1))
		fi
	done
	cd $origDir		
}

function ProcessDir 
{
	for eachfile in $1/*
	do
		#echo "In for loop"
		if [ -f $eachfile ] && ! [ -d $eachfile ]
		then
			fileArr+=($eachfile)
			
		#Potential elif here for subdirectory monitoring?
		elif [ -d $eachfile ] 
		then
			ProcessDir $eachfile
		fi
	done
}

#If no arguments provided, display usage guide
if [ "$#" -eq "0" ];
then
	echo -e "fileIntegrity.sh usage: ./fileIntegrity <file_or_dir> \n\t ./fileIntegrity <file_or_dir1> <file_or_dir2>\n\t ./fileIntegrity <file_or_dir> <file_or_dir2> ... <file_or_dirN>"
	exit
fi

### BEGIN MAIN PROGRAM EXECUTION ###
mkdir 'monitor' 2>/dev/null

isDir="false"

if [ "$#" == "1" ] && [ -d $1 ];
then
	isDir="true"
	#echo "$1 is a directory"
fi

declare -a fileArr=()

#If a directory is provided, get all files in the directory
if [ "$isDir" == "true" ]
then 
	ProcessDir $1
	
#Otherwise, process all args (mix of files and directories
else 
	for eachfile in "$@"
	do	
		#Files only stored in array if they are regular files. If they are directories or directory links do not add them!
		if [ -f $eachfile ] && ! [ -d $eachfile ]
		then
			fileArr+=($eachfile)
		elif [ -d $eachfile ]
		then
			ProcessDir $eachfile
		else
			echo "Provided parameter '$eachfile' cannot be monitored: not a normal file or directory"
		fi
	done
fi

#Display the files being monitored
echo "Files being monitored for integrity: "
for file in "${fileArr[@]}"
do
	echo -e "\t$file"

done
echo "" 

#Hash each file being monitored
echo -n "Making integral backup files..."
for eachfile in "${fileArr[@]}"
do
	read -r sha_val rest <<< "$(sha256sum $eachfile)"
	#echo -e $sha_val >> shas.txt
	MakePath "$eachfile"
	#touch monitor/$eachfile
	cp $eachfile monitor/$eachfile
done
echo " Done!"

#echo "File Arr is ${fileArr[@]}"
arglist="${fileArr[@]}"
#echo "Arg list is $arglist"

#Countdown to monitor
for ((i=5; i > 0; i--)); 
do
	echo -e -n "\rInitiating monitor in $i"
	#echo $i
	sleep 1
done

watch -n 10 -t "bash shacheck.sh $arglist"
