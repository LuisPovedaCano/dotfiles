# Aliases
Set-Alias -Name pve -Value .\.venv\Scripts\activate

# Custom commands
function gd {
    Set-Location "C:\dev"
}

# Extensions and Tools
Invoke-Expression (&starship init powershell)
