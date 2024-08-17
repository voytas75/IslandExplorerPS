function Start-HTTPServer {
  $listener = New-Object System.Net.HttpListener
  $listener.Prefixes.Add("http://+:8082/")
  $listener.Start()
  Write-Host "Game server is running on http://localhost:8082/..."

  while ($listener.IsListening) {
    $context = $listener.GetContext()
    $request = $context.Request
    $response = $context.Response
    $html = ""

    if ($request.Url.AbsolutePath -eq "/") {
      # Serve the initial HTML form
      $html = @"
<!DOCTYPE html>
<html>
<body>
<h1>Island Explorer Game</h1>
<p>Current Location: $($global:GameState.Location)</p>
<p>Inventory: $($global:GameState.Inventory -join ", ")</p>
<p>Progress: $($global:GameState.Progress)</p>
<p>Description of Scene: $($global:GameState.Description)</p>
<form action="/command" method="get">
  <label for="command">Enter your command:</label><br><br>
  <input type="text" id="command" name="command" required><br><br>
  <input type="submit" value="Submit">
</form>
<p>Available Commands:</p>
<ul>
  <li><a href="/command?command=help">Help</a></li>
  <li><a href="/">Start New Game</a></li>
  <li><a href="/command?command=go north">Go North</a></li>
  <li><a href="/command?command=go south">Go South</a></li>
  <li><a href="/command?command=go east">Go East</a></li>
  <li><a href="/command?command=go west">Go West</a></li>
  <li><a href="/command?command=inventory">Inventory</a></li>
</ul>

</body>
</html>
"@
    }
    elseif ($request.Url.AbsolutePath -eq "/command") {
      # Process the command and respond with the result
      $command = $request.QueryString["command"]
      $global:GameState.lastCommand = $command
      $gameResponse = Invoke-GameCommand -Command $command
      if ($command -eq "help") {
        $htmlHelp = $global:GameState.Help
      }

      # Serve the result and the form again
      $html = @"
<!DOCTYPE html>
<html>
<body>
<h1>Island Explorer Game</h1>
<p>Current Location: $($global:GameState.Location)</p>
<p>Last Command: $($global:GameState.lastCommand)</p>
<p>Inventory: $($global:GameState.Inventory -join ", ")</p>
<p>Progress: $($global:GameState.Progress)</p>
<p>Description of Scene: $($global:GameState.Description)</p>
<p>Items in Location: $($global:GameState.Items -join ", ")</p>
<p>Item description: $($global:GameState.ItemDescription)</p>
<p>Activity: $($global:GameState.activity)</p>
<p>other: $($global:GameState.other)</p>
<form action="/command" method="get">
  <label for="command">Enter your command:</label><br><br>
  <input type="text" id="command" name="command" required><br><br>
  <input type="submit" value="Submit">
</form>
<p>Available Commands:</p>
<ul>
  <li><a href="/command?command=help">Help</a></li>
  <li><a href="/">Start New Game</a></li>
  <li><a href="/command?command=go north">Go North</a></li>
  <li><a href="/command?command=go south">Go South</a></li>
  <li><a href="/command?command=go east">Go East</a></li>
  <li><a href="/command?command=go west">Go West</a></li>
  <li><a href="/command?command=inventory">Inventory</a></li>
</ul>
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
  }
}

