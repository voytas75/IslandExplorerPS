function Start-IEPSGame {
    param()
    
    # Initial Game State
    $global:gameState = @{
        Location  = "Beach"
        Inventory = @()
        Progress  = "Start"
    }

    Show-Introduction

    # Game Loop
    while ($true) {
        $command = Get-PlayerCommand
        Invoke-Command $command
    }
}
