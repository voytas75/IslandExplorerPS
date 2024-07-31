function Invoke-DefaultLLM {
    param (
        $prompt,
        [bool]$stream
        )

    
    $SystemPrompt = Get-Content -Path (Join-Path -Path $script:ModulePath -ChildPath "Data\SPEngine.txt") -Raw
    $response = PSAOAI\Invoke-PSAOAIChatCompletion -SystemPrompt $SystemPrompt -usermessage $prompt -Mode Surreal -LogFolder $LogFolder -User "IEPSGame" -Stream $stream -simpleresponse -OneTimeUserPrompt -JSONMode
    
    return $response
}