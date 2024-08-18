<#
.SYNOPSIS
    Describes the surroundings at the player's current location on the island.

.DESCRIPTION
    This function uses an LLM to generate a description of the surroundings based on the player's current location.
    It then generates an image based on the description using the PSAOAI Dalle3 model.

.PARAMETER Location
    The current location of the player.

.NOTES
    Author: Voytas75
    Date: 2024-07
#>
function Get-LookAround {
    [CmdletBinding()]
    param (
        [string]$Location,
        [string]$command
    )

    try {
        Write-Verbose "Starting Get-LookAround function."
        
        # Validate the input
        Write-Verbose "Validating input parameters."
        if ([string]::IsNullOrWhiteSpace($Location)) {
            throw "Location cannot be empty or null."
        }

        # Generate description using LLM
        Write-Verbose "Generating description using LLM."
        $LookAroundPrompt = @"
Based on user command '$command', do: 
- Describe the surroundings at $Location on a mysterious island. 
- Add ways (exit locations) and items in the location. 

Use JSON with keys: description, Location, ways, items, and all others. JSON schema:
{
  "description": "[here put description]",
  "Location": "[here put location]",
  "Ways": 
  [
  "[here put way to go]",
  "[here put way to go]"
  ],
  "Items": [
  "[here put an item]",
  "[here put an item]"
  ],
  "available_activity":"[here goes available activity name]",
  "other":"[here goes other]"
}
Use simple and short form. 
"@
        $responseJSON = Invoke-LLM -prompt $LookAroundPrompt -stream $false -JSONMode $true
        Write-Verbose "Received response from LLM."

        # Parse the response as JSON
        Write-Verbose "Parsing response as JSON."
        try {
            $parsedResponse = $responseJSON | ConvertFrom-Json
        }
        catch {
            return "Failed to parse the response as JSON: $_"
        }

        # Extract information from the parsed response
        $description = $parsedResponse.description
        $location = $parsedResponse.Location
        $ways = $parsedResponse.Ways
        $Items = $parsedResponse.Items
        $available_activity = $parsedResponse.available_activity
        $other = $parsedResponse.other

        # Update global game state
        $global:GameState.activity = $available_activity
        $global:GameState.other = $other
        $global:GameState.Description = $description
        $global:GameState.Location = $location
        $global:GameState.Ways = $ways
        $global:GameState.Items = $Items
        $global:GameState.Progress = "progress"

        # Log the extracted information
        Write-Verbose "Description: $description"
        Write-Verbose "Location: $location"
        Write-Verbose "Ways: $($ways -join ", ")"
        Write-Verbose "Items: $($Items -join ", ")"
        
        # Generate image based on description (commented out)
        # PSAOAI\Invoke-PSAOAIDalle3 -Prompt $description -ApiVersion "2024-02-01" -model "dalle3" -Deployment "dalle3" -quality standard -size 1024x1024

        # Log success
        Write-Verbose "Get-LookAround executed successfully for location: $Location"

        # Create and return result object
        $result = [PSCustomObject]@{
            Description = $description
            Location    = $location
            Ways        = $ways
            Items       = $Items
        }
        Write-Verbose "Returning result object."
        return $result
    }
    catch {
        # Log error
        Write-Error "An error occurred in Get-LookAround: $_"
    }
    finally {
        Write-Verbose "Ending Get-LookAround function."
    }
}