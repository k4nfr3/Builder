CALL config.bat
CALL pre-install.bat


:: Build impacket
CALL clone.bat SecureAuthCorp/impacket


CALL clone.bat Hackndo/WebclientServiceScanner
cd webclientservicescanner
CALL build-py.bat console , WebclientServiceScanner , 0


set _err=%ERRORLEVEL%
set _errorExpected=0
IF "%ERRORLEVEL%" == "%_errorExpected%" (
	CALL log.bat "✅ Build Rubeus.exe OK" 1
	echo Rubeus.exe >Rubeus.lst7z
	echo Rubeus.exe.config >>Rubeus.lst7z
	7z a -t7z -mhe -p%_7Z_PASSWORD_% %_7Z_OUPUT_%\Rubeus.7z @Rubeus.lst7z
	appveyor PushArtifact %_7Z_OUPUT_%\Rubeus.7z
	copy Rubeus.exe %scriptpath%\bin\Rubeus.exe
) else (
	CALL log.bat ERR "FAIL to build a valid Rubeus.exe (This bin return %_err%, expected %_errorExpected%)..." , 1
)


:: Sync threading
CALL sync-thread.bat 0


:: #############################################################################
:END_MAIN
::7z a -t7z -mhe -p%_7Z_PASSWORD_% %_7Z_OUPUT_%\All.7z %scriptpath%\bin\*.exe
::appveyor PushArtifact %_7Z_OUPUT_%\All.7z
dir %scriptpath%\bin\
dir %_7Z_OUPUT_%
cd %_7Z_OUPUT_%
CALL log.bat "✅ Build END"
EXIT /B 0
