function Invoke-GameCommand {
    [CmdletBinding()]
    param (
        $command
    )
    
    Write-Verbose "Received command: $command"
    
    switch -Wildcard ($command) {
        "look*" { 
            Write-Verbose "Executing 'look' command"
            $respond = Get-LookAround -location $global:gameState.Location -Command $command
        }
        "move*" { 
            Write-Verbose "Executing 'move' command"
            $respond = Move-Player -From $global:gameState.Location -Command $command 
        }
        "go*" { 
            Write-Verbose "Executing 'go' command"
            $respond = Move-Player -From $global:gameState.Location -Command $command 
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
        "inspect*" { 
            Write-Verbose "Executing 'inspect' command"
            $respond = get-explore $command 
        }
        "examine*" { 
            Write-Verbose "Executing 'examine' command"
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
            $respond = $global:GameState.Help 
        }
        default { 
            Write-Verbose "Executing default command"
            $prompt = @"
Based on user command '$command' response as JSON. JSON schema: 
{
    "description":"[here is description]",
    "available_activity":
        [
        "[acivity 1]".
        "[acivity n]".
    ],
    "other":"[here goes other]"
}
"@
      
            $respondJSON = invoke-llm -prompt $prompt
            $respond = $respondJSON | ConvertFrom-Json
        $global:GameState = @{
            Description = $respond.Description
            activity = @($respond.available_activity)
            other = $respond.other
        }
        }
    }
    Write-Verbose "GameState Description: $($global:GameState.Description)"
    Write-Verbose "GameState Location: $($global:GameState.Location)"
    Write-Verbose "GameState Ways: $($global:GameState.Ways -join ', ')"
    Write-Verbose "GameState Items: $($global:GameState.Items -join ', ')"
    Write-Verbose "GameState Activity: $($global:GameState.activity -join ', ')"
    Write-Verbose "GameState Other: $($global:GameState.other)"

    Add-GameHistoryEntry

    Show-GameRespond $respond
}