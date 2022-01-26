#Requires -Version 5.1
Throw "Les instructions doivent être exécutées en sélectionnant la ligne puis en appuyant sur F8"

#######################################################################################################################
#                                              TYPES DE COMMANDES
#######################################################################################################################
# Obtenir la liste des cmdlets
Get-Command -CommandType Cmdlet
# Obtenir la liste des fonctions
Get-Command -CommandType Function
# Obtenir la liste des alias
Get-Command -CommandType Alias

#######################################################################################################################
#                                                GET-COMMAND
#######################################################################################################################
<#
Get-Command permet de découvrir les commandes disponibles.
#>

Get-Command -Verb 'Get' # Liste toutes les commandes ayant pour verbe Get (commandes retournant une information)
Get-Command -Module 'BitLocker' # Liste toutes les commandes du module BitLocker
Get-Command -Module ActiveDirectory -Verb Get # Liste toutes les commandes du module ActiveDirectory qui permettent de récupérer une information
Get-Command -Noun 'process' # Liste toutes les commandes dont le nom est 'Process' (après le tiret)
Get-Command -Name '*event*' # Liste toutes les commandes dont le nom complet comprend 'event'
Get-Command -ParameterType ServiceController # Liste toutes les commandes ayant un paramètre de type ServiceController

Get-Command -Name Get-Service -Syntax # Liste la(les) syntaxe(s) de la commande


#######################################################################################################################
#                                                   CMDLETS
#######################################################################################################################

Get-Help about_Command_Syntax -ShowWindow
Get-Help about_CommonParameters -ShowWindow

# ParameterSet
Get-Process 'powershell' # Equivalent à "Get-Process -Name powershell" car le nom du paramètre Name est optionnel (CE N'EST PAS UNE BONNE PRATIQUE)
Get-Process -Name 'powershell' -FileVersionInfo # Utilise le switch FileVersionInfo
Get-Process -Name 'powershell' -Id $PID # Renverra une erreur car les paramètres Name et Id ne peuvent pas être utilisés ensemble

#######################################################################################################################
#                                                  FONCTIONS
#######################################################################################################################
Function Get-VolumeItem ([char]$Volume)
{
    Get-ChildItem -Name "$($Volume):\"
}
Get-VolumeItem -Volume 'C'

#######################################################################################################################
#                                                   ALIAS
#######################################################################################################################
# Liste des alias
Get-Alias

# Liste les alias d'une commande 
Get-Alias -Definition 'Get-ChildItem'

# Attention à ne pas utiliser d'alias dans un script sous peine de rendre celui-ci difficile à lire
    # Exemple avec alias :
gci c:\windows\temp -rec -ex 'toto' -fo -ea ig | ? {gc $_.FullName -ea ig | sls 'test'}
    # Même commande sans alias, plus longue mais moins compliquée à lire
Get-ChildItem -Path 'c:\windows\temp' -Recurse -Exclude 'toto' -Force -ErrorAction Ignore | 
Where-Object {
    Get-Content -Path $_.FullName -ErrorAction Ignore | 
    Select-String -Pattern 'test'
}

# Créer un nouvel alias
New-Alias -Name 'list' -Value 'Get-ChildItem' -Description "Liste les dossiers/fichiers présents dans le répertoire actuel" -Verbose -Force

# Exporter des alias
Export-Alias -Name 'list' -Path 'C:\temp\alias.csv' -As Csv -Force -Verbose

# Importer des alias
Import-Alias -Path C:\Temp\alias.csv -Force -Verbose

# Il n'est pas possible de créer des alias avec paramètre en PowerShell, on doit donc créer un alias de fonction
New-Alias -Name 'list' -Value 'Get-VolumeItem' -Description "Liste les dossiers présents sur le volume passé en paramètre" -Verbose -Force



#######################################################################################################################
#                                                   AIDE
#######################################################################################################################
# 4 cmdlets importantes :
Get-Help # Affiche l'aide liée à une commande (CmdLet, fonction, script, ...)
Get-Verb # Liste les verbes approuvés pour les commandes
Get-Command # Liste les commandes disponibles 
Get-Member # Liste le type, les propriétés et les méthodes d'un objet

# Mettre à jour les fichiers d'aide 
Update-Help -Force


# Aide sur le système d'aide
Get-Help
Get-Help -Name Get-Help -ShowWindow
# Liste les fichiers d'aide sur les rubriques (About Topics)
# https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about?view=powershell-5.1
Get-Help -Name about_* 

# Utilisation du wildcard pour lister les commandes dont le nom comporte un sujet précis : 
Get-Help -Name '*process*'


# Autres paramètres utiles de Get-Help
Get-Help -Name Get-Command -Full # Affiche l'aide complète
Get-Help -Name Get-Command -Detailed # Affiche l'aide détaillée (Description + exemples en plus de l'aide de base)
Get-Help -Name Get-Command -Examples # Affiche des exemples d'utilisation de la commande
Get-Help -Name Get-Command -Online # Affiche la page d'aide en ligne de la commande 
Get-Help -Name Get-Command -Parameter Name # Affiche une description du paramètre Name de la commande
Get-Help -Name Get-Command -ShowWindow # Affiche l'aide dans une fenêtre à part

Get-Help -Name about_Parameters -ShowWindow # Affiche l'aide en lien avec les paramètres de commandes
Get-Help -Name about_CommonParameters -ShowWindow # Affiche l'aide en lien avec les paramètres communs de commandes



#######################################################################################################################
#                                                PIPELINE
#######################################################################################################################
Get-Help -Name about_Pipelines -ShowWindow

# Exemple d'utilisation
@(1,2,3) | Measure-Object
@(1,2,3) | Measure-Object -Sum
ipconfig.exe | Select-String -Pattern 'IPv4'

# Utilisation du wildcard pour récupérer l'aide sur tous les paramètres d'une commande
Get-Help -Name 'Start-Service' -Parameter * # Quels paramètres acceptent des valeurs du pipeline?
Get-Service | Get-Member -MemberType Properties # Quelles propriétés sont renvoyées par la commande à gauche?
Get-Help -Name 'Get-Service' -Parameter Name # Est-ce qu'une propriété du même nom que celles acceptées par la commande de droite existe?

# Possible de chainer un grand nombre de commandes
Get-Service | 
    Select-Object Name,DisplayName,Status,StartType | 
    Where-Object -Property Status -eq Running | 
    Sort-Object -Property StartType | 
    Export-Csv -Path c:\temp\services.csv -NoTypeInformation


# Apprendre une nouvelle commande de façon aléatoire
Get-Command -Module Microsoft*,Cim*,PS* | Get-Random | Get-Help -ShowWindow
# Apprendre une nouvelle rubrique de façon aléatoire
Get-Random -InputObject (Get-Help about*) | Get-Help -ShowWindow

#######################################################################################################################
#                                           Qu'est-ce qu'un objet?
#######################################################################################################################

# https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_objects?view=powershell-5.1
# https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_methods?view=powershell-5.1
# https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_properties?view=powershell-5.1

Get-Help about_Objects -ShowWindow
Get-Help about_Methods -ShowWindow
Get-Help about_Properties -ShowWindow
Get-Help about_Type_Accelerators -ShowWindow


[PSObject].Assembly.GetType('System.Management.Automation.TypeAccelerators')::Get.GetEnumerator() |
    Sort-Object -Property Key |
    Format-Table -AutoSize

#######################################################################################################################
#                                                Type d'objet
#######################################################################################################################

Get-Help -Name ABOUT_TYPE_ACCELERATORS -ShowWindow

[String]$string = 'toto' # Chaine de caractères
[int]$number = 10 # Entier
[double]$double = 10.232 # Decimal
[char]$char = 'c' # Caractère
[array]$array = @(1,'a',2,'b',3,'c') # Tableau
[datetime]$DateTime = Get-Date # Date et heure


<#
Get-Member permet de découvrir les propriétés, les méthodes et le type d'un objet retourné par une commande
#>

Get-Help -Name Get-Member -ShowWindow

Get-Process | Get-Member
Get-ChildItem -Path 'C:\Windows' | Get-Member
'test' | Get-Member

Get-Process | Get-Member -MemberType Properties
Get-Process | Get-Member -MemberType Methods

# Pour que Get-Member puisse fonctionner, la commande doit produire un objet et le retourner sur la sortie standard.
'Ceci est une chaine de caractères' | Get-Member
Write-Host 'Ceci est une chaine de caractères' | Get-Member

# Exemple avec Active Directory
Get-ADUser -Identity 'Michel' | Get-Member
Get-ADUser -Identity 'Michel' -Properties * | Get-Member
Get-ADUser -Identity 'Michel' -Properties LastLogonDate, LastBadPasswordAttempt | Get-Member

<# 
    La méthode .GetType() permet de récupérer le type d'un objet
#>

'ceci est un texte'.GetType()
(Get-Date).GetType()
(Get-Item -Path C:\Users).GetType()
(Get-Item -Path C:\pagefile.sys -Force).GetType()
(Get-Item -Path 'HKLM:\SOFTWARE').GetType()


(42).Gettype()
@('a','b','c').GetType()

$Var = 42
$Var.GetType()

# Certains objets retourne une collection d'objet mais pas leur type réel
$ProcessList = Get-Process
$ProcessList.GetType()

# Il faut alors utiliser un index ou Get-Member
$ProcessList[0].GetType()
$ProcessList[0].GetType().FullName

Get-Process | Get-Member | Select-Object -ExpandProperty TypeName -Unique

#######################################################################################################################
#                                              SELECT-OBJECT
#######################################################################################################################
Get-Help -Name Select-Object -ShowWindow

Get-ChildItem -Path C:\Users | Select-Object -Property Name,LastWriteTime

# Sélection d'une seule propriété
	Get-ChildItem -Path C:\Users | Select-Object -ExpandProperty Name
	(Get-ChildItem -Path C:\Users).Name

# Sélection des 2 premiers objets 
Get-ChildItem -Path C:\Users | Select-Object -Property Name,LastWriteTime -First 2

# Utilisation du wildcard
Get-Service -Name w32time | Select-Object -Property *
Get-Service -Name w32time | Select-Object -Property Status, DisplayName, Can*

#######################################################################################################################
#                                              WHERE-OBJECT
#######################################################################################################################
Get-Help -Name Where-Object -ShowWindow

Get-ChildItem -Path 'C:\Users' | Where-Object -Property Name -EQ -Value psuser
Get-ChildItem -Path 'C:\Users' | Where-Object {$_.Name -eq 'psuser'}

Get-ChildItem -Path 'C:\Users' | Where-Object {($_.Name -eq 'psuser') -and ($_.LastWriteTime -lt (Get-Date).AddHours(-2))}

Get-ChildItem -Path 'C:\Users' | Select-Object -ExpandProperty Name | Where-Object {$_.Length -gt 4}
Get-ChildItem -Path 'C:\Users' | Select-Object -ExpandProperty Name | Where-Object {$_ -match 'user'}

#######################################################################################################################
#                                              ForEach-OBJECT
#######################################################################################################################
Get-Help -Name ForEach-Object -ShowWindow


Get-ChildItem -Path 'C:\Users' | ForEach-Object {"Le profil $($_.Name) a été créé le $($_.CreationTime)"}

# Utilisation des paramètre Begin et End
Get-ChildItem -Path 'C:\Users' | 
    ForEach-Object -Begin {"Lancement du traitement"} -Process {"Le profil $($_.Name) a été créé le $($_.CreationTime)"} -End {"Fin du traitement"}

Get-ChildItem -Path 'C:\Users' | 
    ForEach-Object -Begin {$index = 0} -Process {"Le profil $($_.Name) a été créé le $($_.CreationTime)"; $index++} -End {"Nombre de profils : $index"}
