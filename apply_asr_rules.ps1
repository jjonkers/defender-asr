#Attack Surface Reduction Rules JSON File
$URL = "https://raw.githubusercontent.com/jjonkers/defender-asr/refs/heads/main/asr-rules"
#Convert ASR Rules from JSON
$ASRRules = (Invoke-WebRequest -Uri $URL -UseBasicParsing).Content | ConvertFrom-Json
foreach($Rule in $ASRRules){

    $ASRRuleName = $Rule.Name
    $ASRRuleGUID = $Rule.GUID
    $ASRRuleActions = $Rule.Status

    Write-Output -InputObject "Working on $ASRRuleName Setting the rule to  $ASRRuleActions"
    Add-MpPreference -AttackSurfaceReductionRules_Ids $Rule.GUID -AttackSurfaceReductionRules_Actions AuditMode

}
