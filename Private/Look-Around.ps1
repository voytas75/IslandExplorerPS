function Look-Around {
    $location = $global:gameState.Location
    $description = Invoke-LLM "Describe the surroundings at $location on a mysterious island."
    Write-Host $description
}