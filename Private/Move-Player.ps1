<#
.SYNOPSIS
    Moves the player in a specified direction on the island.

.DESCRIPTION
    This function processes a move command, determines the new location of the player using an LLM, 
    and updates the player's location if the move is valid. It also provides feedback to the player 
    and describes the new surroundings.

.PARAMETER From
    The current location of the player.

.PARAMETER command
    The move command specifying the direction in which the player wants to move.

.NOTES
    Author: Voytas75
    Date: 2024-07
#>
function Move-Player {
    [CmdletBinding()]
    param (
        [string]$From,
        [string]$command
    )

    try {
        Write-Verbose "Starting Move-Player function."
        
        # Validate the input command
        if ([string]::IsNullOrWhiteSpace($command)) {
            Write-Verbose "Invalid command detected: command is null or whitespace."
            return "Invalid command. The command must start with 'move ' and cannot be empty or null."
        }

        # Extract the direction from the command
        $direction = $command -replace "move ", ""
        Write-Verbose "Extracted direction: $direction"

        # Get the current location from the game state
        $currentLocation = $global:gameState.Location
        Write-Verbose "Current location: $currentLocation"

        do {
            # Request new location from LLM
            $llmPrompt = @"
Player moves $direction from $currentLocation. What is new location? Generate a location name. Provide only the name, without any additional description or context. Response as Json. JSON schema: 
{
    "Target_location":"[here will be target location]",
    "available_activity":
        [
            "[acivity 1]",
            "[acivity n]"
        ],
    "other":"[here goes other]"
}
"@
            Write-Verbose "Sending prompt to LLM: $llmPrompt"
            $newLocationJSON = Invoke-LLM -prompt $llmPrompt -jsonmode $true
            $newLocation = ($newLocationJSON | ConvertFrom-Json).Target_location
            Write-Verbose "Received new location: $newLocation"
        } while ([string]::IsNullOrWhiteSpace($newLocation))

        # Update the game state with the new location and other elements
        $global:GameState.Location = $newLocation
        $global:GameState.Activity = ($newLocationJSON | ConvertFrom-Json).available_activity
        $global:GameState.Other = ($newLocationJSON | ConvertFrom-Json).other
        Write-Verbose "Updated game state location"
        Write-Verbose "Updated game state available activity"
        Write-Verbose "Updated game state other"

        # Check if the new location is different from the current location
        if ($newLocation -ne $currentLocation) {
            Write-Verbose "New location is different from the current location."
            Write-Host "You move to $newLocation." -ForegroundColor Green
        } else {
            Write-Verbose "New location is the same as the current location."
            Write-Host "You can't move in that direction." -ForegroundColor Yellow
        }

        # Provide feedback on the new surroundings
        $respond = get-lookaround -Location $global:GameState.Location -Command "look around"
        return $respond
    }
    catch {
        # Log error
        Write-Error "An error occurred in Move-Player: $_"
    }    
}