@echo off
setlocal
set START_DIR=%~dp0
set path=%START_DIR%;%path%

set BIN_DIR=%START_DIR%..\app\p5dms
set path=%BIN_DIR%;%path%

rem get absolute path of bin directory
pushd "%BIN_DIR%"
set BIN_DIR=%cd%
popd

set WORKING_DIR=%START_DIR%..

rem get absolute path of working directory
pushd "%WORKING_DIR%"
set WORKING_DIR=%cd%
popd

set WDS_CONFIG_DIR=%WORKING_DIR%\config\p5dms
echo %WDS_CONFIG_DIR%

set WORKING_DIR=%WORKING_DIR%\runtime

if "%1%"=="" (
    echo "usage: %0% <tenantid>"
    goto :end 
)

set TENANT=%1%
set TENANTCONFIG=%WDS_CONFIG_DIR%\tenants\%TENANT%.yaml

if not exist %TENANTCONFIG% (
    echo %TENANT% is not a tenant. No configuration available: %TENANTCONFIG%
    goto :end 
)

set WKCSREST=p5dmsWkcsRest_%TENANT%

nssm stop %WKCSREST%

set WKCSSPLITTER=p5dmsWkcsSplitter_%TENANT%

nssm stop %WKCSSPLITTER%
:end
endlocal