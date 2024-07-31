function Show-GameRespond {
    param (
        [PSCustomObject]$respond
    )

    if ($null -eq $respond) {
        Write-Host "No response to display." -ForegroundColor Yellow
        return
    }

    if ($respond.PSObject.Properties.Match("Description").Count -gt 0) {
        Write-Host "Description: $($respond.Description)" -ForegroundColor Cyan
    }

    if ($respond.PSObject.Properties.Match("Location").Count -gt 0) {
        Write-Host "Location: $($respond.Location)" -ForegroundColor Green
    }

    if ($respond.PSObject.Properties.Match("Ways").Count -gt 0) {
        Write-Host "Ways to go: $($respond.Ways -join ", ")" -ForegroundColor Magenta
    }

    if ($respond.PSObject.Properties.Match("Items").Count -gt 0) {
        Write-Host "Items: $($respond.Items -join ", ")" -ForegroundColor Blue
    }
}
