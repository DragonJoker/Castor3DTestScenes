@echo OFF

set C3D_DIR=..\..\binaries\x64\Release\bin
set DATA_DIR=.\PBR_MetallicRoughness

setlocal disableDelayedExpansion
for /f "delims=" %%A in ('forfiles /s /p %DATA_DIR% /m *.cscn /c "cmd /c echo @relpath"') do (
	set "file=%%~A"
	setlocal enableDelayedExpansion
	echo "Testing !file:~2!"
	%C3D_DIR%\CastorTestLauncher -vk "%DATA_DIR%\!file:~2!"
	%C3D_DIR%\DiffImage vk -f "%DATA_DIR%\!file:~2!"
	endlocal
)