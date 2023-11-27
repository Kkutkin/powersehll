# Récupère la configuration AppLocker
$appLockerPolicy = Get-AppLockerPolicy -Effective | Select-Object -ExpandProperty RuleCollections

# Convertit la configuration AppLocker en un format exploitable pour CSV
$result = @()
foreach ($ruleCollection in $appLockerPolicy) {
    $rules = $ruleCollection.Rules
    foreach ($rule in $rules) {
        $result += [PSCustomObject]@{
            'Action' = $rule.Action
            'RuleName' = $rule.Name
            'RuleType' = $rule.RuleType
            'UserOrGroup' = $rule.UserOrGroup
            'Conditions' = $rule.Conditions -join ";"
            'Exceptions' = $rule.Exceptions -join ";"
            'FilePath' = $rule.FilePath
        }
    }
}

# Exporte le résultat dans un fichier CSV
$result | Export-Csv -Path "AppLocker_Configuration.csv" -NoTypeInformation
