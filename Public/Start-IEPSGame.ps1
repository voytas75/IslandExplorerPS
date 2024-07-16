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
    # Initial Game State
    $gameState = @{
        Location  = "Beach"
        Inventory = @()
        Progress  = "Start"
    }

    Show-Introduction

    # Game Loop
    while ($true) {
        $gameState
        try {
            $command = Get-PlayerCommand

            # Validate the command before processing
            if (-not [string]::IsNullOrWhiteSpace($command)) {
                Invoke-command -Command $command
            } else {
                Write-Host "Invalid command. Please try again." -ForegroundColor Yellow
            }
        }
        catch {
            Write-Error "An error occurred while processing the command: $_"
        }
    }
}
