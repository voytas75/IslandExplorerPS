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

Use JSON with keys: description, Location, ways, items. JSON Example:
{
  "description": "[here put description]",
  "Location": "[here put location]",
  "Ways": 
  [
  "[here put way to go]",
  "[here put way to go]"
  ],
  "Items": [
  "[here put a item]",
  "[here put a item]"
  ]
}
Response with json. Use simple and short form. 
"@
        $responseJSON = Invoke-LLM -prompt $LookAroundPrompt -stream $false -JSONMode $true
        Write-Verbose "Received response from LLM."

        $parsedResponse = $null
        try {
            Write-Verbose "Parsing response as JSON."
            $parsedResponse = $responseJSON | ConvertFrom-Json
        }
        catch {
            return "Failed to parse the response as JSON: $_"
        }

        $description = $parsedResponse.description
        $location = $parsedResponse.Location
        $ways = $parsedResponse.Ways
        $Items = $parsedResponse.Items

        Write-Verbose "Description: $description"
        Write-Verbose "Location: $location"
        Write-Verbose "Ways: $($ways -join ", ")"
        Write-Verbose "Items: $($Items -join ", ")"
        
        # Generate image based on description
        #PSAOAI\Invoke-PSAOAIDalle3 -Prompt $description -ApiVersion "2024-02-01" -model "dalle3" -Deployment "dalle3" -quality standard -size 1024x1024

        # Log success
        Write-Verbose "Get-LookAround executed successfully for location: $Location"
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