
const Map<String, String> CodeToTITANZ = {
  '000': 'ABGESANDT',
  '253': 'DECKADRESSE',
  '505': 'LAUFEND',
  '758': 'STIMMUNG',
  '019': 'ADRESSE',
  '262': 'DOKUMENT',
  '514': 'LEGENDE',
  '767': 'TBK',
  '028': 'ÄNDERUNG',
  '271': 'DRINGEND',
  '523': 'LESBAR',
  '776': 'TERMIN',
  '037': 'ANLEG-EN/UNG',
  '280': 'EINSATZ, EINSETZEN',
  '532': 'MAßNAHME',
  '785': 'TREFF',
  '046': 'ANTWORT-EN',
  '299': 'EINSCHÄTZ-EN/UNG',
  '541': 'MATERIAL',
  '794': 'TREFF WIE VEREINBART',
  '055': 'ANWEIS-EN/UNG',
  '307': 'EINVERSTANDEN (MIT)',
  '550': 'MIKRAT',
  '802': 'TREFFART',
  '064': 'ARBEIT-EN',
  '316': 'EMPFANG-EN',
  '569': 'MILITÄR-ISCH',
  '811': 'TREFFTERMIN',
  '073': 'ARBEITSSTELLE',
  '325': 'ENTLEER-EN/UNG',
  '578': 'MITBRINGEN',
  '820': 'ÜBER',
  '082': 'AUFENTHALT',
  '334': 'ENTLEERT',
  '587': 'MITTEIL-EN/UNG',
  '839': 'ÜBERGABE, ÜBERGEBEN',
  '091': 'AUFGABE, AUFGEBEN',
  '343': 'ERGEBNIS',
  '596': 'NACHRICHT',
  '848': 'ÜBERPRÜF-EN/UNG',
  '109': 'AUFKLÄR-EN/UNG',
  '352': 'ERHALT-EN/UNG',
  '604': 'NÄCHST',
  '857': 'UNBEDINGT',
  '118': 'AUFNAHME, AUFGEBEN',
  '361': 'ERMITTEL-N/UNG',
  '613': 'NEGATIV',
  '866': 'UNTERSTÜTZ-EN/UNG',
  '127': 'AUFTRAG',
  '370': 'ERWART-N/UNG',
  '622': 'NORMAL',
  '875': 'VERBIND-EN/UNG',
  '136': 'AUSFÜHRLICH',
  '389': 'FESTSTELL-EN/UNG',
  '631': 'NOTWENDIG',
  '884': 'VEREINBAR-EN/UNG',
  '145': 'BAHNHOF',
  '398': 'FREQUENZ',
  '640': 'OBJEKT',
  '893': 'VERNICHT-EN/UNG',
  '154': 'BEGINN-EN',
  '406': 'FUNK',
  '659': 'OPERATIV',
  '901': 'VORAUSSICHTLICH',
  '163': 'BELEG-EN/UNG',
  '415': 'GEHEIMSCHREIBMITTEL',
  '668': 'PÄCKCHEN',
  '910': 'VORBEREIT-EN/UNG',
  '172': 'BELEGT',
  '424': 'GRENZÜBERGANG',
  '677': 'POLITIK, POLITISCH',
  '929': 'VORLÄUFIG',
  '181': 'BENÖTIGEN',
  '433': 'INFORMATION, INFORMIEREN',
  '686': 'POST',
  '938': 'VORSCHLAG-EN',
  '190': 'BEOBACHT-EN/UNG',
  '442': 'INSTRUKTEUR',
  '695': 'POST NOCH NICHT ERHALTEN',
  '947': 'WESTBERLIN',
  '208': 'BERICHT-EN',
  '451': 'INTERESSE, INTERESSIEREN',
  '703': 'REAKTION (AUF)',
  '956': 'WESTDEUTSCHLAND',
  '217': 'BERLIN',
  '460': 'KARTE',
  '712': 'SEND-EN/UNG',
  '965': 'WIEDERHOLUNG-EN/UNG',
  '226': 'BESTÄTIG-EN/UNG',
  '479': 'KONTAKT',
  '721': 'SICHERHEIT',
  '974': 'WIRTSCHAFT-LICH',
  '235': 'BRIEF',
  '488': 'KONTROLL-EN/IEREN',
  '730': 'SOFORT',
  '983': 'ZEICHEN',
  '244': 'CHIFFRE',
  '497': 'KURIER',
  '749': 'SPRUCH',
  '992': 'ZENTRALE',
};

const Map<String, String> TITANZToCode = {
  'POST NOCH NICHT ERHALTEN': '695',
  'TREFF WIE VEREINBART': '794',
  'GEHEIMSCHREIBMITTEL': '415',
  'EINVERSTANDEN MIT': '307',
  'VORAUSSICHTLICH': '901',
  'WESTDEUTSCHLAND': '956',
  'WIEDERHOLUNGUNG': '965',
  'WIEDERHOLUNGEN': '965',
  'WIRTSCHAFTLICH': '974',
  'EINVERSTANDEN': '307',
  'ARBEITSSTELLE': '073',
  'GRENZÜBERGANG': '424',
  'INTERESSIEREN': '451',
  'KONTROLLIEREN': '488',
  'UNTERSTÜTZUNG': '866',
  'VORBEREITUNG': '910',
  'REAKTION AUF': '703',
  'VEREINBARUNG': '884',
  'FESTSTELLUNG': '389',
  'UNTERSTÜTZEN': '866',
  'EINSCHÄTZUNG': '299',
  'EINSCHÄTZEN': '299',
  'MILITÄRISCH': '569',
  'TREFFTERMIN': '811',
  'DECKADRESSE': '253',
  'ÜBERPRÜFUNG': '848',
  'ERMITTELUNG': '361',
  'BESTÄTIGUNG': '226',
  'INFORMATION': '433',
  'INFORMIEREN': '433',
  'VORSCHLAGEN': '938',
  'BEOBACHTUNG': '190',
  'INSTRUKTEUR': '442',
  'VERNICHTUNG': '893',
  'VORBEREITEN': '910',
  'VEREINBAREN': '884',
  'AUSFÜHRLICH': '136',
  'FESTSTELLEN': '389',
  'ENTLEERUNG': '325',
  'MITBRINGEN': '578',
  'AUFENTHALT': '082',
  'MITTEILUNG': '587',
  'ÜBERPRÜFEN': '848',
  'AUFKLÄRUNG': '109',
  'VERNICHTEN': '893',
  'BESTÄTIGEN': '226',
  'BEOBACHTEN': '190',
  'WESTBERLIN': '947',
  'SICHERHEIT': '721',
  'WIRTSCHAFT': '974',
  'KONTROLLEN': '488',
  'VERBINDUNG': '875',
  'KONTROLLE': '488',
  'BERICHTEN': '208',
  'INTERESSE': '451',
  'NOTWENDIG': '631',
  'ERHALTUNG': '352',
  'AUFKLÄREN': '109',
  'UNBEDINGT': '857',
  'ERMITTELN': '361',
  'ERWARTUNG': '370',
  'VERBINDEN': '875',
  'POLITISCH': '677',
  'VORLÄUFIG': '929',
  'BENÖTIGEN': '181',
  'VORSCHLAG': '938',
  'EINSETZEN': '280',
  'ABGESANDT': '000',
  'ANTWORTEN': '046',
  'ANWEISUNG': '055',
  'EMPFANGEN': '316',
  'ENTLEEREN': '325',
  'MITTEILEN': '587',
  'ÜBERGEBEN': '839',
  'NACHRICHT': '596',
  'AUFGEBEN': '118',
  'AUFNAHME': '118',
  'ERHALTEN': '352',
  'ERWARTEN': '370',
  'FREQUENZ': '398',
  'BEGINNEN': '154',
  'OPERATIV': '659',
  'BELEGUNG': '163',
  'PÄCKCHEN': '668',
  'MAßNAHME': '532',
  'MATERIAL': '541',
  'ANWEISEN': '055',
  'ARBEITEN': '064',
  'TREFFART': '802',
  'ENTLEERT': '334',
  'ÜBERGABE': '839',
  'ERGEBNIS': '343',
  'ANLEGUNG': '037',
  'DOKUMENT': '262',
  'STIMMUNG': '758',
  'ÄNDERUNG': '028',
  'DRINGEND': '271',
  'REAKTION': '703',
  'ZENTRALE': '992',
  'EMPFANG': '316',
  'MILITÄR': '569',
  'AUFGABE': '091',
  'LAUFEND': '505',
  'ADRESSE': '019',
  'LEGENDE': '514',
  'ANLEGEN': '037',
  'ANTWORT': '046',
  'EINSATZ': '280',
  'NEGATIV': '613',
  'AUFTRAG': '127',
  'BAHNHOF': '145',
  'BELEGEN': '163',
  'BERICHT': '208',
  'POLITIK': '677',
  'SENDUNG': '712',
  'KONTAKT': '479',
  'ZEICHEN': '983',
  'CHIFFRE': '244',
  'LESBAR': '523',
  'TERMIN': '776',
  'MIKRAT': '550',
  'ARBEIT': '064',
  'OBJEKT': '640',
  'BEGINN': '154',
  'BELEGT': '172',
  'BERLIN': '217',
  'SENDEN': '712',
  'SOFORT': '730',
  'KURIER': '497',
  'SPRUCH': '749',
  'NORMAL': '622',
  'NÄCHST': '604',
  'TREFF': '785',
  'KARTE': '460',
  'BRIEF': '235',
  'POST': '686',
  'FUNK': '406',
  'ÜBER': '820',
  'TBK': '767',
};

String? codebook(String input, int i, Map<String, String> codeBook) {
  for (var key in codeBook.keys) {
    if (input.startsWith(key, i)) {
      return key;
    }
  }
  return null;
}

String addOneTimePad(String input, String keyOneTimePad) {
  keyOneTimePad = keyOneTimePad.replaceAll(RegExp(r'\D'), '');
  if (keyOneTimePad.isEmpty) return input;

  var out = '';
  for (int i = 0; i < input.length; i++) {
    if (i >= keyOneTimePad.length) {
      out += input[i];
      continue;
    }

    int a = int.tryParse(input[i]) ?? 0;
    int b = int.tryParse(keyOneTimePad[i]) ?? 0;

    out += ((a + b) % 10).toString();
  }

  return out;
}

String subtractOneTimePad(String input, String keyOneTimePad) {
  keyOneTimePad = keyOneTimePad.replaceAll(RegExp(r'\D'), '');
  if (keyOneTimePad.isEmpty) return input;

  var out = '';
  for (int i = 0; i < input.length; i++) {
    if (i >= keyOneTimePad.length) {
      out += input[i];
      continue;
    }

    int a = int.tryParse(input[i]) ?? 0;
    int b = int.tryParse(keyOneTimePad[i]) ?? 0;

    out += ((a - b) % 10).toString();
  }

  return out;
}

String? checkCode(String code, bool isLetterMode, Map<String, String> codeToAZ, Map<String, String> codeToNumbers) {
  return isLetterMode ? codeToAZ[code] : codeToNumbers[code];
}