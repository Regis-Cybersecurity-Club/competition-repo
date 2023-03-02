#!/bin/bash
#Makes a path to a certain file. Used to create nested directories
function MakePath 
{
	#echo "MakePath arg: $1"
	
	origDir=$PWD
	cd monitor 
	dirArr=($(echo $1 | tr "/" "\n"))
	
	for dir in $dirArr
	do
		#echo -e -n "\tdir is $dir"
		#echo ""
		mkdir $dir 2>/dev/null
		cd $dir
	done
	cd $origDir	
		
}

#If no arguments provided, display usage guide
if [ "$#" -eq "0" ];
then
	echo -e "fileIntegrity.sh usage: fileIntegrity <dir> \n\t fileIntegrity <file1> <file2> ... <fileN>\n"
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

	#echo "Inside isDir if"	
	for eachfile in $1/*
	do
		#echo "In for loop"
		if [ -f $eachfile ] && ! [ -d $eachfile ]
		then
			fileArr+=($eachfile)
		fi
	done

else 
	#echo "Inside !isDir"
	for eachfile in "$@"
	do	
		#Files only stored in array if they are regular files. If they are directories or directory links do not add them!
		if [ -f $eachfile ] && ! [ -d $eachfile ]
		then
			fileArr+=($eachfile)
		else
			echo "Provided parameter '$eachfile' cannot be monitored: not a normal file"
		fi
	done
fi

#Display the files being monitored

echo "Files being monitored for integrity: "
for file in "${fileArr[@]}"
do
	echo -e -n "\t$file"
	echo ""
done

echo "" 

#Hash each file being monitored
for eachfile in "${fileArr[@]}"
do
	read -r sha_val rest <<< "$(sha256sum $eachfile)"
	echo -e $sha_val >> shas.txt
	MakePath "$eachfile"
	#touch monitor/$eachfile
	cp $eachfile monitor/$eachfile
done

#echo "File Arr is ${fileArr[@]}"
arglist="${fileArr[@]}"
#echo "Arg list is $arglist"

#Countdown to monitor
for ((i=5; i > 0; i--)); 
do
	echo -e -n "\rInitiating monitor in $i"
	#echo $i
	#i=$((i+$decremant))
	sleep 1
done

watch -n 30 "bash shacheck.sh $arglist"
