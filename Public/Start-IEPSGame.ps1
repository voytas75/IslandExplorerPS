<#
.SYNOPSIS
    Starts the Island Explorer PowerShell game.

.DESCRIPTION
    Initializes the game state and enters the main game loop, prompting the player for commands and processing them.

.NOTES
    Author: Voytas75
    Date: 2024-07
#>
function Start-IEPSGame {
    [CmdletBinding()]
    param(
        
    )
    # Initial Game State
    $gameState = @{
        Location  = "Beach"
        Inventory = @()
        Progress  = "Start"
    }

    Show-Introduction

    # Game Loop
    while ($true) {
        Write-Verbose "Game state (hashtable): $($gameState | Out-String)"
        try {
            $command = Get-PlayerCommand

            # Validate the command before processing
            if (-not [string]::IsNullOrWhiteSpace($command)) {
                Invoke-gamecommand -Command $command
            } else {
                Write-Host "Invalid command. Please try again." -ForegroundColor Yellow
            }
        }
        catch {
            Write-Error "An error occurred while processing the command: $_"
        }
    }
}
