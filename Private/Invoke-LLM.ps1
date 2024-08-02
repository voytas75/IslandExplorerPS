function Invoke-LLM {
    [CmdletBinding()]
    param (
        [string]$prompt,
        [string]$model = "default", # Optional parameter to specify different models if needed
        [bool]$stream,
        [bool]$jsonmode = $true
    )

    if ([string]::IsNullOrWhiteSpace($prompt)) {
        $prompt = "response as JSON. JSON scheme {`"description`":`"[here is description]`"}"
    }
    Write-Verbose "Invoke-LLM function called with prompt: $prompt, model: $model, stream: $stream"

    # Placeholder for actual LLM integration
    switch ($model) {
        "default" { 
            Write-Verbose "Using default model"
            $response = Invoke-DefaultLLM $prompt -stream $stream -JSONMode $jsonmode
            Write-Verbose "Invoke-LLM function respond: $response"
            return $response
        }
        default { 
            Write-Verbose "Model not supported: $model"
            return "Model not supported." 
        }
    }
}