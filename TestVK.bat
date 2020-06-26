@echo OFF

cd /d %~dp0

set C3D_DIR=..\..\binaries\x64\Release\bin

:loop
if not "%1" == "" (
	set FILE=%1
	echo "Testing %1"
	%C3D_DIR%\CastorTestLauncher -vk "%1"
	%C3D_DIR%\DiffImage vk -f "%1"
	shift
	goto loop
)
