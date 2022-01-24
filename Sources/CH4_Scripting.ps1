#Requires -Version 5.1
Throw "Les instructions doivent être exécutées en sélectionnant la ligne puis en appuyant sur F8"


#######################################################################################################################
#                                                VARIABLES
#######################################################################################################################

Get-Help about_Variables -ShowWindow
Get-Help about_Automatic_Variables -ShowWindow
Get-Help about_Preference_Variables -ShowWindow

# Liste des variables disponibles au lancement d'une session PowerShell
Get-ChildItem -Path 'variable:'
Get-Variable

# Une variable non déclarée vaudra $null avant d'être modifiée
$null -eq $inexistant

[string]$var1 = 'valeur'

# Assigner plusieurs variables avec une seule déclaration
$a = $b = $c = 0 # $a, $b et $c valent 0
$i , $j , $k = 10, "red", $true # $i vaut 10, $j vaut "red" et $k vaut $true
$i , $j = 10, "red", $true # $i vaut 10 et $j est un tableau de valeurs comprenant "red" et $true

# Eviter le franglais et le pluriel dans les noms de variables
$var = 'var1'
$vars = Get-Variable # Difficile de voir la différence avec $var
$VarList = Get-Variable # Nom plus clair indiquant que la variable contient plusieurs objets


# Cmdlet de gestion des variables
Get-Command -Noun 'variable'

New-Variable -Name 'varStr' -Value 'Texte' -Description 'Ceci est une variable de type String'
Set-Variable -Name 'varStr' -Value 'Texte modifié'
Get-Variable -Name 'varStr' | Select-Object -Property *
Clear-Variable -Name 'varStr' 
Remove-Variable -Name 'varStr'

# Variables automatiques
<# 
(Get-Help about_Automatic_Variables -Full).Split("`r`n") | 
    Select-String -Pattern '^(\$[^\s\.]+)' -AllMatches  | 
    Select-Object @{n='Name'; e = {$_.Matches[0].Value}} -Unique | 
    Select-Object -ExpandProperty Name | 
    Set-Clipboard
#>
$$
$?
$PSCmdlet
$^
$_
$args
$ConsoleFileName
$Error
$ErrorView
$Event
$EventArgs
$EventSubscriber
$ExecutionContext
$true
$false
$foreach
$ForEach
$HOME
$host
$input
$LastExitCode
$Matches
$MyInvocation
$NestedPromptLevel
$null
$PID
$PROFILE
$PSBoundParameters
$PSCommandPath
$PSCulture
$PSDebugContext
$PSHOME
$PSItem
$PSScriptRoot
$PSSenderInfo
$PSUICulture
$PSVersionTable
$PWD
$Sender
$ShellId
$StackTrace
$switch
$this

# Variables de préférence
<# 
(Get-Help about_Preference_Variables -Full).Split("`r`n") | 
    Select-String -Pattern '^(\$[^\s\.]+)' -AllMatches  | 
    Select-Object @{n='Name'; e = {$_.Matches[0].Value}} -Unique | 
    Select-Object -ExpandProperty Name | 
    Set-Clipboard
#>

$ErrorView
$FormatEnumerationLimit
$MaximumAliasCount
$MaximumDriveCount
$MaximumErrorCount
$MaximumFunctionCount
$MaximumHistoryCount
$MaximumVariableCount
$OFS
$OutputEncoding
$PSDefaultParameterValues
$PSEmailServer
$PSModuleAutoloadingPreference
$PSSessionApplicationName
$PSSessionConfigurationName
$PSSessionOption
$Transcript
$VerbosePreference
$WarningPreference
$WarningPreference
$WhatIfPreference
$WhatIfPreference
$ProgressPreference
$InformationPreference
$ConfirmPreference
$DebugPreference
$ErrorActionPreference



#######################################################################################################################
#                       Opérateurs / Manipulation de chaines de caractères / Opérateurs spéciaux
#######################################################################################################################
# Voir "CH4-3_Opérateurs.ps1"

# Manipulation de chaines de caractère
    # Différence entre "" et ''
$var = 'texte'

'texte' # Texte brut sans interprétation 
"texte" # Interprétation possible

'Ceci est un $var' # Affichera le texte tel quel
"Ceci est un $var" # Affichera Ceci est un texte

    # Caractère d'échappement
    # https://ss64.com/ps/syntax-esc.html
"La variable `$var`b vaut '$var'" # Utilisation du caractère d'échappement ` (Alt-gr+7)

<# 
`0 => caractère null
`a => Alerte
`b => Backspace (Effacement)
`n => Nouvelle ligne
`r => Retour chariot
`t => Tabulation horizontale
#>


    # Here-String

@"
Texte 
    sur
`tplusieurs
Lignes`r`navec la variable `"`$var=$var`"
"@

@'
Texte 
    sur
`tplusieurs
Lignes`r`navec la variable `$var=$var
'@




#######################################################################################################################
#                                          Tableaux et dictionnaires
#######################################################################################################################

Get-Help about_Arrays -ShowWindow
Get-Help about_Hash_Tables -ShowWindow


$tab = @(1,2,3)
$tab = @('a','b','c')
$tab = @(1,'a',2,'b',3,'c')
$tab | Get-Member # Méthodes et propriétés des objets du tableau
$tab.psbase | Get-Member # Méthodes et propriétés d'un tableau
$tab.GetType()
$tab.psobject.GetType()
$tab.Count # Nombre d'éléments dans le tableau

    # Les tableaux peuvent servir à stocker le resultat de commandes
    # Le résultat sera toujours un tableau de 0 ou plus éléments
$StartingSvc = Get-Service | Where-Object Status -eq Running
$StartingSvc.GetType()
$StartingSvc.Count

$StartingSvc2 = @(Get-Service | Where-Object Status -eq Running)
$StartingSvc2.GetType()
$StartingSvc2.Count

$tab = @(1,2,3)
$tab[0] # Premier élément du tableau
$tab[-1] # Dernier élément du tableau
$tab[0..($tab.Count -1)] # Tous les éléments
$tab[-2] = 6 # Modification de l'avant dernier élément du tableau
$tab

$tab = New-Object -TypeName System.Collections.ArrayList
$tab = [System.Collections.ArrayList]@()

$Count = $tab.Add('new') # Ajout d'un élément et récupération du nombre d'éléments dans la collection
$tab.Clear() # Suppression de tous les éléments du tableau
$Index = $tab.IndexOf('new') # Index de l'élément 'new'
$tab.Insert(0,'insert') # Insertion de l'élément 'insert' à la première position
$tab.Item(0) # Récupération de l'élément à l'index 0
$tab.Item(0) = 'Modified' # Modification du premier élément
$tab[0] = 'Modified' # Modification du premier élément
$tab.Remove('insert') # Suppression de l'élément 'insert'
$tab.RemoveAt(1) # Suppression du 2ème élément
$tab.Reverse() # Inversion des éléments, ne renvoie rien
$tab.Sort() # Tri des éléments, ne renvoie rien


# @{} => table de hash
Get-Help -Name 'about_Hash_Tables' -ShowWindow

$Hash = @{name = 'hash'; value = 1; comment = 'Ceci est une table de hash'}
$Hash.Name
$Hash['Name']
$Hash['Name'] = 'hash modifié'


#######################################################################################################################
#                                               Commentaires
#######################################################################################################################


# Commentaire sur une ligne


<# 
    Commentaire
    sur 
    plusieurs
    lignes
#>

#region
$var

    # commentaire

'texte'
#endregion


#######################################################################################################################
#                                          Structures conditionnelles
#######################################################################################################################

# Voir "CH4-8_Structures_conditionnelles.ps1"


#######################################################################################################################
#                                                   Boucles
#######################################################################################################################

# Voir "CH4-8_Boucles.ps1"


#######################################################################################################################
#                                                   Fonctions
#######################################################################################################################

Get-Help ABOUT_LANGUAGE_KEYWORDS -ShowWindow
Get-Help about_Functions -ShowWindow

<# 
function <verb-name> {
    param ([type]$parameter1 [,[type]$parameter2])
    <statement list>
} 
#>

Function Get-PowerShellProcess {
    Get-CimInstance -ClassName Win32_Process | 
        Where-Object Name -Match 'powershell' |
        Select-Object -Property Name,ProcessId
}

Function Get-VolumeItem ([char]$Volume)
{   
    Get-ChildItem -Name "$($Volume):\"
}

Function Get-VolumeItem 
{
    Param ([char]$Volume)
    
    Get-ChildItem -Name "$($Volume):\"
}

Function Get-VolumeItem 
{
    Param ([char]$Volume)
    
    $List = Get-ChildItem -Name "$($Volume):\"
    Return $List
}
Get-VolumeItem -Volume 'C'

    # Différences de scope (étendue)
$Path = 'C:\Temp_Script'
Function Get-Path {
    $Path
}


#######################################################################################################################
#                                                   Splatting
#######################################################################################################################

Get-Help about_Splatting -ShowWindow

Start-Process -FilePath 'powershell.exe' -ArgumentList "-NoProfile -NoLogo -File C:\temp\test.ps1" -WindowStyle Hidden -PassThru -Wait -RedirectStandardError 'C:\temp\error.txt'
$ParamList = @{
    FilePath = 'powershell.exe'
    ArgumentList = "-NoProfile -NoLogo -File C:\temp\test.ps1"
    WindowStyle = 'Hidden'
    PassThru = $true
    Wait = $true
    RedirectStandardError = 'C:\temp\error.txt'
}
Start-Process @ParamList

#######################################################################################################################
#                                               Lancement d'un script
#######################################################################################################################

