TERMS OF USE
============================================

The use of the software package you are about to download requires a deep knowledge of the Stäubli robot systems.

Do not use this package if you have not been through a Stäubli official maintenance training class, as the use of 
this software may result in non-ordinary behaviour of the Stäubli robot system it is being used onto.


 MST : Maintenance software Toolkit contents 
============================================

A windows command line script "bootrom.bat" to update robot that are in VAL3 version 5.0 to 5.3.
Then the robot supports boot from USB stick and the use of this MST.


Several VAL3 applications that can be launch after booting the CS8 with this MST :

- dynBrakeMST : allows to disable dynamic braking on some axis to check backlash of the mechanics.

- maint_starc : allows to update the starc software version compatible with current hardware
= at least version 1.13 or latest version if STARC2 board is present

- RestoreBkp : allows to restore a backup done with a val3 version >=6 or SRS version >=6
(backups have to be copied in the backups directory of the USB stick)


Changes :
=======

29 jan 2013 : m3.0
Based on R&D version MST universal3.0
Support of MM1 CPU (=SRC7.5): new boot7_vx6 folder

17 jul 2012 : m2.1.0.0
Based on R&D version MST universal2.1
Support of TP80 robot (=SRC7.4)
German library of messages for phaseAdjustment application

10 apr 2012 m2.0.0.2
Bug correction for FieldValReg in SRC 7

20 jan 2012  m2.0.0.1
Bug correction m2.0.0.0 can't boot 


11 jan 2012 : m2.0.0.0
Compatibility with SRC 6.9 & 7.3
Based on R&D version MST uni2.0

16 nov 2011 :
version m1.1.1.2 : based on R&D version MST universal1.1a
Bug correction of phaseAdjustement application that was not working with new encoder.


18 oct 2011 :
version m1.1.1.1 : based on R&D version MST universal1.1
Compatible with SRC 7.x and SRC 6.x
New application PhaseAdjust V1.0
New application FieldValReg v2.0


21 jul 2010 : 
- Starc version updated to 1.18.3