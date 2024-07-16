function Invoke-Command {
    param ($command)
    
    switch -Wildcard ($command) {
        "look*" { Look-Around -location $gameState.Location }
        "move*" { Move-Player $command }
        "go*" { Move-Player $command }
        "take*" {take-item $command}
        "explore*" {explore $command}
        "inventory" { Show-Inventory }
        "inv" { Show-Inventory }
        "help" { Show-Help }
        default { invoke-llm -prompt $command }
    }
}