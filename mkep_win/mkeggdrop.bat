@ECHO off
:: rmrbranco@openmailbox.org
:: https://github.com/RuiBranco/mkep
:: Started 15/5/2002









::CONFIG
::YOU CAN CHOOSE THE LANG
SET lang=en

::DO NOT CHANGE ANYTHING BELOW THIS LINE
::HOWEVER, I TRY TO WRITE A SIMPLE AND CLEAN CODE FOR ALL UNDERSTAND

::WINDOW TITLE
TITLE mkep - mkeggdrop

::SET VAR
SET drive=%~d0
SET folder=%~dp0
SET file=cron.exe

::CHECK FOR A LIBS
IF NOT "%folder%" == "%drive%\mkep\" GOTO ERROR2
IF NOT EXIST %systemroot%\System32\taskkill.exe GOTO :ERROR
IF NOT EXIST %systemroot%\System32\tasklist.exe GOTO :ERROR
IF NOT EXIST %drive%\mkep GOTO :ERROR1

::CHECK IF CRONTAB IS RUNNING
TASKLIST | FIND /i "%file%">NUL
IF %ERRORLEVEL% equ 1 (
   ECHO Crontab is down. Trying to start Crontab.
   START crontab\%file%
)

ECHO Crontab is down.                                        
ECHO Trying to start Crontab.

START crontab\%file%

:RUN
::SHOW MENU
ECHO.
TYPE mklang\%lang%\menu-egg.txt
ECHO.
@ECHO off
TYPE mklang\%lang%\pe.txt
SET /p menu= :
IF '%menu%'=='1' GOTO MAKE
IF '%menu%'=='2' GOTO END
IF '%menu%'=='3' GOTO KILL
CLS

:MAKE
::ASKING FOR A BOT NICKNAME
ECHO.
SET nick=
TYPE mklang\%lang%\e1.txt
SET /P nick= :
ECHO.

::ASKING FOR A PASSWORD
SET pwd=
TYPE mklang\%lang%\e3.txt
SET /P pwd= :
ECHO.

:PORT
::ASKING FOR ANY PORT
SET port=
TYPE mklang\%lang%\ep2.txt
SET /P port= :
ECHO Checking port is avaiable.
netstat -a | FIND /i ":%port%"
IF errorlevel 1 GOTO CONTINUE

:BUSY
::IF PORT IS BUSY ASK FOR ANOTHER ONE
TYPE mklang\%lang%\ep3.txt
GOTO PORT

:CONTINUE
::ASKING OWNER NICKNAME
SET owner=
TYPE mklang\%lang%\e6.txt
SET /P owner= :
ECHO.

::ASKING FOR BOT USERNAME
SET email=
TYPE mklang\%lang%\e5.txt
SET /P email= :
ECHO.

::ASKING FOR A IRC SERVER
SET ircserver=
TYPE mklang\%lang%\e7.txt
SET /P ircserver= :
ECHO.

::CREATE THE CONFIGS
TYPE temp\temp1.txt >> eggdrop.conf
ECHO set username "egg-%nick%" >> eggdrop.conf
ECHO set admin "%email%" >> eggdrop.conf
ECHO set network "%ircserver%" >> eggdrop.conf
TYPE temp\temp2.txt >> eggdrop.conf
ECHO logfile mco * "logs/egg-%nick%.log" >> eggdrop.conf
ECHO logfile jpk egg-%nick% "logs/egg-%nick%.log" >> eggdrop.conf
TYPE temp\temp3.txt >> eggdrop.conf
ECHO set userfile "egg-%nick%.user" >> eggdrop.conf
ECHO set pidfile "pid.egg-%nick%"  >> eggdrop.conf
TYPE temp\temp4.txt >> eggdrop.conf
ECHO set owner "%owner%" >> eggdrop.conf
TYPE temp\temp5.txt >> eggdrop.conf
ECHO set chanfile "egg-%nick%.chan" >> eggdrop.conf
TYPE temp\temp6.txt >> eggdrop.conf

:CHANNEL
::ASKING FOR A CHANNEL
SET channel=
TYPE mklang\%lang%\e13.txt
SET /P channel= :

ECHO channel add %channel% >> eggdrop.conf

::ASKING FOR IF YOU WANT ANOTHER CHANNEL
SET channelask=
TYPE mklang\%lang%\e14.txt
SET /P channelask= :
IF /I '%channelask%'=='y' GOTO CHANNEL
IF /I '%channelask%'=='n' GOTO RUN1

:RUN1
::CREATE THE CONFIGS
TYPE temp\temp7.txt >> eggdrop.conf
ECHO set default-port %port% >> eggdrop.conf
ECHO set nick "%nick%" >> eggdrop.conf
ECHO set altnick "%nick%" >> eggdrop.conf
ECHO set realname "%nick%" >> eggdrop.conf
ECHO set init-server { putserv "NICKSERV IDENTIFY %pwd%" } >> eggdrop.conf
ECHO set servers { >> eggdrop.conf
ECHO %ircserver% >> eggdrop.conf
ECHO } >> eggdrop.conf
TYPE temp\temp8.txt >> eggdrop.conf
ECHO set files-path "%drive%\mkep\egg-%nick%" >> eggdrop.conf
ECHO set incoming-path "%drive%\mkep\egg-%nick%" >> eggdrop.conf
TYPE temp\temp9.txt >> eggdrop.conf
ECHO set notefile "egg-%nick%.notes" >> eggdrop.conf
TYPE temp\temp10.txt >> eggdrop.conf

:CRON
::ASKING IF YOU WANT ADD PROCESS IN CRONTAB
SET cron=
TYPE mklang\%lang%\e15.txt
SET /P cron= :
IF /I '%cron%'=='y' GOTO NEXT1
IF /I '%cron%'=='n' GOTO NEXT2

:NEXT1
::ADD THE TASK IN CRONTAB
ECHO 0,10,20,30,40,50 * * * * %drive%\mkep\egg-%nick%\chk.bat>NUL >> crontab\crontab 

:NEXT2
::CREATE THE CONFIGS
MD %drive%\mkep\egg-%nick%
XCOPY /E %drive%\mkep\Windrop %drive%\mkep\egg-%nick%\>NUL

::CREATE THE MONITORING FILE
TYPE temp\temp12.txt >> chk.bat
ECHO SET file=egg-%nick%.exe >> chk.bat
ECHO SET port=%port% >> chk.bat
TYPE temp\temp13.txt >> chk.bat
MOVE chk.bat %drive%\mkep\egg-%nick%

::CREATE RUN ONCE FILE
TYPE temp\temp14.txt >> RunOnce.bat
ECHO egg-%nick% -m >> RunOnce.bat
TYPE temp\temp15.txt >> RunOnce.bat

::MOVE FILES AND START EGG
MOVE RunOnce.bat %drive%\mkep\egg-%nick%
MOVE eggdrop.conf %drive%\mkep\egg-%nick%

CD %drive%\mkep\egg-%nick%
RENAME eggdrop.exe egg-%nick%.exe
START egg-%nick%.exe>NUL
START RunOnce.bat>NUL
CD %drive%\mkep\

::DISPLAY INFO ABOUT HOW TO WORK
TYPE mklang\%lang%\e16.txt 
TYPE mklang\%lang%\e17.txt
TYPE mklang\%lang%\e18.txt
TYPE mklang\%lang%\e19.txt
PAUSE
GOTO RUN

:ERROR
ECHO.
ECHO Not have the command taskkill or tasklist to manage process.
ECHO It's possible that a few more commands could not be executed.
ECHO.
PAUSE
GOTO END

:ERROR1
ECHO.
ECHO The folder %drive%\mkep does not exist.
ECHO.
PAUSE
GOTO END

:ERROR2
ECHO.
ECHO Folder location is incorrect, 
ECHO the correct location and correct folder is %drive%\mkep
ECHO.
PAUSE

:END
EXIT

:KILL
::KILL PROCESS
SET nick=
TYPE mklang\%lang%\e1.txt
SET /P nick= :
:FORCEKILL
TASKKILL /F /T /IM "egg-%nick%.exe">NUL
TASKLIST | FIND /i "egg-%nick%.exe">NUL
IF %ERRORLEVEL% equ 0 (
   GOTO FORCEKILL
) ELSE (
   PAUSE
   GOTO RUN
)

