function get-Gameitem {
    [CmdletBinding()]
    param (
        [string]$command
    )
    
    Write-Verbose "Starting get-Gameitem function with command: $command"
    
    try {
        # Extract the item name from the command
        Write-Verbose "Extracting item name from command."
        $item = $command -replace "^(take|pick) ", ""
        Write-Verbose "Item extracted: $item"

        # Check if the item is already in the inventory
        Write-Verbose "Checking if item is already in the inventory."
        if ($global:gameState.Inventory -contains $item) {
            Write-Host "You already have the $item." -ForegroundColor Yellow
            Write-Verbose "Item already in inventory: $item"
            return
        }

        # Use LLM to determine if the item can be taken from the current location
        Write-Verbose "Generating prompt to check if item can be taken."
        $GameItemPrompt = @"
Decide if the player can take the $item from $($global:gameState.Location)? Answer yes or no as JSON. Example
{
"['Yes' or 'No']"
}
"@
        Write-Verbose "Prompt generated: $GameItemPrompt"
        $canTakeItem = Invoke-LLM -prompt $GameItemPrompt -stream $false
        Write-Verbose "Received response from LLM: $canTakeItem"

        if ($canTakeItem -eq "yes") {
            # Add the item to the inventory
            Write-Verbose "Item can be taken. Adding item to inventory."
            $global:gameState.Inventory += $item
            Write-Host "You have taken the $item." -ForegroundColor Green
        }
        else {
            Write-Verbose "Item cannot be taken from the current location."
            Write-Host "You cannot take the $item from here." -ForegroundColor Red
        }

        Write-Verbose "Returning result of Get-LookAround function."
        return (Get-LookAround -Location $global:gameState.Location -command "look around")
    }
    catch {
        Write-Error "An error occurred in get-Gameitem function: $_"
    }
    finally {
        Write-Verbose "Ending get-Gameitem function."
    }
}
