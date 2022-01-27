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

# Types d'exceptions
[appdomain]::CurrentDomain.GetAssemblies() |
ForEach-Object {
    Try {
        $_.GetExportedTypes() |
            Where-Object -Property FullName -Match 'Exception'
    }
    Catch {}
} | 
Select-Object -Property @{Label = 'Namespace'; Expression = {$_.Namespace -replace '^System\.'}},
                        Name,
                        @{Label = 'FullName'; Expression = {$_.fullname -replace '^System\.'}},
                        @{Label = 'HelpUri'; Expression = {"https://docs.microsoft.com/en-us/dotnet/api/$($_.FullName)?view=netframework-4.8"}} |
Out-GridView -OutputMode Multiple



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

#https://docs.microsoft.com/en-us/powershell/scripting/windows-powershell/ise/how-to-debug-scripts-in-windows-powershell-ise?view=powershell-5.1


# Cmdlet de debug dans l'ISE
Get-Command -Noun 'PSBreakpoint'

# Entrer dans le debugger lorsque la variable index dans le script CH5-3_Debugger est modifiée
Set-PSBreakpoint -Script 'E:\_GIT\PSTraining\Sources\CH5-3_Debugger.ps1' -Variable 'index' -Verbose

Set-PSBreakpoint -Script 'E:\_GIT\PSTraining\Sources\CH5-3_Debugger.ps1' -Line 5,11 -Verbose


# Modifier un script pour ajouter un arrêt
Wait-Debugger



# Transcription
Start-Transcript -Path 'C:\temp\Transcript.txt' -Force -Append -IncludeInvocationHeader -Verbose

    # ... Instructions à logger ...

Stop-Transcript


# Transcription automatique
# REGISTRE : https://adamtheautomator.com/powershell-logging-2/
# GPO : https://sid-500.com/2017/11/07/powershell-enabling-transcription-logging-by-using-group-policy/

    # Activer la transcription automatique
$KeyPath = "HKLM:\Software\Policies\Microsoft\Windows\PowerShell\Transcription"
$OutputDirectory = "$env:ALLUSERSPROFILE\PSTranscript"

If (! (Test-Path -Path $KeyPath)) {
    New-Item -Path $KeyPath -Force -Verbose   
}

New-ItemProperty -Path $KeyPath -Name 'EnableTranscripting' -PropertyType 'Dword' -Value 1 -Force -Verbose
New-ItemProperty -Path $KeyPath -Name 'OutputDirectory' -PropertyType 'String' -Value $OutputDirectory -Force -Verbose
New-ItemProperty -Path $KeyPath -Name 'EnableInvocationHeader' -PropertyType 'Dword' -Value 1 -Force -Verbose

    # Désactiver la transcription
Remove-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\PowerShell\Transcription" -Force -Recurse -Verbose
Remove-Item -Path "$env:ALLUSERSPROFILE\PSTranscript" -Recurse -Force -Verbose