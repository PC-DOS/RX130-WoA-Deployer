@echo off

setlocal EnableExtensions
setlocal EnableDelayedExpansion
set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )
if ERRORLEVEL 0 (goto IsAdmin) else (goto IsNotAdmin) 

:IsAdmin
cls
title RX-130 Windows 10 Desktop on ARM64 �քӲ����ʽ
color 0a
echo ====================
echo RX-130 Windows 10 Desktop on ARM64 �քӲ����ʽ
echo ���� PC-DOS
echo �汾��RX-130_WoA_Deployer.AnyCPU.FRE.20190215-1825
echo ====================
echo=
echo ����ʽ�鹩RX-130/RX-127ϵ���b���քӲ���Windows 10 Desktop on ARM64֮�á��_ʼǰ��Ո�_���ѽ����UEFI�g�w�Č��룬���ѽ���EFIESP��MainOS�ŵ��^����ŵ��C��̖��Ո�ձ���ϵ�y����T��ֈ��д˳�ʽ��
echo=
ping 127.0.0.1 -n 5 > nul
echo Ո�����ⰴ�I���_ʼ��
pause > nul
cls
echo �����L��������YӍ...
echo=
echo Ոݔ��EFIESP�ŵ��^�Ĵŵ��C��̖���@����ȥ��"E:":
set /p sEFIESP=
echo Ոݔ��MainOS�ŵ��^�Ĵŵ��C��̖���@����ȥ��"F:":
set /p sMainOS=
echo Ոݔ�����Iϵ�yӳ���λ�ã��@����ȥ��"G:\sources\install.wim"����Ҳ���Կ��]ݔ������λ�ã��@����ȥ��"install.wim"����"\sources\install.wim":
set /p sInstall=
echo Ոݔ�����Iϵ�yӳ��־��̖���@����ȥ��"1":
set /p iIndex=
echo Ոݔ���ӳ�ʽܛ�w��λ�ã��@����ȥ��"D:\RX-130\Drivers"����Ҳ���Կ��]ݔ������λ�ã��@����ȥ��"\Drivers":
set /p sDrivers=
cls

:Start
cls
echo �YӍ�L���ꮅ���M�B����:
echo EFIESP�ŵ��^�Ĵŵ��C��̖: %sEFIESP%
echo MainOS�ŵ��^�Ĵŵ��C��̖: %sMainOS%
echo ���Iϵ�yӳ���λ��: %sInstall%
echo ���Iϵ�yӳ��־��̖: %iIndex%
echo �ӳ�ʽܛ�w��λ��: %sDrivers%
echo=
echo Ո�x����Ҫ�����I:
echo [0]�Ԅӻ����b(���b���Iϵ�y -^> ����EFIϵ�y�ŵ��ָ� -^> ���b�ӳ�ʽܛ�w -^> ���Ô�λ������C�K�_���yԇģʽ -^> �P�]���چ��}��߉݋̎����)
echo [1]���b���Iϵ�y
echo [2]����EFIϵ�y�ŵ��ָ�
echo [3]���b�ӳ�ʽܛ�w
echo [4]���Ô�λ������C�K�_���yԇģʽ
echo [5]�P�]���چ��}��߉݋̎����
echo [6]׃��EFIESP�ŵ��^�Ĵŵ��C��̖
echo [7]׃��MainOS�ŵ��^�Ĵŵ��C��̖
echo [8]׃�����Iϵ�yӳ���λ��
echo [9]׃�����Iϵ�yӳ��־��̖
echo [10]׃���ӳ�ʽܛ�w��λ��
echo [E]�Y��
set iChoice=n
set /p iChoice=Ոݔ�������x��:
if "%iChoice%" == "0" goto AutoExecute
if "%iChoice%" == "1" goto DeployOS
if "%iChoice%" == "2" goto CreateEFIESP
if "%iChoice%" == "3" goto InstallDriver
if "%iChoice%" == "4" goto DisableSecurityCheck
if "%iChoice%" == "5" goto DisableLogicProessor
if "%iChoice%" == "6" goto ChangeEFIESP
if "%iChoice%" == "7" goto ChangeMainOS
if "%iChoice%" == "8" goto ChangeInstall
if "%iChoice%" == "9" goto ChangeIndex
if "%iChoice%" == "10" goto ChangeDriver
if "%iChoice%" == "E" goto Exit
if "%iChoice%" == "e" goto Exit
goto Start

:AutoExecute
cls
echo ���ڰ��b���Iϵ�y...
Format %sMainOS% /v:MainOS /FS:NTFS /q /x /y
Dism /Apply-Image /ImageFile:"%sInstall%" /Index:%iIndex% /ApplyDir:%sMainOS%
echo=
echo ���ڽ���EFIϵ�y�ŵ��ָ�...
Format %sEFIESP%  /v:EFIESP /FS:FAT /q /x /y
BCDBoot %sMainOS%\Windows /s %sEFIESP% /f UEFI
echo=
echo ���ڰ��b�ӳ�ʽܛ�w...
Dism /Image:%sMainOS% /Add-Driver /Driver:"%sDrivers%" /Recurse
echo=
echo ���ڽ��Ô�λ������C�K�_���yԇģʽ...
bcdedit /store "%sEFIESP%\EFI\Microsoft\Boot\BCD" /set {default} testsigning on
bcdedit /store "%sEFIESP%\EFI\Microsoft\Boot\BCD" /set {globalsettings} nointegritychecks on
echo=
echo �����P�]���چ��}��߉݋̎����...
bcdedit /store "%sEFIESP%\EFI\Microsoft\Boot\BCD" /set {default} numproc 4
echo=
echo ��Ҫ������I����ɣ�Ո�����ⰴ�I�Իص������x�Ρ�
pause > nul
goto Start

:DeployOS
cls
echo ���ڰ��b���Iϵ�y...
Format %sMainOS% /v:MainOS /FS:NTFS /q /x /y
Dism /Apply-Image /ImageFile:"%sInstall%" /Index:%iIndex% /ApplyDir:%sMainOS%
echo=
echo ��Ҫ������I����ɣ�Ո�����ⰴ�I�Իص������x�Ρ�
pause > nul
goto Start

:CreateEFIESP
cls
echo ���ڽ���EFIϵ�y�ŵ��ָ�...
Format %sEFIESP% /v:EFIESP /FS:FAT /q /x /y
BCDBoot %sMainOS%\Windows /s %sEFIESP% /f UEFI
echo=
echo ��Ҫ������I����ɣ�Ո�����ⰴ�I�Իص������x�Ρ�
pause > nul
goto Start

:InstallDriver
cls
echo ���ڰ��b�ӳ�ʽܛ�w...
Dism /Image:%sMainOS% /Add-Driver /Driver:"%sDrivers%" /Recurse
echo=
echo ��Ҫ������I����ɣ�Ո�����ⰴ�I�Իص������x�Ρ�
pause > nul
goto Start

:DisableSecurityCheck
cls
echo ���ڽ��Ô�λ������C�K�_���yԇģʽ...
bcdedit /store "%sEFIESP%\EFI\Microsoft\Boot\BCD" /set {default} testsigning on
bcdedit /store "%sEFIESP%\EFI\Microsoft\Boot\BCD" /set {globalsettings} nointegritychecks on
echo=
echo ��Ҫ������I����ɣ�Ո�����ⰴ�I�Իص������x�Ρ�
pause > nul
goto Start

:DisableLogicProessor
cls
echo �����P�]���چ��}��߉݋̎����...
bcdedit /store "%sEFIESP%\EFI\Microsoft\Boot\BCD" /set {default} numproc 4
echo=
echo ��Ҫ������I����ɣ�Ո�����ⰴ�I�Իص������x�Ρ�
pause > nul
goto Start

:ChangeEFIESP
cls
echo Ոݔ��EFIESP�ŵ��^�Ĵŵ��C��̖���@����ȥ��"E:":
set /p sEFIESP=
goto Start

:ChangeMainOS
cls
echo Ոݔ��MainOS�ŵ��^�Ĵŵ��C��̖���@����ȥ��"F:":
set /p sMainOS=
goto Start

:ChangeInstall
cls
echo Ոݔ�����Iϵ�yӳ���λ�ã��@����ȥ��"G:\sources\install.wim":
set /p sInstall=
goto Start

:ChangeIndex
cls
echo Ոݔ�����Iϵ�yӳ��־��̖���@����ȥ��"1":
set /p iIndex=
goto Start

:ChangeDriver
cls
echo Ոݔ���ӳ�ʽܛ�w��λ�ã��@����ȥ��"D:\RX-130\Drivers":
set /p sDrivers=
goto Start

:Exit
echo Ո�����ⰴ�I�ԽY����
pause > nul
exit

:IsNotAdmin
echo �e�`: �o����ϵ�y����T��ֈ��д˳�ʽ��Ո�����ⰴ�I�ԽY����
pause > nul
exit