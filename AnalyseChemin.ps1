Param(
    [Parameter(Mandatory=$true)]
    [string]$Chemin
)

# Fonction pour récupérer les permissions d'un dossier et ses sous-dossiers de manière récursive
Function Get-Permissions {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Path
    )

    # Récupérer les permissions du dossier actuel
    $acl = Get-Acl -Path $Path

    # Récupérer la liste des éléments dans le dossier
    $items = Get-ChildItem -Path $Path -Force

    # Boucle à travers chaque élément pour récupérer les permissions
    foreach ($item in $items) {
        # Vérifier s'il s'agit d'un dossier
        if ($item.PSIsContainer) {
            Get-Permissions -Path $item.FullName
        }

        # Écrire les informations sur les permissions dans un fichier CSV
        $itemPath = $item.FullName
        $permissions = $acl.Access | Select-Object @{Name='Chemin';Expression={$itemPath}}, IdentityReference, FileSystemRights, AccessControlType
        $permissions | Export-Csv -Path "permissions.csv" -Append -NoTypeInformation

        # Gérer les erreurs s'il y en a
        try {
            $acl | Out-Null
        } catch {
            $_.Exception.Message | Out-File -FilePath "erreurs.txt" -Append
        }
    }
}

# Appeler la fonction pour démarrer l'analyse des permissions
Get-Permissions -Path $Chemin
