@echo OFF

set C3D_DIR=..\..\binaries\x64\Release\bin
set DATA_DIR=.\PBR_MetallicRoughness

setlocal disableDelayedExpansion
for /f "delims=" %%A in ('forfiles /s /p %DATA_DIR% /m *.cscn /c "cmd /c echo @relpath"') do (
	set "file=%%~A"
	setlocal enableDelayedExpansion
	echo "Testing !file:~2!"
	echo "  OpenGL"
	%C3D_DIR%\CastorTestLauncher -gl "%DATA_DIR%\!file:~2!"
	echo "  Direct3D 11"
	%C3D_DIR%\CastorTestLauncher -d3d11 "%DATA_DIR%\!file:~2!"
	echo "  Vulkan"
	%C3D_DIR%\CastorTestLauncher -vk "%DATA_DIR%\!file:~2!"
	%C3D_DIR%\DiffImage gl d3d11 vk -f "%DATA_DIR%\!file:~2!"
	endlocal
)