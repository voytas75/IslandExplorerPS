function take-item {
    param ($command)
    
    # Extract the item name from the command
    $item = $command -replace "take ", ""

    # Check if the item is already in the inventory
    if ($global:gameState.Inventory -contains $item) {
        Write-Host "You already have the $item." -ForegroundColor Yellow
        return
    }

    # Use LLM to determine if the item can be taken from the current location
    $canTakeItem = Invoke-LLM "Can the player take the $item from $($global:gameState.Location)? Answer yes or no."

    if ($canTakeItem -eq "yes") {
        # Add the item to the inventory
        $global:gameState.Inventory += $item
        Write-Host "You have taken the $item." -ForegroundColor Green
        $gameState.inventory += $item
    } else {
        Write-Host "You cannot take the $item from here." -ForegroundColor Red
    }
}
