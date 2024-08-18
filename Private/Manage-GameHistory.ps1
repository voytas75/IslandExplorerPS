# Function to initialize the game history
function Initialize-GameHistory {
    # Initialize GameHistory as an array of hashtables
    $global:GameHistory = @(
        @{
            Timestamp   = (Get-Date)  # Current date and time
            Command     = ""            # Command issued by the player
            Result      = ""             # Result of the command
            Location    = ""           # Player's location at the time of the command
            Inventory   = @()         # Player's inventory at the time of the command
            Description = ""        # Description of the scene at the time of the command
        }
    )
    # To add a new element to GameHistory, use the following syntax:
    # $global:GameHistory += @{
    #     Timestamp = (Get-Date)
    #     Command = "new command"
    #     Result = "result of the command"
    #     Location = "new location"
    #     Inventory = @("item1", "item2")
    #     Description = "new description"
    # }    
}

# Function to add an entry to the game history
function Add-GameHistoryEntry {
    $entry = @{
        Timestamp   = (Get-Date)
        Command     = $global:GameState.lastCommand
        Result      = $global:GameState.Description
        Location    = $global:GameState.Location
        Inventory   = $global:GameState.Inventory
        Description = $global:GameState.Description
    }

    $global:GameHistory += $entry
}

# Function to get the game history
function Get-GameHistory {
    return $global:GameHistory
}