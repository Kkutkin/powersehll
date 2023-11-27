function AnalyserServicesNonDesactives {
    param (
        [string]$FichierErreurs,
        [string]$FichierCSV
    )

    # Récupérer tous les services
    $services = Get-CimInstance -ClassName Win32_Service | Where-Object { $_.StartMode -ne 'Disabled' }

    # Créer une liste pour stocker les détails des services non désactivés
    $detailsServices = @()

    # Boucle à travers tous les services pour vérifier le mode de démarrage
    foreach ($service in $services) {
        $detailsServices += [PSCustomObject]@{
            'Nom du service' = $service.Name
            'Description' = $service.DisplayName
            'Type de démarrage' = $service.StartMode
            'Statut' = $service.State
            'Nom du fichier exécutable' = $service.PathName
            'Compte d\'exécution' = $service.StartName
        }
    }

    # Exporter les détails des services dans un fichier CSV
    $detailsServices | Export-Csv -Path $FichierCSV -NoTypeInformation

    # Vérifier les services avec un démarrage différent de "Désactivé" et enregistrer les erreurs
    $servicesNonDesactives = $services | Where-Object { $_.StartMode -ne 'Disabled' }
    if ($servicesNonDesactives) {
        "Services non désactivés : $($servicesNonDesactives.Count)" | Out-File -FilePath $FichierErreurs -Append
        $servicesNonDesactives | ForEach-Object { "`t$($_.Name) - $($_.DisplayName)" | Out-File -FilePath $FichierErreurs -Append }
    } else {
        "Aucun service trouvé avec un démarrage différent de 'Désactivé'" | Out-File -FilePath $FichierErreurs -Append
    }
}

# Exemple d'utilisation de la fonction avec les noms de fichiers spécifiés
AnalyserServicesNonDesactives -FichierErreurs "ErreursServices.txt" -FichierCSV "DetailsServices.csv"
