
# Set the current module's name
$script:ModuleName = "IsPSGame"
$script:ModuleNameFull = "Island Explorer PowerShell Game"
$script:ModulePath = $PSScriptRoot

# Retrieve all public and private PowerShell scripts within the module
$Public = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue -Recurse )
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue -Recurse )

# Import all public and private scripts, and handle any potential errors
$FoundErrors = @(
    Foreach ($Import in @($Public + $Private)) {
        Try {
            . $Import.Fullname
        }
        Catch {
            Write-Error -Message "Failed to import functions from $($import.Fullname): $_"
            $true
        }
    }
)

# If any errors are found, alert the user and halt the script
if ($FoundErrors.Count -gt 0) {
    $ModuleElementName = (Get-ChildItem $PSScriptRoot\*.psd1).BaseName
    Write-Warning "Importing module $ModuleElementName failed. Fix errors before continuing."
    break
}

# Enforce the use of TLS 1.2 security protocol
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

# Determine the installed version of the module
$ModuleVersion = [version]"0.0.1"

# Query the PSGallery repository for the most recent version of the module
$LatestModule = Find-Module -Name $script:ModuleName -Repository PSGallery -ErrorAction SilentlyContinue

# If a more recent version is available, inform the user
try {
    if ($ModuleVersion -lt $LatestModule.Version) {
        Write-Host "An update is available for $script:ModuleName. Installed version: $ModuleVersion. Latest version: $($LatestModule.Version)." -ForegroundColor Red
    } 
}
catch {
    Write-Error "An error occurred while checking for updates: $_"
}

# Greet the user upon module initiation
Write-Host "Welcome to game $script:ModuleNameFull ($script:ModuleName)"
write-Host ""
write-Host "Start-IEPSGame to start a game" -ForegroundColor White
write-Host ""