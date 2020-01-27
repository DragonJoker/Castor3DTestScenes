@echo OFF

set C3D_DIR=..\..\binaries\x64\Release\bin
set DATA_DIR=.\Common

setlocal disableDelayedExpansion
for /f "delims=" %%A in ('forfiles /s /p %DATA_DIR% /m *.cscn /c "cmd /c echo @relpath"') do (
	set "file=%%~A"
	setlocal enableDelayedExpansion
	echo "Testing !file:~2!"
	REM echo "  OpenGL"
	REM %C3D_DIR%\CastorTestLauncher -gl "%DATA_DIR%\!file:~2!"
	REM echo "  Direct3D 11"
	REM %C3D_DIR%\CastorTestLauncher -d3d11 "%DATA_DIR%\!file:~2!"
	echo "  Vulkan"
	%C3D_DIR%\CastorTestLauncher -vk "%DATA_DIR%\!file:~2!"
	REM %C3D_DIR%\DiffImage gl d3d11 vk -f "%DATA_DIR%\!file:~2!"
	endlocal
)