# PowerShell script to download JSON and apply registry settings

# URL of the raw JSON file on GitHub
$jsonUrl = "https://raw.githubusercontent.com/jjonkers/defender-asr/refs/heads/main/regkeys.json"
$logFile = "registry_changes.log"

try {
    # Download and parse JSON content
    $registrySettings = Invoke-RestMethod -Uri $jsonUrl

    # Loop through each registry setting in the JSON
    foreach ($setting in $registrySettings) {
        try {
            # Check if registry path exists
            if (!(Test-Path $setting.path)) {
                New-Item -Path $setting.path -Force | Out-Null
                "$(Get-Date) - Created new registry path: $($setting.path)" | Add-Content $logFile
            }

            # Get current value if it exists
            $currentValue = $null
            try {
                $currentValue = Get-ItemProperty -Path $setting.path -Name $setting.name -ErrorAction SilentlyContinue
            }
            catch { }

            # Set the registry value
            Set-ItemProperty -Path $setting.path `
                            -Name $setting.name `
                            -Value $setting.value `
                            -Type $setting.type `
                            -Force

            if ($currentValue) {
                "$(Get-Date) - Updated existing value: $($setting.path)\$($setting.name) from $($currentValue.$($setting.name)) to $($setting.value)" | Add-Content $logFile
            }
            else {
                "$(Get-Date) - Created new value: $($setting.path)\$($setting.name) = $($setting.value)" | Add-Content $logFile
            }
        }
        catch {
            "$(Get-Date) - ERROR applying setting $($setting.path)\$($setting.name): $_" | Add-Content $logFile
            Write-Error "Failed to apply setting $($setting.path)\$($setting.name): $_"
        }
    }

    Write-Host "All registry settings applied successfully. Check $logFile for details."
}
catch {
    $errorMessage = "$(Get-Date) - ERROR: $_"
    $errorMessage | Add-Content $logFile
    Write-Error $errorMessage
}
