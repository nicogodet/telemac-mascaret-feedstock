:: TELEMAC home directory
set HOMETEL=%SRC_DIR%\opentelemac
:: Configuration file
set SYSTELCFG=%HOMETEL%\configs\systel.windows.cfg

set PYTHONUNBUFFERED="true"

:: Configure PATH and PYTHONPATH
set PATH=%HOMETEL%\scripts\python3;%PATH%
set PYTHONPATH=%HOMETEL%\scripts\python3;%PYTHONPATH%

:: Compile all configs (currently: gnu.dynamic gnu.dynamic.debug)
python -m compile_telemac -j32
if errorlevel 1 exit 1

for %%f in (%HOMETEL%\scripts\python3\*.py) do (
  echo @echo off > %HOMETEL%\scripts\%%~nf.py.bat
  echo python %%~dp0\python3\%%~nf.py %%* >> %HOMETEL%\scripts\%%~nf.py.bat
)

:: Copy builds
mkdir %LIBRARY_PREFIX%\opentelemac\builds
xcopy %HOMETEL%\builds %LIBRARY_PREFIX%\opentelemac\builds /E /H /C /I

:: Copy sources
mkdir %LIBRARY_PREFIX%\opentelemac\sources
xcopy %HOMETEL%\sources %LIBRARY_PREFIX%\opentelemac\sources /E /H /C /I

:: Copy configs
mkdir %LIBRARY_PREFIX%\opentelemac\configs
copy  %SYSTELCFG% %LIBRARY_PREFIX%\opentelemac\configs

:: Copy python scripts
mkdir %LIBRARY_PREFIX%\opentelemac\scripts
xcopy %HOMETEL%\scripts %LIBRARY_PREFIX%\opentelemac\scripts /E /H /C /I
:: Replace VnV command 
:: mpirun is just an alias for mpiexec, replace with mpiexec
sed -i 's/mpirun/mpiexec/g' %LIBRARY_PREFIX%\opentelemac\scripts\python3\vvytel\vnv_api.py
:: On Windows, better to call `python -m module` rather than rely on file association
sed -i 's/template.py/python -m template/g' %LIBRARY_PREFIX%\opentelemac\scripts\python3\vvytel\vnv_api.py
:: Fixes "module 'matplotlib.tri' has no attribute 'triangulation'"
sed -i 's/mtri.triangulation.Triangulation/mtri.Triangulation/g' %LIBRARY_PREFIX%\opentelemac\scripts\python3\postel\plot2d.py

:: Copy TELEMAC command to enable/disable debug mode
copy %RECIPE_DIR%\scripts\telemac-debug.bat %SCRIPTS%\

:: Trick to solve "mpirun not found"
FOR /F "tokens=*" %%i in (' "where mpiexec" ') do SET MPIEXEC_PATH=%%~dpi
copy %MPIEXEC_PATH%\mpiexec.exe %MPIEXEC_PATH%\mpirun.exe

setlocal EnableDelayedExpansion

:: Copy the [de]activate scripts to %PREFIX%\etc\conda\[de]activate.d.
:: This will allow them to be run on environment activation.
for %%F in (activate deactivate) DO (
    if not exist %PREFIX%\etc\conda\%%F.d mkdir %PREFIX%\etc\conda\%%F.d
    copy %RECIPE_DIR%\scripts\%%F.bat %PREFIX%\etc\conda\%%F.d\%PKG_NAME%_%%F.bat
)
