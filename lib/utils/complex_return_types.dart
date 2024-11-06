import 'dart:typed_data';

import 'package:gc_wizard/utils/constants.dart';

class DoubleText {
  String text;
  double value;

  DoubleText(this.text, this.value);

  @override
  String toString() {
    return 'Text: $text, Value: $value';
  }
}

class IntegerText {
  String text;
  int value;

  IntegerText(this.text, this.value);
}

class BoolText {
  String text;
  bool value;

  BoolText(this.text, this.value);
}

class IntegerListText {
  String text;
  List<int> value;

  IntegerListText(this.text, this.value);
}

class Uint8ListText {
  String text;
  Uint8List value;

  Uint8ListText(this.text, this.value);
}

class DateTimeTZDuration extends DateTimeTZ {
  Duration duration;

  DateTimeTZDuration({required DateTime dateTimeUtc, Duration timezone = const Duration(), required this.duration})
      : super(dateTimeUtc: dateTimeUtc, timezone: timezone);
}

class DateTimeTZ {
  DateTime dateTimeUtc;
  Duration timezone;

  DateTimeTZ({required this.dateTimeUtc, this.timezone = const Duration()});

  static DateTimeTZ now() {
    return fromLocalTime(DateTime.now(), DateTime.now().timeZoneOffset);
  }

  static DateTimeTZ fromLocalTime(DateTime localDatetime, Duration timezone) {
    return DateTimeTZ(dateTimeUtc: localDatetime.add(-timezone), timezone: timezone);
  }

  DateTime toLocalTime() {
    return dateTimeUtc.add(timezone);
  }

  String toLocalTimezoneAllNames(){
    // https://en.wikipedia.org/wiki/List_of_time_zone_abbreviations
    // https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
    switch (timezone.inMinutes) {
      case -720: return 'BIT IDLW'; // UTC - 12
      case -660: return 'NUT SST'; // UTC - 11
      case -600: return 'CKT HST SDT TAHT'; // UTC - 10
      case -570: return 'MART MIT'; // UTC - 9:30
      case -540: return 'AKST GAMT GIT HDT'; // UTC - 9
      case -480: return 'AKDT CIST PST'; // UTC - 8
      case -420: return 'MAST PDT'; // UTC - 7
      case -360: return 'CST EAST GALT MDT'; // UTC - 6
      case -300: return 'ACT CDT COT CST EASST ECT EST PET'; // UTC - 5
      case -240: return 'AMT AST BOT CDT CLT COST ECT EDT FKT GYT PYT VET'; // UTC - 4
      case -210: return 'NST NT'; // UTC - 3:30
      case -180: return 'ADT AMST ART BRT CLST FKST GFT PMST PYST ROTT SRT UYT WGT'; // UTC - 3
      case -150: return 'NDT'; // UTC - 2:30
      case -120: return 'BRST FNT GST PMDT UYST WGST'; // UTC - 2
      case -60: return 'AZOT CVT EGT'; // UTC - 1
      case 0: return 'AZOST EGT GMT UTC WET';
      case 60: return 'BST CET DFT IST MET WAT WEST'; // UTC + 1
      case 120: return 'CAT CEST EET HAEC IST KALT MEST SAST WAST'; // UTC + 2
      case 180: return 'AST EAT EEST FET IDT MSK SYOT TRT VOLT'; // UTC + 3
      case 210: return 'IRST'; // UTC + 3:30
      case 240: return 'AMT AZT GET GST MUT RET SAMT SCT'; // UTC + 4
      case 270: return 'AFT IRDT'; // UTC + 4:30
      case 300: return 'AQTT HMT MAWT MVT ORAT PKT TFT TJT UZT YEKT'; // UTC + 5
      case 330: return 'IST SLST'; // UTC + 5:30
      case 345: return 'NPT'; // UTC + 5:45
      case 360: return 'ALMT BIOT BST BTT IOT KGT OMST VOST'; // UTC + 6
      case 390: return 'CCT MMT'; // UTC + 6:30
      case 420: return 'CXT DAVT HOVT ICT KRAT NOVT THA WIB'; // UTC + 7
      case 480: return 'ACT AWST BNT CHOT CST HKT HOVST IRKT MST MYT PHT PHST SGT TST ULAT WITA WST'; // UTC + 8
      case 525: return 'ACWST CWST'; // UTC + 8:45
      case 540: return 'CHOST JST KST PWT TLT ULAST WIT YAKT'; // UTC + 9
      case 570: return 'ACST'; // UTC + 9:30
      case 600: return 'AEST AET AEST CHST CHUT DDUT PGT VLAT'; // UTC + 10
      case 630: return 'ACDT LHST'; // UTC + 10:30
      case 660: return 'AEDT BST KOST LHST MIST NCT NFT PONT SAKT  SBT SRET VUT'; // UTC + 11
      case 720: return 'ANAT FJT GILT MAGT MHT NZST PETT TVT WAKT'; // UTC + 12
      case 765: return 'CHATS'; // UTC + 12:45
      case 780: return 'NZDT PHOT TKT TOT'; // UTC + 13
      case 825: return 'CHADT'; // UTC + 13:45
      case 840: return 'LINT'; // UTC + 14
      default: return UNKNOWN_ELEMENT;
    }
  }

  String toLocalTimezoneName(){
    return DateTime.now().timeZoneName;
  }
}

class KeyValueBase {
  Object? id;
  String key;
  String value;

  KeyValueBase(this.id, this.key, this.value);
}
