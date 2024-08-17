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
</body>
</html>
"@
        }
        elseif ($request.Url.AbsolutePath -eq "/command") {
            # Process the command and respond with the result
            $command = $request.QueryString["command"]
            $gameResponse = Invoke-GameCommand -Command $command

            # Serve the result and the form again
            $html = @"
<!DOCTYPE html>
<html>
<body>
<h1>Island Explorer Game</h1>
<p>$gameResponse</p>
<p>Current Location: $($global:GameState.Location)</p>
<p>Inventory: $($global:GameState.Inventory -join ", ")</p>
<p>Progress: $($global:GameState.Progress)</p>
<p>Description of Scene: $($gameResponse.Description)</p>
<form action="/command" method="get">
  <label for="command">Enter your command:</label><br><br>
  <input type="text" id="command" name="command" required><br><br>
  <input type="submit" value="Submit">
</form>
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

