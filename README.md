# GC Wizard

<p align="center">
  <img src="https://github.com/S-Man42/GCWizard/blob/master/assets/logo/circle_border_128.png?raw=true" alt="GC Wizard logo"/>
</p>

The GC Wizard is an open-source tool collection for **Android** and **iOS**. There is also an alpha version of a **[Web View](http://gcwizard.net)**.

It was originally created to offer Geocachers an offline tool to support them with in-field mysteries and riddles. So, the GC Wizard contains numerous tools for simple cryptography, geodetic and scientific calculations as well as hundreds of sets of various symbols.

Meanwhile the project became very huge and might be practicable for many non-Geocaching issues.

Translated into 🇬🇧 🇩🇪 🇫🇷 🇰🇷 🇳🇱 🇸🇰 🇸🇪 (Crowdin: [Translate into your language](https://crowdin.com/project/gc-wizard))

Based on **Flutter/Dart**.

## Philosophy
1. There are so many great Geocaches out there. We had so much fun with them. With the GC Wizard, **we want to give something back to the community**. We may not make such great Geocaches, but hopefully a great supporting tool.
1. The **GC Wizard will always be free** for everybody.
1. With making this project open-source we want to invite all the great GC tool providers to share their knowledge and algorithms. Nobody should need to build a ROT-13 tool or whatever from scratch anymore. **Somebody already did it**.

## Highlights

### General
* **Formula Solver**: For handling variables in multi stage caches
* **Multi Decoder**: Enter an unknown code and let several decoders and calculators interpret it in a row
* More than **250 sets of Symbol Tables**: Direct decoding symbols to characters; save own encoding as an image
* **[Online Manual](https://blog.gcwizard.net/manual/en/)**: Every tool has its own manual page, translated into 🇬🇧 🇩🇪

### Cryptography & Encodings
* **Alphabet Values** (A = 1, B = 2, ...): Completely configurable alphabets with language specific special character handling
* **Braille** graphical decoder: Type the points into a graphical interface; supports different languages
* **Book Cipher**: Choose the correct system (e.g. Line + Letter Number or Section + Line + Word Number, ...), handle special characters and empty lines, ...
* **Enigma**: A full working Enigma simulator incl. numerous possible settings
* **Esoteric Languages**: Generators and interpretors for several esoteric programming languages like Brainfuck, Ook, Malbolge and Chef
* **Morse**
* **Numeral Words**: Lists of important numbers in different languages. For English and German there are parsers to identify even complex numeral words like "onethousandthreehundredfourty-two"
* **Substitution** and **Vigenère Code Breakers**: Try to find the solution without knowing the keys
* **Classic Codes**: Playfair, Polybios, Railfence, ...
* **Historic codes**: Caesar, Vigenère, old telegraph codes, ...
* **Military codes**: ADFGX, Cipher Wheel, Tapir, ...
* **Technical encodings**: BCD, CCITT, Hashes (incl. brute-force hash breaker), RSA, ...
* ...

### Coordinates
* **High precision coordinate algorithms** which support even with very long distances by always considering the earth's shape (ellipsoid)
* Support of **many different rotation ellipsoids**, even other planets
* **Coordinate Formats**: Support of UTM, MGRS, XYZ, SwissGrid, QTH, NAC, PlusCode, Geohash, ...
* **Waypoint Projection**: Includes precise reverse projection
* **Open Map**: Set own points and lines between points, measure paths, export as and import from GPX/KML files; OpenStreetMap and satellite view
* **Variable Coordinate**: Interpolate coordinate formulas if some parts of coordinate are not given. Show result on map
* Several **high-precise calculations**: Antipode, Cross bearing, Center point of two and three coordinates, different intersections of lines and circles, ...

### Science and Technology
*  **Astronomy**: Calculate position of sun and moon at a certain place and time
* **Color Space Converter**: Convert color values between RGB, HSL, Hex, CMYK, YPbPr, ...
* **Countries**: ISO and IOC codes, calling and vehicle registration codes, flags, IATA and ICAO airfield codes
* **Date and Time functions**: Weekday, time differences, ...
* **Irrational Numbers**: *π*, *φ* and *e*: Show and search up to > 1,000,000 digits
* **Number sequences**: Factorial, Fibonacci, Fermat, Mersenne and Co.
* **Numeral Systems**: Converts decimal to binary, hexadecimal, ...; supports negative bases
* **Periodic Table of the Elements**: Interactive view and lists which order the elements by any criterion
* **Phone Keys** (Vanity): Converts classic phone keys to letters. Supports phone model specific behaviours
* **Prime Numbers**: Search prime numbers up to 1,000,000
* **Segment Display**: Graphical interface for decoding and encoding 7, 14 or 16 segment displays
* **Unit Converter**: Length, Volume, Pressure, Power and many more; convert between common units incl. prefixes like *micro* and *kilo*
* Apparent Temperature, Combinatorics, Cross Sums, DTMF, Keyboard layouts, Projectiles, Resistor codes, ...

### Images and Files
* **Hex Viewer**
* **Exif/Metadata Viewer** for images
* **Wherigo Analyzer** to show content of WIG cartridges
* Analyse frames of **Animated Images**
* **Color corrections**: Adjust contrast, saturation, gamma, edge detection, ...
* Search for **Hidden Data** or hidden archives
* Read **QR/Barcodes** from images, create QR/Barcodes from binary input
* ...

## Links

* [Manual](https://blog.gcwizard.net/manual/en/) 🇬🇧 🇩🇪
* [Web View](http://gcwizard.net)

### Development
* [Github](https://github.com/S-Man42/GCWizard): Code and assets
* [Crowdin](https://crowdin.com/project/gc-wizard): Translations

### Social Media
* [Blog](https://blog.gcwizard.net/) 🇬🇧 🇩🇪
* [Mastodon](https://fosstodon.org/@gcwizard) 🇬🇧

### App Stores
* There are **two versions** available: Normal and *Gold*. *Gold* version **is absolutely the same** (only another logo 😉), no additional features. It is just for supporting the developers.
* [Google PlayStore](https://play.google.com/store/apps/details?id=de.sman42.gc_wizard) ([Gold](https://play.google.com/store/apps/details?id=de.sman42.gc_wizard_gold))
* [Apple AppStore](https://apps.apple.com/us/app/id1506766126) ([Gold](https://apps.apple.com/us/app/id1510372318))
