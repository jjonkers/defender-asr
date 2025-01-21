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

                "$(Get-Date) - Created new registry path: $($setting.path)"| Add-Content $logFile

            }



            # Get current value if it exists

            $currentValue = $null

            try {

                $currentValue = Get-ItemProperty -Path $setting.path -Name $setting.name -ErrorAction SilentlyContinue

            }

            catch { }



            # Set the registry value

            Set-ItemProperty -Path $setting.path 
