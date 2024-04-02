@echo off

:: Set TELEMAC specific environnement variables
set HOMETEL=%CONDA_PREFIX%\Library\opentelemac
set SYSTELCFG=%HOMETEL%\configs\systel.windows.cfg
set USETELCFG=gnu.dynamic

:: Store PATH, PYTHONPATH, PYTHONUNBUFFERED
set _OLD_VIRTUAL_PATH=%PATH%
set _OLD_VIRTUAL_PYTHONPATH=%PYTHONPATH%
if defined PYTHONUNBUFFERED (
    set _OLD_VIRTUAL_PYTHONUNBUFFERED=%PYTHONUNBUFFERED%
)

:: Add TELEMAC binaries directory to PATH
set PATH=%HOMETEL%\builds\%USETELCFG%\lib;%PATH%
:: Add TELEMAC scripts folder to PATH
set PATH=%HOMETEL%\scripts;%PATH%
::Add TELEMAC Python scripts to PYTHONPATH
set PYTHONPATH=%HOMETEL%\scripts\python3;%PYTHONPATH%
set PYTHONPATH=%HOMETEL%\builds\%USETELCFG%\wrap_api\lib;%PYTHONPATH%
set PYTHONUNBUFFERED="true"
