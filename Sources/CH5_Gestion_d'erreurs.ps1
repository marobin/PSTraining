#Requires -Version 5.1
Throw "Les instructions doivent être exécutées en sélectionnant la ligne puis en appuyant sur F8"


#######################################################################################################################
#                                                Variable $Error
#######################################################################################################################
Get-Help about_Automatic_Variables -ShowWindow

$Error | Get-Member | Select-Object -ExpandProperty TypeName -Unique # Type [System.Management.Automation.ErrorRecord]
$Error | Get-Member

$Error.GetType().FullName # Type [System.Collections.ArrayList]

$Error.Count # Nombre d'erreurs enregistrées
$Error.Clear() # Supprime toutes les erreurs enregistrées
$Error.RemoveAt(0) # Supprime la dernière erreur enregistrée (index 0)

$Error[0].Exception.Message # Message d'erreur de la dernière erreur enregistrée


$Error | Format-List * -Force
$Error.InvocationInfo | Format-List *
$Exception = $Error.Exception
$Exception.InnerException

#######################################################################################################################
#                                             Try / Catch / Finally
#######################################################################################################################
Get-Help about_Try_Catch_Finally -ShowWindow

    # Exemple simple
try {
    1/0
}
catch {

    $_.Exception.Message # équivalent à $Error[0].Exception.Message
}


    # Exemple avec le type d'objet à catcher
try {
    Get-ChildItem -Path "C:\Windows\ServiceProfiles\LocalService" -ErrorAction Continue
    Get-Item -Path C:\temp\Toto -ErrorAction Stop
}
catch [System.UnauthorizedAccessException] {
    "Accès refusé : $($_.Exception.Message)"
}
catch [System.Management.Automation.ItemNotFoundException] {
    "Fichier introuvable : $($_.Exception.Message)"
}

    # Exemple avec le bloc Finally
<#
Les instructions du bloc Finally s'exécutent indépendamment du fait que le bloc Try rencontre une erreur de terminaison. 
PowerShell exécute le bloc Finally avant que le script ne se termine ou que le bloc actuel ne sorte de sa portée.

Peut être utile pour : 
 - Libérer les ressources utilisées par un script
 - Exécuter un bout de code même si CTRL+C est utilisé pour arrêter le script. 
 - Exécute du code également si un mot-clé Exit arrête le script à l'intérieur d'un bloc Catch. 
#>

try {
    
}
catch {
    
}
Finally {

}



#######################################################################################################################
#                                                   DEBUGGING
#######################################################################################################################




