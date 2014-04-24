#/bin/sh

# rmrbranco@openmailbox.org
# https://github.com/RuiBranco/mkep
# Started 15/5/2002

# ChangeLog
# 8/4/14 - ADD* improvement code








# DO NOT CHANGE ANYTHING BELOW THIS LINE
# HOWEVER, I TRY TO WRITE A SIMPLE AND CLEAN CODE FOR ALL UNDERSTAND


clear

echo "
+-+-+-+-+-+-+-+-+-+ +-+-+-+ +-+-+-+-+-+-+-+-+
|m|k|e|g|g|d|r|o|p| |a|n|d| |m|k|p|s|y|b|n|c|
+-+-+-+-+-+-+-+-+-+ +-+-+-+ +-+-+-+-+-+-+-+-+
http://code.google.com/p/mkep/
"

mkdir -p ~/psybncs

# QUESTION
echo -n "Nickname for psyBNC: "
read -e NICK

# CHECK NICKNAME 
if [ -d ~/psybncs/$NICK ]
then
	sfd="sfd" 
else
	cp -r /usr/share/psybnc_default/psybnc ~/psybncs/$NICK
fi
cd ~/psybncs/$NICK

# QUESTION ABOUT PARTYLINE PORT
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

echo "PSYBNC.SYSTEM.PORT1=$PARTYLINEPORT" > $NICK.conf
echo "PSYBNC.SYSTEM.HOST1=*" >> $NICK.conf
echo "PSYBNC.HOSTALLOWS.ENTRY0=*;*" >> $NICK.conf

# QUESTION
echo -n "Do you want to add the psyBNC on Crontab? [S/N]: "
read -e CONTINUAR

while [ $CONTINUAR = "S" ] || [ $CONTINUAR = "s" ]
do
	cp /usr/share/psybnc_default/psybnc/*.tempfile ~/psybncs/$NICK
	cat 1.tempfile > psybncchk
	DIR=`pwd`
	echo "PSYBNCPATH=$DIR" >> psybncchk
	cat 2.tempfile >> psybncchk	
	echo "./psybnc $NICK.conf &>/dev/null" >> psybncchk
        chmod 700 psybnc
	chmod 700 psybncchk
	chmod 700 $NICK.conf
	echo "0,10,20,30,40,50 * * * * $DIR/psybncchk >/dev/null 2>&1" >> ~/cron
	crontab ~/cron

	echo "Added on Crontab."

	CONTINUAR="N"
done

rm -f *.tempfile

# SHOW INFO
echo "
#################################################################

To activate psyBNC now simply run the following commands:
1)  cd ~/psybns/$NICK
2)  ./psybnc $NICK.conf

To connect to psyBNC simply enter their commands in usual IRC client (E.g. xChat):
1)  /server irc.server.org:$PARTYLINEPORT:Password_you_want_for_psyBNC

If you find something wrong in the script please share with us, https://github.com/RuiBranco/mkep

#################################################################
"

