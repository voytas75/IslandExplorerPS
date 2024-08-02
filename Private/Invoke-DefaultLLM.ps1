function Invoke-DefaultLLM {
    [CmdletBinding()]
    param (
        [string]$prompt,  # User prompt to be sent to the LLM
        [bool]$stream,    # Flag to enable or disable streaming
        [bool]$jsonmode   # Flag to enable or disable JSON mode
    )

    # Verbose message indicating the start of the function
    Write-Verbose "Starting Invoke-DefaultLLM function with prompt: $prompt, stream: $stream, jsonmode: $jsonmode"

    # Construct the path to the system prompt file
    $systemPromptPath = Join-Path -Path $script:ModulePath -ChildPath "Data\SPEngine.txt"
    Write-Verbose "System prompt path: $systemPromptPath"

    # Read the system prompt from the file
    try {
        $SystemPrompt = Get-Content -Path $systemPromptPath -Raw
        Write-Verbose "Successfully read system prompt from file."
    }
    catch {
        Write-Error "Failed to read system prompt from file: $_"
        return
    }

    # Invoke the PSAOAIChatCompletion function with the provided parameters
    try {
        $response = PSAOAI\Invoke-PSAOAIChatCompletion `
            -SystemPrompt $SystemPrompt `
            -usermessage $prompt `
            -Mode Surreal `
            -LogFolder $LogFolder `
            -User "IEPSGame" `
            -Stream $stream `
            -simpleresponse `
            -OneTimeUserPrompt `
            -JSONMode:$jsonmode
        Write-Verbose "Received response from PSAOAIChatCompletion."
    }
    catch {
        Write-Error "Failed to invoke PSAOAIChatCompletion: $_"
        return
    }

    # Return the response
    Write-Verbose "Returning response from Invoke-DefaultLLM function."
    return $response
}