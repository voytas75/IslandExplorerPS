function Invoke-Command {
    param ($command)
    
    switch -Wildcard ($command) {
        "look*" { Look-Around }
        "move*" { Move-Player $command }
        "go*" { Move-Player $command }
        "inventory" { Show-Inventory }
        "inv" { Show-Inventory }
        "help" { Show-Help }
        default { invoke-llm -prompt $command }
    }
}