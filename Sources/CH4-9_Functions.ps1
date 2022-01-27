
# Différences de scope (étendue)
    # Exemple 1
$Counter = 1
"Ex1-Compte avant : $Counter"
Function Set-Count {
    $Counter = $Counter * 4
}

Set-Count
"Ex1-Compte après : $Counter"




    # Exemple 2
$Counter = 1
"Ex2-Compte avant : $Counter"
Function Set-Count {
    $Script:Counter = $Counter * 4
}

Set-Count
"Ex2-Compte après : $Counter"




    # Exemple 
$Script:Counter = 1
"Ex3-Compte avant : $Counter"
Function Set-Count {
    $Counter = 2
    "Ex3- Compte $Counter (Local) / $Script:Counter (Script)"
    $Script:Counter = $Counter * 4
}

Set-Count
"Ex3-Compte après : $Counter"