set l_temp=%1
set l_bootFile=%2
set l_tn=%5=%6
IF "%l_tn%"=="tn=boot7" set l_tnParameter= %l_tn%
IF "%l_tn%"=="tn=boot7_vx6" set l_tnParameter= %l_tn%
IF NOT "%l_target%"=="" GOTO END
set l_target=
REM Management of known target : bootline.dat is kept unchanged
IF "%l_bootFile%"=="men007" set l_target=men007
IF "%l_bootFile%"=="men07n" set l_target=men07n
IF "%l_bootFile%"=="men" set l_target=men
IF "%l_bootFile%"=="men_hp" set l_target=men_hp
IF "%l_bootFile%"=="teknor" set l_target=teknor
IF "%l_bootFile%"=="menxc11" set l_target=menxc11
IF NOT "%l_target%"=="" GOTO END
REM Refuses downgrade or bootrom update with 'vxworks' target (before VAL3 s5.0)
ECHO.
ECHO Downgrade, or bootrom.sys update cannot be done before VAL3 s5.0
ECHO Press Ctrl+C to stop update.
PAUSE
:END
