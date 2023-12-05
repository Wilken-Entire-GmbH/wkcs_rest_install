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

set LOG_DIR=%WORKING_DIR%\logs

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

(set LF=^

)

set WKCSREST=p5dmsWkcsRest_%TENANT%
set WKCSSPLITTER=p5dmsWkcsSplitter_%TENANT%

rem wkcs to rest setup
nssm install %WKCSREST% "%BIN_DIR%\wds_wkcs_rest.exe" 
nssm set %WKCSREST% AppDirectory "%WORKING_DIR%"
nssm set %WKCSREST% DisplayName "Wilken P/5 DMS WKCS REST Adapter for %TENANT%"
nssm set %WKCSREST% Description "Wilken P/5 DMS WKCS REST Adapter for %TENANT%"
nssm set %WKCSREST% Start SERVICE_DELAYED_AUTO_START
nssm set %WKCSREST% AppStdout "%LOG_DIR%\%TENANT%_wkcsrest.log"
nssm set %WKCSREST% AppStderr "%LOG_DIR%\%TENANT%_wkcsrest.log"
nssm set %WKCSREST% AppEnvironmentExtra WDS_CONFIG_DIR=%WDS_CONFIG_DIR%^%LF%%LF%NODE_TLS_REJECT_UNAUTHORIZED=0^%LF%%LF%WDS_TENANT_CONFIG=%TENANT%^%LF%%LF%WDS_RUNTIME_DIR=%WORKING_DIR%\p5dms\%TENANT%

rem wkcs to rest setup
nssm install %WKCSSPLITTER% "%BIN_DIR%\wds_wkcs_splitter.exe" 
nssm set %WKCSSPLITTER% AppDirectory "%WORKING_DIR%"
nssm set %WKCSSPLITTER% DisplayName "Wilken P/5 DMS WKCS Splitter for %TENANT%"
nssm set %WKCSSPLITTER% Description "Wilken P/5 DMS WKCS Splitter for %TENANT%"
nssm set %WKCSSPLITTER% Start SERVICE_DELAYED_AUTO_START
nssm set %WKCSSPLITTER% AppStdout "%LOG_DIR%\%TENANT%_wkcssplit.log"
nssm set %WKCSSPLITTER% AppStderr "%LOG_DIR%\%TENANT%_wkcssplit.log"
nssm set %WKCSSPLITTER% AppEnvironmentExtra WDS_CONFIG_DIR=%WDS_CONFIG_DIR%^%LF%%LF%NODE_TLS_REJECT_UNAUTHORIZED=0^%LF%%LF%WDS_TENANT_CONFIG=%TENANT%^%LF%%LF%WDS_RUNTIME_DIR=%WORKING_DIR%\p5dms\%TENANT%

:end
endlocal
