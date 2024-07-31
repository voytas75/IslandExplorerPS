function Invoke-GameCommand {
    [CmdletBinding()]
    param (
        $command
    )
    
    Write-Verbose "Received command: $command"
    
    switch -Wildcard ($command) {
        "look*" { 
            Write-Verbose "Executing 'look' command"
            $respond = Get-LookAround -location $gameState.Location -Command $command
        }
        "move*" { 
            Write-Verbose "Executing 'move' command"
            Move-Player $command 
        }
        "go*" { 
            Write-Verbose "Executing 'go' command"
            Move-Player $command 
        }
        "take*" { 
            Write-Verbose "Executing 'take' command"
            get-Gameitem $command 
        }
        "pick*"{
            Write-Verbose "Executing 'pick' command"
            get-Gameitem $command 
        }
        "explore*" { 
            Write-Verbose "Executing 'explore' command"
            explore $command 
        }
        "inventory" { 
            Write-Verbose "Executing 'inventory' command"
            Show-Inventory 
        }
        "inv" { 
            Write-Verbose "Executing 'inv' command"
            Show-Inventory 
        }
        "help" { 
            Write-Verbose "Executing 'help' command"
            Show-Help 
        }
        default { 
            Write-Verbose "Executing default command"
            invoke-llm -prompt $command 
        }
    }
    Show-GameRespond $respond
}