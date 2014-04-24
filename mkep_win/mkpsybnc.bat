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
TITLE mkep - mkpsybnc

::SET VAR
SET drive=%~d0
SET folder=%~dp0
SET file=Cron.exe

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

:RUN
::SHOW MENU
ECHO.
TYPE mklang\%lang%\menu-psy.txt
ECHO.
@ECHO off
TYPE mklang\%lang%\pe.txt
SET /p menu= :
IF '%menu%'=='1' GOTO MAKE
IF '%menu%'=='2' GOTO END
IF '%menu%'=='3' GOTO KILL
CLS

:MAKE
::ASKING FOR A NICKNAME
SET nick=
TYPE mklang\%lang%\p1.txt
SET /P nick= :
ECHO.

:PORT
::ASKING FOR ANY PORT
SET port=
TYPE mklang\%lang%\ep2.txt
SET /P port= :
ECHO Checking port is avaiable.
netstat -a | FIND /i ":%port%"
IF errorlevel 1 GOTO CRON

:BUSY
::IF PORT IS BUSY ASK FOR ANOTHER ONE
TYPE mklang\%lang%\ep3.txt
GOTO PORT

:CRON
::ASKING IF YOU WANT ADD PROCESS IN CRONTAB
SET cron=
TYPE mklang\%lang%\p4.txt
SET /P cron= :
IF /I '%cron%'=='y' GOTO NEXT1
IF /I '%cron%'=='n' GOTO NEXT2

:NEXT1
::ADD THE TASK IN CRONTAB
ECHO 0,10,20,30,40,50 * * * * %drive%\mkep\psy-%nick%\chk.bat>NUL >> crontab\crontab 

:NEXT2
::CREATE THE CONFIGS
MD %drive%\mkep\psy-%nick%
XCOPY /E %drive%\mkep\psybnc %drive%\mkep\psy-%nick%\>NUL
ECHO PSYBNC.SYSTEM.PORT1=%port% >> psybnc.conf
TYPE temp\temp11.txt >> psybnc.conf

::CREATE THE MONITORING FILE
TYPE temp\temp12.txt >> chk.bat
ECHO SET file=psy-%nick%.exe >> chk.bat
ECHO SET port=%port% >> chk.bat
TYPE temp\temp13.txt >> chk.bat

::MOVE FILES AND START PSY
MOVE chk.bat %drive%\mkep\psy-%nick%
MOVE psybnc.conf %drive%\mkep\psy-%nick%
CD %drive%\mkep\psy-%nick%\
RENAME psybnc.exe psy-%nick%.exe
START psy-%nick%>NUL

::DISPLAY INFO ABOUT HOW TO CONNECT
CD %drive%\mkep\
TYPE mklang\%lang%\p5.txt
ECHO /server localhost:%port%
TYPE mklang\%lang%\p7.txt
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
TYPE mklang\%lang%\p1.txt
SET /P nick= :
:FORCEKILL
TASKKILL /F /T /IM "psy-%nick%.exe">NUL
TASKLIST | FIND /i "psy-%nick%.exe">NUL
IF %ERRORLEVEL% equ 0 (
   GOTO FORCEKILL
) ELSE (
   PAUSE
   GOTO RUN
)

