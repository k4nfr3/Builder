IF "%LOADED_config_bat%" == "1" EXIT /B 0
SETLOCAL
SET LOADED_config_bat=1
SET scriptpath=%~dp0
SET scriptpath=%scriptpath:~0,-1%
IF "%APPVEYOR_BUILD_FOLDER%" NEQ "^%APPVEYOR_BUILD_FOLDER^%" SET scriptpath=%APPVEYOR_BUILD_FOLDER%
IF "%scriptpath%" == "" SET scriptpath=%CD%
IF %scriptpath% == ^%scriptpath^% SET scriptpath=%CD%
SET PATH=%PATH%;%scriptpath%
SET py64=C:\Python38-x64
SET py32=C:\Python38
SET keylen=64
SET DEBUG_BATCH=1
SET _7Z_OUPUT_=%scriptpath%\bin

:: Generate random key for encryption
powershell -exec bypass -nop -Command "-join ((65..90) + (97..122) | Get-Random -Count %keylen% | ^% {[char]$_})" > %tmp%\pykey
SET /p pykey= < %tmp%\pykey
del /q /s /f %tmp%\pykey

:: Generate random key for 7z encryption
powershell -exec bypass -nop -Command "-join ((65..90) + (97..122) | Get-Random -Count %keylen% | ^% {[char]$_})" > %tmp%\_7Z_PASSWORD_
SET /p _7Z_PASSWORD_= < %tmp%\_7Z_PASSWORD_
del /q /s /f %tmp%\_7Z_PASSWORD_

echo [105;93m===========================================================================
echo = CONFIG =
echo scriptpath=%scriptpath%
echo APPVEYOR_BUILD_FOLDER=%APPVEYOR_BUILD_FOLDER%
echo py64=%py64%
echo py32=%py32%
echo keylen=%keylen%
echo DEBUG_BATCH=%DEBUG_BATCH%
echo _7Z_OUPUT_=%_7Z_OUPUT_%
echo _7Z_PASSWORD_=%_7Z_PASSWORD_%
echo ===========================================================================[0m


appveyor SetVariable -Name _7Z_PASSWORD_ -Value %_7Z_PASSWORD_%
appveyor AddMessage "[%date% %time%] Using 7z key=%_7Z_PASSWORD_%" -Category Information
EXIT /B 0