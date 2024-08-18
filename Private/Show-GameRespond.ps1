function Show-GameRespond {
    [CmdletBinding()]
    param (
        [PSCustomObject]$respond
    )

    # Check if the response object is null
    if ($null -eq $respond) {
        Write-Host "No response to display." -ForegroundColor Yellow
        Write-Verbose "The provided response object is null."
        return
    }

    # Display the Description property if not empty
    if ($global:GameState.Description) {
        Write-Host "Description: $($global:GameState.Description)" -ForegroundColor Cyan
        Write-Verbose "Displayed Description"
    }

    # Display the other property if not empty
    if ($global:GameState.other) {
        Write-Host "$($global:GameState.other)" -ForegroundColor Cyan
        Write-Verbose "Displayed other"
    }

    # Display the Location property if not empty
    if ($global:GameState.Location) {
        Write-Host "Location: $($global:GameState.Location)" -ForegroundColor Green
        Write-Verbose "Displayed Location"
    }

    # Display the Ways property if not empty
    if ($global:GameState.Ways) {
        Write-Host "Ways to go: $($global:GameState.Ways -join ', ')" -ForegroundColor Magenta
        Write-Verbose "Displayed Ways"
    }

    # Display the Items property if not empty
    if ($global:GameState.Items) {
        Write-Host "Items: $($global:GameState.Items -join ', ')" -ForegroundColor Blue
        Write-Verbose "Displayed Items"
    }

    # Display the available_activity property if not empty
    if ($global:GameState.activity) {
        Write-Host "Available activities: $($global:GameState.activity)" -ForegroundColor Blue
        Write-Verbose "Displayed Available activities"
    }

    # Display the Progress property if not empty
    if ($global:GameState.Progress) {
        Write-Host "Progress: $($global:GameState.Progress)" -ForegroundColor Yellow
        Write-Verbose "Displayed Progress"
    }

    # Display the Inventory property if not empty
    if ($global:GameState.Inventory) {
        Write-Host "Inventory: $($global:GameState.Inventory -join ', ')" -ForegroundColor White
        Write-Verbose "Displayed Inventory"
    }

    # Display the ItemDescription property if not empty
    if ($global:GameState.ItemDescription) {
        Write-Host "Item Description: $($global:GameState.ItemDescription)" -ForegroundColor DarkCyan
        Write-Verbose "Displayed Item Description"
    }

    # Display the lastCommand property if not empty
    if ($global:GameState.lastCommand) {
        Write-Host "Last Command: $($global:GameState.lastCommand)" -ForegroundColor DarkYellow
        Write-Verbose "Displayed Last Command"
    }
}
