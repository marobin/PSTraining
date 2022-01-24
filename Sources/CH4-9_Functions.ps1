
# Différences de scope (étendue)
    # Exemple 1
$Counter = 1
"1-Compte avant : $Counter"
Function Set-Count {
    $Counter = $Counter * 4
}

Set-Count
"1-Compte après : $Counter"

    # Exemple 2
$Counter = 1
"2-Compte avant : $Counter"
Function Set-Count {
    $Script:Counter = $Counter * 4
}

Set-Count
"2-Compte après : $Counter"


    # Exemple 2
$Script:Counter = 1
"3-Compte avant : $Counter"
Function Set-Count {
    $Counter = 2
    "3- Compte $Counter (Local) / $Script:Counter (Script)"
    $Script:Counter = $Counter * 4
}

Set-Count
"3-Compte après : $Counter"