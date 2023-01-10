#Maintain Users

echo "Would you like to change a password (y/n)? "
read userResponse
while [ $userResponse == "y" ] 
do
	echo "System Users:"
	users
	echo
	echo "Change password for Which user?"
	read userResponse
	passwd $userResponse
done