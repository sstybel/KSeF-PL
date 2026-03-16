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
- [Skrypt automatyzujący proces pobierania i generowania dokumentów z **KSeF** w **PowerShell**](#skrypt-automatyzujący-proces-pobierania-i-generowania-dokumentów-z-ksef-w-powershell)
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

W tym celu wchodzimy na stronę [**Krajowego Systemu e-Faktur**](https://ksef.podatki.gov.pl/) – [**https://ksef.podatki.gov.pl/**](https://ksef.podatki.gov.pl/) i wybieramy przycisk **„`Zaloguj się do KSeF`”**.

![Screen-Shot](https://github.com/sstybel/KSeF-PL/blob/main/images/01.png)

Przeniesie nas na stronę logowania, gdzie wybieramy kafelek **„`Uwierzytelnij się w Krajowym Systemie e-Faktur`”**.

![Screen-Shot](https://github.com/sstybel/KSeF-PL/blob/main/images/02.png)

Jako sposób logowania wybieramy **„`Zaloguj przez login.gov.pl`”**.

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

## Pobieranie faktur w formacie XML KSeF

## Pobieranie wykazu faktur w formacie CSV

## Generowanie wizualizacji faktur w formacie PDF

## Skrypt automatyzujący proces pobierania i generowania dokumentów z KSeF w PowerShell

## Tworzenie harmonogramu zadań w systemie Windows realizującego automatyzację

---

## Download

<a href="https://github.com/sstybel/KSeF-PL/releases/latest"><img alt="Static Badge" src="https://img.shields.io/badge/download-red?style=for-the-badge&label=stable&color=%23FF0000&link=https%3A%2F%2Fgithub.com%2Fsstybel%2FKSeF-PL%2Freleases%2Flatest"></a> ![GitHub Release](https://img.shields.io/github/v/release/sstybel/KSeF-PL?sort=date&display_name=release&style=for-the-badge&logo=github&label=release&link=https%3A%2F%2Fgithub.com%2Fsstybel%2FKSeF-PL) ![GitHub Downloads (all assets, all releases)](https://img.shields.io/github/downloads/sstybel/KSeF-PL/total?style=for-the-badge&logo=github&link=https%3A%2F%2Fgithub.com%2Fsstybel%2FKSeF-PL)

##  GitHub

![GitHub stats](https://github-readme-stats-sigma-five.vercel.app/api?username=sstybel&show_icons=true&theme=react&hide_title=true&include_all_commits=true)

&nbsp;

---

## Copyright &copy; 2025 - 2026 by Sebastian Stybel, [www.BONO-IT.pl](https://www.bono-it.pl/)
