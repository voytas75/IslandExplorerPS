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
        $prompt = "The player is at $($global:gameState.Location) and wants to explore $action. Describe what they see, hear, and feel."
        $descriptionJSON = Invoke-LLM -prompt $prompt -stream $false -jsonmode $true
        Write-Verbose "Received JSON response from LLM."

        # Convert JSON response to PowerShell object
        Write-Verbose "Converting JSON response to PowerShell object."
        $description = $descriptionJSON | ConvertFrom-Json

        # Return the description object
        Write-Verbose "Returning the description object."
        return $description
    }
    catch {
        # Error handling
        Write-Error "An error occurred in the explore function: $_"
    }
    finally {
        Write-Verbose "Ending explore function."
    }
}
