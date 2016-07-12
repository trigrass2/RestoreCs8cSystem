@ECHO OFF
set l_ipAdress=%1
set l_login=%2
set l_password=%3
set l_target=%4
set l_keep=false
set l_tnParameter=
set l_path="boot"

REM Management of optional target parameter
if "%l_target%"=="teknor" GOTO ORDER
if "%l_target%"=="men" GOTO ORDER
if "%l_target%"=="men_hp" GOTO ORDER
if "%l_target%"=="men007" GOTO ORDER
if "%l_target%"=="men07n" GOTO ORDER
REM if target = keep, bootline.dat will be kept unchanged
if "%l_target%"=="keep" set l_keep=true
if "%l_target%"=="keep" set l_target=
if NOT "%l_target%"=="" GOTO ERROR

REM Set temp directory
:ORDER
IF NOT "%TEMP%"=="" set l_temp=%TEMP%\cs8_backup
IF "%TEMP%"=="" set l_temp=C:\TEMP\cs8_backup
IF NOT EXIST %l_temp%       MD %l_temp%
set l_temp=%l_temp%\%l_ipAdress%

IF "%l_ipAdress%"=="" GOTO ERROR										
IF "%l_login%"=="" GOTO ERROR										
IF "%l_password%"=="" GOTO ERROR										

REM Check that all files to update are present
set l_file=""
IF NOT EXIST _replaceStr.exe set l_file=_replaceStr.exe
IF NOT EXIST _bootline.bat set l_file=_bootline.bat
IF NOT EXIST _ftpBootline.txt set l_file=_ftpBootline.txt
IF NOT EXIST _ftpBootrom.txt set l_file=_ftpBootrom.txt
IF NOT EXIST boot\sys\men007.sys set l_file=boot\sys\men007.sys
IF NOT EXIST boot\sys\men07n.sys set l_file=boot\sys\men07n.sys
IF NOT EXIST boot\sys\men_hp.sys set l_file=boot\sys\men_hp.sys
IF NOT EXIST boot\sys\men.sys set l_file=boot\sys\men.sys
IF NOT EXIST boot\sys\teknor.sys set l_file=boot\sys\teknor.sys
IF NOT %l_file% == "" GOTO INVALID

REM Build directories needed for backup
IF NOT EXIST %l_temp%       MD %l_temp%
IF NOT EXIST %l_temp%	GOTO ERROR_TEMP
IF NOT EXIST %l_temp%\sys MD %l_temp%\sys				
IF EXIST %l_temp%\options.cfx DEL %l_temp%\options.cfx

:TARGET
REM Retrieve current bootline.dat to retrieve l_tnParameter
IF EXIST %l_temp%\sys\bootline.dat DEL %l_temp%\sys\bootline.dat
type _ftpBootline.txt | _replaceStr #TEMP# %l_temp% | _replaceStr #LOGIN# %l_login% | _replaceStr #PASSWORD# %l_password% > %l_temp%\ftpBootline.txt
CALL ftp -i -n -v -s:%l_temp%\ftpBootline.txt %l_ipAdress% > %l_temp%\backup.txt
IF NOT EXIST %l_temp%\sys\bootline.dat GOTO ERROR_BOOTLINE
REM Download current bootline to determine target if target is still unknown
FOR /F "tokens=2* delims=/" %%i in (%l_temp%\sys\bootline.dat) do @echo CALL %l_temp%\bootline.bat %l_temp% %%j > %l_temp%\bootline2.bat
type _bootline.bat > %l_temp%\bootline.bat
CALL %l_temp%\bootline2.bat %l_temp%

:BOOTLINE
REM Create new bootline.dat unless 'keep' was requested
if "%l_keep%"=="true" GOTO FTP
REM Create the bootline.dat that matches the specified target
IF EXIST %l_temp%\sys\bootline.dat DEL %l_temp%\sys\bootline.dat
IF "%l_target%"=="men" ECHO ata=1,0(0,0):/ata0/men f=0xa%l_tnParameter% o=gei > %l_temp%\sys\bootline.dat
IF "%l_target%"=="men_hp" ECHO ata=1,0(0,0):/ata0/men_hp f=0xa%l_tnParameter% o=gei > %l_temp%\sys\bootline.dat
IF "%l_target%"=="men007" ECHO ata=1,0(0,0):/ata0/men007 f=0xa%l_tnParameter% o=fei > %l_temp%\sys\bootline.dat
IF "%l_target%"=="men07n" ECHO ata=1,0(0,0):/ata0/men07n f=0xa%l_tnParameter% o=fei > %l_temp%\sys\bootline.dat
IF "%l_target%"=="teknor" ECHO ata=1,0(0,0):/ata0/teknor f=0xa%l_tnParameter% o=fei > %l_temp%\sys\bootline.dat
IF "%l_target%"=="menxc11" ECHO fs(0,0):/bd0/menxc11 f=0x408%l_tnParameter% o=men_sec > %l_temp%\sys\bootline.dat

:FTP
REM Launch update script if bootline.dat file has been built successfully
IF NOT EXIST %l_temp%\sys\bootline.dat GOTO ERROR_BOOTLINE

REM Update ftp script with target name
IF "%l_target%"=="" GOTO ERROR_BOOTLINE
REM extract path from tnParameter
IF NOT "%l_tnParameter%"=="" FOR /F "tokens=1* delims== " %%a IN ('ECHO %l_tnParameter%') DO set l_path=%%b
type _ftpBootrom.txt | _replaceStr #TEMP# %l_temp% | _replaceStr #LOGIN# %l_login% | _replaceStr #PASSWORD# %l_password% | _replaceStr #PATH# %l_path% | _replaceStr #TARGET# %l_target% > %l_temp%\ftp.txt

ECHO.
ECHO  New bootrom.sys will be sent to the target %l_ipAdress%.
PAUSE
CALL ftp -i -v -n -s:%l_temp%\ftp.txt %l_ipAdress%
ECHO.
ECHO --------------------------------------------------
ECHO  Please check that there was no network error during update before reboot.
ECHO --------------------------------------------------		
ECHO.															
GOTO END														
																
:ERROR															
ECHO.															
ECHO ERROR IN PARAMETER. Format is :	
ECHO update ip_adress login ftpPassword [target]
ECHO target= teknor (CS8) / men (CS8C, CS8HP) / men007 (CS8, CS8C, CS8HP) / men07n (CS8, CS8C, CS8HP)
GOTO END

:ERROR_TEMP
ECHO.
ECHO ERROR Could not create %l_temp% for backup
PAUSE															
GOTO END
			
:INVALID
ECHO.
ECHO ERROR: Incomplete software reference
ECHO %l_file% is missing
ECHO Check the content of boot directory
GOTO END														

:ERROR_BOOTLINE
ECHO.
ECHO ERROR: Unable to connect or retrieve target type.
ECHO ERROR: (network error, invalid login or password,
ECHO ERROR:  or /sys/bootline.dat missing or unexpected)
ECHO ERROR: Check network and login.
ECHO ERROR: If correct, specify a CPU type as 4th parameter.
GOTO END
																
:END															
																
