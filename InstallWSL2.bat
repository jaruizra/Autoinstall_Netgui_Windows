@echo off

REM Mirar si WSL esta instalado o no
wsl --status >null 2>&1
if %ERRORLEVEL% neq 0 (
    echo Attempting to install WSL...
    wsl --install
    REM Compuebo errores
    if %ERRORLEVEL% neq 0 (
        echo Error while installing WSL. Abort operation.
        exit /b %ERRORLEVEL%
    )
    wsl --set-default-version 2
    if %ERRORLEVEL% neq 0 (
        echo Error while setting default version of WSL to WSL2. Abort operation.
        exit /b %ERRORLEVEL%
    )
    wsl --update
    if %ERRORLEVEL% neq 0 (
        echo Error while updating WSL2. Abort operation.
        exit /b %ERRORLEVEL%
    )
) else (
    echo WSL is already installed.
    exit /b 0
)

REM Crea la variable file con la ruta del archivo .wslconfig
set "file=%UserProfile%\.wslconfig"

REM Crear el archivo .wslconfig si no existe
if not exist "%file%" (
    echo Creating %file%...
) else (
    echo Updating %file%...
)

REM Añade la configuración [wsl2] al archivo .wslconfig
(
    echo [wsl2]
    echo swap=32GB
) > "%file%"

echo Configuration complete.
pause
