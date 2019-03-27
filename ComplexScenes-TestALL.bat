@echo OFF

set C3D_DIR=..\..\binaries\x64\Release\bin
set DATA_DIR=.\ComplexScenes

setlocal disableDelayedExpansion
for /f "delims=" %%A in ('forfiles /s /p %DATA_DIR% /m *.cscn /c "cmd /c echo @relpath"') do (
	set "file=%%~A"
	setlocal enableDelayedExpansion
	echo "Testing !file:~2!"
	echo "  OpenGL 3.x"
	%C3D_DIR%\CastorTestLauncher --opengl3 "%DATA_DIR%\!file:~2!"
	echo "  OpenGL 4.x"
	%C3D_DIR%\CastorTestLauncher --opengl4 "%DATA_DIR%\!file:~2!"
	REM echo "  Direct3D 11"
	REM %C3D_DIR%\CastorTestLauncher --direct3d11 "%DATA_DIR%\!file:~2!"
	echo "  Vulkan"
	%C3D_DIR%\CastorTestLauncher --vulkan "%DATA_DIR%\!file:~2!"
	REM %C3D_DIR%\DiffImage opengl3 opengl4 direct3d11 vulkan -f "%DATA_DIR%\!file:~2!"
	%C3D_DIR%\DiffImage opengl3 opengl4 vulkan -f "%DATA_DIR%\!file:~2!"
	endlocal
)