#echo "Test"
files=( "$@" )
#printf "Array contains %d elements: \n" ${#files[@]}
printf "%d files being monitored: \n" ${#files[@]}

warning_count=0	# No. of files modified since watch has taken place.
filenum=1	# File Number in the array

for file in "${files[@]}"
do	
	#Collect hashes, remove the last part of the sha string which is the path to the file"
	live_sha="$(sha256sum $file)"
	live_sha="${live_sha% ' '*}"
	saved_sha="$(sha256sum monitor/$file)"
	saved_sha="${saved_sha% ' '*}"
	
	
	#If modified, display the warning, otherwise list it's OK
	if [ "$live_sha" != "$saved_sha" ];
	then 
		echo -e "\t$file: MODIFIED"
		warning_count=$((warning_count+1))
	else
		echo -e "\t$file: OK"
	fi
	filenum=$((filenum+1))
done

### MONITOR SUMMARY
if [ "$warning_count" = "0" ];
then 
	echo -e "\n\n$(date): monitored files are OK"
else
	echo -e "\n\n$(date): $warning_count file(s) have been modified!"
fi
