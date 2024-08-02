function Show-GameRespond {
    [CmdletBinding()]
    param (
        [PSCustomObject]$respond
    )

    # Check if the response object is null
    if ($null -eq $respond) {
        Write-Host "No response to display." -ForegroundColor Yellow
        Write-Verbose "The provided response object is null."
        return
    }

    # Check and display the Description property if it exists
    if ($respond.PSObject.Properties.Match("Description").Count -gt 0) {
        Write-Host "Description: $($respond.Description)" -ForegroundColor Cyan
        Write-Verbose "Displayed Description: $($respond.Description)"
    } else {
        Write-Verbose "Description property not found in the response object."
    }

    # Check and display the other property if it exists
    if ($respond.PSObject.Properties.Match("other").Count -gt 0) {
        Write-Host "$($respond.other)" -ForegroundColor Cyan
        Write-Verbose "Displayed other: $($respond.other)"
    } else {
        Write-Verbose "Other property not found in the response object."
    }

    # Check and display the Location property if it exists
    if ($respond.PSObject.Properties.Match("Location").Count -gt 0) {
        Write-Host "Location: $($respond.Location)" -ForegroundColor Green
        Write-Verbose "Displayed Location: $($respond.Location)"
    } else {
        Write-Verbose "Location property not found in the response object."
    }

    # Check and display the Ways property if it exists
    if ($respond.PSObject.Properties.Match("Ways").Count -gt 0) {
        Write-Host "Ways to go: $($respond.Ways -join ", ")" -ForegroundColor Magenta
        Write-Verbose "Displayed Ways: $($respond.Ways -join ", ")"
    } else {
        Write-Verbose "Ways property not found in the response object."
    }

    # Check and display the Items property if it exists
    if ($respond.PSObject.Properties.Match("Items").Count -gt 0) {
        Write-Host "Items: $($respond.Items -join ", ")" -ForegroundColor Blue
        Write-Verbose "Displayed Items: $($respond.Items -join ", ")"
    } else {
        Write-Verbose "Items property not found in the response object."
    }

    # Check and display the available_activity property if it exists
    if ($respond.PSObject.Properties.Match("available_activity").Count -gt 0) {
        Write-Host "Available activities: $($respond.available_activity)" -ForegroundColor Blue
        Write-Verbose "Displayed Available activities: $($respond.available_activity)"
    } else {
        Write-Verbose "Available activities property not found in the response object."
    }
}
