# System pobierania faktur z systemu KS<span style="color: red">e</span>F - wersja Polska / [*English version*](https://github.com/sstybel/KSeF-EN)

<a href="https://github.com/sstybel/KSeF-PL/releases/latest"><img alt="Static Badge" src="https://img.shields.io/badge/download-red?style=for-the-badge&label=stable&color=%23FF0000&link=https%3A%2F%2Fgithub.com%2Fsstybel%2FKSeF-PL%2Freleases%2Flatest"></a> ![GitHub Release](https://img.shields.io/github/v/release/sstybel/KSeF-PL?sort=date&display_name=release&style=for-the-badge&logo=github&label=release&link=https%3A%2F%2Fgithub.com%2Fsstybel%2FKSeF-PL) ![GitHub Downloads (all assets, all releases)](https://img.shields.io/github/downloads/sstybel/KSeF-PL/total?style=for-the-badge&logo=github&link=https%3A%2F%2Fgithub.com%2Fsstybel%2FKSeF-PL)

---

## 📘 Spis treści

- [Wstęp](#wstęp)
- [Tworzenie tokenu w systemie **KSeF**](#tworzenie-tokenu-w-systemie-ksef)
- [Niezbędne narzędzia](#niezbędne-narzędzia)
- [Pobieranie faktur w formacie **XML KSeF**](#pobieranie-faktur-w-formacie-xml-ksef)
- [Pobieranie wykazu faktur w formacie **CSV**](#pobieranie-wykazu-faktur-w-formacie-csv)
- [Generowanie wizualizacji faktur w formacie **PDF**](#generowanie-wizualizacji-faktur-w-formacie-pdf)
- [Skrypt automatyzujący proces pobierania i generowania dokumentów z **KSeF** w **Windows PowerShell**](#skrypt-automatyzujący-proces-pobierania-i-generowania-dokumentów-z-ksef-w-windows-powershell)
- [Tworzenie harmonogramu zadań w systemie Windows realizującego automatyzację](#tworzenie-harmonogramu-zadań-w-systemie-windows-realizującego-automatyzację)

## Wstęp

W niniejszym dokumencie opisane zostanie użycie dwóch narzędzi do:
1.	Pobierania faktur w formacie **XML KSeF** - [**KSeF XML Download**](https://github.com/sstybel/ksef-xml-download)
2.	Generowania wizualizacji faktur w formacie PDF na podstawie faktur **XML KSeF** - [**KSeF PDF Generator**](https://github.com/sstybel/ksef-pdf-generator)

Opracowanie skupia się na stworzeniu automatyzacji polegającej na cyklicznym (co 4h) sprawdzaniu dostępności nowych faktur (sprzedażowych i zakupowych) w systemie **KSeF**. Jeśli pojawią się w systemie **KSeF** nowe faktury (sprzedażowe lub/i zakupowe), skrypt automatyzujący wykonuje następujące 3 czynności:
1.	Pobiera faktury **XML KSeF** sprzedażowe lub/i zakupowe do odpowiednich folderów, tj.:
    1.	Sprzedażowe: `[DYSK]:\[LOKALIZACJA]\[ROK]\[MIESIAC]\Faktury-Sprzedaz\` (np. `C:\KSeF\2026\03\Faktury-Sprzedaz\`);
    2. Zakupowe: `[DYSK]:\[LOKALIZACJA]\[ROK]\[MIESIAC]\Faktury-Zakupowe\` (np. `C:\KSeF\2026\03\Faktury-Zakupowe\`);
2.	Uaktualnia bieżący (za dany miesiąc) wykaz faktur do pliku **CSV** i umieszcza go w katalogu: `[DYSK]:\[LOKALIZACJA]\[ROK]\[MIESIAC]\_KSeF_\ksef_output[ROK][MIESIAC].csv` (np. `C:\KSeF\2026\03\_KSeF_\ksef_output202603.csv`);
3.	Generuje wizualizacje faktur w formacie **PDF** wg standardu [**PDF/A-3**](https://pl.wikipedia.org/wiki/PDF/A#PDF/A-3) ([**ISO 19005-3:2012**](https://www.iso.org/standard/57229.html)) na podstawie pobranych faktur w formacie **XML KSeF** i umieszcza je w tej samej lokalizacji – patrz punk 1.

Każdy miesiąc będzie posiadał swoją niezależną strukturę katalogów z wykazem faktur **KSeF XML**, listą dokumentów w pliku **CSV** oraz reprezentacją wizualną faktur w formacie **PDF**.

## Tworzenie tokenu w systemie KSeF

Do poprawnego funkcjonowania narzędzia [**KSeF XML Download**](https://github.com/sstybel/ksef-xml-download), niezbędne jest skonfigurowanie jednego z dwóch  mechanizmów uwierzytelniania w systemie **KSeF**:

1.	Uwierzytelnianie Certyfikatem;
2.	Uwierzytelnianie Tokenem;

Na potrzeby tej automatyzacji wybrano metodę **uwierzytelniania Tokenem**.

Możesz wykorzystać już posiadany token lub ze względów bezpieczeństwa wygenerować nowy token na potrzeby skryptu.

W tym celu wchodzimy na stronę [**Krajowego Systemu e-Faktur**](https://ksef.podatki.gov.pl/) – [**https://ksef.podatki.gov.pl/**](https://ksef.podatki.gov.pl/) i wybieramy przycisk **„[`Zaloguj się do KSeF`](https://ap.ksef.mf.gov.pl/web/)”**.

![Screen-Shot](https://github.com/sstybel/KSeF-PL/blob/main/images/01.png)

Przeniesie nas na stronę logowania, gdzie wybieramy kafelek **„[`Uwierzytelnij się w Krajowym Systemie e-Faktur`](https://ap.ksef.mf.gov.pl/web/)”**.

![Screen-Shot](https://github.com/sstybel/KSeF-PL/blob/main/images/02.png)

Jako sposób logowania wybieramy **„[`Zaloguj przez login.gov.pl`](https://ap.ksef.mf.gov.pl/web/login)”**.

![Screen-Shot](https://github.com/sstybel/KSeF-PL/blob/main/images/03.png)

Następnie podajemy **NIP** podmiotu dla którego będziemy pobierać faktury **KSeF** i klikamy przycisk **„`Uwierzytelnij`”**.

![Screen-Shot](https://github.com/sstybel/KSeF-PL/blob/main/images/04.png)

W kolejnym kroku wybieramy sposób logowania do usług [**Ministerstwa Finansów**](https://www.gov.pl/web/finanse), np. z wykorzystaniem aplikacji [**mObywatel**](https://www.gov.pl/web/mobywatel).

![Screen-Shot](https://github.com/sstybel/KSeF-PL/blob/main/images/05.png)

Po uwierzytelnieniu, zalogowało nas w **Krajowym Systemie e-Faktur – Aplikacja Podatnika KSeF**, gdzie udajemy się do sekcji **„`Tokeny`”** i wybieramy **„`Generuj token`”**.

![Screen-Shot](https://github.com/sstybel/KSeF-PL/blob/main/images/06.png)

Wypełniamy formularz podając:
1.	Nazwę tokena;
2.	Ustawiając uprawnienia dla tokena – zaznaczmy „przeglądanie faktur”;
3.	Klikamy przycisk **„`Generuj token`”**.

![Screen-Shot](https://github.com/sstybel/KSeF-PL/blob/main/images/07.png)

Jeśli nie pokaże się token, należy naciskać przycisk **„`Odśwież`”**, aż do momentu gdy zobaczymy token.

![Screen-Shot](https://github.com/sstybel/KSeF-PL/blob/main/images/08.png)

Przeważnie po jednym lub dwóch odświeżeniach zobaczymy nasz nowy token. Token jest wyświetlany tylko jeden raz, więc musisz go skopiować (przycisk **„`Kopiuj`”**) i zapisać w bezpiecznym miejscu, w przeciwnym razie, będziesz musiał go unieważnić i wygenerować ponownie – powtórzyć całą procedurę generowania tokenu od nowa.

![Screen-Shot](https://github.com/sstybel/KSeF-PL/blob/main/images/09.png)

Masz wygenerowany token i możesz przystąpić do testów i konfiguracji skryptu.

## Niezbędne narzędzia

Do wykonania automatyzacji, jak wspomniano we wstępie, potrzebne będą dwa narzędzia, które pobieramy z repozytorium [**GitHub**](https://github.com/sstybel):

1.	[**KSeF XML Download**](https://github.com/sstybel/ksef-xml-download/) - https://github.com/sstybel/ksef-xml-download/releases/latest
2.	[**KSeF PDF Generator**](https://github.com/sstybel/ksef-pdf-generator/) - https://github.com/sstybel/ksef-pdf-generator/releases/latest 

W tym celu tworzymy np. katalog **`KSeF-Firma`** w katalogu głównym na dysku **`M:\`**, w której to lokalizacji zapisujemy pobrane wcześniej z repozytorium [**GitHub**](https://github.com/sstybel) pliki wykonywalne `.exe`. Do tego celu używam powłoki [**Windows PowerShell**](https://learn.microsoft.com/pl-pl/powershell/scripting/what-is-windows-powershell?view=powershell-7.5).

```
PS C:\> m:

PS M:\> cd \

PS M:\> mkdir KSeF-Firma

PS M:\> cd KSeF-Firma

PS M:\KSeF-Firma> Invoke-WebRequest https://github.com/sstybel/ksef-xml-download/releases/download/1.40/ksef-xml-download.exe `
-OutFile .\ksef-xml-download.exe

PS M:\KSeF-Firma> Invoke-WebRequest https://github.com/sstybel/ksef-pdf-generator/releases/download/1.4.0/ksef-pdf-generator.exe `
-OutFile .\ksef-pdf-generator.exe

PS M:\KSeF-Firma> dir

PS M:\KSeF-Firma> dir

    Directory: M:\KSeF-Firma

Mode                  LastWriteTime         Length     Name
-----                 -------------         -------    -----
-a----                18.03.2026  12:00     41685797   ksef-pdf-generator.exe
-a----                18.03.2026  12:00     19273120   ksef-xml-download.exe

PS M:\KSeF-Firma>
```

W ten sposób mamy przegotowane środowisko do dalszej pracy.

## Pobieranie faktur w formacie XML KSeF

Pierwszą czynność jaką wykonamy to pobierzemy faktur zakupowe (**Subject2**) i sprzedażowe (**Subject1**) za miesiąc marzec 2026 (tj. 2026-03-01). Faktury w formacie **XML KSeF** zostaną zapisane do odpowiednich katalogów, np.:

1.	Zakupowe (**Subject2**) - `M:\KSeF-Firma\Faktury-Zakupy\`
2.	Sprzedażowe (**Subject1**) - `M:\KSeF-Firma\Faktury-Sprzedaz\`

W tym celu wykonujemy następujące polecenia:

```
PS M:\KSeF-Firma> mkdir Faktury-Sprzedaz

PS M:\KSeF-Firma> mkdir Faktury-Zakupy

PS M:\KSeF-Firma> dir


    Directory: M:\KSeF-Firma


Mode         LastWriteTime     Length  Name
----         -------------     ------  ----
d-----   18.03.2026  18:19             Faktury-Sprzedaz
d-----   18.03.2026  18:19             Faktury-Zakupy
-a----   18.03.2026  17:01   41685797  ksef-pdf-generator.exe
-a----   18.03.2026  16:58   19273120  ksef-xml-download.exe


PS M:\KSeF-Firma> .\ksef-xml-download.exe --nip 1234567890 `
--token "20260201-EC-1A2B3C4D5E-1122334455-AB|nip-1234567890|11aa22bb33cc44dd55ee66ff77aa88bb99cc00dd11ee22ff33aa44bb55cc66dd" `
--subject-type Subject1and2 `
--download-xml `
--xml-sub1-output-dir .\Faktury-Sprzedaz `
--xml-sub2-output-dir .\Faktury-Zakupy `
--ksef-state-dir .\Stan `
--output json `
--output-filename marzec_2026.json `
--output-append `
--output-dir .\

KSeF XML Invoices Downloader - ver. 1.40
Copyright (c) 2025 - 2026 by Sebastian Stybel, www.BONO-IT.pl
--------------------------------------------------------------------

Connecting to KSeF system (environment: prod)...
NIP (Tax ID): 1234567890
Authentication method: token
Session initialized. Reference number: 20260318-AA-1122334455-AABBCCDDEE-FF

Downloading invoices issued (sales) and received (purchases) - Subject1 and Subject2...
No existing KSeF state found at: .\Stan\ksef_state.json. A new state file will be created at: .\Stan\ksef_state.json
KSeF state saved to: .\Stan\ksef_state.json
{
    "Subject1": [
        {
.....
		}
    ],
    "Subject2": [
        {
.....
        }
    ]
}

Downloading KSeF XML file(s) from issued (sales) - Subject1 to: .\Faktury-Sprzedaz
  Downloaded: .\Faktury-Sprzedaz\1234567890-20260220-112233440000-12.xml
  Downloaded: .\Faktury-Sprzedaz\1234567890-20260228-445566770000-34.xml
  Downloaded: .\Faktury-Sprzedaz\1234567890-20260309-889900AA0000-56.xml
  Downloaded: .\Faktury-Sprzedaz\1234567890-20260312-BBCCDDEE0000-78.xml

Downloading KSeF XML file(s) from received (purchases) - Subject2 to: .\Faktury-Zakupy
  Downloaded: .\Faktury-Zakupy\1122334455-20260216-AA11BB22CC33-55.xml
  Downloaded: .\Faktury-Zakupy\6677889900-20260221-BB00CC99DD88-44.xml
  Downloaded: .\Faktury-Zakupy\1112223334-20260303-321123321123-33.xml
  Downloaded: .\Faktury-Zakupy\5556667778-20260309-456654456654-22.xml
  Downloaded: .\Faktury-Zakupy\1133557799-20260312-778899998877-11.xml

Ending session...
Session ended.

PS M:\KSeF-Firma> tree /f

Folder PATH listing for volume DataSS
Volume serial number is A4F7-F767
M:.
│   ksef-pdf-generator.exe
│   ksef-xml-download.exe
│   marzec_2026.json
│
├───Faktury-Sprzedaz
│       1234567890-20260220-112233440000-12.xml
│       1234567890-20260228-445566770000-34.xml
│       1234567890-20260309-889900AA0000-56.xml
│       1234567890-20260312-BBCCDDEE0000-78.xml
│
├───Faktury-Zakupy
│       1122334455-20260216-AA11BB22CC33-55.xml
│       6677889900-20260221-BB00CC99DD88-44.xml
│       1112223334-20260303-321123321123-33.xml
│       5556667778-20260309-456654456654-22.xml
│       1133557799-20260312-778899998877-11.xml
│
└───Stan
        ksef_state.json

PS M:\KSeF-Firma>
```

Faktury w formacie **XML KSeF** zostały pobrane.

## Pobieranie wykazu faktur w formacie CSV

Kolejną czynność jaką wykonamy to pobranie wykazu faktur za miesiąc marzec 2026 (tj. 2026-03-01). Wykaz faktur zostanie zapisany do pliku w formacie **CSV** (**`marzec_2026.csv`**), który można będzie otworzyć w programie **Excel** w celu dalszej analizy.

W tym celu wykonujemy następujące polecenia:

```
PS M:\KSeF-Firma> .\ksef-xml-download.exe --nip 1234567890 `
--token "20260201-EC-1A2B3C4D5E-1122334455-AB|nip-1234567890|11aa22bb33cc44dd55ee66ff77aa88bb99cc00dd11ee22ff33aa44bb55cc66dd" `
--subject-type Subject1and2 `
--output csv `
--output-filename marzec_2026.csv `
--output-append `
--output-dir .\ `
--xml-sub1-output-dir .\Faktury-Sprzedaz `
--xml-sub2-output-dir .\Faktury-Zakupy

KSeF XML Invoices Downloader - ver. 1.40
Copyright (c) 2025 - 2026 by Sebastian Stybel, www.BONO-IT.pl
--------------------------------------------------------------------

Connecting to KSeF system (environment: prod)...
NIP (Tax ID): 1234567890
Authentication method: token
Session initialized. Reference number: 20260318-CC-9988776655-FFAADDEECC-55

Downloading invoices issued (sales) and received (purchases) - Subject1 and Subject2...
"ksefSubjectType";"ksefNumber";"formSystemCode";"formSchemaVersion";"formValue";"invoiceNumber";"invoiceIssueDate";"invoiceCurrency";"invoiceType";"invoicingMode";"invoiceHash";"sellerNIP";"sellerName";"buyerIdType";"buyerIdValue";"buyerName";"netAmount";"vatAmount";"grossAmount";"qrCode";"fileName"

.....

Ending session...
Session ended.

PS M:\KSeF-Firma> dir

    Directory: M:\KSeF-Firma

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        18.03.2026     19:27                Faktury-Sprzedaz
d-----        18.03.2026     19:27                Faktury-Zakupy
d-----        18.03.2026     19:27                Stan
-a----        18.03.2026     17:01       41685797 ksef-pdf-generator.exe
-a----        18.03.2026     16:58       19273120 ksef-xml-download.exe
-a----        18.03.2026     19:31           4608 marzec_2026.csv
-a----        18.03.2026     19:27          14325 marzec_2026.json
```

Wykaz faktur został pobrany (lub uaktualniony) w pliku **`marzec_2026.csv`**.

![Screen-Shot](https://github.com/sstybel/KSeF-PL/blob/main/images/10.png)

Opis pół nagłowka **CSV** jest następujący:
- **ksefSubjectType** - Typ faktury **KSeF**: **Subject1** (faktura sprzedażowa), **Subject2** (faktura zakupowa);
- **ksefNumber** - Numer  faktury nadany przez system **KSeF**;
- **formSystemCode** - Kod faktury **KSeF** (wersja);
- **formSchemaVersion** - Schemat wersji faktury **KSeF**;
- **formValue** - Rodzaj formularza **KSeF**;
- **invoiceNumber** - Numer faktury nadany przez wystawiającego fakturę;
- **invoiceIssueDate** - Data wystawienia faktury;
- **invoiceInvoicingDate** - Data nadania nr **KSeF**;
- **invoiceCurrency** - Waluta, np. PLN;
- **invoiceType** - Typ faktury, np. VAT;
- **invoicingMode** - Tryb wystawienia faktury: **Online**, **Offline**;
- **invoiceHash** - Hash (skrót / "odcisk palca") faktury;
- **sellerNIP** - NIP sprzedawcy;
- **sellerName** - Nazwa sprzedawcy;
- **buyerIdType** - Typ identyfikatora kupującego, np. NIP;
- **buyerIdValue** - Identyfikator kupującego. Jeśli typ identyfikatora kupującego to NIP, to identyfikator kupującego jest numerem NIP;
- **buyerName** - Nazwa kupującego;
- **netAmount** - Wartość netto, ogółem netto faktury;
- **vatAmount** - Wartość VAT, ogółem VAT faktury;
- **grossAmount** - Wartość brutto, ogółem brutto faktury - Wartość netto + Wartość VAT;
- **qrCode** - Link do strony internetowej systemu **KSeF** weryfikującej wystawienie faktury w systemie **KSeF**;
- **fileName** - Lokalizacja pliku faktury **XML KSeF**.

## Generowanie wizualizacji faktur w formacie PDF

Ostatnią czynność jaką wykonamy to generowanie wizualizacji faktur w formacie **PDF** wg standardu [**PDF/A-3**](https://pl.wikipedia.org/wiki/PDF/A#PDF/A-3) ([**ISO 19005-3:2012**](https://www.iso.org/standard/57229.html)) za miesiąc marzec 2026 (tj. 2026-03-01). 

Wizualizacje faktur zostaną zapisane w tych samych folderach co faktury pobrane w formacie **XML KSeF**. Dodatkowo wygenerowane faktury w formacie [**PDF/A-3**](https://pl.wikipedia.org/wiki/PDF/A#PDF/A-3) zawierają osadzony plik **XML** faktury **KSeF**.

W tym celu wykonujemy następujące polecenia:

```
PS M:\KSeF-Firma> .\ksef-pdf-generator.exe -s .\marzec_2026.json

KSeF PDF Generator - ver. 1.4.0
Copyright (c) 2025 - 2026 by Sebastian Stybel, www.BONO-IT.pl
------------------------------------------------------------------------------

State file provided: .\marzec_2026.json
Processing state file: .\marzec_2026.json
Added XML file from state: .\Faktury-Sprzedaz\1234567890-20260220-112233440000-12.xml

.....

Invoice version: FA (3)
Generating PDF...
PDF generated successfully: .\Faktury-Zakupy\1133557799-20260312-778899998877-11. pdf

PS M:\KSeF-Firma> tree /f

Folder PATH listing for volume DataSS
Volume serial number is A4F7-F767
M:.
│   ksef-pdf-generator.exe
│   ksef-xml-download.exe
│   marzec_2026.csv
│   marzec_2026.json
│
├───Faktury-Sprzedaz
│       1234567890-20260220-112233440000-12.pdf
│       1234567890-20260220-112233440000-12.xml
│       1234567890-20260228-445566770000-34.pdf
│       1234567890-20260228-445566770000-34.xml
│       1234567890-20260309-889900AA0000-56.pdf
│       1234567890-20260309-889900AA0000-56.xml
│       1234567890-20260312-BBCCDDEE0000-78.pdf
│       1234567890-20260312-BBCCDDEE0000-78.xml
│
├───Faktury-Zakupy
│       1122334455-20260216-AA11BB22CC33-55.pdf
│       1122334455-20260216-AA11BB22CC33-55.xml
│       6677889900-20260221-BB00CC99DD88-44.pdf
│       6677889900-20260221-BB00CC99DD88-44.xml
│       1112223334-20260303-321123321123-33.pdf
│       1112223334-20260303-321123321123-33.xml
│       5556667778-20260309-456654456654-22.pdf
│       5556667778-20260309-456654456654-22.xml
│       1133557799-20260312-778899998877-11.pdf
│       1133557799-20260312-778899998877-11.xml
│
└───Stan
        ksef_state.json

PS M:\KSeF-Firma>
```

Faktury w formacie **PDF** zostały wygenerowane.

![Screen-Shot](https://github.com/sstybel/KSeF-PL/blob/main/images/11.png)

## Skrypt automatyzujący proces pobierania i generowania dokumentów z KSeF w Windows PowerShell

Podsumowując cały powyższy algorytm postepowania opisany powyżej, pozostaje nam to wszystko oskryptować.

Jako powłokę dla skryptu wybrałem powłokę [**Windows PowerShell**](https://learn.microsoft.com/pl-pl/powershell/scripting/what-is-windows-powershell?view=powershell-7.5), gdyż jest dostepna bez dodatkowych instalacji w systemie [**Microsoft Windows**](https://www.microsoft.com/pl-pl/windows) od wersji **Windows 10**,

Na początek uzmiennijmy sobie wszystkie niezbędne parametry, aby w przyszłości muc szybko modyfikować zachowanie skryptu.

**Plik: `KSeF.ps1`**
```
Clear-Host # Czyścimy ekran

$QUIET = "" # Pokazuj komunikaty na ekranie
#$QUIET = "--quiet" # Odkomentuj jeśli chcesz włączyć tryb cichy - bez pokazywania komunikatów na ekranie

# Ekran powitalny
if ($QUIET -eq "") {
    Write-Host "Pobieranie faktur z systemu KSeF"
    Write-Host "Copyright (c) 2025 - 2026 by Sebastian Stybel, www.BONO-IT.pl"
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
```

Następnie utwórzmy niezbędną strukturę katalogów, w których przechowywane będą dane pobrane z systemu **KSeF**.

```
# Tworzenie struktury katalogowej
$NewDir = New-Item -ItemType Directory -Path $KSeFCSVOutputDIR -Force -ErrorAction SilentlyContinue
$NewDir = New-Item -ItemType Directory -Path $KSeFJSONOutputDIR -Force -ErrorAction SilentlyContinue
$NewDir = New-Item -ItemType Directory -Path $KSeFCSVStateDIR -Force -ErrorAction SilentlyContinue
$NewDir = New-Item -ItemType Directory -Path $KSeFJSONStateDIR -Force -ErrorAction SilentlyContinue
$NewDir = New-Item -ItemType Directory -Path $KSeFInvSub1DIR -Force -ErrorAction SilentlyContinue
$NewDir = New-Item -ItemType Directory -Path $KSeFInvSub2DIR -Force -ErrorAction SilentlyContinue
```

Na koniec wykonujemy trzy polecenie, zgodnie z tym co sobie zaplanowaliśmy powyżej oraz wykorzystując zmienne zdefiniowane wcześniej.

```
# Pobieranie faktur sprzedażowych i zakupowych w formacie KSeF XML

& $LocDIR/ksef-xml-download.exe --nip $KSeFNIP `
--token $KSeFToken `
--subject-type Subject1and2 `
--download-xml `
--xml-sub1-output-dir $KSeFInvSub1DIR `
--xml-sub2-output-dir $KSeFInvSub2DIR `
--ksef-state-dir $KSeFJSONStateDIR `
--output json `
--output-filename $KSeFOutputFileNameJSON `
--output-append `
--output-dir $KSeFJSONOutputDIR `
--date-from $KSeFDownloadStart `
$QUIET

# Pobieranie wykazu faktur sprzedażowych i zakupowych w formacie CSV

& $LocDIR/ksef-xml-download.exe --nip $KSeFNIP `
--token $KSeFToken `
--subject-type Subject1and2 `
--xml-sub1-output-dir $KSeFInvSub1DIR `
--xml-sub2-output-dir $KSeFInvSub2DIR `
--ksef-state-dir $KSeFCSVStateDIR `
--output csv `
--output-filename $KSeFOutputFileNameCSV `
--output-append `
--output-dir $KSeFCSVOutputDIR `
--date-from $KSeFDownloadStart `
$QUIET

# Generowanie wizualizacji faktur w formacie PDF (PDF/A-3 standard - ISO 19005-3:2012) na podstawie pobranych faktur XML z systemu KSeF

& $LocDIR/ksef-pdf-generator.exe --state $KSeFOutputJSON `
$QUIET
```

Kompletny skrypt można pobrać z repozytorium [**KSeF.ps1**](https://github.com/sstybel/KSeF-PL/blob/main/KSeF.ps1).

## Tworzenie harmonogramu zadań w systemie Windows realizującego automatyzację

Finalnie należy skrypt wprawić w *"ruch"*, czyli wyzwalać (uruchamiać) go cyklicznie. W systemie [**Microsoft Windows**](https://www.microsoft.com/pl-pl/windows) mamy harmonogram zadań, w którym stworzymy cykliczne zadanie.

Cykliczność zadania nie może być zbyt duża, gdyż system **KSeF** ma zabezpieczenie przed przeciążeniem systemu przed nadmierną ilością wywołań. Jednak najbardziej rozsądnym czasem kolejnych wywoływań jest ustawienie tego czasu na **2h** - **4h**, czyli od 12 do 6 uruchomień na dobę - jeśli komputer będzie włączony 24h na dobę.

Jeśli chodzi o wywoływanie skryptu napisanego w [**Windows PowerShell**](https://learn.microsoft.com/pl-pl/powershell/scripting/what-is-windows-powershell?view=powershell-7.5) w zadaniu harmonogramu zadań, to na zakładce zadania w części **Akcje**, należy w następujący sposób wypełnić formularz:

- Program/skrypt: **`Powershell.exe`**
- Dodaj argumenty (opcjonalnie): **`-ExecutionPolicy Bypass M:\KSeF-Firma\KSeF.ps1`**
- Rozpocznij w (opcjonalnie): **`M:\KSeF-Firma\`**

Wyeksportowane zadanie harmonogramu zadań możesz pobrać z repozytorium [**BONO-IT_KSeF.xml**](https://github.com/sstybel/KSeF-PL/blob/main/KSeF.ps1).

![Screen-Shot](https://github.com/sstybel/KSeF-PL/blob/main/images/12.png)

---

## Download

<a href="https://github.com/sstybel/KSeF-PL/releases/latest"><img alt="Static Badge" src="https://img.shields.io/badge/download-red?style=for-the-badge&label=stable&color=%23FF0000&link=https%3A%2F%2Fgithub.com%2Fsstybel%2FKSeF-PL%2Freleases%2Flatest"></a> ![GitHub Release](https://img.shields.io/github/v/release/sstybel/KSeF-PL?sort=date&display_name=release&style=for-the-badge&logo=github&label=release&link=https%3A%2F%2Fgithub.com%2Fsstybel%2FKSeF-PL) ![GitHub Downloads (all assets, all releases)](https://img.shields.io/github/downloads/sstybel/KSeF-PL/total?style=for-the-badge&logo=github&link=https%3A%2F%2Fgithub.com%2Fsstybel%2FKSeF-PL)

##  GitHub

![GitHub stats](https://github-readme-stats-sigma-five.vercel.app/api?username=sstybel&show_icons=true&theme=react&hide_title=true&include_all_commits=true)

&nbsp;

---

## Copyright &copy; 2025 - 2026 by Sebastian Stybel, [www.BONO-IT.pl](https://www.bono-it.pl/)
