#/bin/sh

# rmrbranco@openmailbox.org
# https://github.com/RuiBranco/mkep
# Started 15/5/2002











# DO NOT CHANGE ANYTHING BELOW THIS LINE
# HOWEVER, I TRY TO WRITE A SIMPLE AND CLEAN CODE FOR ALL UNDERSTAND
                                                                          

clear 

echo "
+-+-+-+-+-+-+-+-+-+ +-+-+-+ +-+-+-+-+-+-+-+-+
|m|k|e|g|g|d|r|o|p| |a|n|d| |m|k|p|s|y|b|n|c|
+-+-+-+-+-+-+-+-+-+ +-+-+-+ +-+-+-+-+-+-+-+-+
http://code.google.com/p/mkep/
"

# CREATE FIRST CONFIGS
if [ -d ~/eggdrops ]
then
        cp /usr/share/eggdrop_default/eggdrop/*.tempfile ~/eggdrops
else
	cp -r /usr/share/eggdrop_default/eggdrop ~/eggdrops
fi

cd ~/eggdrops

# QUESTION
echo -n "Nickname for Eggdrop (E.g. My_Bot): "
read -e NICK

cat 1.tempfile > $NICK.conf
echo "set nick \"$NICK\"" >> $NICK.conf
mkdir -p $NICK

# QUESTION
echo -n "Alternative Nickname for Eggdrop (E.g. My_Bot_): "
read -e ALTNICK
echo "set altnick \"$ALTNICK\"" >> $NICK.conf

# QUESTION
echo -n "The Nickname password for Eggdrop: "
read -e PASS

# QUESTION
echo -n "Realname for Eggdrop (E.g. The Bot): "
read -e REALNAME
echo "set realname \"$REALNAME\"" >> $NICK.conf

# QUESTION
echo -n "Username for Eggdrop (ex. My_Bot): "
read -e USERNAME
echo "set username \"$USERNAME\"" >> $NICK.conf

# QUESTION
echo -n "Nick off the Owner off the eggdrop (E.g. My_nick): "
read -e OWNER
echo "set admin \"$OWNER\"" >> $NICK.conf

# QUESTION
echo "set servers {" >> $NICK.conf
CONTINUAR="S"
while [ $CONTINUAR = "S" ] || [ $CONTINUAR = "s" ]
do
	echo -n "Tell the IRC server to connect eggdrop(E.g. irc.server.org:6667): "         
	read -e SERVER
	echo "$SERVER" >> $NICK.conf	

	echo -n "Do you want add another server? [S/N]: "
	read -e CONTINUAR
done
echo "}" >> $NICK.conf
echo "set network \"PTshells\"" >> $NICK.conf
echo 'set botnet-nick "$nick"' >> $NICK.conf
echo "set owner \"$OWNER\"" >> $NICK.conf
echo "set confvar \"$NICK\"" >> $NICK.conf

# QUESTION
echo -n "Do you want use vhost on eggdrop? [S/N]: "
read -e CONTINUAR
  
while [ $CONTINUAR = "S" ] || [ $CONTINUAR = "s" ]
do
        echo -n "Tell the vhost (ex. hostname.org): "
        read -e VHOST
	echo "set my-hostname \"$VHOST\"" >> $NICK.conf

        echo -n "Tell the IP off the vhost (ex. 123.45.67.89): " 
        read -e IPVHOST
	echo "set my-ip \"$IPVHOST\"" >> $NICK.conf
        CONTINUAR="N"
done

# QUESTION ABOUT PARTYLINE PORT
cat 2.tempfile >> $NICK.conf
PARTYLINEPORT=1024
        
while [ $PARTYLINEPORT -ge 50000 ] || [ $PARTYLINEPORT -le 1024 ]
do
        echo -n "Enter the port you want to access psyBNC (must be greater than 1024 and less than 50000): "
        read -e PARTYLINEPORT
	
	if [ $PARTYLINEPORT -lt 50000 ] && [ $PARTYLINEPORT -gt 1024 ] && [ -n $PARTYLINEPORT ]
	then
		TEMP=`netstat -al | grep -c ":$PARTYLINEPORT "`
        	if [ $TEMP -gt 0 ]  
        	then
                	echo "Busy port, please choose another."
                	PARTYLINEPORT=1024
       		fi
	else
		PARTYLINEPORT=1024
	fi

done
echo "listen $PARTYLINEPORT all" >> $NICK.conf


# QUESTION
cat 3.tempfile >> $NICK.conf
echo -n "Do you want add a channel on eggdrop? [S/N]: "
read -e CONTINUAR

while [ $CONTINUAR = "S" ] || [ $CONTINUAR = "s" ]
do
        echo -n "Tell the channel (E.g. #My_channel): "
        read -e CANAL

	echo "channel add $CANAL {" >> $NICK.conf
	echo " chanmode \"+nt-likm\""  >> $NICK.conf
	echo "}" >> $NICK.conf
	echo "channel set  $CANAL +statuslog" >> $NICK.conf	 

        echo -n "Do you want add another channel? [S/N]: "
        read -e CONTINUAR
done

cat 4.tempfile >> $NICK.conf 
echo "set nickpass \"$PASS\"" >> $NICK.conf
cat 5.tempfile >> $NICK.conf

# QUESTION
echo -n "Do you want add Eggdrop on Crontab? [S/N]: "
read -e CONTINUAR

while [ $CONTINUAR = "S" ] || [ $CONTINUAR = "s" ]
do
	cat 6.tempfile > $NICK.botchk
	DIR=`pwd`
	echo "botdir=\"$DIR\"" >> $NICK.botchk
	echo "botscript=\"eggdrop $NICK.conf\"" >> $NICK.botchk
	echo "nick=\"$NICK\"" >> $NICK.botchk
	echo "confvar=\"\$nick\"" >> $NICK.botchk
	cat 7.tempfile >> $NICK.botchk
        chmod 700 eggdrop
	chmod 700 $NICK.botchk
	chmod 700 $NICK.conf
	echo "0,10,20,30,40,50 * * * * $DIR/$NICK.botchk >/dev/null 2>&1" >> ~/cron
	crontab ~/cron

	echo "Added in Crontab."

	CONTINUAR="N"
done

rm -f *.tempfile

# SHOW INFO
echo "
#################################################################

To activate Eggdrop now simply run the following commands:
1)  cd ~/eggdrops
2)  ./eggdrop -m $NICK.conf

When Eggdrop are on irc simply enter their commands in usual IRC client (E.g. xChat):
1)  /msg $NICK hello
2)  /msg $NICK ident_password

To access party-line of Eggdrop:
1)  /chat $NICK

If you find something wrong in the script please share with us, https://github.com/RuiBranco/mkep

#################################################################"
"

