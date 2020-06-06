#  script deels gehaald van https://github.com/stefan73be - aangepast naar eigen noden
#  maakt een SS en O365 user (lln of lkr) aan en mailt alle gegevens naar een e-mailadres
#  lees eerst de bijhorende readme - je moet namelijk een aantal zaken installeren en configureren




#  0 - FUNCTIES

    #Foolproofkeuze - zorgt ervoor dat je bij bepaalde zaken geen verkeerde input kunt geven waardoor de user niet wordt aangemaakt
    function Foolproofkeuze 
        {
           param( [string]$variable, [string]$tekst, [string]$keuze1, [string]$keuze2)

           $variable = Read-host "Maak een keuze voor $tekst : $keuze1 of $keuze2"
           while($keuze1,$keuze2 -notcontains $variable )
                    {
                        $variable = Read-Host "Foute keuze. Probeer opnieuw."
                    }
                    Return $variable
        }



    write-host "Script om tegelijk een user voor O365 en SS aan te maken." 
    write-host "_________________________________________________________" 

#  A - VERBINDING - de gegevens om verbinding te maken met Smartschool platform.

    $urlSmartschool = "**https://jouwschoolnaam.smartschool.be/Webservices/V3?wsdl"
    $accesscode = "**code-die-je-hebt-ingesteld-bij-algemene-configuratie-webservices"



#  B - INFORMATIE - input van de gebruiker voor alle info te verkrijgen
#  hier moet je als school keuzes maken - welke info wil je van welke rol verzamelen?
#  bij het onderdeel C - SMARTSCHOOL kan je namelijk nog veel meer gegevens verzamelen dan die hier staan
#  je voegt hier dan een variable toe die je een waarde geeft via read-host. Die variable zet je dan bij in de lijst bij C - SMARTSCHOOL

    $rol             = Foolproofkeuze -variable $rol -tekst "de basisrol" -keuze1 "leerkracht" -keuze2 "leerling"
    $voornaam        = read-host "Geef de voornaam van de $rol (zonder accenten)."
    $achternaam      = read-host "Geef de achternaam van de $rol $voornaam (zonder accenten)."
    $mailprive       = read-host "Geef het e-mailmailadres van de $rol of het adres naar waar je de gegevens wilt sturen."
    $geslacht        = Foolproofkeuze -variable $geslacht -tekst "het geslacht" -keuze1 "m" -keuze2 "v"
    $geboorte        = read-host "Geef de geboortedatum in het volgende format DD-MM-YYYY"
    $gebruikersnaam  = "$voornaam.$achternaam".ToLower()

    #  hiermee kan je de gebruikersnaam aanpassen, als de automatisch aangemaakte gebruikersnaam al zou bestaan
    $keuzegebruikersnaam = read-host "Is de gebruikersnaam $gebruikersnaam correct? j/n"
    if ($keuzegebruikersnaam -eq "n")
        {
            $keuzenaam = read-host "Geef de gebruikersnaam van de $rol $voornaam $achternaam (zonder accenten, in de vorm voornaam.achternaam)".ToLower()
            $gebruikersnaam = $keuzenaam.ToLower()
            "Gebruikersnaam = $gebruikersnaam".ToLower()
        }
    else
        {
            $gebruikersnaam = "$voornaam.$achternaam".ToLower()
            "Gebruikersnaam = $gebruikersnaam".ToLower()
        }
   
    $wachtwoord      = read-host "Geef een tijdelijk wachtwoord voor $gebruikersnaam."

    #  om de co-accounts aan te maken van een leerling op SS 
    if ($rol -eq "leerling")
        {
            $stamboek = read-host "Wat is het stamboeknummer van de leerling?"
            $co_1_rol = Foolproofkeuze -variable $co_1_rol -tekst "het type account van co-account 1" -keuze1 "moeder" -keuze2 "vader"
            $co_1_voornaam = read-host "Geef de voornaam van de $co_1_rol van $voornaam $achternaam"
            $co_1_achternaam = read-host "Geef de achternaam van de $co_1_rol van $voornaam $achternaam"
            $co_1_wachtwoord = read-host "Geef het wachtwoord van de $co_1_rol van $voornaam $achternaam"

            $co_2_rol = Foolproofkeuze -variable $co_2_rol -tekst "het type account van co-account 2" -keuze1 "moeder" -keuze2 "vader"
            $co_2_voornaam = read-host "Geef de voornaam van de $co_2_rol van $voornaam $achternaam"
            $co_2_achternaam = read-host "Geef de achternaam van de $co_2_rol van $voornaam $achternaam"
            $co_2_wachtwoord = read-host "Geef het wachtwoord van de $co_2_rol van $voornaam $achternaam"
        }



# C - O365 - Aanmaken van O365 user

    if ($rol -eq "leerkracht")  
        {
            connect-msolservice
            New-Msoluser –userprincipalname "**$gebruikersnaam@domein.be" `
            -displayname "$voornaam $achternaam" `
            -password $wachtwoord `
            –firstname $voornaam `
            -lastname $achternaam `
            -passwordneverexpires 1 `
            -forcechangepassword 1 `
            -LicenseAssignment **domein:STANDARDWOFFPACK_FACULTY `
            -usagelocation BE `
            -PreferredLanguage nl
        }

    else 
        {
            connect-msolservice
            New-Msoluser –userprincipalname "**$gebruikersnaam@leerling.domein.be" `
            -displayname "$voornaam $achternaam" `
            -password $wachtwoord `
            –firstname $voornaam `
            -lastname $achternaam `
            -passwordneverexpires 1 `
            -forcechangepassword 1 `
            -LicenseAssignment **domein:STANDARDWOFFPACK_STUDENT `
            -usagelocation BE `
            -PreferredLanguage nl
        }



# D - SMARTSCHOOL - de gebruiker toevoegen aan Smartschool en de co-accounts instellen

    $proxy = New-WebServiceProxy -Uri $urlSmartschool
    $proxy.SaveUser($accesscode,`           #webaccesscode
                   '',`                     #intern nummer
                   $gebruikersnaam,`        #gebruikersnaam
                   $wachtwoord,`            #wachtwoord
                   $co_1_wachtwoord,`       #wachtwoord co-account 1
                   $co_2_wachtwoord,`       #wachtwoord co-account 2
                   $voornaam,`              #voornaam
                   $achternaam,`            #achternaam
                   '',`                     #extra voornamen
                   '',`                     #initialen
                   $geslacht,`              #geslacht 'm' of 'v'
                   $geboorte,`              #geboortedatum DD-MM-YYYY
                   '',`                     #geboorteplaats
                   '',`                     #geboorteland
                   '',`                     #straat en nummer
                   '',`                     #postcode
                   '',`                     #stad/gemeente
                   '',`                     #land
                   '',`                     #het e-mailadres van de gebruiker
                   '',`                     #mobielnummer
                   '',`                     #telefoonnummer
                   '',`                     #fax
                   '',`                     #rijksregisternummer
                   $stamboek,`              #stamboeknummer
                   $rol,`                   #basisrol
                   $koppelingsveld);        #koppelingsveld schoolagenda

    $proxy.saveUserParameter($accesscode,  $gebruikersnaam, 'type_coaccount1', $co_1_rol)
    $proxy.saveUserParameter($accesscode,  $gebruikersnaam, 'naam_coaccount1', $co_1_achternaam)
    $proxy.saveUserParameter($accesscode,  $gebruikersnaam, 'voornaam_coaccount1', $co_1_voornaam)
    $proxy.saveUserParameter($accesscode,  $gebruikersnaam, 'type_coaccount2', $co_2_rol)
    $proxy.saveUserParameter($accesscode,  $gebruikersnaam, 'naam_coaccount2', $co_2_achternaam)
    $proxy.saveUserParameter($accesscode,  $gebruikersnaam, 'voornaam_coaccount2', $co_2_voornaam)


    $proxy.forcePasswordReset($accesscode, $gebruikersnaam, '0')
    $proxy.forcePasswordReset($accesscode, $gebruikersnaam, '1')
    $proxy.forcePasswordReset($accesscode, $gebruikersnaam, '2')


    write-host "De nieuwe gebruiker is aangemaakt! Driewerf hoera!"
    write-host "---------------------------------"



# E - MAIL - 

    if ($rol -eq "leerkracht")
    {     
        write-host " "
        $antwoordmail = Read-host "Wil je de gegevens per mail naar de gebruikers sturen? (j/n)"
        write-host " "

        if ($antwoordmail -eq "j") 
        {
            send-mailmessage -smtpserver uit.telenet.be `
                -from "**kies-een-e-mailadres" `
                -to "$mailprive" `
                -cc "**kies-een-e-mailadres" `
                -subject "$voornaam $achternaam - Gegevens voor Office 365 en Smartschool" `
                -body "Dag $voornaam<br><br>Hieronder vind je de gegevens om in te loggen op Smartschool en Office 365.`
                                    <br><br>Gebruikersnaam Smartschool (**eigen-url-smartschool):      $gebruikersnaam`
                                    <br>Gebruikersnaam Office 365 (www.office.com):                                  **$gebruikersnaam@domein.be`
                                    <br>Wachtwoord voor beide systemen (hoofdlettergevoelig):                        $wachtwoord`
                                    <br>De eerste keer dat je inlogt, zal je een melding krijgen om je wachtwoord te wijzigen.`
                                    <br><br>Veel succes op onze school`
                                    <br><br>Met vriendelijke groeten`
                                    <br>ICT-dienst" `
                -BodyAsHtml `
                -DeliveryNotificationOption OnSuccess, OnFailure
            }
        else 
            { 
                write-host "Oké, de mail wordt niet verstuurd."
            }
           
    }

    else
    {     
        write-host " "
        $antwoordmail = Read-host "Wil je de gegevens per mail naar de gebruikers sturen? (j/n)"
        write-host " "

        if ($antwoordmail -eq "j") 
        {
            send-mailmessage -smtpserver uit.telenet.be `
                -from "**kies-een-e-mailadres" `
                -to "$mailprive" `
                -cc "**kies-een-e-mailadres" `
                -subject "$voornaam $achternaam - Gegevens voor Office 365 en Smartschool" `
                -body "Dag $voornaam<br><br>Hieronder vind je de gegevens om in te loggen op Smartschool en Office 365.`
                                    <br><br>Gebruikersnaam Smartschool (*eigen-url-smartschool):      $gebruikersnaam`
                                    <br>Gebruikersnaam Office 365 (www.office.com):                                  **$gebruikersnaam@leerling.domein.be`
                                    <br>Wachtwoord voor beide systemen (hoofdlettergevoelig):                        $wachtwoord`
                                    <br>De eerste keer dat je inlogt, zal je een melding krijgen om je wachtwoord te wijzigen.`
                                    <br><br>Je ouders hebben ook een acccount op Smartschool`
                                    <br>Gebruikersnaam van je $co_1_rol is $gebruikersnaam en het wachtwoord is      $co_1_wachtwoord`
                                    <br>Gebruikersnaam van je $co_2_rol is $gebruikersnaam en het wachtwoord is      $co_2_wachtwoord`
                                    <br><br>Veel succes op onze school`
                                    <br><br>Met vriendelijke groeten`
                                    <br>ICT-dienst" `
                -BodyAsHtml `
                -DeliveryNotificationOption OnSuccess, OnFailure
         }
        else 
            { 
                write-host "Oké, de mail wordt niet verstuurd." 
            }
            
    }

Read-Host "Het script is afgelopen. Je kunt de gegevens nog kopiëren als je wilt of op ENTER drukken om af te sluiten."