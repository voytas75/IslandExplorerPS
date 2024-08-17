# Define the script block with all necessary functions and logic
$scriptBlock = {
    # Dictionary to store game sessions
    $global:GameSessions = @{}

    # Function to start a new game
    function Start-NewGame {
        $sessionId = [System.Guid]::NewGuid().ToString()
        $global:GameSessions[$sessionId] = @{
            NumberToGuess = Get-Random -Minimum 1 -Maximum 10
            Attempts = 0
        }
        return $sessionId
    }

    # Function to process a guess
    function Process-Guess {
        param (
            [string]$sessionId,
            [int]$userGuess
        )

        if (-not $global:GameSessions.ContainsKey($sessionId)) {
            return "Invalid session. Please start a new game."
        }

        $gameState = $global:GameSessions[$sessionId]
        $gameState.Attempts++
        
        if ($userGuess -eq $gameState.NumberToGuess) {
            $response = "Congratulations! You guessed the number $($gameState.NumberToGuess) in $($gameState.Attempts) attempts!"
            $global:GameSessions.Remove($sessionId) # End the session
        } elseif ($userGuess -lt $gameState.NumberToGuess) {
            $response = "Too low! Try again."
        } else {
            $response = "Too high! Try again."
        }

        return $response
    }

    # HTTP server setup
    $listener = New-Object System.Net.HttpListener
    $listener.Prefixes.Add("http://+:8082/")
    $listener.Start()
    Write-Host "Game server is running on http://localhost:8082/..."

    while ($listener.IsListening) {
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response
        $sessionId = ""

        if ($request.Url.AbsolutePath -eq "/") {
            # Start a new game and serve the initial HTML form
            $sessionId = Start-NewGame
            $html = @"
<!DOCTYPE html>
<html>
<body>
<h1>Guess the Number Game</h1>
<form action="/guess" method="get">
  <label for="guess">Enter your guess (1-10):</label><br><br>
  <input type="hidden" name="sessionId" value="$sessionId">
  <input type="number" id="guess" name="guess" min="1" max="10" required><br><br>
  <input type="submit" value="Submit">
</form>
</body>
</html>
"@
        }
        elseif ($request.Url.AbsolutePath -eq "/guess") {
            # Process the guess and respond with the result
            $sessionId = $request.QueryString["sessionId"]
            $userGuess = [int]$request.QueryString["guess"]
            $gameResponse = Process-Guess -sessionId $sessionId -userGuess $userGuess

            # Serve the result and the form again (if the game is not over)
            if ($global:GameSessions.ContainsKey($sessionId)) {
                $html = @"
<!DOCTYPE html>
<html>
<body>
<h1>Guess the Number Game</h1>
<p>$gameResponse</p>
<form action="/guess" method="get">
  <label for="guess">Enter your guess (1-10):</label><br><br>
  <input type="hidden" name="sessionId" value="$sessionId">
  <input type="number" id="guess" name="guess" min="1" max="10" required><br><br>
  <input type="submit" value="Submit">
</form>
</body>
</html>
"@
            } else {
                $html = @"
<!DOCTYPE html>
<html>
<body>
<h1>Guess the Number Game</h1>
<p>$gameResponse</p>
<p><a href="/">Start a New Game</a></p>
</body>
</html>
"@
            }
        }

        # Send the response
        $buffer = [System.Text.Encoding]::UTF8.GetBytes($html)
        $response.ContentLength64 = $buffer.Length
        $response.OutputStream.Write($buffer, 0, $buffer.Length)
        $response.OutputStream.Close()
    }
}

# Start the HTTP server as a background job
$job = Start-Job -ScriptBlock $scriptBlock

# Output the job ID to track the server
$job.Id


# Display other job data
$jobs = Get-Job
foreach ($job in $jobs) {
    Write-Host "Job ID: $($job.Id)"
    Write-Host "Job Name: $($job.Name)"
    Write-Host "Job State: $($job.State)"
    Write-Host "Job HasMoreData: $($job.HasMoreData)"
    #Write-Host "Job Command: $($job.Command)"
    Write-Host "-----------------------------"
}

