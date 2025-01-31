
IF "%LOADED_config_bat%" == "1" EXIT /B 0
SET LOADED_config_bat=1
SET scriptpath=%~dp0
SET scriptpath=%scriptpath:~0,-1%
IF "%APPVEYOR_BUILD_FOLDER%" NEQ "^%APPVEYOR_BUILD_FOLDER^%" SET scriptpath=%APPVEYOR_BUILD_FOLDER%
IF "%scriptpath%" == "" SET scriptpath=%CD%
IF %scriptpath% == ^%scriptpath^% SET scriptpath=%CD%
SET PATH=%PATH%;%scriptpath%
SET py64=C:\Python39-x64\python.exe
SET py32=C:\Python39\python.exe
SET ENABLE_BUILD_X86=0
SET keylen=64
SET _7Z_OUPUT_=%scriptpath%\bin
IF NOT DEFINED BUILDER_THREADING SET BUILDER_THREADING=1
SET BUILDER_NB_THREAD=%NUMBER_OF_PROCESSORS%
SET BUILDER_THREADING_TITLE=%random%%random%%random%%random%%random%%random%
SET PYTHONOPTIMIZE=1
::IF NOT DEFINED PYTHONOPTIMIZE_FLAG SET PYTHONOPTIMIZE_FLAG=-OO
IF NOT DEFINED PYTHONOPTIMIZE_FLAG SET PYTHONOPTIMIZE_FLAG= 
SET CGO_ENABLED=0
SET GOPATH=%scriptpath%\GOPATH\

:: Generate random key for encryption
powershell -exec bypass -nop -Command "-join ((65..90) + (97..122) | Get-Random -Count %keylen% | %% {[char]$_})" > %tmp%\pykey
SET /p pykey= < %tmp%\pykey
del /q /s /f %tmp%\pykey

:: Generate random key for 7z encryption
powershell -exec bypass -nop -Command "-join ((65..90) + (97..122) | Get-Random -Count %keylen% | %% {[char]$_})" > %tmp%\_7Z_PASSWORD_
SET /p _7Z_PASSWORD_= < %tmp%\_7Z_PASSWORD_
del /q /s /f %tmp%\_7Z_PASSWORD_


echo [105;93m===========================================================================
echo = CONFIG =
echo scriptpath=%scriptpath%
echo APPVEYOR_BUILD_FOLDER=%APPVEYOR_BUILD_FOLDER%
echo py64=%py64%
echo py32=%py32%
echo ENABLE_BUILD_X86=%ENABLE_BUILD_X86%
echo BUILDER_THREADING=%BUILDER_THREADING%
echo BUILDER_NB_THREAD=%BUILDER_NB_THREAD%
echo BUILDER_THREADING_TITLE=%BUILDER_THREADING_TITLE%
echo keylen=%keylen%
echo _7Z_OUPUT_=%_7Z_OUPUT_%
echo _7Z_PASSWORD_=%_7Z_PASSWORD_%
echo ===========================================================================[0m

appveyor SetVariable -Name _7Z_PASSWORD_ -Value %_7Z_PASSWORD_%
CALL log.bat "Using 7z key=%_7Z_PASSWORD_%" 1
EXIT /B 0
