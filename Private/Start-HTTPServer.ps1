function Start-HTTPServer {
  [CmdletBinding()]
  param()

  try {
    # Initialize the HTTP listener
    $listener = New-Object System.Net.HttpListener
    $listener.Prefixes.Add("http://+:8082/")
    $listener.Start()
    Write-Host "Game server is running on http://localhost:8082/..."
    Write-Verbose "HTTP listener started and listening on port 8082."

    while ($listener.IsListening) {
      try {
        # Get the context and request
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response
        $html = ""

        if ($request.Url.AbsolutePath -eq "/") {
          Write-Verbose "Serving initial HTML form."
          # Serve the initial HTML form
          $html = @"
<!DOCTYPE html>
<html>
<body>
<h1>Island Explorer Game</h1>
<p>Description of Scene: $($global:GameState.Description)</p>
<p>Current Location: $($global:GameState.Location)</p>
<p>Inventory: $($global:GameState.Inventory -join ", ")</p>
<p>Progress: $($global:GameState.Progress)</p>
<form action="/command" method="get">
  <label for="command">Enter your command:</label><br><br>
  <input type="text" id="command" name="command" required><br><br>
  <input type="submit" value="Submit">
</form>
<i>
<p>Available Commands:</p>
<ul>
  <li><a href="/command?command=look around">Look around</a></li>
  <li><a href="/command?command=go north">Go North</a></li>
  <li><a href="/command?command=go south">Go South</a></li>
  <li><a href="/command?command=go east">Go East</a></li>
  <li><a href="/command?command=go west">Go West</a></li>
  <li><a href="/command?command=inventory">Inventory</a></li>
  <li><a href="/command?command=help">Help</a></li>
</ul>
</i>
</body>
</html>
"@
        }
        elseif ($request.Url.AbsolutePath -eq "/command") {
          Write-Verbose "Processing command from URL."
          # Process the command and respond with the result
          $command = $request.QueryString["command"]
          $global:GameState.lastCommand = $command
          Invoke-GameCommand -Command $command
          Write-Verbose "Game command invoked: $command"

          if ($command -eq "help") {
            $htmlHelp = $global:GameState.Help
            Write-Verbose "Help content: $htmlHelp"
          }
          $activityLinks = "<i>no actions</i>"
          if ($global:GameState.activity) {
            $activityLinks = $global:GameState.activity | ForEach-Object { "<li><a href='/command?command=$($_)'>$($_)</a></li>" } 
          }

          # Serve the result and the form again
          $html = @"
<!DOCTYPE html>
<html>
<body>
<h1>Island Explorer Game</h1>
<p>Description of Scene: <b> $($global:GameState.Description)</b></p>
<p>Others: $($global:GameState.other)</p>
<p>Current Location: $($global:GameState.Location)</p>
<p>Last Command: $($global:GameState.lastCommand)</p>
<p>Inventory: $($global:GameState.Inventory -join ", ")</p>
<p>Progress: $($global:GameState.Progress)</p>
<p>Items in Location: $($global:GameState.Items -join ", ")</p>
<p>Item description: $($global:GameState.ItemDescription)</p>
<p>Activities: 
  <ul>
    $activityLinks
  </ul>
</p>
<form action="/command" method="get">
  <label for="command">Enter your command:</label><br><br>
  <input type="text" id="command" name="command" required><br><br>
  <input type="submit" value="Submit">
</form>
<i>
<p>Available Commands:</p>
<ul>
  <li><a href="/command?command=look around">Look around</a></li>
  <li><a href="/command?command=go north">Go North</a></li>
  <li><a href="/command?command=go south">Go South</a></li>
  <li><a href="/command?command=go east">Go East</a></li>
  <li><a href="/command?command=go west">Go West</a></li>
  <li><a href="/command?command=inventory">Inventory</a></li>
  <li><a href="/command?command=help">Help</a></li>
</ul>
</i>
$htmlHelp
</body>
</html>
"@
        }

        # Send the response
        $buffer = [System.Text.Encoding]::UTF8.GetBytes($html)
        $response.ContentLength64 = $buffer.Length
        $response.OutputStream.Write($buffer, 0, $buffer.Length)
        $response.OutputStream.Close()
        Write-Verbose "Response sent to client."
      }
      catch {
        Write-Error "An error occurred while processing the request: $_"
      }
    }
  }
  catch {
    Write-Error "An error occurred while starting the HTTP server: $_"
  }
  finally {
    if ($listener -and $listener.IsListening) {
      $listener.Stop()
      Write-Verbose "HTTP listener stopped."
    }
  }
}
