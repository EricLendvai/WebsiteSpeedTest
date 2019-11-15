@echo off
if %1. == . goto MissingParameter
if %1. == debug.   goto GoodParameter
if %1. == release. goto GoodParameter

echo You must send "debug" or "release" as parameter
goto End

:GoodParameter

SET MINGWVERPATH=i686-8.1.0-win32-dwarf-rt_v6-rev0
set HB_PATH=C:\Harbour

set PATH=C:\Program Files (x86)\mingw-w64\%MINGWVERPATH%\mingw32\bin;%HB_PATH%\bin\win\mingw;C:\HarbourTools;%PATH%
set HB_COMPILER=mingw

C:
md "C:\HarbourTestCode-32\WebsiteSpeedTest\%1\"
cd "C:\HarbourTestCode-32\WebsiteSpeedTest\%1\"

if %1 == debug (
		hbmk2 ..\WebsiteSpeedTest.hbp -b
) else (
		hbmk2 ..\WebsiteSpeedTest.hbp
)

goto End
:MissingParameter
echo Missing Parameter
:End