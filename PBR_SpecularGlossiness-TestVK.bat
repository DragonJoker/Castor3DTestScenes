@echo OFF

set C3D_DIR=..\..\binaries\x64\Release\bin
set DATA_DIR=.\PBR_SpecularGlossiness

setlocal disableDelayedExpansion
for /f "delims=" %%A in ('forfiles /s /p %DATA_DIR% /m *.cscn /c "cmd /c echo @relpath"') do (
	set "file=%%~A"
	setlocal enableDelayedExpansion
	echo "Testing !file:~2!"
	%C3D_DIR%\CastorTestLauncher --vulkan "%DATA_DIR%\!file:~2!"
	%C3D_DIR%\DiffImage vulkan -f "%DATA_DIR%\!file:~2!"
	endlocal
)