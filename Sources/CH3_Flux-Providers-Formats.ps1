#Requires -Version 5.1
Throw "Les instructions doivent être exécutées en sélectionnant la ligne puis en appuyant sur F8"


#######################################################################################################################
#                                                   FLUX
#######################################################################################################################
Get-Help about_Output_Streams -ShowWindow

    # 1- Success
Get-Help -Name Write-Output -ShowWindow

Write-Output -InputObject "Sortie standard"
"Sortie standard"


    # 2- Error
Get-Help -Name Write-Error -ShowWindow

        # Afficher les erreurs (par défaut)
$ErrorActionPreference = 'Continue'
Write-Error -Message "Ceci est une erreur"
        
        # Ignorer les erreurs
$ErrorActionPreference = 'SilentlyContinue'
Write-Error -Message "Ceci est une erreur invisible"

        # Stoper l'exécution à la première erreur
$ErrorActionPreference = 'Stop'
1..10 | ForEach-Object {
    Write-Output -InputObject "Première ligne"
    1 / 0
    Write-Output -InputObject "Deuxième ligne"
}


    # 3- Warning
Get-Help -Name Write-Warning -ShowWindow

$WarningPreference = 'Continue'

Write-Warning -Message "Ceci est un avertissement"


    # 4- Verbose
Get-Help -Name Write-Verbose -ShowWindow

Write-Verbose -Message "Texte verbeux invisible"
$VerbosePreference = 'Continue'
Write-Verbose -Message "Ce texte est verbeux"



    # 5- Debug
Get-Help -Name Write-Debug -ShowWindow


Write-Debug -Message "Texte de debug invisible"
$DebugPreference = 'Continue'
Write-Debug -Message "Texte de debug"


    # 6- Information
Get-Help -Name Write-Information -ShowWindow

Write-Information -Message "Ceci est une information invisible"
$InformationPreference = 'Continue'
Write-Information -Message "Ceci est une information"



    # Progress
Get-Help -Name Write-Progress -ShowWindow

for ($i = 1; $i -le 100; $i++ )
{
    If (($i -ge 50) -and ($i -le 70)) {
        $ProgressPreference = 'Continue'
    }
    else {
        $ProgressPreference = 'SilentlyContinue'
    }
    Write-Progress -Activity "En formation..." -Status "$i% Complete:" -PercentComplete $i
    Start-Sleep -Milliseconds 250
}


# Variables Preference
Get-Help about_Preference_Variables -ShowWindow
Get-ChildItem 'variable:' | Where-Object -Property Name -match 'preference' | Select-Object -Property Name,Value,Description

$ErrorActionPreference.GetType()
[enum]::GetValues('System.Management.Automation.ActionPreference')
<# 
[enum]::GetValues('System.Management.Automation.ActionPreference')
SilentlyContinue
Stop
Continue
Inquire
Ignore
#>

# Activer l'option verbose sur une commande/fonction avec -Verbose même si $VerbosePreference = 'SilentlyContinue'
$VerbosePreference = 'SilentlyContinue'
New-Item -Path 'C:\tempFile' -Verbose

# Eviter d'utiliser write-host 
# https://devblogs.microsoft.com/scripting/writing-output-with-powershell/
'Ceci est une chaine de caractères' | Get-Member
Write-Host 'Ceci est une chaine de caractères' | Get-Member

#######################################################################################################################
#                                                PROVIDERS
#######################################################################################################################
Get-Help -Name about_Providers -ShowWindow

Get-PSProvider

Get-PSDrive

Get-PSDrive -PSProvider Registry


# Voir les commandes communes aux providers
Get-Command -Module Microsoft.PowerShell.Management -Noun '*item*'

# Lister les éléments d'un PSDrive
Get-ChildItem -Path alias:
Get-ChildItem -Path cert: -Recurse
Get-ChildItem -Path env:
Get-ChildItem -Path C:\
Get-ChildItem -Path Function:
Get-ChildItem -Path HKLM:
Get-ChildItem -Path Variable:
Get-ChildItem -Path wsman:

# Certains providers peuvent être accéder à l'aide de variables
$Alias:cd
$env:COMPUTERNAME
${Function:Clear-Host}
$Variable:PSVersionTable


# Créer un élément sur un PSDrive
New-Item -Path 'C:\' -Name 'Temp1' # Fichier
New-Item -Path 'C:\' -Name 'Temp2' -ItemType Directory  # Dossier
New-Item -Path 'HKLM:\SOFTWARE\Test' # Clé registre

# Supprimer un élément 
Remove-Item -Path 'C:\Temp'

#######################################################################################################################
#                                             Système de fichiers
#######################################################################################################################

# Trouver les types .NET associés au système de fichiers
Get-ChildItem -Path 'C:\Windows' | Get-Member | Select-Object -ExpandProperty TypeName -Unique

# Dossiers [System.IO.DirectoryInfo]
Get-Item -Path 'C:\Windows' | Get-Member
Get-Item -Path 'C:\Windows' | Select-Object -Property *

# Fichiers [System.IO.FileInfo]
Get-Item -Path 'C:\Windows\notepad.exe' | Get-Member
Get-Item -Path 'C:\Windows\notepad.exe' | Select-Object -Property * 
Get-Item -Path 'C:\Windows\notepad.exe' | Select-Object -ExpandProperty VersionInfo | Select-Object -Property *
Get-Item -Path 'C:\Windows\notepad.exe' | 
    Select-Object -ExpandProperty VersionInfo | 
    Select-Object -ExpandProperty ProductVersion


# Copier un élément
Copy-Item -Path 'C:\Windows\notepad.exe' -Destination 'C:\Temp'
# Déplacer ou renommer un élément
Move-Item -Path 'C:\Temp\notepad.exe' -Destination 'C:\Users'

# Renommer un élément
Rename-Item -Path 'C:\Temp' -NewName 'C:\Temp2'

# Ouvrir un élément
Invoke-Item -Path 'C:\Windows\notepad.exe' 
Invoke-Item -Path 'C:\Windows\System32\calc.exe' 
Invoke-Item -Path C:\temp\redirection.log

# Modification du contenu d'un fichier 
Get-Command -Module 'Microsoft.PowerShell.Management' -Noun 'content'

Get-Content -Path 'C:\Temp\text.txt' # Lecture du fichier
Set-Content -Path 'C:\Temp\text.txt' -Value 'Ligne de texte' # Remplacement du contenu du fichier, équivalent  > C:\temp\text.txt
Add-Content -Path 'C:\Temp\text.txt' -Value 'Deuxième ligne' # Ajout de contenu dans le fichier, équivalent >> C:\temp\text.txt
Clear-Content -Path 'C:\Temp\text.txt' # Suppression du contenu du fichier sans supprimer le fichier


Get-Content -Path 'C:\Temp\text.txt' | 
    ForEach-Object -Begin {$linenumber = 0} {"Ligne $linenumber : $_";$linenumber++} -End {"Nombre de lignes $linenumber"}

ForEach ($index in @(0..1000000)) {
    Add-Content -Path 'C:\Temp\text.txt' -Value "$index"
}

Get-Content -Path 'C:\Temp\text.txt' | Measure-Object
Measure-Command {Get-Content -Path 'C:\Temp\text.txt'}
Measure-Command {Get-Content -Path 'C:\Temp\text.txt' -raw}
#######################################################################################################################
#                                                   REGISTRE
#######################################################################################################################

Get-Help about_Registry_Provider -ShowWindow

Get-Item -Path 'HKLM:\SOFTWARE','HKLM:\SOFTWARE\WOW6432Node' | Get-Member | Select-Object -ExpandProperty TypeName -Unique
Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' | Get-Member | Select-Object -ExpandProperty TypeName -Unique

# Clé de registre [Microsoft.Win32.RegistryKey]
$RegKey = Get-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion'
$RegKey.GetType().FullName # Type Microsoft.Win32.RegistryKey
    
    # Ajouter une clé de registre
New-Item -Path 'HKCU:\SOFTWARE\Test'


    # Lister le nom des sous-clés 
$RegKey.GetSubKeyNames()

    # Supprimer une clé de registre
Remove-Item -Path 'HKCU:\SOFTWARE\Test'
Remove-Item -Path 'HKCU:\SOFTWARE\Test' -Recurse # Supprimer la clé et ses sous-clés

# Valeurs registre
    # Lister le nom des valeurs 
$RegKey.GetValueNames() # Méhode .NET
Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name
     
    # Récupérer une valeur
$RegKey.GetValue('ProductName') # Méhode .NET
Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -Name 'ProductName'
(Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -Name 'ProductName').ProductName
    
    # Récupérer le type d'une valeur
$RegKey.GetValueKind('ProductName') # Méhode .NET
$RegKey.GetValueKind('ProductName').GetType().FullName # Type [Microsoft.Win32.RegistryValueKind]
(Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -Name 'ProductName').ProductName.Gettype().FullName # Type .NET et non [Microsoft.Win32.RegistryValueKind]

    # Ajouter une valeur
New-ItemProperty -Path 'HKCU:\SOFTWARE\Test' -Name 'plop' -PropertyType 'String' -Value 'Ceci est un test' 
New-ItemProperty -Path 'HKCU:\SOFTWARE\Test' -Name 'H2G2' -PropertyType 'DWORD' -Value 42
    # Ajouter une valeur (Méthode .NET)
$RegKey = [Microsoft.Win32.RegistryKey]::OpenBaseKey([Microsoft.Win32.RegistryHive]::CurrentUser,[Microsoft.Win32.RegistryView]::Default) # Ouvrir la ruche HKCU
$SubKey = $RegKey.OpenSubKey('SOFTWARE\Test') # Ouvrir la clé en mode lecture
$SubKey.GetValueKind('plop') # Type String
$SubKey.GetValueKind('plop_d') # Type DWord

    # Modifier une valeur
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Test' -Name 'plop' -Value 'Valeur modifiée'
Get-ItemProperty -Path 'HKCU:\SOFTWARE\Test' -Name 'plop'
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Test' -Name '(Default)' -Value 'Valeur par défaut' # Modification de la valeur par défaut de la clé
    # Modifier une valeur (Méthode .NET)
$RegKey = [Microsoft.Win32.RegistryKey]::OpenBaseKey([Microsoft.Win32.RegistryHive]::CurrentUser,[Microsoft.Win32.RegistryView]::Default) # Ouvrir la ruche HKCU
$SubKey = $RegKey.OpenSubKey('SOFTWARE\Test',$true) # Ouvrir la clé en mode écriture (2ème argument = $true)
$SubKey.SetValue('plop',42,[Microsoft.Win32.RegistryValueKind]::DWord)
$SubKey.GetValueKind('plop') # dword

    # Supprimer une valeur 
Remove-ItemProperty -Path 'HKCU:\SOFTWARE\Test' -Name 'plop'
    # Supprimer une valeur (Méthode .NET)
$RegKey = [Microsoft.Win32.RegistryKey]::OpenBaseKey([Microsoft.Win32.RegistryHive]::CurrentUser,[Microsoft.Win32.RegistryView]::Default) # Ouvrir la ruche HKCU
$SubKey = $RegKey.OpenSubKey('SOFTWARE\Test',$true) # Ouvrir la clé en mode écriture (2ème argument = $true)
$SubKey.DeleteValue('plop')

    # Renommer une valeur
    Rename-ItemProperty -Path 'HKCU:\SOFTWARE\Test' -Name 'H2G2' -NewName 'toto'

    # Renommer une clé
Rename-Item -Path 'HKCU:\SOFTWARE\Test' -NewName 'Test_Formation'

#######################################################################################################################
#                                             Recherche de texte
#######################################################################################################################
Get-Help -Name Select-String -ShowWindow

Get-Help -Name Select-String -ShowWindow

# Correspondance simple
Get-Content -Path 'C:\Temp\text21.txt' | Select-String -Pattern 'Ligne'

# Correspondance avec une expression régulière
Get-Content -Path 'C:\Temp\text21.txt' | Select-String -Pattern 'Ligne \d+'

# Ne pas interpréter l'expression régulière
Get-Content -Path 'C:\Temp\text21.txt' | Select-String -Pattern 'Ligne \d+' -SimpleMatch

# Ajouter un contexte (1 ligne avant, 0 ligne après)
Get-Content -Path 'C:\Temp\text21.txt' | Select-String -Pattern 'Ligne' -Context @(1,0)

# Retourner toutes les lignes qui ne correspondent pas 
Get-Content -Path 'C:\Temp\text21.txt' | Select-String -Pattern 'Ligne' -NotMatch

# La cmdlet renvoie un objet de type [Microsoft.PowerShell.Commands.MatchInfo]
Get-Content -Path 'C:\Temp\text21.txt' | Select-String -Pattern 'Ligne' | Get-Member
Get-Content -Path 'C:\Temp\text21.txt' | Select-String -Pattern 'Ligne' | Select-Object -Property *

# 
Get-Content -Path 'C:\Temp\text21.txt' | 
    Select-String -Pattern 'Ligne' -Context @(1,0) |
    ForEach-Object {
        "Ligne $($_.LineNumber) : $($_.Line)"
    }


# Utiliser le paramètre Path pour indique le(s) fichier(s) à analyser
Select-String -Pattern 'ligne' -Path 'C:\temp\*.txt'

# Parcourir les propriétés de l'objet Microsoft.PowerShell.Commands.MatchInfo
$MatchList = Get-Content -Path 'C:\Temp\text21.txt' | Select-String -Pattern 'Ligne'
$MatchList.Matches
$MatchList.Matches[0].Value


#######################################################################################################################
#                                             CSV, XML, HTML, JSON
#######################################################################################################################

# CSV
Get-Command -Noun 'csv'

    # Export de la liste des services Windows dans un fichier csv en utilisant la virgule comme séparateur
    Get-Service | 
    Select-Object -Property Name,StartType,DisplayName | 
    Export-Csv -Path 'C:\temp\Services.csv' -NoTypeInformation -Delimiter ','
    # Import du fichier csv + filtre sur les 5 premiers services dont le type de démarrage est Automatic
Import-Csv -Path 'C:\temp\Services.csv' -Delimiter ',' | 
    Where-Object StartType -eq 'Automatic' | 
    Select-Object -First 5

    # Modifier l'encodage du fichier
Get-Service | 
    Select-Object -Property Name,StartType,DisplayName | 
    Export-Csv -Path 'C:\temp\Services.csv' -NoTypeInformation -Delimiter ',' -Encoding UTF8


# XML
Get-Command -Noun 'xml'

    # Convertion de l'objet en objet XmlDocument
$xmlDoc = Get-Service | 
            Select-Object -Property Name,StartType,DisplayName | 
            ConvertTo-Xml -NoTypeInformation -As Document 

    # Convertion de l'objet en chaine de caractère au format XML
$xmlString = Get-Service | 
                Select-Object -Property Name,StartType,DisplayName | 
                ConvertTo-Xml -NoTypeInformation -As String 

    # Convertion de l'objet en flux pouvant être écrit dans un fichier
Get-Service | 
    Select-Object -Property Name,StartType,DisplayName | 
    ConvertTo-Xml -NoTypeInformation -As Stream | 
    Out-File -FilePath 'C:\temp\services.xml' 

    # Import d'un fichier xml
[xml]$xmlStream = Get-Content -Path 'C:\temp\services.xml'

    # Type d'objets suivant la méthode de convertion
$xmlDoc.GetType().FullName # System.Xml.XmlDocument
$xmlString.GetType().FullName # System.String
$xmlStream.GetType().FullName # System.Xml.XmlDocument


$xmlDoc.Objects.Object[0].Property

$xmlDoc.Objects.Object | 
    Foreach-object {
        $_.Property | 
            Where-Object -Property Name -eq 'DisplayName' | 
            ForEach-Object {
                $_.'#text'
            }
    }


# HTML
Get-Command -Noun 'html'

# Convertion simple d'un objet en HTML
Get-Service | 
    Select-Object -Property Name,StartType,DisplayName | 
    ConvertTo-Html | 
    Out-File -FilePath 'C:\temp\services_raw.html'

# Convertion avancée d'un objet en HTML
$Title = "<br><p><span class=titre_list>Liste des services</span><br><span class=subtitle>Mis à jour le $(Get-Date)</span></p><br>"
$CSS_File = 'C:\temp\services.css'
$MyData = Get-Service | 
            Select-Object -Property Name,StartupType,Description | 
            ConvertTo-Html -Fragment
$colorTagTable = @{
    Automatic = ' class="Automatic">Automatic<';
    Manual = ' class="Manual">Manual<';
    Disabled = ' class="Disabled">Disabled<'
}

$colorTagTable.Keys | ForEach-Object { $MyData = $MyData -replace ">$_<",($colorTagTable.$_) }
ConvertTo-Html  -Body "$Title<br>$MyData" -CSSUri $CSS_File | Out-File -FilePath 'C:\temp\services.html'
$html = Get-Content -Path 'C:\temp\services.html'




# JSON
Get-Command -Noun 'json'

Get-Service | 
    Select-Object -Property Name,StartType,DisplayName | 
    ConvertTo-Json | 
    Out-File -FilePath 'C:\temp\services.json'

Get-Content -Path 'C:\temp\services.json' | ConvertFrom-Json
$json = Get-Content -Path 'C:\temp\services.json' | ConvertFrom-Json


#######################################################################################################################
#                                             Propriétés calculées
#######################################################################################################################

# Utiliser des propriétés calculées
Get-Help about_Calculated_Properties -ShowWindow

<#
Commandes acceptant les propriétés calculées :
    Compare-Object
    ConvertTo-Html
    Format-Custom
    Format-List
    Format-Table
    Format-Wide
    Group-Object
    Measure-Object
    Sort-Object
    Select-Object
#>

    # Exemple pour trouver les processus qui ont établi une connexion internet
Get-Help -Name Get-Process -Parameter * # Trouver les paramètres de Get-Process qui acceptent les valeurs du pipeline
Get-NetTCPConnection | Get-Member -MemberType Properties | Where-Object Definition -Match 'Int' # Trouver les propriétés retournées par Get-NetTCPConnection qui correspondent au type accepté
Get-NetTCPConnection | Get-Member -MemberType Properties -Name '*process*' # Trouver les propriétés retournées par Get-NetTCPConnection qui correspondent à un processus
# Le nom attendu est Id mais la propriété renvoyée par Get-NetTCPConnection est OwningProcess
# On utilise une propriété calculée pour modifier le nom de la propriété et rendre les commandes compatibles

Get-NetTCPConnection -AppliedSetting Internet | 
    Select-Object -Property @{Label = 'Id'; Expression = { $_.OwningProcess }} | 
    Get-Process

Get-NetTCPConnection | Select-Object -Property RemoteAddress,State,@{Label = 'Id'; Expression = { (Get-Process -Id $_.OwningProcess).Name }}




#######################################################################################################################
#                        WMI (Windows Management Instrumentation) et CIM (Common Information Model)
#######################################################################################################################

<# 
Utiliser WMI ou CIM?
https://docs.microsoft.com/en-us/powershell/scripting/learn/ps101/07-working-with-wmi?view=powershell-5.1
https://techgenix.com/wmi-or-cim-powershell/
https://devblogs.microsoft.com/scripting/should-i-use-cim-or-wmi-with-windows-powershell/
https://powershell-guru.com/powershell-best-practice-4-use-cim-cmdlets-not-wmi-cmdlets
#>

Get-Help about_WMI -ShowWindow
Get-Help about_WMI_Cmdlets -ShowWindow
Get-Command -Noun 'wmi*' | Get-Help -ShowWindow

Get-Command -Noun 'cim*' | Get-Help -ShowWindow



# Récupérer la liste des processus en cours
Get-WmiObject -Class Win32_Process | Get-Member # Type [System.Management.ManagementObject#root\cimv2\Win32_Process]
    # Attention, le filtrage par propriété ou avec Select-Object change le type d'objet retourné et donc bloque l'accès aux méthodes de la classe WMI/CIM
Get-WmiObject -Class Win32_Process -Property Name,CommandLine,ExecutablePath | Get-Member # Type [System.Management.ManagementObject#\Win32_Process]
Get-WmiObject -Class Win32_Process | Select-Object -Property Name,CommandLine,ExecutablePath | Get-Member # Type [Selected.System.Management.ManagementObject]

Get-CimInstance -ClassName Win32_Process | Get-Member # Type [Microsoft.Management.Infrastructure.CimInstance#root/cimv2/Win32_Process]
    # Attention, le filtrage par propriété ou avec Select-Object change le type d'objet retourné et donc bloque l'accès aux méthodes de la classe WMI/CIM
Get-CimInstance -ClassName Win32_Process -Property Name,CommandLine,ExecutablePath | Get-Member # Type [Microsoft.Management.Infrastructure.CimInstance#__PartialCIMInstance]
Get-CimInstance -ClassName Win32_Process | Select-Object -Property Name,CommandLine,ExecutablePath | Get-Member # Type [Selected.Microsoft.Management.Infrastructure.CimInstance]

# Récupérer le nom des utilisateurs ayant des processus actifs
(Get-WmiObject -Class Win32_Process).GetOwner() | Select-Object Domain,User -Unique
Get-CimInstance -ClassName Win32_Process | Invoke-CimMethod -MethodName 'GetOwner' | Select-Object Domain,User -Unique



# Récupérer les méthodes/propriétés d'une classe
    # Méthodes
Get-CimClass -ClassName Win32_Process | Select-Object -ExpandProperty CimClassMethods
Get-CimClass -ClassName Win32_Process | Select-Object -ExpandProperty CimClassMethods | Select-Object -ExpandProperty Parameters
    # Propriétés
Get-CimClass -ClassName Win32_Process | Select-Object -ExpandProperty CimClassProperties



# Arrêter les processus lancés depuis le dossier C:\Program Files\Notepad++
    # Méthode 1
    Get-WmiObject -Query 'SELECT * FROM Win32_PROCESS WHERE CommandLine Like "%C:\\Windows\\Notepad%"' | Invoke-WmiMethod -Name Terminate -Verbose
    
    # Méthode 2
Get-WmiObject -Class 'Win32_Process' | 
    Where-Object -Property CommandLine -Like "*C:\Program Files\Notepad++*" | 
    ForEach-Object {
        $_.Terminate()
    }

    # Méthode 3
Get-CimInstance -Query 'SELECT * FROM Win32_PROCESS WHERE CommandLine Like "%C:\\Program Files\\Notepad++%"' | Invoke-CimMethod -MethodName Terminate -Verbose


Where-Object -Property ExecutablePath -like '*C:\Program Files\Notepad++*'

#######################################################################################################################
#                                                   FORMATAGE
#######################################################################################################################

Get-Command -Verb 'format' -Module 'Microsoft.PowerShell.Utility' | Get-Help -ShowWindow

# Afficher toutes les propriétés d'un objet (une propriété par ligne)
Get-Service | Select-Object -First 5 | Format-List # équivalent à Select-Object -Property *
Get-Service | Select-Object -First 5 | Format-List -GroupBy StartType

# Afficher certaines propriétés d'un objet dans un tableau
Get-Service | Select-Object -First 5 | Format-Table 
Get-Service | Select-Object -First 5 | Format-Table -Property Name,StartType,Description,Status,BinaryPathName -AutoSize
Get-Service | Select-Object -First 5 | Format-Table -Property Name,StartType,Description,Status,BinaryPathName -AutoSize -Wrap
Get-Service | Select-Object -First 5 | Format-Table -Property Name,StartType,Description,Status -AutoSize -Wrap

# Afficher une seule propriété dans une liste prenant la largeur de l'écran
Get-Service | Select-Object -First 50 | Format-Wide
Get-Service | Select-Object -First 50 | Format-Wide -Property description

# Afficher un objet ou le contenu d’un fichier en hexadécimal [Microsoft.PowerShell.Commands.ByteCollection]
Format-Hex -InputObject 89
Format-Hex -InputObject 'Y'

Format-Hex -path 'C:\temp\text21.txt'
Get-Content -Path 'C:\temp\text21.txt' | Format-Hex