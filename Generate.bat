@echo OFF

cd /d %~dp0

set C3D_DIR=..\..\binaries\x64\Release\bin

:loop
if not "%1" == "" (
	set FILE=%1
	echo "Generating %1"
	%C3D_DIR%\CastorTestLauncher --generate "%1"
	shift
	goto loop
)

pause
