#Requires -Version 5.1
Throw "Les instructions doivent être exécutées en sélectionnant la ligne puis en appuyant sur F8"

$PSVersionTable

#######################################################################################################################
#                                                   ISE
#######################################################################################################################
# Récupérer la liste des raccourcis de l'ISE
# A EXÉCUTER DEPUIS L'ISE
$gps = $psISE.GetType().Assembly
$rm = New-Object -TypeName System.Resources.ResourceManager -ArgumentList @('GuiStrings',$gps)
$rm.GetResourceSet((Get-Culture),$True,$True) | Where-Object -Property Value -CMatch "(F\d)|(Shift\+)|(Alt\+)|(Ctrl\+)"

#######################################################################################################################
#                                  Politique d'exécution des scripts
#######################################################################################################################

Get-Help -Name about_Execution_Policies -ShowWindow

# Connaitre le niveau actuel de la politique d'exécution
Get-ExecutionPolicy

# Connaitre le niveau actuel de la politique d'exécution de chaque étendue 
Get-ExecutionPolicy -List

# Modifier la politique pour toutes les sessions lancées par l'utilisateur actuel à RemoteSigned
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force -Verbose


#######################################################################################################################
#                             Fournisseurs d'accès aux données (Providers)
#######################################################################################################################

Get-Help -Name about_Providers -ShowWindow

# Liste des providers
Get-PSProvider

# Liste des lecteurs PS
Get-PSDrive

Get-PSDrive -PSProvider Registry

#######################################################################################################################
#                                               Modules
#######################################################################################################################
# Liste des modules actuellement chargés 
Get-Module 

# Liste de tous les modules disponibles
Get-Module -ListAvailable

# Installation des modules Pester et PSScriptAnalyzer
Install-Module -Name Pester,PSScriptAnalyzer -Verbose

# Importation de modules
Import-Module -Name ActiveDirectory -Force -Verbose # Import du module pour Active Directory
Import-Module "C:\Program Files\Microsoft Deployment Toolkit\Bin\MicrosoftDeploymentToolkit.psd1" -Verbose # Import du module pour MDT


#######################################################################################################################
#                                             PROFIL POWERSHELL
#######################################################################################################################
<#
Le profil PowerShell est chargé lorsqu'une nouvelle session powershell.exe est lancée

La variable $profile correspond au chemin du profil de l'utilisateur actuel pour l'hôte actuel (console, ise, VSCode, ...)
Il existe 4 profils différents : 
    - $profile.AllUsersAllHosts : Profil utilisé pour tous les utilisateurs indépendamment de l'hôte (nécessite une élévation de droits)
    - $profile.AllUsersCurrentHost : Profil utilisé pour tous les utilisateurs sur l'hôte actuel (nécessite une élévation de droits)
    - $profile.CurrentUserAllHosts : Profil utilisé pour l'utilisateur actuel indépendamment de l'hôte
    - $profile.CurrentUserCurrentHost : Profil utilisé l'utilisateur actuel sur l'hôte actuel
#>
New-Item -Path $profile.CurrentUserAllHosts -ItemType File -Force -Verbose # Créé le script du profil utilisé pour l'utilisateur actuel indépendamment de l'hôte
ise $profile.CurrentUserAllHosts # Ouvre le script avec l'ISE

# Pour lancer une session powershell.exe sans utiliser de profil, il suffit d'ajouter le paramètre -NoProfile
# Cela permet de gagner quelques millisecondes/secondes
powershell.exe -NoProfile -File C:\temp\test.ps1

# Plus d'information sur les profils : https://devblogs.microsoft.com/powershell-community/how-to-make-use-of-powershell-profile-files/