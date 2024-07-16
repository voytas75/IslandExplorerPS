function explore {
    param ($command)

    # Extract the direction or action from the command
    $action = $command -replace "explore ", ""

    # Use LLM to generate the exploration description based on the current location and action
    $description = Invoke-LLM "The player is at $($global:gameState.Location) and wants to explore $action. Describe what they see, hear, and feel."

    # Output the generated description
    Write-Host $description -ForegroundColor Cyan
}
