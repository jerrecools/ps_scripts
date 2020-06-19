# Door het uitvoeren van dit script worden er "edu teams" (klassen) aangemaakt op basis van een .csv bestand.
# In het bestand mag je een teamnaam, owners (leerkrachten) en members (leerlingen) kiezen. 
# Je kan de groepen scheiden door een komma en wil je meerdere owners of members toevoegen, dan scheid je deze door een ";"


# Importeren van het .csv bestand in dezelfde directory als je script
    $csv = Import-Csv "$PSScriptRoot\teams.csv"


# Verbinden met MS Teams - zie https://docs.microsoft.com/en-us/microsoftteams/install-prerelease-teams-powershell-module
    Connect-MicrosoftTeams


# Functie die ervoor zorgt dat meerdere gebruikers (gescheiden door een ";") van een zelfde rol worden gesplit en toegevoegd
    function toevoegen_gebruikers
    {
        param($gebruikers,$groupid,$rol)
        $usersplit = $gebruikers -split ";"
            for($j =0; $j -le ($usersplit.count - 1) ; $j++)
            {
                Add-TeamUser -GroupId $GroupId -User $usersplit[$j] -Role $rol
            }

    }


# Een foreach loop die de .csv doorloopt en teams aanmaakt per naam met de juiste gebruikers en instellingen
    foreach($i in $csv)
    {
        $teamnaam = $i.naam
        $owners = $i.titu
        $leerlingen = $i.lln
           
        Write-Host "-------------------------------------------------------------------------------------------------"
        Write-Host "De volgende klas wordt aangemaakt" $teamnaam
        $group = New-Team -MailNickname $teamnaam -displayname $teamnaam -Template "EDU_Class"
        Set-Team -GroupId $group.GroupId -AllowAddRemoveApps $false -AllowCreateUpdateChannels $false -AllowCreateUpdateRemoveTabs $false -AllowDeleteChannels $false -AllowUserDeleteMessages $false -AllowUserEditMessages $false
 
        write-Host "De volgende leerkrachten worden toegevoegd:" $owners
        toevoegen_gebruikers -gebruikers $owners -groupid $group.GroupId -rol "Owner"
        Write-Host "De volgende leerlingen worden toegevoegd:" $leerlingen
        toevoegen_gebruikers -gebruikers $leerlingen -groupid $group.GroupId -rol "Member"

    }


Read-Host -Prompt "Press Enter to exit"
