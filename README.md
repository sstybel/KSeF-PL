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
3.	Generuje wizualizacje faktur w formacie **PDF** wg standardu **PDF/A-3** (**ISO 19005-3:2012**) na podstawie pobranych faktur w formacie **XML KSeF** i umieszcza je w tej samej lokalizacji – patrz punk 1.

Każdy miesiąc będzie posiadał swoją niezależną strukturę katalogów z wykazem faktur **KSeF XML**, listą dokumentów w pliku **CSV** oraz reprezentacją wizualną faktur w formacie **PDF**.

## Tworzenie tokenu w systemie KSeF

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
