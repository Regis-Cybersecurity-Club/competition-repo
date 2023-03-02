#echo "Test"
files=( "$@" )
#printf "Array contains %d elements: \n" ${#files[@]}
printf "%d files being monitored: \n" ${#files[@]}

warning_count=0	# No. of files modified since watch has taken place.
filenum=1	# File Number in the array

for file in "${files[@]}"
do	
	#Ensure files exist first (both original & backup)
	#If they are there, execute if statement
	if [ -f $file ] && [ -f monitor/$file ]
	then
		#Collect hashes, remove the last part of the sha string which is the path to the file"
		live_sha="$(sha256sum $file)"
		live_sha="${live_sha% ' '*}"
		saved_sha="$(sha256sum monitor/$file)"
		saved_sha="${saved_sha% ' '*}"
		
		
		#If modified, display the warning, otherwise list it's OK (ONLY WHEN THERE'S NOT TOO MANY FILES BEING MONITORED)
		if [ "$live_sha" != "$saved_sha" ];
		then 
			echo -e "\t$file: MODIFIED"
			warning_count=$((warning_count+1))
			echo "$(diff monitor/$file $file)"
		elif [ "${#files[@]}" -le "20" ];
		then
			echo -e "\t$file: OK"
		fi
		
		filenum=$((filenum+1))
	
	#If the original is absent, try to copy it from the backup and check if the copy was successful
	elif ! [ -f $file ]
	then
		echo -e -n "\t$file: ORIGINAL REMOVED!"
		
		cp monitor/$file $file
		
		if [ -f $file ]
		then
			echo -e "\t(Recovered)"
		else
			echo -e "\t(Recovery Failed)"
		fi
		
	#If the backup is absent, try to copy it from the original and check if the copy was successful
	elif ! [ -f monitor/$file ]
	then
		echo -e -n "\t$file: BACKUP REMOVED!"
		cp $file monitor/$file
		
		if [ -f monitor/$file ]
		then
			echo -e "\t(Recovered)"
		else
			echo -e "\t(Recovery Failed)"
		fi
	fi
done

### MONITOR SUMMARY
if [ "$warning_count" = "0" ];
then 
	echo -e "\n\n$(date): monitored files are OK"
else
	echo -e "\n\n$(date): $warning_count file(s) have been modified!"
fi
