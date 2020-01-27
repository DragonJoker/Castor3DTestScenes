@echo OFF

cd /d %~dp0

set C3D_DIR=..\..\binaries\x64\Release\bin

:loop
if not "%1" == "" (
	set FILE=%1
	echo "Testing %1"
	echo "    Vulkan"
	%C3D_DIR%\CastorTestLauncher -vk "%1"
	echo "    OpenGL"
	%C3D_DIR%\CastorTestLauncher -gl "%1"
	echo "    Direct3D 11"
	%C3D_DIR%\CastorTestLauncher -d3d11 "%1"
	REM echo "    Diffing"
	REM %C3D_DIR%\DiffImage gl d3d11 vk -f "%1"
	shift
	goto loop
)

pause
