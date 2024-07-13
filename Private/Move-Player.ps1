function Move-Player {
    param ($command)
    
    $direction = $command -replace "move ", ""
    $newLocation = Invoke-LLM "If the player moves $direction from $($global:gameState.Location), where do they end up on the island?"
    
    if ($newLocation -ne $global:gameState.Location) {
        $global:gameState.Location = $newLocation
        Write-Host "You move $direction to $newLocation."
        Look-Around
    } else {
        Write-Host "You can't move in that direction."
    }
}