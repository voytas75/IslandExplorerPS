function Invoke-LLM {
    [CmdletBinding()]
    param (
        [string]$prompt,
        [string]$model = "default", # Optional parameter to specify different models if needed
        [bool]$stream
    )

    Write-Verbose "Invoke-LLM function called with prompt: $prompt, model: $model, stream: $stream"

    # Placeholder for actual LLM integration
    switch ($model) {
        "default" { 
            Write-Verbose "Using default model"
            $response = Invoke-DefaultLLM $prompt -stream $stream
            Write-Verbose "Invoke-LLM function respond: $response"
            return $response
        }
        default { 
            Write-Verbose "Model not supported: $model"
            return "Model not supported." 
        }
    }
}