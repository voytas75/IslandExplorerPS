function Get-PlayerCommand {
    Write-Host -NoNewline "> "
    $input = Read-Host
    return $input
}