#  script deels gehaald van https://github.com/stefan73be - aangepast naar eigen noden
#  maakt een SS en O365 user (lln of lkr) aan en mailt alle gegevens naar een e-mailadres
#  lees eerst de bijhorende readme - je moet namelijk een aantal zaken installeren en configureren


#  A - VERBINDING - de gegevens om verbinding te maken met Smartschool platform.
    $urlSmartschool = "**https://jouwschoolnaam.smartschool.be/Webservices/V3?wsdl"
    $accesscode = "**code-die-je-hebt-ingesteld-bij-algemene-configuratie-webservices"


#  B - INFORMATIE - input van de gebruiker voor alle info te verkrijgen
#  hier moet je als school keuzes maken - welke info wil je van welke rol verzamelen?
#  bij het onderdeel C - SMARTSCHOOL kan je namelijk nog veel meer gegevens verzamelen dan die hier staan

        #  aanmaken van een form
        Add-Type -AssemblyName System.Windows.Forms

        $SS_O365                    = New-Object system.Windows.Forms.Form
        $SS_O365.ClientSize         = '1650,950'
        $SS_O365.text               = "GUI script - users O365 en SS"
        $SS_O365.BackColor          = "#ADCDBE"
        $SS_O365.MaximizeBox = $true

        # Toevoegen van een icoon
        $iconBase64      = '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'
        $iconBytes       = [Convert]::FromBase64String($iconBase64)
        $stream          = New-Object IO.MemoryStream($iconBytes, 0, $iconBytes.Length)
        $stream.Write($iconBytes, 0, $iconBytes.Length);
        $iconImage       = [System.Drawing.Image]::FromStream($stream, $true)
        $SS_O365.Icon       = [System.Drawing.Icon]::FromHandle((New-Object System.Drawing.Bitmap -Argument $stream).GetHIcon())
        
        # FUNCTIES die het maken van tekst, keuzevakken ... gemakkelijker maken
                #toevoegen van tekst
                function tekstlabel {
                    [CmdletBinding()]
                    Param(
                        [Parameter(Mandatory=$true)]
                        [string]$Location,
                        [Parameter(Mandatory=$true)]
                        [string]$font,
                        [Parameter(Mandatory=$false)]
                        [string]$Text = ''
                    )
                    $tlabel = New-Object Windows.Forms.Label
                    $tlabel.Location = $Location
                    $tlabel.Font     = $font
                    $tlabel.Text     = $Text
                    $tlabel.AutoSize = $True
                    return $tlabel
                }

                #toevoegen van een dropdownlist
                function keuzebox {
                    [CmdletBinding()]
                    Param(
                        [Parameter(Mandatory=$true)]
                        [string]$kboxlocation,
                        [Parameter(Mandatory=$true)]
                        [string]$kboxfont,
                        [Parameter(Mandatory=$true)]
                        [string]$kboxwidth,
                        [Parameter(Mandatory=$true)]
                        [string]$kboxitem1,
                        [Parameter(Mandatory=$true)]
                        [string]$kboxitem2=''
                    )
                    $kbox = New-Object system.Windows.Forms.ComboBox
                    $kbox.Location      = $kboxlocation
                    $kbox.Font          = $kboxfont
                    $kbox.width         = $kboxwidth
                    $kbox.AutoSize      = $True
                    @($kboxitem1, $kboxitem2) | ForEach-Object {[void] $kbox.Items.Add($_)}
                    return $kbox
                }

                #toevoegen van een invoervak
                function tekstvak {
                    [CmdletBinding()]
                    Param(
                        [Parameter(Mandatory=$true)]
                        [string]$tvaklocation,
                        [Parameter(Mandatory=$true)]
                        [string]$tvakfont,
                        [Parameter(Mandatory=$true)]
                        [string]$tvakwidth,
                        [Parameter(Mandatory=$true)]
                        [string]$tvakheight=''
                    )
                    $tvak = New-Object system.Windows.Forms.TextBox
                    $tvak.Location      = $tvaklocation
                    $tvak.Font          = $tvakfont
                    $tvak.width         = $tvakwidth
                    $tvak.AutoSize      = $True
                    $tvak.multiline     = $false
                    $tvak.height         =$tvakheight
                    return $tvak
                }



        # Start van de infoverzameling

                # Titel form
                $Titel = tekstlabel -Location "20,20" -font "Microsoft Sans Serif,15" -Text "Een script om tegelijk een O365 en SS user aan te maken."

                # basisrol van de gebruiker
                $Titel_form_rol     = tekstlabel -Location "20,70" -font "Microsoft Sans Serif,11" -Text "Kies de basisrol."
                $form_rol           = keuzebox -kboxlocation "20,110" -kboxfont "Microsoft Sans Serif,10" -kboxwidth "200" -kboxitem1 "leerling" -kboxitem2 "leerkracht" 

                # voornaam van de gebruiker
                $Titel_form_voornaam = tekstlabel -Location "20,150" -font "Microsoft Sans Serif,11" -Text "Voornaam van de gebruiker"     
                $form_voornaam = tekstvak -tvaklocation "20,190" -tvakfont "Microsoft Sans Serif,10" -tvakwidth "314" -tvakheight "20"       
                $form_voornaam.add_TextChanged({$form_gebruikersnaam.Text = $form_voornaam.Text.ToLower() + "." + $form_achternaam.Text.ToLower()})

                # achternaam van de gebruiker
                $Titel_form_achternaam = tekstlabel -Location "20,230" -font "Microsoft Sans Serif,11" -Text "Achternaam van de gebruiker"  
                $form_achternaam = tekstvak -tvaklocation "20,270" -tvakfont "Microsoft Sans Serif,10" -tvakwidth "314" -tvakheight "20"       
                $form_achternaam.add_TextChanged({$form_gebruikersnaam.Text = $form_voornaam.Text.ToLower() + "." + $form_achternaam.Text.ToLower()})
 
                # mail om de info naar te sturen
                $Titel_form_mail = tekstlabel -Location "20,310" -font "Microsoft Sans Serif,11" -Text "E-mailadres naar waar je de gegevens wilt sturen"  
                $form_mail = tekstvak -tvaklocation "20,350" -tvakfont "Microsoft Sans Serif,10" -tvakwidth "314" -tvakheight "20"       
 
                # geslacht van de gebruiker
                $Titel_form_geslacht     = tekstlabel -Location "20,390" -font "Microsoft Sans Serif,11" -Text "Geslacht."
                $form_geslacht           = keuzebox -kboxlocation "20,430" -kboxfont "Microsoft Sans Serif,10" -kboxwidth "200" -kboxitem1 "m" -kboxitem2 "v" 

                # Geboortedam van de gebruiker
                $Titel_form_geboorte = tekstlabel -Location "20,470" -font "Microsoft Sans Serif,11" -Text "Geboortedatum DD-MM-YYYY"
                $form_geboorte = tekstvak -tvaklocation "20,510" -tvakfont "Microsoft Sans Serif,10" -tvakwidth "314" -tvakheight "20"       
 
                # Gebruikersnaam in de vorm van voornaam.achternaam
                $Titel_form_gebruikersnaam = tekstlabel -Location "20,550" -font "Microsoft Sans Serif,11" -Text "Gebruikersnaam"
                $form_gebruikersnaam = tekstvak -tvaklocation "20,590" -tvakfont "Microsoft Sans Serif,10" -tvakwidth "314" -tvakheight "20"       

                # Wachtwoord van de gebruikers
                $Titel_form_wachtwoord = tekstlabel -Location "20,630" -font "Microsoft Sans Serif,11" -Text "Kies een tijdelijk wachtwoord: hoofdletter, kleine letter en ander teken - minstens 8 tekens"
                $form_wachtwoord = tekstvak -tvaklocation "20,670" -tvakfont "Microsoft Sans Serif,10" -tvakwidth "314" -tvakheight "20"       

                # Stamboeknummer (leerling)
                $Titel_form_stamboek = tekstlabel -Location "20,710" -font "Microsoft Sans Serif,11" -Text "Stamboeknummer 1234567"
                $form_stamboek = tekstvak -tvaklocation "20,750" -tvakfont "Microsoft Sans Serif,10" -tvakwidth "200" -tvakheight "20"       

                # Het soort account van co-account 1
                $Titel_form_type_co_1     = tekstlabel -Location "20,790" -font "Microsoft Sans Serif,11" -Text "Kies het type van co-account 1."
                $form_type_co_1           = keuzebox -kboxlocation "20,830" -kboxfont "Microsoft Sans Serif,10" -kboxwidth "200" -kboxitem1 "moeder" -kboxitem2 "vader" 
 
                # Voornaam van co-account 1
                $Titel_form_co_1_voornaam = tekstlabel -Location "365,790" -font "Microsoft Sans Serif,11" -Text "Voornaam van de gebruiker"
                $form_co_1_voornaam  = tekstvak -tvaklocation "370,830" -tvakfont "Microsoft Sans Serif,10" -tvakwidth "200" -tvakheight "20"       

                # Achtrernaam van co-account 1
                $Titel_form_co_1_achternaam = tekstlabel -Location "615,790" -font "Microsoft Sans Serif,11" -Text "Achternaam van de gebruiker"
                $form_co_1_achternaam  = tekstvak -tvaklocation "620,830" -tvakfont "Microsoft Sans Serif,10" -tvakwidth "200" -tvakheight "20"       

                # Wachtwoord van co-account 1
                $Titel_form_co_1_wachtwoord = tekstlabel -Location "865,790" -font "Microsoft Sans Serif,11" -Text "Kies een tijdelijk wachtwoord: hoofdletter, kleine letter en ander teken - minstens 8 tekens"
                $form_co_1_wachtwoord  = tekstvak -tvaklocation "870,830" -tvakfont "Microsoft Sans Serif,10" -tvakwidth "200" -tvakheight "20"       
      
                # Het soort account van co-account 2
                $Titel_form_type_co_2     = tekstlabel -Location "20,870" -font "Microsoft Sans Serif,11" -Text "Kies het type van co-account 2."
                $form_type_co_2           = keuzebox -kboxlocation "20,910" -kboxfont "Microsoft Sans Serif,10" -kboxwidth "200" -kboxitem1 "moeder" -kboxitem2 "vader" 
      
                # Voornaam van co-account 2
                $Titel_form_co_2_voornaam = tekstlabel -Location "365,870" -font "Microsoft Sans Serif,11" -Text "Voornaam van de gebruiker"
                $form_co_2_voornaam  = tekstvak -tvaklocation "370,910" -tvakfont "Microsoft Sans Serif,10" -tvakwidth "200" -tvakheight "20"       
     
                # Achternaam van co-account 2
                $Titel_form_co_2_achternaam = tekstlabel -Location "615,870" -font "Microsoft Sans Serif,11" -Text "Achternaam van de gebruiker"
                $form_co_2_achternaam  = tekstvak -tvaklocation "620,910" -tvakfont "Microsoft Sans Serif,10" -tvakwidth "200" -tvakheight "20"       

                # Wachtwoord van co-account 2
                $Titel_form_co_2_wachtwoord = tekstlabel -Location "865,870" -font "Microsoft Sans Serif,11" -Text "Kies een tijdelijk wachtwoord: hoofdletter, kleine letter en ander teken - minstens 8 tekens"
                $form_co_2_wachtwoord  = tekstvak -tvaklocation "870,910" -tvakfont "Microsoft Sans Serif,10" -tvakwidth "200" -tvakheight "20"       
       

        # Het tonen en verbergen van info die alleen voor leerlingen moet worden ingevuld
        $form_rol.add_SelectedIndexChanged(
        {
            if ($form_rol.SelectedItem -eq "leerling") 
            {
                $Titel_form_stamboek.Visible              = $true
                $form_stamboek.Visible                    = $true
                $Titel_form_type_co_1.Visible             = $true
                $form_type_co_1.Visible                   = $true
                $Titel_form_co_1_voornaam.Visible         = $true
                $form_co_1_voornaam.Visible               = $true
                $Titel_form_co_1_achternaam.Visible       = $true
                $form_co_1_achternaam.Visible             = $true
                $Titel_form_type_co_2.Visible             = $true
                $form_type_co_2.Visible                   = $true
                $Titel_form_co_2_voornaam.Visible         = $true
                $form_co_2_voornaam.Visible               = $true
                $Titel_form_co_2_achternaam.Visible       = $true
                $form_co_2_achternaam.Visible             = $true
                $Titel_form_co_1_wachtwoord.Visible       = $true
                $form_co_1_wachtwoord.Visible             = $true
                $Titel_form_co_2_wachtwoord.Visible       = $true
                $form_co_2_wachtwoord.Visible             = $true
            }

            else 
            {
    
                $Titel_form_stamboek.Visible              = $false
                $form_stamboek.Visible                    = $false
                $Titel_form_type_co_1.Visible             = $false
                $form_type_co_1.Visible                   = $false
                $Titel_form_co_1_voornaam.Visible         = $false
                $form_co_1_voornaam.Visible               = $false
                $Titel_form_co_1_achternaam.Visible       = $false
                $form_co_1_achternaam.Visible             = $false
                $Titel_form_type_co_2.Visible             = $false
                $form_type_co_2.Visible                   = $false
                $Titel_form_co_2_voornaam.Visible         = $false
                $form_co_2_voornaam.Visible               = $false
                $Titel_form_co_2_achternaam.Visible       = $false
                $form_co_2_achternaam.Visible             = $false
                $Titel_form_co_1_wachtwoord.Visible       = $false
                $form_co_1_wachtwoord.Visible             = $false
                $Titel_form_co_2_wachtwoord.Visible       = $false
                $form_co_2_wachtwoord.Visible             = $false
        }    


    })


            # KNOPPEN - Bevestigen en annuleren van info
                $ok                   = New-Object system.Windows.Forms.Button
                $ok.BackColor         = "#15670F"
                $ok.text              = "OK"
                $ok.width             = 90
                $ok.height            = 30
                $ok.location          = New-Object System.Drawing.Point(870,20)
                $ok.Font              = 'Microsoft Sans Serif,10'
                $ok.ForeColor         = "#ffffff"


                $annuleer                       = New-Object system.Windows.Forms.Button
                $annuleer.BackColor             = "#ffffff"
                $annuleer.text                  = "Annuleer"
                $annuleer.width                 = 90
                $annuleer.height                = 30
                $annuleer.location              = New-Object System.Drawing.Point(760,20)
                $annuleer.Font                  = 'Microsoft Sans Serif,10'
                $annuleer.ForeColor             = "#000"
                $annuleer.DialogResult          = [System.Windows.Forms.DialogResult]::Cancel
                $SS_O365.CancelButton   = $annuleer
                $SS_O365.Controls.Add($annuleer)






# Wat er moet gebeuren bij "OK" klikken = start van script dat de users aanmaakt
$ok.Add_Click({ toevoegen })


function toevoegen { 
       $rol = $form_rol.SelectedItem
       $voornaam = $form_voornaam.Text
       $achternaam = $form_achternaam.Text
       $mailprive = $form_mail.text
       $geslacht = $form_geslacht.SelectedItem
       $geboorte = $form_geboorte.text
       $gebruikersnaam = $form_gebruikersnaam.text
       $wachtwoord = $form_wachtwoord.text
       $stamboek = $form_stamboek.text
       $co_1_rol = $form_type_co_1.SelectedItem
       $co_1_voornaam = $form_co_1_voornaam.Text
       $co_1_achternaam = $form_co_1_achternaam.Text
       $co_1_wachtwoord = $form_co_1_wachtwoord.Text
       $co_2_rol = $form_type_co_2.SelectedItem
       $co_2_voornaam = $form_co_2_voornaam.Text
       $co_2_achternaam = $form_co_2_achternaam.Text
       $co_2_wachtwoord = $form_co_2_wachtwoord.Text   




$SS_O365.Close()


[System.Windows.MessageBox]::Show('Gebruiker wordt aangemaakt ... Vul je O365 gegevens in als admin.')

     
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


# E - MAIL - 

    if ($rol -eq "leerkracht")
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
        
            send-mailmessage -smtpserver uit.telenet.be `
                -from "**kies-een-e-mailadres" `
                -to "$mailprive" `
                -cc "**kies-een-e-mailadres" `
                -subject "$voornaam $achternaam - Gegevens voor Office 365 en Smartschool" `
                -body "Dag $voornaam<br><br>Hieronder vind je de gegevens om in te loggen op Smartschool en Office 365.`
                                    <br><br>Gebruikersnaam Smartschool (**eigen-url-smartschool):      $gebruikersnaam`
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
        
            
    }



$SS_O365.controls.AddRange(@($Titel,$Titel_form_rol,$form_rol,$Titel_form_voornaam,$form_voornaam,$Titel_form_achternaam,$form_achternaam,$Titel_form_mail,$form_mail, $Titel_form_geslacht, $form_geslacht,$Titel_form_geboorte,$form_geboorte, $Titel_form_gebruikersnaam ,$form_gebruikersnaam ,$Titel_form_wachtwoord ,$form_wachtwoord ,$Titel_form_stamboek,$form_stamboek,$Titel_form_type_co_1,$form_type_co_1,$Titel_form_co_1_voornaam,$form_co_1_voornaam, $Titel_form_co_1_achternaam,$form_co_1_achternaam,$Titel_form_type_co_2,$form_type_co_2,$Titel_form_co_2_voornaam,$form_co_2_voornaam, $Titel_form_co_2_achternaam,$form_co_2_achternaam, $Titel_form_co_1_wachtwoord, $form_co_1_wachtwoord, $Titel_form_co_2_wachtwoord, $form_co_2_wachtwoord, $ok,$annuleer))


[void]$SS_O365.ShowDialog()


