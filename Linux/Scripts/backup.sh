
printf "Backing up Binaries...\n"
tar cf - /usr/bin -P | pv -s $(du -sb /usr/bin | awk '{print $1}') | gzip > bin.tar.gz
tar cf - /usr/sbin -P | pv -s $(du -sb /usr/sbin | awk '{print $1}') | gzip > sbin.tar.gz
printf "Binaries backed up!\n\n\n"

printf "Backing up libraries...\n"
#tar cf - /usr/lib -P | pv -s $(du -sb /usr/lib | awk '{print $1}') | gzip > lib.tar.gz
tar cvzf lib32.tar.gz -P /usr/lib32
tar cvzf lib64.tar.gz -P /usr/lib64
tar cvzf libx32.tar.gz -P /usr/libx32
tar cvzf libexec.tar.gz -P /usr/libexec
#tar cf - /usr/lib32 -P | pv -s $(du -sb /usr/lib32 | awk '{print $1}') | gzip > lib32.tar.gz
#tar cf - /usr/lib64 -P | pv -s $(du -sb /usr/lib64 | awk '{print $1}') | gzip > lib64.tar.gz
#tar cf - /usr/libx32 -P | pv -s $(du -sb /usr/libx32 | awk '{print $1}') | gzip > libx32.tar.gz
#tar cf - /usr/libexec -P | pv -s $(du -sb /usr/libexec | awk '{print $1}') | gzip > libexec.tar.gz
printf "Libraries backed up!\n"

mkdir bin
cp /usr/bin/cp ./bin/
cp /usr/bin/bash ./bin/
cp /usr/bin/tar ./bin/
