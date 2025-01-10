@echo off

:: Get date and time in a reliable format
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "fdate=%dt:~0,4%%dt:~4,2%%dt:~6,2%"
set "ftime=%dt:~8,2%%dt:~10,2%%dt:~12,2%"

:: Create the backup folder
set "folder=C:\Documents\Logs-%fdate%-%ftime%"
echo .
echo Creating folder: %folder%
MKDIR "%folder%"
if %errorlevel% neq 0 echo Error creating folder! & exit /b

:: Backup event logs
echo .
echo Creating backup of Brink Logs
wevtutil epl Brink "%folder%\Brink-%fdate%.evtx"
if %errorlevel% neq 0 echo Error backing up Brink logs!

echo Creating backup of Application Logs
wevtutil epl Application "%folder%\Application-%fdate%.evtx"
if %errorlevel% neq 0 echo Error backing up Application logs!

echo Creating backup of System Logs
wevtutil epl System "%folder%\System-%fdate%.evtx"
if %errorlevel% neq 0 echo Error backing up System logs!

:: Backup SDF files
echo .
echo Backing up SDF files
COPY C:\Brink\POS\Register.sdf "%folder%\Register-%fdate%.sdf" /y
if %errorlevel% neq 0 echo Error copying Register.sdf!

COPY C:\Brink\POS\PosRegister.db "%folder%\PosRegister-%fdate%.db" /y
if %errorlevel% neq 0 echo Error copying PosRegister.db!

COPY C:\Brink\Pos\PosEventLogs.db "%folder%\PosEventLogs-%fdate%.db" /y
if %errorlevel% neq 0 echo Error copying PosEventLogs.db!

COPY C:\Brink\Pos\Brink.InStoreDataMesh.db "%folder%\Brink.InStoreDataMesh-%fdate%.db" /y
if %errorlevel% neq 0 echo Error copying Brink.InStoreDataMesh.db!

COPY C:\Brink\Pos\BrinkUtility.key "%folder%\BrinkUtility-%fdate%.key" /y
if %errorlevel% neq 0 echo Error copying BrinkUtility.key!

COPY C:\Brink\Register.cfg "%folder%\Register.cfg-%fdate%.cfg" /y
if %errorlevel% neq 0 echo Error copying Register.cfg!

:: Backup the Brink POS Backup folder
echo .
echo Creating backup of Brink POS Backup folder
XCOPY /E /I "C:\Brink\POS\Backup" "%folder%\Backup-%fdate%"
if %errorlevel% neq 0 echo Error backing up Backup folder!

:: Zip the backup folder using PowerShell
echo .
echo Zipping up logs and SDF files
powershell -Command "Compress-Archive -Path '%folder%\*' -DestinationPath '%folder%\Logs-%fdate%-%ftime%.zip'" 
if %errorlevel% neq 0 echo Error zipping files!

echo .
echo Done!
