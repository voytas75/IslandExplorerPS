function New-GameCacheFolder {
    [CmdletBinding()]
    param (
        [string]$GameName = "IslandExplorerPS"
    )

    # Define the root path for the cache folder in the user's Documents directory
    $rootPath = [System.IO.Path]::Combine([System.Environment]::GetFolderPath('MyDocuments'), $GameName)

    # Check if the directory already exists
    if (-not (Test-Path -Path $rootPath)) {
        try {
            # Create the directory
            New-Item -ItemType Directory -Path $rootPath -Force | Out-Null
            Write-Verbose "Created cache folder at: $rootPath"
        }
        catch {
            Write-Error "Failed to create cache folder at ${rootPath}: $_"
        }
    } else {
        Write-Verbose "Cache folder already exists at: $rootPath"
    }

    return $rootPath
}
