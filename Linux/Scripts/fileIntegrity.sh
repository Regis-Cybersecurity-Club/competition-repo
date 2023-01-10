mkdir 'monitor'

read -r sha_val rest <<< "$(sha256sum /var/www/html/index.html)"

read -r sha_val2 rest <<< "$(sha256sum /var/www/html/info.php)"

echo "sha_val is" $sha_val
echo "sha_val2 is" $sha_val2

echo -e $sha_val >> shas.txt
echo -e $sha_val2 >> shas.txt

watch -n 120 shacheck.sh