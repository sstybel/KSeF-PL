Clear-Host

$QUIET = "" # Pokazuj komunikaty na ekranie
#$QUIET = "--quiet" # Odkomentuj jeśli chcesz włączyć tryb cichy - bez pokazywania komunikatów na ekranie

if ($QUIET -eq "") {
    Write-Host "Pobieranie faktur z systemu KSeF"
    Write-Host "Copyright © 2025 - 2026 by Sebastian Stybel, www.BONO-IT.pl"
    Write-Host "----------------------------------------------------------------------"
}

$LocDIR = (Get-Location).Path # Tu podaj ścieżkę do bazowego katalogu, gdzie będą pobierane faktury z KSeF (domyślnie: katalog z którego uruchomiono skrypt)
$ROK = (Get-Date).ToString("yyyy") # Bieżący rok (np. 2026)
$MIE = (Get-Date).ToString("MM") # Bieżący miesiąc (np. 03)
$DZI = "01" # Pierwszy (01) dzień miesiąca

$KSeFNIP = "1234567890" # Tu podaj NIP firmy
$KSeFToken = "20260201-EC-1A2B3C4D5E-1122334455-AB|nip-1234567890|11aa22bb33cc44dd55ee66ff77aa88bb99cc00dd11ee22ff33aa44bb55cc66dd" # Tu podaj Token KSeF
$KSeFDownloadStart = $ROK + "-" + $MIE + "-" + $DZI # Data (np. 2026-03-01) od kiedy mają być pobierane faktury
$KSeFJSONStateDIR = "$LocDIR/$ROK/$MIE/_KSeF_/State/JSON/" # Ścieżka do katalogu ze stanem pobierania faktur KSeF dla formatu JSON
$KSeFJSONOutputDIR = "$LocDIR/$ROK/$MIE/_KSeF_/" # Ścieżka do katalogu wyjściowego dla wykazu faktur w formacie JSON
$KSeFCSVStateDIR = "$LocDIR/$ROK/$MIE/_KSeF_/State/CSV/" # Ścieżka do katalogu ze stanem pobierania faktur KSeF dla formatu CSV
$KSeFCSVOutputDIR = "$LocDIR/$ROK/$MIE/_KSeF_/" # Ścieżka do katalogu wyjściowego dla wykazu faktur w formacie CSV
$KSeFOutputFileNameJSON = "ksef_output_$ROK$MIE.json"  # Nazwa pliku wyjściowego z wykazem faktur w formacie JSON
$KSeFOutputFileNameCSV = "ksef_output_$ROK$MIE.csv" # Nazwa pliku wyjściowego z wykazem faktur w formacie CSV
$KSeFOutputJSON = "$KSeFJSONOutputDIR$KSeFOutputFileNameJSON" # Lokalizacja i nazwa pliku z wykazem faktur w formacie JSON - wykorzystywana przez program (ksef-pdf-generator.exe) generujący faktury w formacie PDF
$KSeFInvSub1DIR = "$LocDIR/$ROK/$MIE/Faktury-Sprzedaz/" # Ścieżka do katalogu, gdzie mają być pobierane faktury sprzedażowe (KSeF - Subject1)
$KSeFInvSub2DIR = "$LocDIR/$ROK/$MIE/Faktury-Zakupowe/" # Ścieżka do katalogu, gdzie mają być pobierane faktury zakupowe (KSeF - Subject2)

# Tworzenie struktury katalogowej
$NewDir = New-Item -ItemType Directory -Path $KSeFCSVOutputDIR -Force -ErrorAction SilentlyContinue
$NewDir = New-Item -ItemType Directory -Path $KSeFJSONOutputDIR -Force -ErrorAction SilentlyContinue
$NewDir = New-Item -ItemType Directory -Path $KSeFCSVStateDIR -Force -ErrorAction SilentlyContinue
$NewDir = New-Item -ItemType Directory -Path $KSeFJSONStateDIR -Force -ErrorAction SilentlyContinue
$NewDir = New-Item -ItemType Directory -Path $KSeFInvSub1DIR -Force -ErrorAction SilentlyContinue
$NewDir = New-Item -ItemType Directory -Path $KSeFInvSub2DIR -Force -ErrorAction SilentlyContinue

# Pobieranie faktur sprzedażowych i zakupowych w formacie KSeF XML
& $LocDIR/_Apps_/ksef-xml-download.exe --nip $KSeFNIP --token $KSeFToken --subject-type Subject1and2 --download-xml --xml-sub1-output-dir $KSeFInvSub1DIR --xml-sub2-output-dir $KSeFInvSub2DIR --ksef-state-dir $KSeFJSONStateDIR --output json --output-filename $KSeFOutputFileNameJSON --output-append --output-dir $KSeFJSONOutputDIR --date-from $KSeFDownloadStart $QUIET

# Pobieranie wykazu faktur sprzedażowych i zakupowych w formacie CSV
& $LocDIR/_Apps_/ksef-xml-download.exe --nip $KSeFNIP --token $KSeFToken --subject-type Subject1and2 --xml-sub1-output-dir $KSeFInvSub1DIR --xml-sub2-output-dir $KSeFInvSub2DIR --ksef-state-dir $KSeFCSVStateDIR --output csv --output-filename $KSeFOutputFileNameCSV --output-append --output-dir $KSeFCSVOutputDIR --date-from $KSeFDownloadStart $QUIET

# Generowanie wizualizacji faktur w formacie PDF (PDF/A-3 standard - ISO 19005-3:2012) na podstawie pobranych faktur XML z systemu KSeF
& $LocDIR/_Apps_/ksef-pdf-generator.exe --state $KSeFOutputJSON $QUIET
