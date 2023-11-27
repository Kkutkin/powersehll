function ConnectToPostgreSQL {
    param (
        [string]$Server,
        [string]$Database,
        [string]$Username,
        [string]$Password
    )

    try {
        # Importer le module Npgsql
        Import-Module -Name Npgsql

        # Paramètres de connexion
        $connectionString = "Server=$Server;Database=$Database;User ID=$Username;Password=$Password;"

        # Créer la connexion
        $connection = New-Object -TypeName Npgsql.NpgsqlConnection($connectionString)
        
        # Ouvrir la connexion
        $connection.Open()

        # Afficher un message si la connexion est établie avec succès
        Write-Host "Connexion à la base de données PostgreSQL établie avec succès."

        # Vous pouvez exécuter des requêtes ou d'autres opérations avec cette connexion ici

        # N'oubliez pas de fermer la connexion à la fin de vos opérations
        $connection.Close()
    }
    catch {
        Write-Host "Erreur lors de la connexion à la base de données PostgreSQL : $_.Exception.Message"
    }
}

# Exemple d'utilisation de la fonction en fournissant les informations de connexion
ConnectToPostgreSQL -Server "localhost" -Database "NomDeLaBase" -Username "Utilisateur" -Password "MotDePasse"
