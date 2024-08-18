function Invoke-GameCommand {
    [CmdletBinding()]
    param (
        [string]$command
    )
    
    Write-Verbose "Received command: $command"
    
    try {
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
                $respond = Get-GameItem -Command $command 
            }
            "pick*" {
                Write-Verbose "Executing 'pick' command"
                $respond = Get-GameItem -Command $command 
            }
            "explore*" { 
                Write-Verbose "Executing 'explore' command"
                $respond = Get-Explore -Command $command 
            }
            "inspect*" { 
                Write-Verbose "Executing 'inspect' command"
                $respond = Get-Explore -Command $command 
            }
            "examine*" { 
                Write-Verbose "Executing 'examine' command"
                $respond = Get-Explore -Command $command 
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
        "[activity 1]",
        "[activity n]"
    ],
    "other":"[here goes other]"
}
"@
                Write-Verbose "Generated prompt for LLM: $prompt"
                $respondJSON = Invoke-LLM -prompt $prompt
                Write-Verbose "Received JSON response from LLM: $respondJSON"
                $respond = $respondJSON | ConvertFrom-Json
                $global:GameState.Description = $respond.description
                $global:GameState.activity = $respond.available_activity
                $global:GameState.other = $respond.other
            }
        }
    }
    catch {
        Write-Error "An error occurred while processing the command: $_"
        return
    }

    Write-Verbose "GameState Description: $($global:GameState.Description)"
    Write-Verbose "GameState Location: $($global:GameState.Location)"
    Write-Verbose "GameState Ways: $($global:GameState.Ways -join ', ')"
    Write-Verbose "GameState Items: $($global:GameState.Items -join ', ')"
    Write-Verbose "GameState Activity: $($global:GameState.activity -join ', ')"
    Write-Verbose "GameState Other: $($global:GameState.other)"

    try {
        Add-GameHistoryEntry
        Write-Verbose "Added game history entry"
        Get-GameHistory
        Write-Verbose "Retrieved game history"
        Show-GameRespond $respond
        Write-Verbose "Displayed game response"
    }
    catch {
        Write-Error "An error occurred while updating game history or displaying the response: $_"
    }
}