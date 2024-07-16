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
function Look-Around {
    param (
        [string]$Location
    )

    try {
        # Validate the input
        if ([string]::IsNullOrWhiteSpace($Location)) {
            throw "Location cannot be empty or null."
        }

        # Generate description using LLM
        $description = Invoke-LLM -prompt "Describe the surroundings at $Location on a mysterious island. Simple and short."

        # Generate image based on description
        #PSAOAI\Invoke-PSAOAIDalle3 -Prompt $description -ApiVersion "2024-02-01" -model "dalle3" -Deployment "dalle3" -quality standard -size 1024x1024

        # Log success
        Write-Host "Look-Around executed successfully for location: $Location" -ForegroundColor Green
    }
    catch {
        # Log error
        Write-Error "An error occurred in Look-Around: $_"
    }
}