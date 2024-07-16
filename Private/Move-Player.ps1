<#
.SYNOPSIS
    Moves the player in a specified direction on the island.

.DESCRIPTION
    This function processes a move command, determines the new location of the player using an LLM, 
    and updates the player's location if the move is valid. It also provides feedback to the player 
    and describes the new surroundings.

.PARAMETER command
    The move command specifying the direction in which the player wants to move.

.NOTES
    Author: Voytas75
    Date: 2024-07
#>
function Move-Player {
    param (
        [string]$command
    )

    try {
        # Validate the input
        if ([string]::IsNullOrWhiteSpace($command)) {
            throw "Invalid command. The command must start with 'move ' and cannot be empty or null."
        }

        # Extract the direction from the command
        $direction = $command -replace "move ", ""

        # Determine the new location using LLM
        $currentLocation = $gameState.Location

        do {
        #$newLocation = Invoke-LLM "player moves $direction from $currentLocation. What is new location? Respond with the location only"
        $newLocation = Invoke-LLM "player moves $direction from $currentLocation. What is new location? Generate a location name. Provide only the name, without any additional description or context"
        
        }while ($newLocation -eq "")

        $gameState.location = $newLocation

        Invoke-LLM "Player moves $direction from $currentLocation to $newLocation. Create simple and short description."

        # Check if the new location is different from the current location
        if ($newLocation -ne $currentLocation) {
            # Update the global game state with the new location
            $gameState.Location = $newLocation
            Write-Host "You move to $newLocation." -ForegroundColor Green
            Look-Around -Location $newLocation
        } else {
            Write-Host "You can't move in that direction." -ForegroundColor Yellow
        }
    }
    catch {
        # Log error
        Write-Error "An error occurred in Move-Player: $_"
    }
}