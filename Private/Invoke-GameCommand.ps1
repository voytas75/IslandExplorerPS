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
            $respond = Move-Player -From $gameState.Location -Command $command 
        }
        "go*" { 
            Write-Verbose "Executing 'go' command"
            $respond = Move-Player -From $gameState.Location -Command $command 
        }
        "take*" { 
            Write-Verbose "Executing 'take' command"
            $respond = get-Gameitem $command 
        }
        "pick*"{
            Write-Verbose "Executing 'pick' command"
            $respond = get-Gameitem $command 
        }
        "explore*" { 
            Write-Verbose "Executing 'explore' command"
            $respond = get-explore $command 
        }
        "inventory" { 
            Write-Verbose "Executing 'inventory' command"
            $respond = Show-Inventory 
        }
        "inv" { 
            Write-Verbose "Executing 'inv' command"
            $respond = Show-Inventory 
        }
        "help" { 
            Write-Verbose "Executing 'help' command"
            Show-Help 
        }
        default { 
            Write-Verbose "Executing default command"
            $prompt = "Based on user command '$command' response as JSON. JSON scheme {`"description`":`"[here is description]`",`"available_activity`":`"[here goes available activity name]`",`"other`":`"[here goes other]`"}"
      
            $respondJSON = invoke-llm -prompt $prompt
            $respond = $respondJSON | ConvertFrom-Json
        }
    }
    Show-GameRespond $respond
}