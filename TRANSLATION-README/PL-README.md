# GC WIZARD

<p align="center">
  <img src="https://github.com/GCWizard/GCWizard/blob/master/assets/logo/circle_border_128.png?raw=true" alt="GC Wizard logo"/>
</p>

GC Wizard to zbiór narzędzi Open-source dla **Androida** oraz **iOSa**. Jest również dostępna wersja **[WWW](http://gcwizard.net)**.

Pierwotnie został stworzony, aby zaoferować geocacherom narzędzie offline, które pomoże im w rozwiązywaniu zagadek i łamigłówek w terenie. GC Wizard zawiera więc liczne narzędzia do prostej kryptografii, obliczeń geodezyjnych i naukowych, a także setki zestawów różnych symboli.

W międzyczasie projekt stał się bardzo duży i może być praktyczny dla wielu zagadnień niezwiązanych z geocachingiem.

Został przetłumaczony na: 🇬🇧 🇩🇪 🇫🇷 🇰🇷 🇳🇱 🇸🇰 🇸🇪 (Crowdin: [Przetłumacz na swój język](https://crowdin.com/project/gc-wizard))

Został stworzony na **Flutter/Dart**.



## Filozofia
1. Jest tak wiele wspaniałych skrytek geocache. Mieliśmy z nimi tyle zabawy. **Dzięki GC Wizard chcemy dać coś społeczności**. Być może nie stworzymy tak wspaniałych skrytek, ale mamy nadzieję, że będzie to świetne narzędzie pomocnicze.
1. **GC WIZARD zawsze będzie darmowy** dla wszystkich.
1. Tworząc ten projekt open-source, chcemy zaprosić wszystkich wspaniałych twórców zagadek do dzielenia się swoją wiedzą i algorytmami. Nikt nie powinien już potrzebować budować narzędzia ROT-13 lub czegokolwiek innego od zera. **Ktoś już to zrobił**.

## Najważniejsze funkcje:

### Ogólne
**Formula Solver**: Do obsługi zmiennych w wieloetapowych skrytkach =-- 
**Multi Decoder**: Wprowadź nieznany kod i pozwól, aby kilka dekoderów i kalkulatorów zinterpretowało go pod rząd.
* Ponad **250 zestawów tabel symboli**: Bezpośrednie dekodowanie symboli na znaki; zapisywanie własnego kodowania jako obrazu
* **[Podręcznik Online](https://blog.gcwizard.net/manual/en/)**: Każde narzędzie ma własną stronę podręcznika, przetłumaczoną na 🇬🇧 🇩🇪

### Kryptografia i kodowanie
* **Wartości Liczbowe** (A = 1, B = 2, ...): W pełni konfigurowalne alfabety z obsługą znaków specjalnych specyficznych dla danego języka
* Dekoder graficzny **Braille**: Wpisywanie punktów do interfejsu graficznego; obsługuje różne języki
**Szyfr książkowy**: Wybór właściwego systemu (np. linia + numer litery lub sekcja + linia + numer słowa, ...), obsługa znaków specjalnych i pustych linii, ...
**Enigma**: W pełni działający symulator Enigmy z wieloma możliwymi ustawieniami
**Języki ezoteryczne**: Generatory i interpretatory dla kilku ezoterycznych języków programowania, takich jak Brainf*ck, Ook, Malbolge i Chef
**Alfabet MORSE'A**.
**Zdania liczbowe**: Listy ważnych liczb w różnych językach. Dla języka angielskiego i niemieckiego dostępne są parsery identyfikujące nawet złożone słowa liczbowe, takie jak „tysiąctrzystaczterdzieści-dwa”.
**Substitution** i **Łamacz szyfrów Vigenère**: Spróbuj znaleźć rozwiązanie bez znajomości kluczy
**Klasyczne szyfry**: Playfair, Polybios, Railfence, ...
**Historyczne kody**: Cezar, Vigenère, stare kody telegraficzne, ...
**Kody wojskowe**: ADFGX, Cipher Wheel, Tapir, ...
**Kodowania techniczne**: BCD, CCITT, Hashes (w tym brute-force hash breaker), RSA, ...
* ...

### Współrzędne
* **Algorytmy dla wysokiej precyzji współrzędnych**, które obsługują nawet bardzo duże odległości, zawsze biorąc pod uwagę kształt Ziemi (elipsoidę).
* Obsługa **wielu różnych elipsoid obrotu**, nawet innych planet
* **Formaty współrzędnych**: Obsługa UTM, MGRS, XYZ, SwissGrid, QTH, NAC, PlusCode, Geohash, ...
* **Projekcja współrzędnych**: Obejmuje precyzyjną projekcję wsteczną
* **Open Map**: Ustawianie własnych punktów i linii między punktami, mierzenie ścieżek, eksportowanie i importowanie z plików GPX/KML; OpenStreetMap i widok satelitarny.
* **Zmienne wartości**: Interpoluj formuły współrzędnych, jeśli niektóre części współrzędnych nie są podane. Pokaż wynik na mapie
* Kilka **dokładnych obliczeń**: Antypody, namiar krzyżowy, punkt środkowy dwóch i trzech współrzędnych, różne przecięcia linii i okręgów, ...

### Nauka i technologia
* **Astronomia**: Obliczanie pozycji słońca i księżyca w określonym miejscu i czasie
* **Konwerter przestrzeni kolorów**: Konwersja wartości kolorów pomiędzy RGB, HSL, Hex, CMYK, YPbPr, ...
* **Kraje**: Kody ISO i IOC, kody połączeń i rejestracji pojazdów, flagi, kody lotnisk IATA i ICAO.
* **Funkcje daty i godziny**: Dzień tygodnia, różnice czasowe, ...
* **Liczby niewymierne**: *π*, *φ* i *e*: Wyświetlanie i wyszukiwanie do > 1 000 000 cyfr
* **Sekwencje liczbowe**: Faktoryczny, Fibonacciego, Fermata, Mersenne'a i in.
* **Systemy liczbowe**: Konwertuje system dziesiętny na binarny, szesnastkowy, ...; obsługuje bazy ujemne.
* **Tablica okresowa pierwiastków**: Interaktywny widok i listy, które porządkują pierwiastki według dowolnego kryterium
* **Przyciski telefonów** (Vanity): Konwertuje klasyczne klawisze telefonu na litery. Obsługuje zachowania specyficzne dla modelu telefonu
* **Liczby pierwsze**: Wyszukiwanie liczb pierwszych do 1 000 000
* **Wyświetlacze segmentowe**: Graficzny interfejs do dekodowania i kodowania wyświetlaczy 7, 14 lub 16 segmentowych
* **Konwerter jednostek**: Długość, objętość, ciśnienie, moc i wiele innych; konwersja między popularnymi jednostkami, w tym przedrostkami takimi jak *micro* i *kilo*.
* Temperatura pozorna, kombinatoryka, sumy krzyżowe, DTMF, układy klawiatury, pociski, kody rezystorów, ...

### Obrazy i pliki
* **Przeglądarka Hex**
* **Exif/Metadata Viewer** dla obrazów
**Wherigo Analyzer** do wyświetlania zawartości kartridży WIG
* Analiza klatek **Animowanych obrazów**
**Korekta kolorów**: Regulacja kontrastu, nasycenia, gamma, wykrywanie krawędzi, ...
* Wyszukiwanie **Ukrytych danych** lub Ukrytych archiwów
* **Czyta kody QR/Barcody** ze zdjęć, tworzy kody QR z wejścia binarnego
* ...
## Linki

* [Instrukcja](https://blog.gcwizard.net/manual/en/) 🇬🇧 🇩🇪
* [WWW](http://gcwizard.net)
* [FAQ](https://blog.gcwizard.net/category/faq/)

### Development
* [Github](https://github.com/GCWizard/GCWizard): Code and assets
* [Crowdin](https://crowdin.com/project/gc-wizard): Translations
  
### E-mail
* info@gcwizard.net

### Social Media
* [Blog](https://blog.gcwizard.net/) 🇬🇧 🇩🇪
* [Mastodon](https://fosstodon.org/@gcwizard) 🇬🇧

### Sklepy z aplikacjami
* Są dostępne dwie wersje: Normalna i GOLD **GOLD to absolutnie to samo co Normal** (tylko inne logo), bez dodatkowych funkcji. Jest to tylko pomoc dla programistów
* [Google PlayStore](https://play.google.com/store/apps/details?id=de.sman42.gc_wizard) ([Gold](https://play.google.com/store/apps/details?id=de.sman42.gc_wizard_gold))
* [Apple AppStore](https://apps.apple.com/us/app/id1506766126) ([Gold](https://apps.apple.com/us/app/id1510372318))
