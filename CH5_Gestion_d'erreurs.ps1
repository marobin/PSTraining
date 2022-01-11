#Requires -Version 5.1
Throw "Les instructions doivent être exécutées en sélectionnant la ligne puis en appuyant sur F8"


#######################################################################################################################
#                                                Variable $Error
#######################################################################################################################
Get-Help about_Automatic_Variables -ShowWindow

$Error | Get-Member | Select-Object -ExpandProperty TypeName -Unique # Type [System.Management.Automation.ErrorRecord]
$Error | Get-Member

$Error.GetType().FullName # Type [System.Collections.ArrayList]

$Error.Count # Nombre d'erreurs enregistrées
$Error.Clear() # Supprime toutes les erreurs enregistrées
$Error.RemoveAt(0) # Supprime la dernière erreur enregistrée (index 0)

$Error[0].Exception.Message # Message d'erreur de la dernière erreur enregistrée

#######################################################################################################################
#                                                 Write-Error
#######################################################################################################################




#######################################################################################################################
#                                             Try / Catch / Finally
#######################################################################################################################




#######################################################################################################################
#                                                   DEBUGGING
#######################################################################################################################




