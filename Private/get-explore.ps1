function get-explore {
    [CmdletBinding()]
    param (
        [string]$command
    )

    # Verbose message indicating the start of the function
    Write-Verbose "Starting explore function with command: $command"

    try {
        # Extract the direction or action from the command
        Write-Verbose "Extracting action from command."
        $action = $command -replace "explore ", ""
        Write-Verbose "Action extracted: $action"

        # Use LLM to generate the exploration description based on the current location and action
        Write-Verbose "Generating exploration description using LLM."
        $prompt = @"
The player is at $($global:gameState.Location) and wants to explore $action. Describe what they see, hear, and feel. Answer as JSON. Json schema:
{
    "Description": "[description what user sees]",
    "Sounds": "[sound description]", 
    "Smells": "[smell description]",
    "Textures": "[textures description]",
    "available_activity":
    [
        "[acivity 1]",
        "[acivity n]"
    ],
    "other": "[here goes other]"
}
"@
        $exploreJSON = Invoke-LLM -prompt $prompt -stream $false -jsonmode $true
        Write-Verbose "Received JSON response from LLM."

        # Convert JSON response to PowerShell object
        Write-Verbose "Converting JSON response to PowerShell object."
        $explore = $exploreJSON | ConvertFrom-Json

        # Update the global game state with the new description and other details
        Write-Verbose "Updating global game state with the new description and other details."
        $global:GameState.Description = "$($explore.Description) $($explore.Sounds) $($explore.Smells) $($explore.Textures)"
        $global:GameState.activity = $explore.available_activity
        $global:GameState.other = $explore.other

        # Return the description object
        Write-Verbose "Returning the description object."
        return $explore
    }
    catch {
        # Error handling
        Write-Error "An error occurred in the explore function: $_"
    }
    finally {
        Write-Verbose "Ending explore function."
    }
}
