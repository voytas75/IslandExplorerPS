function Invoke-DefaultLLM {
    param ($prompt)

    
    $SystemPrompt = Get-Content -Path (Join-Path -Path $script:ModulePath -ChildPath "Data\SPEngine.txt") -Raw
    $response = PSAOAI\Invoke-PSAOAIChatCompletion -SystemPrompt $SystemPrompt -usermessage $prompt -Mode Surreal -LogFolder $LogFolder -User "IEPSGame" -Stream $true -simpleresponse -OneTimeUserPrompt
    
    return $response
}