#Requires -Version 5.1
Throw "Les instructions doivent être exécutées en sélectionnant la ligne puis en appuyant sur F8"


############### Structure If/ElseIf/Else
Get-Help -Name about_If -ShowWindow

$age = 1
If ($age -lt 2) {
    "Ouin..."
}
ElseIf ($age -lt 12) {
    "Ça grandi vite quand même..."
}
ElseIf ($age -lt 16) {
    "J'veux un scooter!"
}
ElseIf (($age -ge 20) -and ($age -lt 40)) {
    "$age ans, quel bel âge!"
}
ElseIf ($age -eq 40) {
    "C'est parti pour la crise..."
}
Else {
    "$age ans, rien à dire..."
}

############### Structure Switch
Get-Help -Name about_Switch -ShowWindow

    # Sans utilisation du mot clé 'break'
$age = 1
Switch ($age)
{
    {$_ -lt 2} { "Ouin..." }
    {$_ -lt 12} { "Ça grandi vite quand même..." }
    {$_ -lt 16} { "J'veux un scooter!" }
    {($_ -ge 20) -and ($_ -lt 40)} { "$_ ans, quel bel âge!" }
    40 { "C'est parti pour la crise..." }
    Default { "$_ ans, rien à dire..." }
}

    # Avec utilisation du mot clé 'break'
$age = 1
Switch ($age)
{
    {$_ -lt 2} { "Ouin..." ; break}
    {$_ -lt 12} { "Ça grandi vite quand même..." ; break}
    {$_ -lt 16} { "J'veux un scooter!" ; break }
    {($_ -ge 20) -and ($_ -lt 40)} { "$_ ans, quel bel âge!" ; break }
    40 { "C'est parti pour la crise..." ; break }
    Default { "$_ ans, rien à dire..." }
}

    # Utilisation d'expressions régulières
$target = 'https://bing.com'
switch -Regex ($target)
{
    '^ftp\://.*$' { "$_ est une adresse FTP"; Break }
    '^\w+@\w+\.com|edu|org$' { "$_ est une adresse email"; Break }
    '^(http[s]?)\://.*$' { "$_ est une adresse web qui utilise $($matches[1])"; Break }
}
