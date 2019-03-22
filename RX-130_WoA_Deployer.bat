@echo off

setlocal EnableExtensions
setlocal EnableDelayedExpansion
set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )
if ERRORLEVEL 0 (goto IsAdmin) else (goto IsNotAdmin) 

:IsAdmin
cls
title RX-130 Windows 10 Desktop on ARM64 手動部署程式
color 0a
echo ====================
echo RX-130 Windows 10 Desktop on ARM64 手動部署程式
echo 編寫 PC-DOS
echo 版本：RX-130_WoA_Deployer.AnyCPU.FRE.20190215-1825
echo ====================
echo=
echo 本程式為供RX-130/RX-127系列裝置手動部署Windows 10 Desktop on ARM64之用。開始前，請確保已經完成UEFI韌體的寫入，且已經為EFIESP和MainOS磁碟區分配磁碟機代號。請務必以系統管理員身分執行此程式。
echo=
ping 127.0.0.1 -n 5 > nul
echo 請按任意按鍵以開始。
pause > nul
cls
echo 正在蒐集所需的資訊...
echo=
echo 請輸入EFIESP磁碟區的磁碟機代號，這看上去像"E:":
set /p sEFIESP=
echo 請輸入MainOS磁碟區的磁碟機代號，這看上去像"F:":
set /p sMainOS=
echo 請輸入作業系統映像的位置，這看上去像"G:\sources\install.wim"。您也可以考慮輸入相對位置，這看上去像"install.wim"或者"\sources\install.wim":
set /p sInstall=
echo 請輸入作業系統映像分卷標號，這看上去像"1":
set /p iIndex=
echo 請輸入驅動程式軟體的位置，這看上去像"D:\RX-130\Drivers"。您也可以考慮輸入相對位置，這看上去像"\Drivers":
set /p sDrivers=
cls

:Start
cls
echo 資訊蒐集完畢，組態如下:
echo EFIESP磁碟區的磁碟機代號: %sEFIESP%
echo MainOS磁碟區的磁碟機代號: %sMainOS%
echo 作業系統映像的位置: %sInstall%
echo 作業系統映像分卷標號: %iIndex%
echo 驅動程式軟體的位置: %sDrivers%
echo=
echo 請選擇需要的作業:
echo [0]自動化安裝(安裝作業系統 -^> 建立EFI系統磁碟分割 -^> 安裝驅動程式軟體 -^> 禁用數位簽章驗證並開啟測試模式 -^> 關閉存在問題的邏輯處理器)
echo [1]安裝作業系統
echo [2]建立EFI系統磁碟分割
echo [3]安裝驅動程式軟體
echo [4]禁用數位簽章驗證並開啟測試模式
echo [5]關閉存在問題的邏輯處理器
echo [6]變更EFIESP磁碟區的磁碟機代號
echo [7]變更MainOS磁碟區的磁碟機代號
echo [8]變更作業系統映像的位置
echo [9]變更作業系統映像分卷標號
echo [10]變更驅動程式軟體的位置
echo [E]結束
set iChoice=n
set /p iChoice=請輸入您的選擇:
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
echo 正在安裝作業系統...
Format %sMainOS% /v:MainOS /FS:NTFS /q /x /y
Dism /Apply-Image /ImageFile:"%sInstall%" /Index:%iIndex% /ApplyDir:%sMainOS%
echo=
echo 正在建立EFI系統磁碟分割...
Format %sEFIESP%  /v:EFIESP /FS:FAT /q /x /y
BCDBoot %sMainOS%\Windows /s %sEFIESP% /f UEFI
echo=
echo 正在安裝驅動程式軟體...
Dism /Image:%sMainOS% /Add-Driver /Driver:"%sDrivers%" /Recurse
echo=
echo 正在禁用數位簽章驗證並開啟測試模式...
bcdedit /store "%sEFIESP%\EFI\Microsoft\Boot\BCD" /set {default} testsigning on
bcdedit /store "%sEFIESP%\EFI\Microsoft\Boot\BCD" /set {globalsettings} nointegritychecks on
echo=
echo 正在關閉存在問題的邏輯處理器...
bcdedit /store "%sEFIESP%\EFI\Microsoft\Boot\BCD" /set {default} numproc 4
echo=
echo 所要求的作業已完成，請按任意按鍵以回到功能選單。
pause > nul
goto Start

:DeployOS
cls
echo 正在安裝作業系統...
Format %sMainOS% /v:MainOS /FS:NTFS /q /x /y
Dism /Apply-Image /ImageFile:"%sInstall%" /Index:%iIndex% /ApplyDir:%sMainOS%
echo=
echo 所要求的作業已完成，請按任意按鍵以回到功能選單。
pause > nul
goto Start

:CreateEFIESP
cls
echo 正在建立EFI系統磁碟分割...
Format %sEFIESP% /v:EFIESP /FS:FAT /q /x /y
BCDBoot %sMainOS%\Windows /s %sEFIESP% /f UEFI
echo=
echo 所要求的作業已完成，請按任意按鍵以回到功能選單。
pause > nul
goto Start

:InstallDriver
cls
echo 正在安裝驅動程式軟體...
Dism /Image:%sMainOS% /Add-Driver /Driver:"%sDrivers%" /Recurse
echo=
echo 所要求的作業已完成，請按任意按鍵以回到功能選單。
pause > nul
goto Start

:DisableSecurityCheck
cls
echo 正在禁用數位簽章驗證並開啟測試模式...
bcdedit /store "%sEFIESP%\EFI\Microsoft\Boot\BCD" /set {default} testsigning on
bcdedit /store "%sEFIESP%\EFI\Microsoft\Boot\BCD" /set {globalsettings} nointegritychecks on
echo=
echo 所要求的作業已完成，請按任意按鍵以回到功能選單。
pause > nul
goto Start

:DisableLogicProessor
cls
echo 正在關閉存在問題的邏輯處理器...
bcdedit /store "%sEFIESP%\EFI\Microsoft\Boot\BCD" /set {default} numproc 4
echo=
echo 所要求的作業已完成，請按任意按鍵以回到功能選單。
pause > nul
goto Start

:ChangeEFIESP
cls
echo 請輸入EFIESP磁碟區的磁碟機代號，這看上去像"E:":
set /p sEFIESP=
goto Start

:ChangeMainOS
cls
echo 請輸入MainOS磁碟區的磁碟機代號，這看上去像"F:":
set /p sMainOS=
goto Start

:ChangeInstall
cls
echo 請輸入作業系統映像的位置，這看上去像"G:\sources\install.wim":
set /p sInstall=
goto Start

:ChangeIndex
cls
echo 請輸入作業系統映像分卷標號，這看上去像"1":
set /p iIndex=
goto Start

:ChangeDriver
cls
echo 請輸入驅動程式軟體的位置，這看上去像"D:\RX-130\Drivers":
set /p sDrivers=
goto Start

:Exit
echo 請按任意按鍵以結束。
pause > nul
exit

:IsNotAdmin
echo 錯誤: 無法以系統管理員身分執行此程式，請按任意按鍵以結束。
pause > nul
exit