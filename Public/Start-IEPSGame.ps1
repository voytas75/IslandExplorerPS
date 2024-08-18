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
    param()
    
    Write-Verbose "Initializing game state."

    try {
        # Initial Game State
        $global:GameState = @{
            Location        = "Beach"
            Inventory       = @()
            Progress        = "Start"
            Description     = "You find yourself on a deserted island. Your goal is to explore the island, solve puzzles, and find a way to escape. Type 'help' for a list of commands."
            Help            = "Available commands:`n...`nthere is no help`nyou are on your own"
            Items           = $()
            ItemDescription = ""
            activity        = ""
            other           = ""
            lastCommand     = ""
        }

        Write-Verbose "Game state initialized."

        # Initialize game history

        if (-not $global:GameHistory) {
            Initialize-GameHistory
            Write-Verbose "Initializing game history."
        }

        # Show introduction to the player
        Write-Verbose "Showing game introduction."
        Show-Introduction

        # Start HTTP server
        Write-Verbose "Starting HTTP server."
        Start-HTTPServer

        Write-Verbose "Game started successfully."
    }
    catch {
        Write-Error "An error occurred while starting the game: $_"
    }
}
