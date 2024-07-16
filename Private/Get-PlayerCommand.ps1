<#
.SYNOPSIS
    Prompts the player for a command input.

.DESCRIPTION
    This function displays a prompt to the player and reads their input from the console.
    It includes error handling and input validation to ensure robust execution.

.EXAMPLE
    PS C:\> Get-PlayerCommand
    > move north

.NOTES
    Author: Voytas75
    Date: 2024-07
#>
function Get-PlayerCommand {
    try {
        Write-Host -NoNewline "> "
        $userInput = Read-Host

        # Input validation: Ensure the input is not empty or null
        if ([string]::IsNullOrWhiteSpace($userInput)) {
            throw "Input cannot be empty. Please enter a valid command."
        }

        return $userInput
    }
    catch {
        Write-Error "An error occurred while reading the player command: $_"
        return $null
    }
}