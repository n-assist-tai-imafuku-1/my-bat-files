@echo off
mkdir C:\DriverBackup_%date:~0,4%%date:~5,2%%date:~8,2%
dism /online /export-driver /destination:C:\DriverBackup_%date:~0,4%%date:~5,2%%date:~8,2%
pause