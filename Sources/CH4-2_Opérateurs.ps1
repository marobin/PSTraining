#Requires -Version 5.1
Throw "Les instructions doivent être exécutées en sélectionnant la ligne puis en appuyant sur F8"

# Liste des aides qui concernent les opérateurs
Get-Help -Name 'about_*operator*'


############### Arithmétiques
Get-Help -Name 'about_Arithmetic_Operators' -ShowWindow
# Addition
1 + 2 
# Soustraction
5 - 3
# Multiplication
2 * 4
# Division
8 / 4 # Division entière
8 / 3 # Division décimale
# Modulo (Reste de la division entière de 2 nombres)
# Par exemple, pour savoir si un nombre est pair ou impair, 
# on peut faire un modulo 2 sur celui-ci 
# et voir si le résultat est 0 (pair) ou 1 (impair). 
8 % 2
7 % 2


############### Classe .NET Math
[Math]::PI # Constante Pi
[Math]::E # Constante Nombre d'Euler
[Math]::Pow(2,3) # 2 puissance 3
[Math]::Round((8/3),2) # arrondi à 2 chiffres après la virgule de 8 divisé par 3
[Math]::Floor(8/3) # arrondi inférieur de 8 divisé par 3
[Math]::Ceiling(8/3) # arrondi supérieur de 8 divisé par 3


############### Comparaison
Get-Help -Name 'about_Comparison_Operators' -ShowWindow
    # Test d'égalité
1 -eq 1 # 1 égal à 1
1 -eq 2 # 1 égal à 2
1 -ne 2 # 1 non égal à 2
1 -gt 0 # 1 strictement supérieur à 0
1 -ge 1 # 1 supérieur ou égal à 1
1 -lt 2 # 1 strictement inférieur à 2
2 -le 2 # 2 inférieur ou égal à 2

 
    # Appartenance
(1,2,3) -contains 1     # Une collection contient une valeur
(1,2,3) -notcontains 4  # Une collection ne contient pas une valeur
1 -in (1,2,3)           # La valeur se trouve dans la collection
4 -notin  (1,2,3)       # La valeur ne se trouve pas dans la collection

############### Affectation (=, +=, -=, *=, /=, %=, ++, --)
Get-Help -Name 'about_Assignment_Operator' -ShowWindow
$a = 1
$a += 3
$a -= 2
$a *= 5
$a /= 2
$a %= 2
$a

$string = 'test'
$string += ' n°1'
$string

# Opérateurs unaire (++ et --)
$a = 1
$a++
$a--
++$a
--$a
$a


############### Logique (-and, -or, -xor, -not, !) 
Get-Help -Name 'about_Logical_Operators' -ShowWindow
    # ET Logique
$true -and $true 
$true -and $false
1 -eq 2 -and 2 -gt 1

    # OU logique
$true -or $false
1 -eq 2 -or 2 -gt 1

    # OU exclusif : vrai lorsque seulement une instruction est vraie
1 -eq 2 -xor 2 -gt 1
1 -eq 1 -xor 2 -gt 1

    # NON logique
-not (1 -eq 1)
-not (Test-Path -Path 'C:\plop')
! (Test-Path -Path 'C:\plop')

    # Exemple avec plusieurs instructions
$a = 24
$b = 21
($a -gt $b) -and ((-not ($a -lt 20)) -or ($b -lt 20))


############### Redirection (>, >>, 2>&1) 
Get-Help -Name 'about_Redirection' -ShowWindow
'Texte' > C:\temp\test.txt # Remplace le contenu existant par 'Texte'

'Ligne 2' >> C:\temp\test.txt # Ajoute 'Ligne 2' au contenu

# Rediriger des flux différents dans un fichier 
&{
    $VerbosePreference = 'Continue'
    Write-Warning "WARNING"
    1 + 1
    Write-Error "ERROR"
    Write-Output "OUTPUT"
    Write-Verbose -Message "VERBOSE"
 } > C:\Temp\redirection.log

 &{
    $VerbosePreference = 'Continue'
    Write-Warning "WARNING"
    1 + 1
    Write-Error "ERROR"
    Write-Output "OUTPUT"
    Write-Verbose -Message "VERBOSE"
 } 3>&1 2>&1 > C:\Temp\redirection.log

############### Type (-is, -isnot, -as) 
Get-Help -Name 'about_Type_Operators' -ShowWindow

'text' -is [String]
42 -is [String]
42 -isnot [String]

(42 -as [String]) -is [string]

############### Chaine
# correspondance
    # Utilisation du wildcard * avec -like et -notlike
'ceci est un test' -like 'ceci*' # 'ceci est un test' commence bien par 'ceci'
'ceci est un test' -like '*es*' # 'ceci est un test' comprend bien 'es' (dans 'est' et 'test')
'ceci est un test' -like '*test' # 'ceci est un test' se termine bien par 'test'
'ceci est un test' -notlike '*toto*' # 'ceci est un test' ne comporte pas la chaine 'toto'

    # Utilisation d'expressions régulières avec -match et -notmatch
'0324658' -match '^\d+$' # Renvoie true car la chaine ne comporte que des chiffres
'test01234' -match '^\d+$' # Renvoie false car la chaine ne comporte pas que des chiffres
'test01234' -notmatch '^\d+$' # Renvoie true car la chaine ne comporte pas que des chiffres
'\\server\share\path' -match '^\\\\([^\\]+)\\([^\\]+)'
$Matches

# Remplacement
    # Remplacement sans expressions régulières
"Utilisateur 'toto'".Replace("'toto'",$env:USERNAME) # Méthode Replace de la classe System.String
    # Utilisation d'expressions régulières
"Utilisateur '$env:USERNAME'" -replace "'[^']+'",'toto'

# Découpage
Get-Help -Name 'about_Split' -ShowWindow
"ceci est un test".Split(' ') # Méthode Split de la classe System.String
"0- ceci est un`ttest" -split '\s' # -split permet d'utiliser des expressions régulières

# Concaténation
Get-Help -Name 'about_Join' -ShowWindow
-join @('ceci','est','un','test')
('ceci','est','un','test') -join ' | '

# Méthodes de la classe [String]
'' | Get-Member -MemberType Methods

"ceci est un test".IndexOf('e')
"ceci est un test".IndexOf('un')
"ceci est un test".LastIndexOf('e')

'7'.PadLeft(3,'0')
'10.'.PadRight(5,'x')

"ceci est un test".Substring(5,3)

"Ceci est un TEST".ToUpper()
"Ceci est un TEST".ToLower()

"    chaine  ".Trim()
"Ceci est un test".TrimStart("c") # sensible à la casse
"Ceci est un test".TrimStart("iecC ts") # sensible à la casse
"Ceci est un test".TrimEnd("ets") # sensible à la casse



############### Spéciaux

Get-Help about_Special_Characters -ShowWindow

# () => Opérateur de regroupement
(Get-Item *.txt).Count

Get-ChildItem -Path (Get-Content -Path 'C:\Temp\liste_dossiers.txt')

# $() => Sous-expression
"Nous sommes le $(Get-Date)"
"Liste des dossiers : $((Get-ChildItem -Path 'c:\' -Directory).Name -join ', ')"

# @() => tableau
Get-Help -Name 'about_Arrays' -ShowWindow
$tab = @(1,2,3)
$tab = @('a','b','c')
$tab = @(1,'a',2,'b',3,'c')
$tab | Get-Member

    # Le résultat sera toujours un tableau de 0 ou plus éléments
$StartingSvc = Get-Service | Where-Object Status -eq Running
$StartingSvc.GetType()
$StartingSvc.Count

$StartingSvc2 = @(Get-Service | Where-Object Status -eq Running)
$StartingSvc2.GetType()
$StartingSvc2.Count

# @{} => table de hash
Get-Help -Name 'about_Hash_Tables' -ShowWindow
$Hash = @{name = 'hash'; value = 1; comment = 'Ceci est une table de hash'}

# {} => bloc de script
$ScriptBlock = {Get-ChildItem -Path 'C:\'}

# & => opérateur d'invocation
# Permet de lancer une commande, un script ou un bloc de script
    # Commande dans une chaine de caractères
$Instruction = 'Get-ExecutionPolicy'
& $Instruction

    # Exécutable
& calc.exe

    # Bloc de script
& $ScriptBlock

    # /!\ Il n'y a pas d'évaluation des chaines donc il n'est par exemple pas possible d'utiliser des paramètres dans les commandes en chaines de caractères
    $Command = "Get-Service -Name Spooler"
    & $Command
    & "1+1"

    # Il faut dans ce cas utiliser la cmdlet Invoke-Expression
    Invoke-Expression -Command $Command
    Invoke-Expression -Command '1+1'


# . => dot sourcing ou accès à un membre d'un objet
    # dot sourcing
<#
Exécute un script dans l'étendue actuelle de façon à ce que toutes les fonctions, alias et variables que le script crée sont ajoutées à la portée actuelle, et remplacent celles qui existent déjà. 
[NOTE] Attention à ne pas confondre le symbole du point (.) qui représente le répertoire actuel => Il faut laisser un espace après le point pour le dot sourcing
#>

. C:\temp\test.ps1
cd c:\temp
. .\test.ps1

    # accès à un membre
$Hash.Comment
$tab.Count
(Get-Item *.txt).Count

# .. => étendue de nombres entiers
0..10

$text = 'ceci est un texte'
1..$text.Length

# | => pipeline
Get-Help -Name 'about_pipelines' -ShowWindow

# [] => cast ou index de tableau
    # Cast
[DateTime]"2/20/88" - [DateTime]"1/20/88"
[Int] (7/2)
[String] 1 + 0
[Int] '1' + 0

    # Index
$tab = @(1,2,3)
$tab[0] # Premier élément du tableau
$tab[-1] # Dernier élément du tableau
$tab[-2] = 6 # Modification de l'avant dernier élément du tableau
$tab

# -f => formatage de chaines
    # https://lazywinadmin.com/2016/08/powershell-composite-formatting.html
    # https://docs.microsoft.com/en-us/dotnet/standard/base-types/formatting-types
    # https://docs.microsoft.com/en-us/dotnet/standard/base-types/composite-formatting
    # {index[,alignement][:format]}
'0x{0:X}' -f 1234 # Format hexadécimal
'{0:X2}' -f 2 # Hexadécimal sur 2 caractères
"{0} {1,-10} {2:N}" -f 1,"hello",[math]::pi

# :: => membre de classe static
[int]::MaxValue
[string]::IsNullOrEmpty('')


############### Priorité
Get-Help -Name 'about_Operator_Precedence' -ShowWindow

# Les parenthèses permettent de prioriser des opérations
2 + 3 * 4
(2 + 3) * 4

# 
[string]@('Windows','PowerShell','2.0')[0]
([string]@('Windows','PowerShell','2.0'))[0]

# 
2 -gt 4 -and 1 # equivalent à (2 -gt 4) -and 1
2 -gt (4 -and 0)

# 
1 -gt 0 -and $true -and 2 -lt 1
(1 -gt 2) -or ($true) -and (2 -lt 1)
