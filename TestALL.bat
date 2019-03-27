@echo OFF

cd /d %~dp0

set C3D_DIR=..\..\binaries\x64\Release\bin

:loop
if not "%1" == "" (
	set FILE=%1
	echo "Testing %1"
	echo "    Vulkan"
	%C3D_DIR%\CastorTestLauncher --vulkan "%1"
	echo "    OpenGL 3.X"
	%C3D_DIR%\CastorTestLauncher --opengl3 "%1"
	echo "    OpenGL 4.X"
	%C3D_DIR%\CastorTestLauncher --opengl4 "%1"
	echo "    Direct3D 11"
	%C3D_DIR%\CastorTestLauncher --direct3d11 "%1"
	REM echo "    Diffing"
	REM %C3D_DIR%\DiffImage opengl3 opengl4 direct3d11 vulkan -f "%1"
	shift
	goto loop
)

pause
