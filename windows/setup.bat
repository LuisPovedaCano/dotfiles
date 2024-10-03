@echo off
setlocal enabledelayedexpansion

rem Check for admin privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This script requires administrative privileges. Please run as administrator.
    pause
    exit /b
)

rem Check if winget is available
echo Checking if winget is available...
where winget >nul 2>&1
if %errorlevel% neq 0 (
    echo winget is not available on this system. Installation canceled.
    pause
    exit /b
)

rem Check if Python is installed by running 'python --version'
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Installing Python...
    winget install python3 --silent --accept-package-agreements --accept-source-agreements
    if %errorlevel% neq 0 (
        echo Failed to install Python via winget.
        pause
        exit /b
    )
) else (
    echo Python is already installed.
)

rem Check if any version of Microsoft Visual Studio is installed
set "vs_found=0"
for /f "tokens=*" %%v in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\VisualStudio" ^| findstr "Microsoft Visual Studio"') do (
    echo Microsoft Visual Studio is already installed.
    set vs_found=1
    goto :skip_vc_install
)

rem Check if Microsoft C++ Build Tools is installed
if exist "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\" (
    echo Microsoft C++ Build Tools is already installed.
) else (
    echo Installing Microsoft C++ Build Tools...
    winget install -e --id Microsoft.VisualStudio.2022.BuildTools --silent --accept-package-agreements --accept-source-agreements
    if %errorlevel% neq 0 (
        echo Failed to install Microsoft C++ Build Tools via winget.
        pause
        exit /b
    )
)

:skip_vc_install

rem Check if Rust is installed by running 'rustc --version'
rustc --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Installing Rust...
    winget install -e --id Rustlang.Rust.MSVC --silent --accept-package-agreements --accept-source-agreements
    if %errorlevel% neq 0 (
        echo Failed to install Rust via winget.
        pause
        exit /b
    )
) else (
    echo Rust is already installed.
)

rem Check if Git is installed by running 'git --version'
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Installing Git...
    winget install git --silent --accept-package-agreements --accept-source-agreements
    if %errorlevel% neq 0 (
        echo Failed to install Git via winget.
        pause
        exit /b
    )
) else (
    echo Git is already installed.
)

rem Check if Git LFS is installed
git lfs --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Installing Git LFS...
    winget install -e --id GitHub.GitLFS
    if %errorlevel% neq 0 (
        echo Failed to install Git LFS via winget.
        pause
        exit /b
    )
) else (
    echo Git LFS is already installed.
)

rem Check if Docker is installed
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Installing Docker...
    winget install -e --id Docker.DockerDesktop --silent --accept-package-agreements --accept-source-agreements
    if %errorlevel% neq 0 (
        echo Failed to install Docker via winget.
        pause
        exit /b
    )
) else (
    echo Docker is already installed.
)

rem Check if GNU Make is installed
make --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Installing GNU Make...
    winget install ezwinports.make
    if %errorlevel% neq 0 (
        echo Failed to install GNU Make via winget.
        pause
        exit /b
    )
) else (
    echo GNU Make is already installed.
)

rem Check if Starship is installed by running 'starship --version'
starship --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Installing Starship...
    winget install starship --silent --accept-package-agreements --accept-source-agreements
    if %errorlevel% neq 0 (
        echo Failed to install Starship via winget.
        pause
        exit /b
    )
) else (
    echo Starship is already installed.
)

rem Check if Visual Studio Code is installed by running 'code --version'
call code --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Installing Visual Studio Code...
    winget install --id Microsoft.VisualStudioCode --silent --accept-package-agreements --accept-source-agreements
    if %errorlevel% neq 0 (
        echo Failed to install Visual Studio Code via winget.
        pause
        exit /b
    )
) else (
    echo Visual Studio Code is already installed.
)

rem Install extensions for Visual Studio Code
echo Installing extensions for Visual Studio Code...
set extensions=aaron-bond.better-comments eamodio.gitlens Gruntfuggly.todo-tree josetr.cmake-language-support-vscode llvm-vs-code-extensions.vscode-clangd ms-azuretools.vscode-docker ms-python.debugpy ms-python.Python ms-python.vscode-pylance ms-vscode.makefile-tools ms-vscode.powershell ms-vscode-remote.remote-containers PKief.material-icon-theme rust-lang.rust-analyzer supermaven.supermaven tamasfe.even-better-toml redhat.vscode-yaml vadimcn.vscode-lldb yzhang.markdown-all-in-one

for %%i in (%extensions%) do (
    call code --install-extension %%i --force  >nul 2>&1
    if %errorlevel% neq 0 (
        echo Failed to install or update extension %%i
    ) else (
        echo Extension '%%i' is already installed or updated.
    )
)

rem Check if JetBrains Mono Nerd Font is installed by checking the fonts folder
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" | findstr /i "JetBrains Mono Nerd" >nul
if %errorlevel% neq 0 (
    echo Installing JetBrains Mono Nerd Font...
    winget install --id=DEVCOM.JetBrainsMonoNerdFont -e --silent --accept-package-agreements --accept-source-agreements
    if %errorlevel% neq 0 (
        echo Failed to install JetBrains Mono Nerd Font via winget.
        pause
        exit /b
    )
) else (
    echo JetBrains Mono Nerd Font is already installed.
)

rem Define the path to the .config folder
set "configPath=%USERPROFILE%\.config"
set "profilePath=%USERPROFILE%\Documents\WindowsPowerShell"
set "repoPath=%USERPROFILE%\.config\windows\powershell\Microsoft.PowerShell_profile.ps1"
set "targetPath=%USERPROFILE%\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"

if not exist "%profilePath%" (
    mkdir "%profilePath%"
)

if exist "%configPath%" (
    rmdir /s /q "%configPath%"
)

rem Clone your repository directly into the .config directory
git clone https://github.com/LuisPovedaCano/dotfiles.git "%configPath%"

rem Check if the repository was successfully cloned
if %errorlevel% == 0 (
    echo Repository successfully cloned into %configPath%.
    if exist "%repoPath%" (
        echo Creating symbolic link...
        if exist "%targetPath%" (
            echo Removing existing profile...
            del "%targetPath%"
        )
        mklink "%targetPath%" "%repoPath%"
    ) else (
        echo The repository does not contain a PowerShell profile.
    )
) else (
    echo Failed to clone the repository.
)

endlocal
pause
