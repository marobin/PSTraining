$Text = 'Ceci est un texte'

$ServiceList = Get-Service

$RunningServiceList = Get-Service | Where-Object -Property Status -eq Running

ForEach ($index in (0..10)) {
    $index
}

$Text | Out-File -FilePath 'C:\temp\debug.txt'