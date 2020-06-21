rem setlocal ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

REM Usual path: OBJASM_PATH="D:\ObjAsm"
REM It is stored in the registry:
REM   - HKEY_CURRENT_USER\Environment
REM   - HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment

REM ----------- For my own use -----------------
if "%COMPUTERNAME%"=="LWP-JKHC2Z2" (
  set ToolPath="E:\_Software_"
  set Linker="%ToolPath:"=%\Microsoft Visual Studio\2019\Community\VC\Tools\MSVC\14.26.28801\bin\Hostx64\x64\link.exe"
) else (
  set ToolPath="%ProgramFiles(x86)%"
  set Linker="C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin\link.exe"
)

"%SystemRoot%\system32\reg.exe" Query "HKLM\Hardware\Description\System\CentralProcessor\0" | "%SystemRoot%\system32\find.exe" /i "x86" > NUL && set SYSTEM_BITNESS=32 || set SYSTEM_BITNESS=64

if %OS%==64BIT echo This is a 64bit operating system

set BldInf="%OBJASM_PATH%\Build\Tools\BuildInfo.cmd"
set Inc2RC="%OBJASM_PATH%\Build\Tools\Inc2RC.cmd"
set MidlCompiler="%ToolPath:"=%\Windows Kits\10\bin\10.0.18362.0\x64\midl.exe"
set UICCompiler="%WINKIT_PATH%\x86\UICC.exe"
set ResourceCompiler="%ToolPath:"=%\Windows Kits\10\bin\10.0.18362.0\x64\RC.EXE"

if %SYSTEM_BITNESS%==32 (
  set Assembler="!OBJASM_PATH!\Build\Tools\UASM32.EXE"
) else (
  set Assembler="!OBJASM_PATH!\Build\Tools\UASM64.EXE"
)

rem set Linker="%ToolPath:"=%\Microsoft Visual Studio\2019\Community\VC\Tools\MSVC\14.26.28801\bin\Hostx64\x64\link.exe"
set LibraryCompiler="%ToolPath:"=%\Microsoft Visual Studio\2019\Community\VC\Tools\MSVC\14.26.28801\bin\Hostx64\x64\lib.exe"
set Debugger="%ToolPath:"=%\Microsoft Visual Studio\2019\Community\Common7\IDE\devenv.exe"

exit /b 0