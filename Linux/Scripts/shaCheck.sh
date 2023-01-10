read -r sha_val rest <<< "$(sha256sum /var/www/html/index.html)"

read -r sha_val2 rest <<< "$sha256sum /var/www/html/info.php"

ver_sha=$(awk 'NR==1' shas.txt)
ver_sha2=$(awk 'NR==2' shas.txt)

if[ "$var_sha" != "$sha_val"];
then
	echo "WARNING: Index.html value has been modified from integral version!"
fi

if[ "$var_sha2" != "$sha_val2"];
then
	echo "WARNING: info.php value has been modified from integral version!"
fi