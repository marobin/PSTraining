#Requires -Version 5.1
Throw "Les instructions doivent être exécutées en sélectionnant la ligne puis en appuyant sur F8"


############### Boucle for
Get-Help -Name about_For -ShowWindow
    # Exemple 1
for ($i = 0; $i -lt 10 ; $i++)
{
    "Chiffre : $i"
}

    # Exemple 2
$Tab = @(1,3,68,2,14,96)
for ($i = 0; $i -lt $Tab.Count ; $i++)
{
    "Index $i : $($Tab[$i])"
}

    # Exemple 3
for ($i = 0; $i -lt 10 ; $i++)
{
    If (($i % 2) -eq 1)
    {
        Continue
    }
    "Chiffre : $i"
}

    # Exemple 4
for ($i = 0; $i -le 20; $i += 2)
{
    $i
}

    # Exemple 4
for (($i = 0), ($j = 0); $i -le 20; ($j++), ($i += 2))
{
    "$i : $j"
}


############### Boucle foreach
Get-Help -Name about_Foreach -ShowWindow

<# 
https://poshoholic.com/2007/08/21/essential-powershell-understanding-foreach/

foreach ($command in (Get-Command -CommandType All)) { $command } 

    Différent de

Get-Command -CommandType All | foreach { $_ }
#>

    # Exemple 1
$letterArray = 'a','b','c','d'
foreach ($letter in $letterArray)
{
    $letter
}

    # Exemple 2
$FileList = Get-ChildItem -Path 'C:\Windows\Temp' -Filter '*.log'
foreach ($File in $FileList)
{
    # Fichier log dont la taille dépasse 1MB
    If ($File.Length -gt 1MB)
    {
        $File.FullName
    }
}

    # Exemple 3
$Count = 0
$FileList = Get-ChildItem -Path 'C:\Windows\Temp' -Filter '*.log'
foreach ($File in $FileList)
{
    # Fichier log dont la taille dépasse 1mb
    If ($File.Length -gt 1MB)
    {
        $Count++
    }
}
"$Count fichiers dépassent la taille de 1MB"


############### Boucle while
Get-Help -Name about_While -ShowWindow
$value = 0
While ($value -lt 5)
{
    $value++
    $value
}



############### Boucle do (while/until)
Get-Help -Name about_Do -ShowWindow
    # Do...while

$number = Get-Random -Minimum 1 -Maximum 10 # Chiffre au hasard entre 1 et 10
do {
    [int]$guess = Read-Host -Prompt "Quel est le chiffre à deviner?"
    if ($guess -lt $number) {
        Write-Output 'Trop petit!'
    }
    elseif ($guess -gt $number) {
        Write-Output 'Trop grand!'
    }
}
while ($guess -ne $number)

    # Do...until
$number = Get-Random -Minimum 1 -Maximum 10 # Chiffre au hasard entre 1 et 10
do {
    [int]$guess = Read-Host -Prompt "Quel est le chiffre à deviner?"
    if ($guess -lt $number) {
        Write-Output 'Trop petit!'
    }
    elseif ($guess -gt $number) {
        Write-Output 'Trop grand!'
    }
}
until ($guess -eq $number)