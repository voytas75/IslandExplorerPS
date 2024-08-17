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
    $global:GameState = @{
        Location  = "Beach"
        Inventory = @()
        Progress  = "Start"
        Description = "You find yourself on a deserted island. Your goal is to explore the island, solve puzzles, and find a way to escape.
Type 'help' for a list of commands."
        Help = "Available commands:`n...`nthere is no help`nyou are on your own"
        Items = $()
        ItemDescription = ""
        activity = ""
        other = ""
        lastCommand = ""
    }

    Show-Introduction

    # Start HTTP server
    Start-HTTPServer
}


function Start-IEPSGame2 {
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
