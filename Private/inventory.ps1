# Function to Add Item to Inventory
function Add-ToInventory {
    param ($item)
    
    if (-not $global:gameState.Inventory.Contains($item)) {
        $global:gameState.Inventory += $item
        Write-Host "$item has been added to your inventory."
    } else {
        Write-Host "You already have $item in your inventory."
    }
}

# Function to Remove Item from Inventory
function Remove-FromInventory {
    param ($item)
    
    if ($global:gameState.Inventory.Contains($item)) {
        $global:gameState.Inventory = $global:gameState.Inventory | Where-Object { $_ -ne $item }
        Write-Host "$item has been removed from your inventory."
    } else {
        Write-Host "You don't have $item in your inventory."
    }
}

# Function to Show Inventory
function Show-Inventory {
    if ($global:gameState.Inventory.Count -eq 0) {
        Write-Host "Your inventory is empty."
    } else {
        Write-Host "Your inventory contains: $($global:gameState.Inventory -join ', ')"
    }
}
