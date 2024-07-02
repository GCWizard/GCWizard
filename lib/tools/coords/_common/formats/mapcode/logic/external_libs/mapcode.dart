// ported from https://github.com/mapcode-foundation/mapcode-js/

/*
 * Copyright (C) 2003-2018 Stichting Mapcode Foundation (http://www.mapcode.com)
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import 'dart:math';

import 'package:latlong2/latlong.dart';
import 'package:utility/utility.dart';

part 'package:gc_wizard/tools/coords/_common/formats/mapcode/logic/external_libs/ndata.dart';

const iso3166alpha = [
  'VAT',
  'MCO',
  'GIB',
  'TKL',
  'CCK',
  'BLM',
  'NRU',
  'TUV',
  'MAC',
  'SXM',
  'MAF',
  'NFK',
  'PCN',
  'BVT',
  'BMU',
  'IOT',
  'SMR',
  'GGY',
  'AIA',
  'MSR',
  'JEY',
  'CXR',
  'WLF',
  'VGB',
  'LIE',
  'ABW',
  'MHL',
  'ASM',
  'COK',
  'SPM',
  'NIU',
  'KNA',
  'CYM',
  'BES',
  'MDV',
  'SHN',
  'MLT',
  'GRD',
  'VIR',
  'MYT',
  'SJM',
  'VCT',
  'HMD',
  'BRB',
  'ATG',
  'CUW',
  'SYC',
  'PLW',
  'MNP',
  'AND',
  'GUM',
  'IMN',
  'LCA',
  'FSM',
  'SGP',
  'TON',
  'DMA',
  'BHR',
  'KIR',
  'TCA',
  'STP',
  'HKG',
  'MTQ',
  'FRO',
  'GLP',
  'COM',
  'MUS',
  'REU',
  'LUX',
  'WSM',
  'SGS',
  'PYF',
  'CPV',
  'TTO',
  'BRN',
  'ATF',
  'PRI',
  'CYP',
  'LBN',
  'JAM',
  'GMB',
  'QAT',
  'FLK',
  'VUT',
  'MNE',
  'BHS',
  'TLS',
  'SWZ',
  'KWT',
  'FJI',
  'NCL',
  'SVN',
  'ISR',
  'PSE',
  'SLV',
  'BLZ',
  'DJI',
  'MKD',
  'RWA',
  'HTI',
  'BDI',
  'GNQ',
  'ALB',
  'SLB',
  'ARM',
  'LSO',
  'BEL',
  'MDA',
  'GNB',
  'TWN',
  'BTN',
  'CHE',
  'NLD',
  'DNK',
  'EST',
  'DOM',
  'SVK',
  'CRI',
  'BIH',
  'HRV',
  'TGO',
  'LVA',
  'LTU',
  'LKA',
  'GEO',
  'IRL',
  'SLE',
  'PAN',
  'CZE',
  'GUF',
  'ARE',
  'AUT',
  'AZE',
  'SRB',
  'JOR',
  'PRT',
  'HUN',
  'KOR',
  'ISL',
  'GTM',
  'CUB',
  'BGR',
  'LBR',
  'HND',
  'BEN',
  'ERI',
  'MWI',
  'PRK',
  'NIC',
  'GRC',
  'TJK',
  'BGD',
  'NPL',
  'TUN',
  'SUR',
  'URY',
  'KHM',
  'SYR',
  'SEN',
  'KGZ',
  'BLR',
  'GUY',
  'LAO',
  'ROU',
  'GHA',
  'UGA',
  'GBR',
  'GIN',
  'ECU',
  'ESH',
  'GAB',
  'NZL',
  'BFA',
  'PHL',
  'ITA',
  'OMN',
  'POL',
  'CIV',
  'NOR',
  'MYS',
  'VNM',
  'FIN',
  'COG',
  'DEU',
  'JPN',
  'ZWE',
  'PRY',
  'IRQ',
  'MAR',
  'UZB',
  'SWE',
  'PNG',
  'CMR',
  'TKM',
  'ESP',
  'THA',
  'YEM',
  'FRA',
  'ALA',
  'KEN',
  'BWA',
  'MDG',
  'UKR',
  'SSD',
  'CAF',
  'SOM',
  'AFG',
  'MMR',
  'ZMB',
  'CHL',
  'TUR',
  'PAK',
  'MOZ',
  'NAM',
  'VEN',
  'NGA',
  'TZA',
  'EGY',
  'MRT',
  'BOL',
  'ETH',
  'COL',
  'ZAF',
  'MLI',
  'AGO',
  'NER',
  'TCD',
  'PER',
  'MNG',
  'IRN',
  'LBY',
  'SDN',
  'IDN',
  'MX-DIF',
  'MX-TLA',
  'MX-MOR',
  'MX-AGU',
  'MX-CL',
  'MX-QUE',
  'MX-HID',
  'MX-MX',
  'MX-TAB',
  'MX-NAY',
  'MX-GUA',
  'MX-PUE',
  'MX-YUC',
  'MX-ROO',
  'MX-SIN',
  'MX-CAM',
  'MX-MIC',
  'MX-SLP',
  'MX-GRO',
  'MX-NLE',
  'MX-BCN',
  'MX-VER',
  'MX-CHP',
  'MX-BCS',
  'MX-ZAC',
  'MX-JAL',
  'MX-TAM',
  'MX-OAX',
  'MX-DUR',
  'MX-COA',
  'MX-SON',
  'MX-CHH',
  'GRL',
  'SAU',
  'COD',
  'DZA',
  'KAZ',
  'ARG',
  'IN-DD',
  'IN-DN',
  'IN-CH',
  'IN-AN',
  'IN-LD',
  'IN-DL',
  'IN-ML',
  'IN-NL',
  'IN-MN',
  'IN-TR',
  'IN-MZ',
  'IN-SK',
  'IN-PB',
  'IN-HR',
  'IN-AR',
  'IN-AS',
  'IN-BR',
  'IN-UT',
  'IN-GA',
  'IN-KL',
  'IN-TN',
  'IN-HP',
  'IN-JK',
  'IN-CT',
  'IN-JH',
  'IN-KA',
  'IN-RJ',
  'IN-OR',
  'IN-GJ',
  'IN-WB',
  'IN-MP',
  'IN-TG',
  'IN-AP',
  'IN-MH',
  'IN-UP',
  'IN-PY',
  'AU-NSW',
  'AU-ACT',
  'AU-JBT',
  'AU-NT',
  'AU-SA',
  'AU-TAS',
  'AU-VIC',
  'AU-WA',
  'AU-QLD',
  'BR-DF',
  'BR-SE',
  'BR-AL',
  'BR-RJ',
  'BR-ES',
  'BR-RN',
  'BR-PB',
  'BR-SC',
  'BR-PE',
  'BR-AP',
  'BR-CE',
  'BR-AC',
  'BR-PR',
  'BR-RR',
  'BR-RO',
  'BR-SP',
  'BR-PI',
  'BR-TO',
  'BR-RS',
  'BR-MA',
  'BR-GO',
  'BR-MS',
  'BR-BA',
  'BR-MG',
  'BR-MT',
  'BR-PA',
  'BR-AM',
  'US-DC',
  'US-RI',
  'US-DE',
  'US-CT',
  'US-NJ',
  'US-NH',
  'US-VT',
  'US-MA',
  'US-HI',
  'US-MD',
  'US-WV',
  'US-SC',
  'US-ME',
  'US-IN',
  'US-KY',
  'US-TN',
  'US-VA',
  'US-OH',
  'US-PA',
  'US-MS',
  'US-LA',
  'US-AL',
  'US-AR',
  'US-NC',
  'US-NY',
  'US-IA',
  'US-IL',
  'US-GA',
  'US-WI',
  'US-FL',
  'US-MO',
  'US-OK',
  'US-ND',
  'US-WA',
  'US-SD',
  'US-NE',
  'US-KS',
  'US-ID',
  'US-UT',
  'US-MN',
  'US-MI',
  'US-WY',
  'US-OR',
  'US-CO',
  'US-NV',
  'US-AZ',
  'US-NM',
  'US-MT',
  'US-CA',
  'US-TX',
  'US-AK',
  'CA-BC',
  'CA-AB',
  'CA-ON',
  'CA-QC',
  'CA-SK',
  'CA-MB',
  'CA-NL',
  'CA-NB',
  'CA-NS',
  'CA-PE',
  'CA-YT',
  'CA-NT',
  'CA-NU',
  'IND',
  'AUS',
  'BRA',
  'USA',
  'MEX',
  'RU-MOW',
  'RU-SPE',
  'RU-KGD',
  'RU-IN',
  'RU-AD',
  'RU-SE',
  'RU-KB',
  'RU-KC',
  'RU-CE',
  'RU-CU',
  'RU-IVA',
  'RU-LIP',
  'RU-ORL',
  'RU-TUL',
  'RU-BE',
  'RU-VLA',
  'RU-KRS',
  'RU-KLU',
  'RU-TT',
  'RU-BRY',
  'RU-YAR',
  'RU-RYA',
  'RU-AST',
  'RU-MOS',
  'RU-SMO',
  'RU-DA',
  'RU-VOR',
  'RU-NGR',
  'RU-PSK',
  'RU-KOS',
  'RU-STA',
  'RU-KDA',
  'RU-KL',
  'RU-TVE',
  'RU-LEN',
  'RU-ROS',
  'RU-VGG',
  'RU-VLG',
  'RU-MUR',
  'RU-KR',
  'RU-NEN',
  'RU-KO',
  'RU-ARK',
  'RU-MO',
  'RU-NIZ',
  'RU-PNZ',
  'RU-KI',
  'RU-ME',
  'RU-ORE',
  'RU-ULY',
  'RU-PM',
  'RU-BA',
  'RU-UD',
  'RU-TA',
  'RU-SAM',
  'RU-SAR',
  'RU-YAN',
  'RU-KM',
  'RU-SVE',
  'RU-TYU',
  'RU-KGN',
  'RU-CH',
  'RU-BU',
  'RU-ZAB',
  'RU-IRK',
  'RU-NVS',
  'RU-TOM',
  'RU-OMS',
  'RU-KK',
  'RU-KEM',
  'RU-AL',
  'RU-ALT',
  'RU-TY',
  'RU-KYA',
  'RU-MAG',
  'RU-CHU',
  'RU-KAM',
  'RU-SAK',
  'RU-PO',
  'RU-YEV',
  'RU-KHA',
  'RU-AMU',
  'RU-SA',
  'CAN',
  'RUS',
  'CN-SH',
  'CN-TJ',
  'CN-BJ',
  'CN-HI',
  'CN-NX',
  'CN-CQ',
  'CN-ZJ',
  'CN-JS',
  'CN-FJ',
  'CN-AH',
  'CN-LN',
  'CN-SD',
  'CN-SX',
  'CN-JX',
  'CN-HA',
  'CN-GZ',
  'CN-GD',
  'CN-HB',
  'CN-JL',
  'CN-HE',
  'CN-SN',
  'CN-NM',
  'CN-HL',
  'CN-HN',
  'CN-GX',
  'CN-SC',
  'CN-YN',
  'CN-XZ',
  'CN-GS',
  'CN-QH',
  'CN-XJ',
  'CHN',
  'UMI',
  'CPT',
  'ATA',
  'AAA'
];

const _aliases = "2UK=2UT,2CG=2CT,1GU=GUM,1UM=UMI,1VI=VIR,1AS=ASM,1MP=MNP,4CX=CXR,4CC=CCK,4NF=NFK,4HM=HMD," +
    "COL=5CL,5ME=5MX,MEX=5MX,5AG=AGU,5BC=BCN,5BS=BCS,5CM=CAM,5CS=CHP,5CH=CHH,5CO=COA,5DF=DIF,5DG=DUR," +
    "5GT=GUA,5GR=GRO,5HG=HID,5JA=JAL,5MI=MIC,5MO=MOR,5NA=NAY,5NL=NLE,5OA=OAX,5PB=PUE,5QE=QUE,5QR=ROO," +
    "5SL=SLP,5SI=SIN,5SO=SON,5TB=TAB,5TL=TLA,5VE=VER,5YU=YUC,5ZA=ZAC,811=8BJ,812=8TJ,813=8HE,814=8SX," +
    "815=8NM,821=8LN,822=8JL,823=8HL,831=8SH,832=8JS,833=8ZJ,834=8AH,835=8FJ,836=8JX,837=8SD,841=8HA," +
    "842=8HB,843=8HN,844=8GD,845=8GX,846=8HI,850=8CQ,851=8SC,852=8GZ,853=8YN,854=8XZ,861=8SN,862=8GS," +
    "863=8QH,864=8NX,865=8XJ,871=TWN,891=HKG,892=MAC,8TW=TWN,8HK=HKG,8MC=MAC,BEL=7BE,KIR=7KI,PRI=7PO," +
    "CHE=7CH,KHM=7KM,PER=7PM,TAM=7TT,0US=USA,0AU=AUS,0RU=RUS,0CN=CHN,TAA=SHN,ASC=SHN,DGA=IOT,WAK=MHL," +
    "JTN=UMI,MID=1HI,1PR=PRI,5TM=TAM,TAM=TAM,2OD=2OR,";

const _usa_from = 343;
const _usa_upto = 393;
const _ccode_usa = 410;
const _ind_from = 271;
const _ind_upto = 306;
const _ccode_ind = 407;
const _can_from = 394;
const _can_upto = 406;
const _ccode_can = 495;
const _aus_from = 307;
const _aus_upto = 315;
const _ccode_aus = 408;
const _mex_from = 233;
const _mex_upto = 264;
const _ccode_mex = 411;
const _bra_from = 316;
const _bra_upto = 342;
const _ccode_bra = 409;
const _chn_from = 497;
const _chn_upto = 527;
const _ccode_chn = 528;
const _rus_from = 412;
const _rus_upto = 494;
const _ccode_rus = 496;
const _ccode_earth = 532;

const _parents3 = "USA,IND,CAN,AUS,MEX,BRA,RUS,CHN,";
const _parents2 = "US,IN,CA,AU,MX,BR,RU,CN,";

// const _ccode_start = 112; // NLD
// const _mapcode_cversion = "2.0.2";
// const _mapcode_dataversion = "2.3.0";

// *************************** mapcode_org *********************

/// PRIVATE returns string without leading spaces and plus-signs, and trailing spaces
String _trim(String str) {
  return str.replaceAll(RegExp(r'/^\s+|\s+$/g'), '').trim();
}

/// PRIVATE return 2-letter parent country abbreviation (disam in range 1..8)
String _parentname2(int disam) {
  var start = disam * 3 - 3;
  return _parents2.substring(start, start + 2);
}

/// PRIVATE given a parent country abbreviation, return disam (in range 1-8) or negative if error
int _parentletter(String territoryAlphaCode) {
  var p = -1;
  var srch = territoryAlphaCode.toUpperCase() + ',';
  var len = srch.length;
  if (len == 3) {
    p = _parents2.indexOf(srch);
  } else if (len == 4) {
    p = _parents3.indexOf(srch);
  }
  if (p < 0) {
    return -2;
  }
  return (1 + (p / len)).toInt();
}

/// PRIVATE given an ISO abbreviation, set disambiguation for future calls to iso2ccode(); returns nonzero in case of error
var _disambiguate = 1; // GLOBAL
int _set_disambiguate(String territoryAlphaCode) {
  var p = _parentletter(territoryAlphaCode);
  if (p < 0) {
    return -2;
  }
  _disambiguate = p;
  return 0;
}

/// PRIVATE returns alias of ISO abbreviation (if any), or return empty
String _alias2iso(String territoryAlphaCode) {
  String rx;
  if (territoryAlphaCode.length == 2) {
    rx = '[0-9]' + territoryAlphaCode;
  } else {
    rx = territoryAlphaCode;
  }
  rx = rx + '=';
  var p = RegExp(rx).firstMatch(_aliases);
  if (p != null) {
    return _aliases.substring(p.start + 4, p.start + 7);
  }
  return '';
}

/// PRIVATE given ISO code, return territoryNumber (or negative if error)
int _findISO(String territoryAlphaCode) {
  return iso3166alpha.indexOf(territoryAlphaCode);
}

/// PRIVATE given ISO code, return territoryNumber (or negative if error)
int? _iso2ccode(String territoryAlphaCode) {
  if (territoryAlphaCode.isEmpty) {
    return null;
  }
  territoryAlphaCode = territoryAlphaCode.toUpperCase().trim();
  var sp = territoryAlphaCode.indexOf(" ");
  if (sp > 0) {
    territoryAlphaCode = territoryAlphaCode.substring(0, sp);
  }

  var n = territoryAlphaCode.isEmpty ? 0 : int.tryParse(territoryAlphaCode);
  if (n != null) {
    if ((n >= 0) && (n <= _ccode_earth)) {
      return n;
    }
  }

  var i = 0;
  String isoa;
  var sep = territoryAlphaCode.lastIndexOf('-');
  if (sep >= 0) {
    // territory!
    var prefix = territoryAlphaCode.substring(0, sep);
    var properMapcode = territoryAlphaCode.substring(sep + 1);
    if (_set_disambiguate(prefix) != 0 || properMapcode.length < 2) {
      return -1;
    }
    i = _findISO(_parentname2(_disambiguate) + '-' + properMapcode);
    if (i >= 0) {
      return i;
    }
    // recognise alias
    if (properMapcode.length == 3) {
      isoa = _alias2iso(properMapcode);
    } else {
      isoa = _alias2iso(_disambiguate.toString() + '' + properMapcode);
    }
    if (isoa.isNotEmpty) {
      if (isoa[0] == _disambiguate.toString()) {
        properMapcode = isoa.substring(1);
      } else {
        properMapcode = isoa;
        i = _findISO(properMapcode);
        if (i >= 0) {
          return i;
        }
      }
    }
    return _findISO(_parentname2(_disambiguate) + '-' + properMapcode);
  }

  // first rewrite alias in context
  if (territoryAlphaCode.length == 2) {
    isoa = _alias2iso(_disambiguate.toString() + territoryAlphaCode);
    if (isoa.isNotEmpty) {
      if (isoa[0] == _disambiguate.toString()) {
        territoryAlphaCode = isoa.substring(1);
      } else {
        territoryAlphaCode = isoa;
      }
    }
  }

  // no prefix. check if a normal territory
  if (territoryAlphaCode.length == 3) {
    i = _findISO(territoryAlphaCode);
    if (i >= 0) {
      return i;
    }
  }

  // no prefix, check in context
  i = _findISO(_parentname2(_disambiguate) + '-' + territoryAlphaCode);
  if (i >= 0) {
    return i;
  }

  if (territoryAlphaCode.length >= 2) {
    i = _findISO(_parentname2(_disambiguate) + '-' + territoryAlphaCode);
    if (i >= 0) {
      return i;
    }
    // find in ANY context
    var hyphenated = '-' + territoryAlphaCode;
    for (i = 0; i < iso3166alpha.length; i++) {
      if (iso3166alpha[i].indexOf(hyphenated) > 0) {
        if (iso3166alpha[i].substring(iso3166alpha[i].indexOf(hyphenated)) == hyphenated) {
          return i;
        }
      }
    }
  }

  // all else failed, try non-disambiguated alphacode
  isoa = _alias2iso(territoryAlphaCode); // or try ANY alias
  if (isoa.isNotEmpty) {
    if (isoa.codeUnitAt(0) <= 57) {
      // starts with digit
      territoryAlphaCode = _parentname2(isoa.codeUnitAt(0) - 48) + '-' + isoa.substring(1);
    } else {
      territoryAlphaCode = isoa;
    }
    return _iso2ccode(territoryAlphaCode);
  }
  return -1;
}

/// PUBLIC given an alphacode (such as US-AL), returns the territory number (or negative).
/// A contextTerritoryNumber helps to interpret ambiguous (abbreviated) AlphaCodes, such as "AL"
int? _getTerritoryNumber(String territoryAlphaCode, {String? contextTerritory}) {
  if (contextTerritory != null) {
    var contextTerritoryNumber = _getTerritoryNumber(contextTerritory);
    _set_disambiguate(iso3166alpha[contextTerritoryNumber!]);
  }
  return _iso2ccode(territoryAlphaCode);
}

/// PUBLIC return parent country of subdivision (negative if territory is not a subdivision)
int getParentOf(String territory) {
  var territoryNumber = _getTerritoryNumber(territory);
  if (territoryNumber == null) return -199;
  if (territoryNumber >= _usa_from && territoryNumber <= _usa_upto) {
    return _ccode_usa;
  }
  if (territoryNumber >= _ind_from && territoryNumber <= _ind_upto) {
    return _ccode_ind;
  }
  if (territoryNumber >= _can_from && territoryNumber <= _can_upto) {
    return _ccode_can;
  }
  if (territoryNumber >= _aus_from && territoryNumber <= _aus_upto) {
    return _ccode_aus;
  }
  if (territoryNumber >= _mex_from && territoryNumber <= _mex_upto) {
    return _ccode_mex;
  }
  if (territoryNumber >= _bra_from && territoryNumber <= _bra_upto) {
    return _ccode_bra;
  }
  if (territoryNumber >= _rus_from && territoryNumber <= _rus_upto) {
    return _ccode_rus;
  }
  if (territoryNumber >= _chn_from && territoryNumber <= _chn_upto) {
    return _ccode_chn;
  }
  return -199;
}

/// PUBLIC returns true iff territoryNumber is a state
bool _isSubdivision(String territory) {
  return getParentOf(territory) >= 0;
}

/// PRIVATE returns true iff x in range (all values in millionths)
bool _isInRangeX(int x, int minx, int maxx) {
  if (minx <= x && x < maxx) {
    return true;
  }
  if (x < minx) {
    x += 360000000;
  } else {
    x -= 360000000;
  }
  return (minx <= x && x < maxx);
}

/// PRIVATE returns true iff coordinate inside rectangle (all values in millionths)
bool _fitsInside(_coord coord, _mmSet mm) {
  return (mm.miny <= coord.y && coord.y < mm.maxy && _isInRangeX(coord.x, mm.minx, mm.maxx));
}

/// PRIVATE returns true iff coordinate inside rectangle with some room to spare outside (all values in millionths)
bool _fitsInsideWithRoom(_coord coord, _mmSet mm) {
  if (((mm.miny - 60) > coord.y) || (coord.y >= (mm.maxy + 60))) {
    return false;
  }
  var xroom = _xDivider4(mm.miny, mm.maxy) ~/ 4;
  return _isInRangeX(coord.x, mm.minx - xroom, mm.maxx + xroom);
}

/// PRIVATE returns true iff coordinate inside rectangle with some room to spare inside (all values in millionths)
bool _fitsWellInside(_coord coord, _mmSet mm) {
  if (((mm.miny + 60) > coord.y) || (coord.y >= (mm.maxy - 60))) {
    return false;
  }
  var xroom = _xDivider4(mm.miny, mm.maxy) ~/ 4;
  return _isInRangeX(coord.x, mm.minx + xroom, mm.maxx - xroom);
}

/// PRIVATE returns true iff coordinate near the rectangle border
bool _isNearBorderOf(_coord coord, _mmSet mm) {
  return _fitsInsideWithRoom(coord, mm) && (!_fitsWellInside(coord, mm));
}

/// PUBLIC return the AlphaCode (usually an ISO 3166 code) of a territory
/// format: 0=local (often ambiguous), 1=international (full and unambiguous, DEFAULT), 2=shortest (shortest non-ambiguous abbreviation)
String _getTerritoryAlphaCode(String territory, int? format) {
  format ??= 1;
  var territoryNumber = _getTerritoryNumber(territory);
  if (territoryNumber == null || territoryNumber < 0 || territoryNumber > _ccode_earth) {
    return '';
  }
  var full = iso3166alpha[territoryNumber];
  var hyphen = full.indexOf("-");
  if (format == 1 || hyphen <= 0) {
    return full;
  }
  var short = full.substring(hyphen + 1);
  if (format == 0) {
    return short;
  }
  // shortest POSSIBLE
  // see if short occurs multiple times, if not, don't bother with parent
  var count = 0;
  var i = _aliases.indexOf(short + '=');
  if (i >= 0) {
    count = 2;
  } else {
    for (i = 0; i < iso3166alpha.length; i++) {
      var pos = iso3166alpha[i].indexOf("-" + short);
      if ((pos >= 0) && (iso3166alpha[i].substring(pos + 1) == short)) {
        count++;
      }
    }
  }
  return (count == 1) ? short : full;
}

/// PRIVATE low-level routines for data access
int _dataFirstRecord(int territoryNumber) {
  return _data_start[territoryNumber];
}

int _dataLastRecord(int territoryNumber) {
  return _data_start[++territoryNumber] - 1;
}

_mmSet _minmaxSetup(int i) {
  var d = _data_maxy[i];
  if (d < 10) {
    var shortmaxy = [0, 122309, 27539, 27449, 149759, 2681190, 60119, 62099, 491040, 86489];
    d = shortmaxy[d];
  }
  return _mmSet(minx: _data_minx[i], miny: _data_miny[i], maxx: _data_minx[i] + _data_maxx[i], maxy: _data_miny[i] + d);
}

/// low-level tables for mapcode encoding and decoding
const _xdivider19 = [
  360, 360, 360, 360, 360, 360, 361, 361, 361, 361, //  5.2429 degrees
  362, 362, 362, 363, 363, 363, 364, 364, 365, 366, // 10.4858 degrees
  366, 367, 367, 368, 369, 370, 370, 371, 372, 373, // 15.7286 degrees
  374, 375, 376, 377, 378, 379, 380, 382, 383, 384, // 20.9715 degrees
  386, 387, 388, 390, 391, 393, 394, 396, 398, 399, // 26.2144 degrees
  401, 403, 405, 407, 409, 411, 413, 415, 417, 420, // 31.4573 degrees
  422, 424, 427, 429, 432, 435, 437, 440, 443, 446, // 36.7002 degrees
  449, 452, 455, 459, 462, 465, 469, 473, 476, 480, // 41.9430 degrees
  484, 488, 492, 496, 501, 505, 510, 515, 520, 525, // 47.1859 degrees
  530, 535, 540, 546, 552, 558, 564, 570, 577, 583, // 52.4288 degrees
  590, 598, 605, 612, 620, 628, 637, 645, 654, 664, // 57.6717 degrees
  673, 683, 693, 704, 715, 726, 738, 751, 763, 777, // 62.9146 degrees
  791, 805, 820, 836, 852, 869, 887, 906, 925, 946, // 68.1574 degrees
  968, 990, 1014, 1039, 1066, 1094, 1123, 1154, 1187, 1223, // 73.4003 degrees
  1260, 1300, 1343, 1389, 1438, 1490, 1547, 1609, 1676, 1749, // 78.6432 degrees
  1828, 1916, 2012, 2118, 2237, 2370, 2521, 2691, 2887, 3114, // 83.8861 degrees
  3380, 3696, 4077, 4547, 5139, 5910, 6952, 8443, 10747, 14784, // 89.1290 degrees
  23681, 59485
];

const _nc = [1, 31, 961, 29791, 923521, 28629151, 887503681];
const _xside = [0, 5, 31, 168, 961, 168 * 31, 29791, 165869, 923521, 5141947, 28629151];
const _yside = [0, 6, 31, 176, 961, 176 * 31, 29791, 165869, 923521, 5141947, 28629151];

const _decodeChar = [
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  0,
  1,
  2,
  3,
  4,
  5,
  6,
  7,
  8,
  9,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -2,
  10,
  11,
  12,
  -3,
  13,
  14,
  15,
  1,
  16,
  17,
  18,
  19,
  20,
  0,
  21,
  22,
  23,
  24,
  25,
  -4,
  26,
  27,
  28,
  29,
  30,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -2,
  10,
  11,
  12,
  -3,
  13,
  14,
  15,
  1,
  16,
  17,
  18,
  19,
  20,
  0,
  21,
  22,
  23,
  24,
  25,
  -4,
  26,
  27,
  28,
  29,
  30,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1
];

const _encodeChar = [
  '0',
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  'B',
  'C',
  'D',
  'F',
  'G',
  'H',
  'J',
  'K',
  'L',
  'M',
  'N',
  'P',
  'Q',
  'R',
  'S',
  'T',
  'V',
  'W',
  'X',
  'Y',
  'Z',
  'A',
  'E',
  'U'
];

/// PRIVATE given a minimum and maximum latitude, returns a relative stretch factor (in 360th) for the longitude
int _xDivider4(int miny, int maxy) {
  if (miny >= 0) {
    return _xdivider19[(miny) >> 19];
  }
  if (maxy >= 0) {
    return _xdivider19[0];
  }
  return _xdivider19[(-maxy) >> 19];
}

/// PRIVATE lowest level encode/decode routines

int? _decodeBase31(String str) {
  var value = 0;
  for (int i = 0; i < str.length; i++) {
    var c = str.codeUnitAt(i);
    if (c == 46) {
      // dot!
      return value;
    }
    if (_decodeChar[c] < 0) {
      return null;
    }
    value = value * 31 + _decodeChar[c];
  }
  return value;
}

_coord _decodeTriple(String input) {
  int triplex = 0;
  int tripley = 0;
  var c1 = _decodeChar[input.codeUnitAt(0)];
  var x = _decodeBase31(input.substring(1));
  if (x != null) {
    if (c1 < 24) {
      triplex = (c1 % 6) * 28 + (x / 34).floor();
      tripley = (c1 / 6).floor() * 34 + (x % 34).floor();
    } else {
      tripley = (x % 40) + 136;
      triplex = (x / 40).floor() + 24 * (c1 - 24);
    }
  }
  return _coord(y: tripley, x: triplex);
}

Point<int> _decodeSixWide(int v, int width, int height) {
  var D = 6;
  var col = (v / (height * 6)).floor();
  var maxcol = ((width - 4) / 6).floor();
  if (col >= maxcol) {
    col = maxcol;
    D = width - maxcol * 6;
  }
  var w = v - (col * height * 6);
  var x6 = col * 6 + (w % D);
  var y6 = height - 1 - (w / D).floor();
  return Point<int>(x6, y6);
}

int _encodeSixWide(int x, int y, int width, int height) {
  var D = 6;
  var col = (x / 6).floor();
  var maxcol = ((width - 4) / 6).floor();
  if (col >= maxcol) {
    col = maxcol;
    D = width - maxcol * 6;
  }
  return (height * 6 * col) + (height - 1 - y) * D + (x - col * 6);
}

/// high-precision extension routines
int _maxMapcodePrecision() {
  return 8;
}

String _encodeExtension(
    String result, _enc enc, int extrax4, int extray, int dividerx4, int dividery, int extraDigits, int ydirection) {
  if (extraDigits == 0) {
    return result;
  }
  if (extraDigits > _maxMapcodePrecision()) {
    extraDigits = _maxMapcodePrecision();
  }

  // the following are all perfect integers
  var factorx = 810000.0 * dividerx4; // 810000 = 30^4
  var factory = 810000.0 * dividery;
  var valx = (810000.0 * extrax4) + (enc.fraclon);
  var valy = (810000.0 * extray) + (enc.fraclat * ydirection);

  // protect against floating point errors
  if (valx < 0) {
    valx = 0;
  } else if (valx >= factorx) {
    valx = factorx - 1;
  }
  if (valy < 0) {
    valy = 0;
  } else if (valy >= factory) {
    valy = factory - 1;
  }

  result += '-';
  for (;;) {
    factorx /= 30;
    var gx = (valx / factorx).floor();

    factory /= 30;
    var gy = (valy / factory).floor();

    var column1 = (gx / 6).floor();
    var row1 = (gy / 5).floor();
    result += _encodeChar[row1 * 5 + column1];
    if (--extraDigits == 0) {
      break;
    }

    var column2 = (gx % 6);
    var row2 = (gy % 5);
    result += _encodeChar[row2 * 6 + column2];
    if (--extraDigits == 0) {
      break;
    }

    valx -= factorx * gx;
    valy -= factory * gy;
  }
  return result;
}

// ***** MapcodeZone *****

// cconstruct and return empty MapcodeZone
_mzSet _mzEmpty() {
  return _mzSet(fminx: 0, fmaxx: 0, fminy: 0, fmaxy: 0);
}

// construct and return copy of MapcodeZone
_mzSet _mzCopy(_mzSet zone) {
  return _mzSet(fminx: zone.fminx, fmaxx: zone.fmaxx, fminy: zone.fminy, fmaxy: zone.fmaxy);
}

// return true iff MapcodeZone is empty
bool _mzIsEmpty(_mzSet zone) {
  return ((zone.fmaxx <= zone.fminx) || (zone.fmaxy <= zone.fminy));
}

// comstruct MapcodeZone based on coordinate and deltas (in Fractions)
_mzSet _mzSetFromFractions(int y, int x, int yDelta, int xDelta) {
  if (yDelta < 0) {
    return _mzSet(
        fminx: x,
        fmaxx: x + xDelta,
        fminy: y + 1 + yDelta, // y+yDelta can NOT be represented
        fmaxy: y + 1 // y CAN be represented
        );
  } else {
    return _mzSet(fminx: x, fmaxx: x + xDelta, fminy: y, fmaxy: y + yDelta);
  }
}

_coord _mzMidPointFractions(_mzSet zone) {
  return _coord(y: ((zone.fminy + zone.fmaxy) / 2).floor(), x: ((zone.fminx + zone.fmaxx) / 2).floor());
}

_coord _convertFractionsToCoord32(_coord p) {
  return _coord(y: (p.y / 810000).floor(), x: (p.x / 3240000).floor());
}

_coord _wrap(_coord p) {
  if (p.x >= (180 * 3240000 * 1000000)) {
    p.x -= (360 * 3240000 * 1000000);
  }
  if (p.x < (-180 * 3240000 * 1000000)) {
    p.x += (360 * 3240000 * 1000000);
  }
  return p;
}

LatLng _convertFractionsToDegrees(_coord p) {
  return LatLng(min(p.y / (810000 * 1000000), 90.0), p.x / (3240000 * 1000000));
}

_mzSet _mzRestrictZoneTo(_mzSet zone, _mmSet mm) {
  var z = _mzCopy(zone);
  var miny = mm.miny * 810000;
  if (z.fminy < miny) {
    z.fminy = miny;
  }
  var maxy = mm.maxy * 810000;
  if (z.fmaxy > maxy) {
    z.fmaxy = maxy;
  }
  if (z.fminy < z.fmaxy) {
    var minx = mm.minx * 3240000;
    var maxx = mm.maxx * 3240000;
    if ((maxx < 0) && (z.fminx > 0)) {
      minx += (360000000 * 3240000);
      maxx += (360000000 * 3240000);
    } else if ((minx > 1) && (z.fmaxx < 0)) {
      minx -= (360000000 * 3240000);
      maxx -= (360000000 * 3240000);
    }
    if (z.fminx < minx) {
      z.fminx = minx;
    }
    if (z.fmaxx > maxx) {
      z.fmaxx = maxx;
    }
  }
  return z;
}

// returns (possibly empty) MapcodeZone
_mzSet _decodeExtension(String extensionchars, _coord coord32, int dividerx4, int dividery, int lon_offset4,
    int extremeLatMicroDeg, int maxLonMicroDeg) {
  var processor = 1;
  var lon32 = 0;
  var lat32 = 0;
  var odd = 0;
  var idx = 0;
  if (extensionchars.length > 8) {
    return _mzEmpty(); // too many digits
  }
  while (idx < extensionchars.length) {
    int column1, row1, column2, row2;
    var c1 = _decodeChar[extensionchars.codeUnitAt(idx++)];
    if (c1 < 0 || c1 == 30) {
      return _mzEmpty();
    }
    row1 = (c1 / 5).floor();
    column1 = (c1 % 5);
    if (idx < extensionchars.length) {
      var c2 = _decodeChar[extensionchars.codeUnitAt(idx++)];
      if (c2 < 0 || c2 == 30) {
        return _mzEmpty();
      }
      row2 = (c2 / 6).floor();
      column2 = (c2 % 6);
    } else {
      //
      row2 = 0;
      odd = 1;
      column2 = 0;
    } //
    processor *= 30;
    lon32 = lon32 * 30 + column1 * 6 + column2;
    lat32 = lat32 * 30 + row1 * 5 + row2;
  } //

  while (processor < 810000.0) {
    dividerx4 *= 30;
    dividery *= 30;
    processor *= 30;
  }

  var lon4 = (coord32.x * 3240000) + (lon32 * dividerx4) + (lon_offset4 * 810000);
  var lat1 = (coord32.y * 810000) + (lat32 * dividery);

  // determine the range of coordinates that are encode to this mapcode
  _mzSet mapcodeZone;
  if (odd != 0) {
    // odd
    mapcodeZone = _mzSetFromFractions(lat1, lon4, 5 * dividery, 6 * dividerx4);
  } else {
    // not odd
    mapcodeZone = _mzSetFromFractions(lat1, lon4, dividery, dividerx4);
  } // not odd

  // FORCE_RECODE - restrict the coordinate range to the extremes that were provided
  if (mapcodeZone.fmaxx > (maxLonMicroDeg * 3240000)) {
    mapcodeZone.fmaxx = (maxLonMicroDeg * 3240000);
  }
  if (dividery >= 0) {
    if (mapcodeZone.fmaxy > (extremeLatMicroDeg * 810000)) {
      mapcodeZone.fmaxy = (extremeLatMicroDeg * 810000);
    }
  } else {
    if (mapcodeZone.fminy < (extremeLatMicroDeg * 810000)) {
      mapcodeZone.fminy = (extremeLatMicroDeg * 810000);
    }
  }
  return mapcodeZone;
}

_mzSet _decodeGrid(String input, String extensionchars, int m) {
  int relx = 0;
  int rely = 0;
  var prefixlength = input.indexOf('.');
  var postfixlength = input.length - 1 - prefixlength;
  if (prefixlength == 1 && postfixlength == 4) {
    prefixlength++;
    postfixlength--;
    input = input[0] + input[2] + '.' + input.substring(3);
  }

  int divx = 0;
  int divy = _smartdiv(m);
  if (divy == 1) {
    divx = _xside[prefixlength];
    divy = _yside[prefixlength];
  } else {
    divx = (_nc[prefixlength] / divy).floor();
  }

  if (prefixlength == 4 && divx == 961 && divy == 961) {
    input = input[0] + input[2] + input[1] + input.substring(3);
  }

  var v = _decodeBase31(input);

  if (v != null) {
    if (divx != divy && prefixlength > 2) {
      // D==6
      var rel = _decodeSixWide(v, divx, divy);
      relx = rel.x;
      rely = rel.y;
    } else {
      relx = (v / divy).floor();
      rely = (v % divy);
      rely = divy - 1 - rely;
    }
  }

  var mm = _minmaxSetup(m);
  var ygridsize = (mm.maxy - mm.miny + divy - 1).floor() ~/ divy;
  var xgridsize = (mm.maxx - mm.minx + divx - 1).floor() ~/ divx;

  rely = mm.miny + (rely * ygridsize);
  relx = mm.minx + (relx * xgridsize);

  var xp = _xside[postfixlength];
  var dividerx = ((xgridsize + xp - 1) / xp).floor();
  var yp = _yside[postfixlength];
  var dividery = ((ygridsize + yp - 1) / yp).floor();

  var rest = input.substring(prefixlength + 1);

  // decoderelative (postfix vs rely,relx)
  int difx = 0;
  int dify = 0;
  if (postfixlength == 3) {
    var d = _decodeTriple(rest);
    difx = d.x;
    dify = d.y;
  } else {
    if (postfixlength == 4) {
      rest = rest[0] + rest[2] + rest[1] + rest[3];
    }
    v = _decodeBase31(rest);
    if (v != null) {
      difx = (v / yp).floor();
      dify = (v % yp).floor();
    }
  }

  dify = yp - 1 - dify;

  var corner = _coord(
      // in microdegrees
      x: relx + (difx * dividerx),
      y: rely + (dify * dividery));

  if (!_fitsInside(corner, mm)) {
    return _mzEmpty();
  }

  var decodeMaxx = ((relx + xgridsize) < mm.maxx) ? (relx + xgridsize) : mm.maxx;
  var decodeMaxy = ((rely + ygridsize) < mm.maxy) ? (rely + ygridsize) : mm.maxy;
  return _decodeExtension(extensionchars, corner, dividerx << 2, dividery, 0, decodeMaxy, decodeMaxx); // grid
}

String _encodeBase31(int value, int nrchars) {
  var result = '';
  while (nrchars-- > 0) {
    result = _encodeChar[value % 31] + result;
    value = (value / 31).floor();
  }
  return result;
}

String _encodeTriple(int difx, int dify, int dividerx, int dividery) {
  int rx, ry, cx, cy;
  if (dify < 4 * 34) {
    rx = (difx / 28).floor();
    ry = (dify / 34).floor();
    cx = (difx % 28).toInt();
    cy = (dify % 34).toInt();

    return _encodeChar[(rx + 6 * ry)] + _encodeBase31(cx * 34 + cy, 2);
  } else {
    rx = (difx / 24).floor();
    cx = (difx % 24).toInt();

    return _encodeChar[rx + 24] + _encodeBase31(cx * 40 + (dify - 136), 2);
  }
}

String _encodeGrid(_enc enc, int m, _mmSet mm, String headerletter, int extraDigits) {
  var orgcodex = _coDex(m);
  var codex = orgcodex;
  if (codex == 21) {
    codex = 22;
  }
  if (codex == 14) {
    codex = 23;
  }

  var prefixlength = (codex / 10).floor();
  var postfixlength = (codex % 10);

  int divx;
  int divy = _smartdiv(m);
  if (divy == 1) {
    divx = _xside[prefixlength];
    divy = _yside[prefixlength];
  } else {
    divx = (_nc[prefixlength] / divy).floor();
  }

  var ygridsize = ((mm.maxy - mm.miny + divy - 1) / divy).floor();
  var rely = enc.coord32.y - mm.miny;
  rely = (rely / ygridsize).floor();
  var xgridsize = ((mm.maxx - mm.minx + divx - 1) / divx).floor();

  var x = enc.coord32.x;
  var relx = x - mm.minx;
  if (relx < 0) {
    x += 360000000;
    relx += 360000000;
  } else if (relx >= 360000000) {
    x -= 360000000;
    relx -= 360000000;
  } // 1.32 fix FIJI edge case
  if (relx < 0) {
    return "";
  }
  relx = (relx / xgridsize).floor();
  if (relx >= divx) {
    return "";
  }

  int v;
  if (divx != divy && prefixlength > 2) {
    // D==6
    v = _encodeSixWide(relx, rely, divx, divy);
  } else {
    v = relx * divy + (divy - 1 - rely);
  }
  var result = _encodeBase31(v, prefixlength);

  if (prefixlength == 4 && divx == 961 && divy == 961) {
    result = result[0] + result[2] + result[1] + result[3];
  }

  rely = mm.miny + (rely * ygridsize);
  relx = mm.minx + (relx * xgridsize);

  var dividery = ((((ygridsize)) + _yside[postfixlength] - 1) / _yside[postfixlength]).floor();
  var dividerx = ((((xgridsize)) + _xside[postfixlength] - 1) / _xside[postfixlength]).floor();

  result += '.';

  // encoderelative

  var difx = x - relx;
  var dify = enc.coord32.y - rely;
  var extrax = difx % dividerx;
  var extray = dify % dividery;
  difx = (difx / dividerx).floor();
  dify = (dify / dividery).floor();
  dify = _yside[postfixlength] - 1 - dify;

  if (postfixlength == 3) {
    result += _encodeTriple(difx, dify, dividerx, dividery);
  } else {
    var postfix = _encodeBase31((difx) * _yside[postfixlength] + dify, postfixlength);
    if (postfixlength == 4) {
      postfix = postfix[0] + postfix[2] + postfix[1] + postfix[3];
    }
    result += postfix;
  }
  // encoderelative

  if (orgcodex == 14) {
    result = result[0] + '.' + result[1] + result.substring(3);
  }

  return _encodeExtension(headerletter + result, enc, extrax << 2, extray, dividerx << 2, dividery, extraDigits, 1);
} // grid

/// alphabet support

const MAXLANS = 28;
const _asc2lan = [
  //  A       B       C       D       E       F       G       H       I       J       K       L       M       N       O       P       Q       R       S       T       U       V       W       X       Y       Z       0       1       2       3       4       5       6       7       8       9
  [
    0x0041,
    0x0042,
    0x0043,
    0x0044,
    0x0045,
    0x0046,
    0x0047,
    0x0048,
    0x0049,
    0x004a,
    0x004b,
    0x004c,
    0x004d,
    0x004e,
    0x004f,
    0x0050,
    0x0051,
    0x0052,
    0x0053,
    0x0054,
    0x0055,
    0x0056,
    0x0057,
    0x0058,
    0x0059,
    0x005a,
    0x0030,
    0x0031,
    0x0032,
    0x0033,
    0x0034,
    0x0035,
    0x0036,
    0x0037,
    0x0038,
    0x0039
  ], // roman
  [
    0x0391,
    0x0392,
    0x039e,
    0x0394,
    0x0388,
    0x0395,
    0x0393,
    0x0397,
    0x0399,
    0x03a0,
    0x039a,
    0x039b,
    0x039c,
    0x039d,
    0x039f,
    0x03a1,
    0x0398,
    0x03a8,
    0x03a3,
    0x03a4,
    0x0389,
    0x03a6,
    0x03a9,
    0x03a7,
    0x03a5,
    0x0396,
    0x0030,
    0x0031,
    0x0032,
    0x0033,
    0x0034,
    0x0035,
    0x0036,
    0x0037,
    0x0038,
    0x0039
  ], // greek
  [
    0x0410,
    0x0412,
    0x0421,
    0x0414,
    0x0415,
    0x0416,
    0x0413,
    0x041d,
    0x0049,
    0x041f,
    0x041a,
    0x041b,
    0x041c,
    0x0417,
    0x041e,
    0x0420,
    0x0424,
    0x042f,
    0x0426,
    0x0422,
    0x042d,
    0x0427,
    0x0428,
    0x0425,
    0x0423,
    0x0411,
    0x0030,
    0x0031,
    0x0032,
    0x0033,
    0x0034,
    0x0035,
    0x0036,
    0x0037,
    0x0038,
    0x0039
  ], // cyrillic
  [
    0x05d0,
    0x05d1,
    0x05d2,
    0x05d3,
    0x05e3,
    0x05d4,
    0x05d6,
    0x05d7,
    0x05d5,
    0x05d8,
    0x05d9,
    0x05da,
    0x05db,
    0x05dc,
    0x05e1,
    0x05dd,
    0x05de,
    0x05e0,
    0x05e2,
    0x05e4,
    0x05e5,
    0x05e6,
    0x05e7,
    0x05e8,
    0x05e9,
    0x05ea,
    0x0030,
    0x0031,
    0x0032,
    0x0033,
    0x0034,
    0x0035,
    0x0036,
    0x0037,
    0x0038,
    0x0039
  ], // hebrew
  [
    0x0905,
    0x0915,
    0x0917,
    0x0918,
    0x090f,
    0x091a,
    0x091c,
    0x091f,
    0x0049,
    0x0920,
    0x0923,
    0x0924,
    0x0926,
    0x0927,
    0x004f,
    0x0928,
    0x092a,
    0x092d,
    0x092e,
    0x0930,
    0x092b,
    0x0932,
    0x0935,
    0x0938,
    0x0939,
    0x092c,
    0x0966,
    0x0967,
    0x0968,
    0x0969,
    0x096a,
    0x096b,
    0x096c,
    0x096d,
    0x096e,
    0x096f
  ], // Devanagari
  [
    0x0d12,
    0x0d15,
    0x0d16,
    0x0d17,
    0x0d0b,
    0x0d1a,
    0x0d1c,
    0x0d1f,
    0x0049,
    0x0d21,
    0x0d24,
    0x0d25,
    0x0d26,
    0x0d27,
    0x0d20,
    0x0d28,
    0x0d2e,
    0x0d30,
    0x0d31,
    0x0d32,
    0x0d09,
    0x0d34,
    0x0d35,
    0x0d36,
    0x0d38,
    0x0d39,
    0x0d66,
    0x0d67,
    0x0d68,
    0x0d69,
    0x0d6a,
    0x0d6b,
    0x0d6c,
    0x0d6d,
    0x0d6e,
    0x0d6f
  ], // Malayalam
  [
    0x10a0,
    0x10a1,
    0x10a3,
    0x10a6,
    0x10a4,
    0x10a9,
    0x10ab,
    0x10ac,
    0x0049,
    0x10ae,
    0x10b0,
    0x10b1,
    0x10b2,
    0x10b4,
    0x10ad,
    0x10b5,
    0x10b6,
    0x10b7,
    0x10b8,
    0x10b9,
    0x10a8,
    0x10ba,
    0x10bb,
    0x10bd,
    0x10be,
    0x10bf,
    0x0030,
    0x0031,
    0x0032,
    0x0033,
    0x0034,
    0x0035,
    0x0036,
    0x0037,
    0x0038,
    0x0039
  ], // Georgian
  [
    0x30a2,
    0x30ab,
    0x30ad,
    0x30af,
    0x30aa,
    0x30b1,
    0x30b3,
    0x30b5,
    0x0049,
    0x30b9,
    0x30c1,
    0x30c8,
    0x30ca,
    0x30cc,
    0x004f,
    0x30d2,
    0x30d5,
    0x30d8,
    0x30db,
    0x30e1,
    0x30a8,
    0x30e2,
    0x30e8,
    0x30e9,
    0x30ed,
    0x30f2,
    0x0030,
    0x0031,
    0x0032,
    0x0033,
    0x0034,
    0x0035,
    0x0036,
    0x0037,
    0x0038,
    0x0039
  ], // Katakana
  [
    0x0e30,
    0x0e01,
    0x0e02,
    0x0e04,
    0x0e32,
    0x0e07,
    0x0e08,
    0x0e09,
    0x0049,
    0x0e0a,
    0x0e11,
    0x0e14,
    0x0e16,
    0x0e17,
    0x004f,
    0x0e18,
    0x0e1a,
    0x0e1c,
    0x0e21,
    0x0e23,
    0x0e2c,
    0x0e25,
    0x0e27,
    0x0e2d,
    0x0e2e,
    0x0e2f,
    0x0e50,
    0x0e51,
    0x0e52,
    0x0e53,
    0x0e54,
    0x0e55,
    0x0e56,
    0x0e57,
    0x0e58,
    0x0e59
  ], // Thai
  [
    0x0eb0,
    0x0e81,
    0x0e82,
    0x0e84,
    0x0ec3,
    0x0e87,
    0x0e88,
    0x0e8a,
    0x0ec4,
    0x0e8d,
    0x0e94,
    0x0e97,
    0x0e99,
    0x0e9a,
    0x004f,
    0x0e9c,
    0x0e9e,
    0x0ea1,
    0x0ea2,
    0x0ea3,
    0x0ebd,
    0x0ea7,
    0x0eaa,
    0x0eab,
    0x0ead,
    0x0eaf,
    0x0030,
    0x0031,
    0x0032,
    0x0033,
    0x0034,
    0x0035,
    0x0036,
    0x0037,
    0x0038,
    0x0039
  ], // Laos
  [
    0x0556,
    0x0532,
    0x0533,
    0x0534,
    0x0535,
    0x0538,
    0x0539,
    0x053a,
    0x053b,
    0x053d,
    0x053f,
    0x0540,
    0x0541,
    0x0543,
    0x0555,
    0x0547,
    0x0548,
    0x054a,
    0x054d,
    0x054e,
    0x0545,
    0x054f,
    0x0550,
    0x0551,
    0x0552,
    0x0553,
    0x0030,
    0x0031,
    0x0032,
    0x0033,
    0x0034,
    0x0035,
    0x0036,
    0x0037,
    0x0038,
    0x0039
  ], // armenian
  [
    0x099c,
    0x0998,
    0x0995,
    0x0996,
    0x09ae,
    0x0997,
    0x0999,
    0x099a,
    0x0049,
    0x099d,
    0x09a0,
    0x09a1,
    0x09a2,
    0x09a3,
    0x004f,
    0x09a4,
    0x09a5,
    0x09a6,
    0x09a8,
    0x09aa,
    0x099f,
    0x09ac,
    0x09ad,
    0x09af,
    0x09b2,
    0x09b9,
    0x09e6,
    0x09e7,
    0x09e8,
    0x09e9,
    0x09ea,
    0x09eb,
    0x09ec,
    0x09ed,
    0x09ee,
    0x09ef
  ], // Bengali/Assamese
  [
    0x0a05,
    0x0a15,
    0x0a17,
    0x0a18,
    0x0a0f,
    0x0a1a,
    0x0a1c,
    0x0a1f,
    0x0049,
    0x0a20,
    0x0a23,
    0x0a24,
    0x0a26,
    0x0a27,
    0x004f,
    0x0a28,
    0x0a2a,
    0x0a2d,
    0x0a2e,
    0x0a30,
    0x0a2b,
    0x0a32,
    0x0a35,
    0x0a38,
    0x0a39,
    0x0a21,
    0x0a66,
    0x0a67,
    0x0a68,
    0x0a69,
    0x0a6a,
    0x0a6b,
    0x0a6c,
    0x0a6d,
    0x0a6e,
    0x0a6f
  ], // Gurmukhi
  [
    0x0f58,
    0x0f40,
    0x0f41,
    0x0f42,
    0x0f64,
    0x0f44,
    0x0f45,
    0x0f46,
    0x0049,
    0x0f47,
    0x0f49,
    0x0f55,
    0x0f50,
    0x0f4f,
    0x004f,
    0x0f51,
    0x0f53,
    0x0f54,
    0x0f56,
    0x0f5e,
    0x0f60,
    0x0f5f,
    0x0f61,
    0x0f62,
    0x0f63,
    0x0f66,
    0x0f20,
    0x0f21,
    0x0f22,
    0x0f23,
    0x0f24,
    0x0f25,
    0x0f26,
    0x0f27,
    0x0f28,
    0x0f29
  ], // Tibetan
  [
    0x0628,
    0x062a,
    0x062d,
    0x062e,
    0x062B,
    0x062f,
    0x0630,
    0x0631,
    0x0627,
    0x0632,
    0x0633,
    0x0634,
    0x0635,
    0x0636,
    0x0647,
    0x0637,
    0x0638,
    0x0639,
    0x063a,
    0x0641,
    0x0642,
    0x062C,
    0x0644,
    0x0645,
    0x0646,
    0x0648,
    0x0030,
    0x0031,
    0x0032,
    0x0033,
    0x0034,
    0x0035,
    0x0036,
    0x0037,
    0x0038,
    0x0039
  ], // Arabic
  [
    0x1112,
    0x1100,
    0x1102,
    0x1103,
    0x1166,
    0x1105,
    0x1107,
    0x1109,
    0x1175,
    0x1110,
    0x1111,
    0x1161,
    0x1162,
    0x1163,
    0x110b,
    0x1164,
    0x1165,
    0x1167,
    0x1169,
    0x1172,
    0x1174,
    0x110c,
    0x110e,
    0x110f,
    0x116d,
    0x116e,
    0x0030,
    0x0031,
    0x0032,
    0x0033,
    0x0034,
    0x0035,
    0x0036,
    0x0037,
    0x0038,
    0x0039
  ], // Korean // 0xc601, 0xc77c, 0xc774, 0xc0bc, 0xc0ac, 0xc624, 0xc721, 0xce60, 0xd314, 0xad6c (vocal digits)
  [
    0x1005,
    0x1000,
    0x1001,
    0x1002,
    0x1013,
    0x1003,
    0x1004,
    0x101a,
    0x0049,
    0x1007,
    0x100c,
    0x100d,
    0x100e,
    0x1010,
    0x101d,
    0x1011,
    0x1012,
    0x101e,
    0x1014,
    0x1015,
    0x1016,
    0x101f,
    0x1017,
    0x1018,
    0x100f,
    0x101c,
    0x1040,
    0x1041,
    0x1042,
    0x1043,
    0x1044,
    0x1045,
    0x1046,
    0x1047,
    0x1048,
    0x1049
  ], // Burmese
  [
    0x1789,
    0x1780,
    0x1781,
    0x1782,
    0x1785,
    0x1783,
    0x1784,
    0x1787,
    0x179a,
    0x1788,
    0x178a,
    0x178c,
    0x178d,
    0x178e,
    0x004f,
    0x1791,
    0x1792,
    0x1793,
    0x1794,
    0x1795,
    0x179f,
    0x1796,
    0x1798,
    0x179b,
    0x17a0,
    0x17a2,
    0x17e0,
    0x17e1,
    0x17e2,
    0x17e3,
    0x17e4,
    0x17e5,
    0x17e6,
    0x17e7,
    0x17e8,
    0x17e9
  ], // Khmer
  [
    0x0d85,
    0x0d9a,
    0x0d9c,
    0x0d9f,
    0x0d89,
    0x0da2,
    0x0da7,
    0x0da9,
    0x0049,
    0x0dac,
    0x0dad,
    0x0daf,
    0x0db1,
    0x0db3,
    0x004f,
    0x0db4,
    0x0db6,
    0x0db8,
    0x0db9,
    0x0dba,
    0x0d8b,
    0x0dbb,
    0x0dbd,
    0x0dc0,
    0x0dc3,
    0x0dc4,
    0x0030,
    0x0031,
    0x0032,
    0x0033,
    0x0034,
    0x0035,
    0x0036,
    0x0037,
    0x0038,
    0x0039
  ], // Sinhalese
  [
    0x0794,
    0x0780,
    0x0781,
    0x0782,
    0x0797,
    0x0783,
    0x0784,
    0x0785,
    0x0049,
    0x0786,
    0x0787,
    0x0788,
    0x0789,
    0x078a,
    0x004f,
    0x078b,
    0x078c,
    0x078d,
    0x078e,
    0x078f,
    0x079c,
    0x0790,
    0x0791,
    0x0792,
    0x0793,
    0x07b1,
    0x0030,
    0x0031,
    0x0032,
    0x0033,
    0x0034,
    0x0035,
    0x0036,
    0x0037,
    0x0038,
    0x0039
  ], // Thaana
  [
    0x3123,
    0x3105,
    0x3108,
    0x3106,
    0x3114,
    0x3107,
    0x3109,
    0x310a,
    0x0049,
    0x310b,
    0x310c,
    0x310d,
    0x310e,
    0x310f,
    0x004f,
    0x3115,
    0x3116,
    0x3110,
    0x3111,
    0x3112,
    0x3113,
    0x3129,
    0x3117,
    0x3128,
    0x3118,
    0x3119,
    0x0030,
    0x0031,
    0x0032,
    0x0033,
    0x0034,
    0x0035,
    0x0036,
    0x0037,
    0x0038,
    0x0039
  ], // Chinese
  [
    0x2D49,
    0x2D31,
    0x2D33,
    0x2D37,
    0x2D53,
    0x2D3C,
    0x2D3D,
    0x2D40,
    0x2D4F,
    0x2D43,
    0x2D44,
    0x2D45,
    0x2D47,
    0x2D4D,
    0x2D54,
    0x2D4E,
    0x2D55,
    0x2D56,
    0x2D59,
    0x2D5A,
    0x2D62,
    0x2D5B,
    0x2D5C,
    0x2D5F,
    0x2D61,
    0x2D63,
    0x0030,
    0x0031,
    0x0032,
    0x0033,
    0x0034,
    0x0035,
    0x0036,
    0x0037,
    0x0038,
    0x0039
  ], // Tifinagh (BERBER)
  [
    0x0b99,
    0x0b95,
    0x0b9a,
    0x0b9f,
    0x0b86,
    0x0ba4,
    0x0ba8,
    0x0baa,
    0x0049,
    0x0bae,
    0x0baf,
    0x0bb0,
    0x0bb2,
    0x0bb5,
    0x004f,
    0x0bb4,
    0x0bb3,
    0x0bb1,
    0x0b85,
    0x0b88,
    0x0b93,
    0x0b89,
    0x0b8e,
    0x0b8f,
    0x0b90,
    0x0b92,
    0x0030,
    0x0031,
    0x0032,
    0x0033,
    0x0034,
    0x0035,
    0x0036,
    0x0037,
    0x0038,
    0x0039
  ], // Tamil (digits 0xBE6-0xBEF)
  [
    0x121B,
    0x1260,
    0x1264,
    0x12F0,
    0x121E,
    0x134A,
    0x1308,
    0x1200,
    0x0049,
    0x12E8,
    0x12AC,
    0x1208,
    0x1293,
    0x1350,
    0x12D0,
    0x1354,
    0x1240,
    0x1244,
    0x122C,
    0x1220,
    0x12C8,
    0x1226,
    0x1270,
    0x1276,
    0x1338,
    0x12DC,
    0x1372,
    0x1369,
    0x136a,
    0x136b,
    0x136c,
    0x136d,
    0x136e,
    0x136f,
    0x1370,
    0x1371
  ], // Amharic (digits 1372|1369-1371)
  [
    0x0C1E,
    0x0C15,
    0x0C17,
    0x0C19,
    0x0C2B,
    0x0C1A,
    0x0C1C,
    0x0C1F,
    0x0049,
    0x0C20,
    0x0C21,
    0x0C23,
    0x0C24,
    0x0C25,
    0x004f,
    0x0C26,
    0x0C27,
    0x0C28,
    0x0C2A,
    0x0C2C,
    0x0C2D,
    0x0C2E,
    0x0C30,
    0x0C32,
    0x0C33,
    0x0C35,
    0x0030,
    0x0031,
    0x0032,
    0x0033,
    0x0034,
    0x0035,
    0x0036,
    0x0037,
    0x0038,
    0x0039
  ], // Telugu
  [
    0x0B1D,
    0x0B15,
    0x0B16,
    0x0B17,
    0x0B23,
    0x0B18,
    0x0B1A,
    0x0B1C,
    0x0049,
    0x0B1F,
    0x0B21,
    0x0B22,
    0x0B24,
    0x0B25,
    0x0B20,
    0x0B26,
    0x0B27,
    0x0B28,
    0x0B2A,
    0x0B2C,
    0x0B39,
    0x0B2E,
    0x0B2F,
    0x0B30,
    0x0B33,
    0x0B38,
    0x0030,
    0x0031,
    0x0032,
    0x0033,
    0x0034,
    0x0035,
    0x0036,
    0x0037,
    0x0038,
    0x0039
  ], // Odia
  [
    0x0C92,
    0x0C95,
    0x0C96,
    0x0C97,
    0x0C8E,
    0x0C99,
    0x0C9A,
    0x0C9B,
    0x0049,
    0x0C9C,
    0x0CA0,
    0x0CA1,
    0x0CA3,
    0x0CA4,
    0x004f,
    0x0CA6,
    0x0CA7,
    0x0CA8,
    0x0CAA,
    0x0CAB,
    0x0C87,
    0x0CAC,
    0x0CAD,
    0x0CB0,
    0x0CB2,
    0x0CB5,
    0x0030,
    0x0031,
    0x0032,
    0x0033,
    0x0034,
    0x0035,
    0x0036,
    0x0037,
    0x0038,
    0x0039
  ], // Kannada
  [
    0x0AB3,
    0x0A97,
    0x0A9C,
    0x0AA1,
    0x0A87,
    0x0AA6,
    0x0AAC,
    0x0A95,
    0x0049,
    0x0A9A,
    0x0A9F,
    0x0AA4,
    0x0AAA,
    0x0AA0,
    0x004f,
    0x0AB0,
    0x0AB5,
    0x0A9E,
    0x0AAE,
    0x0AAB,
    0x0A89,
    0x0AB7,
    0x0AA8,
    0x0A9D,
    0x0AA2,
    0x0AAD,
    0x0030,
    0x0031,
    0x0032,
    0x0033,
    0x0034,
    0x0035,
    0x0036,
    0x0037,
    0x0038,
    0x0039
  ], // Gujarati
];

/// PRIVATE substitute characters in str with characters form the specified language (pass asHTML=1 to explicitly HTML-encode characters)
String _showinlan(String str, int lan, bool asHTML) {
  str = _to_ascii(str);
  if (lan == 0) {
    return str;
  }

  var result = '';

  // skip leading territory
  var sp = str.indexOf(' ');
  if (sp++ > 0) {
    result = str.substring(0, sp);
    str = str.substring(sp);
  }

  if (lan == 1 || lan == 3 || lan == 14 || lan == 15) {
    // greek hebrew arabic korean
    str = _convertToAbjad(str);
  }

  // unpack for languages that do not support E and U
  if (lan == 1) {
    // greek
    var rest = '';
    var h = str.indexOf('-');
    if (h >= 0) {
      rest = str.substring(h);
      str = str.substring(0, h);
    }
    if (str.contains('E') || str.contains('U')) {
      str = _aeu_pack(_aeu_unpack(str), short: true);
    }
    str += rest;
  }

  // substitute
  for (var i = 0; i < str.length; i++) {
    var c = str.codeUnitAt(i);
    if (c >= 65 && c <= 90) {
      c = _asc2lan[lan][c - 65];
    } else if (c >= 48 && c <= 57) {
      c = _asc2lan[lan][c + 26 - 48];
    }

    if (asHTML && (c < 32 || c > 93)) {
      result += '&#' + c.toString() + ';';
    } else {
      result += String.fromCharCode(c);
    }
  }
  return result;
}

/// PRIVATE convert all characters to Roman (ASCII) alphabet (if possible)
String _to_ascii(String str) {
  var letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
  var result = '';
  str = str.trim().toUpperCase();
  if (str.isEmpty) return str;

  var len = str.length;
  for (var i = 0; i < len; i++) {
    var c = str.codeUnitAt(i);
    if (c > 0 && c < 127) {
      result += str[i];
    } else {
      var found = 0;
      for (int lan = 0; lan < MAXLANS; lan++) {
        var nrc = _asc2lan[lan].length;
        for (int j = 0; j < nrc; j++) {
          if (c == _asc2lan[lan][j]) {
            result += letters[j];
            found = 1;
            break;
          }
        }
        if (found != 0) {
          break;
        }
      }
      if (found == 0) {
        result += '?';
      }
    }
  }
  var p = result.lastIndexOf(' ');
  if (p < 0) {
    p = 0;
  } else {
    p++;
  }
  if (result[p] == 'A') {
    var mc = result.substring(p);
    var rest = '';
    var h = mc.indexOf('-');
    if (h >= 0) {
      rest = mc.substring(h);
      mc = mc.substring(0, h);
    }
    result = result.substring(0, p) + _aeu_pack(_aeu_unpack(mc), short: false) + rest;
    /* v1.50 repack A-voweled to AEU-voweled */
  }

  if (_isAbjadScript(str)) {
    result = _convertFromAbjad(result);
  }

  return result;
}

/// PRIVATE lowest-level data access
String _headerLetter(int i) {
  var flags = _data_flags[i];
  if (((flags >> 7) & 3) == 1) {
    return _encodeChar[(flags >> 11) & 31];
  }
  return '';
}

int _smartdiv(int i) {
  return _data_special1[i];
}

bool isRestricted(int i) {
  return (_data_flags[i] & 512) != 0;
}

bool _isNameless(int i) {
  return (_data_flags[i] & 64) != 0;
}

bool _isAutoHeader(int i) {
  return (_data_flags[i] & (8 << 5)) != 0;
}

int _codexLen(int i) {
  var flags = _data_flags[i] & 31;
  return (flags / 5).floor() + (flags % 5) + 1;
}

int _coDex(int i) {
  var flags = _data_flags[i] & 31;
  return 10 * (flags / 5).floor() + (flags % 5) + 1;
}

bool _isSpecialShape(int i) {
  return (_data_flags[i] & 1024) != 0;
}

int _recType(int i) {
  return ((_data_flags[i] >> 7) & 3); // 1=pipe 2=plus 3=star
}

int _firstNamelessRecord(int index, int firstcode) {
  var i = index;
  var codex = _coDex(i);
  while (i >= firstcode && _coDex(i) == codex && _isNameless(i)) {
    i--;
  }
  return (i + 1);
}

int _countNamelessRecords(int index, int firstcode) {
  var i = _firstNamelessRecord(index, firstcode);
  var e = index;
  var codex = _coDex(e);
  while (_coDex(e) == codex) {
    e++;
  }
  return (e - i);
}

// mid-level encode/decode
String _encodeNameless(_enc enc, int m, int firstcode, int extraDigits) {
  var A = _countNamelessRecords(m, firstcode);
  if (A < 1) {
    return '';
  }
  var p = (31 / A).floor();
  var r = (31 % A);
  var codex = _coDex(m);
  var codexlen = _codexLen(m);
  var X = m - _firstNamelessRecord(m, firstcode);

  int storage_offset;

  if (codex != 21 && A <= 31) {
    storage_offset = (X * p + (X < r ? X : r)) * (961 * 961);
  } else if (codex != 21 && A < 62) {
    if (X < (62 - A)) {
      storage_offset = X * (961 * 961);
    } else {
      storage_offset = (62 - A + ((X - 62 + A) / 2).floor()) * (961 * 961);
      if (((X + A) % 2) == 1) {
        storage_offset += (16 * 961 * 31);
      }
    }
  } else {
    var BASEPOWER = (codex == 21) ? 961 * 961 : 961 * 961 * 31;
    var BASEPOWERA = (BASEPOWER / A).floor();
    if (A == 62) {
      BASEPOWERA++;
    } else {
      BASEPOWERA = (961) * (BASEPOWERA / 961).floor();
    }

    storage_offset = X * BASEPOWERA;
  }

  var mm = _minmaxSetup(m);
  var SIDE = _smartdiv(m);
  var orgSIDE = SIDE;
  var xSIDE = SIDE;

  var dividerx4 = _xDivider4(mm.miny, mm.maxy); // note that xDivider4 is 4 times too large
  var xFracture = (enc.fraclon / 810000).floor();
  var dx = ((4 * (enc.coord32.x - mm.minx) + xFracture).floor() / dividerx4).floor(); // dx is in millionths
  var extrax4 = (enc.coord32.x - mm.minx) * 4 - dx * dividerx4; // extrax4 is in quarter-millionths

  var dividery = 90;
  var dy = ((mm.maxy - enc.coord32.y) / dividery).floor();
  var extray = (mm.maxy - enc.coord32.y) % dividery;

  if (extray == 0 && enc.fraclat > 0) {
    dy--;
    extray += dividery;
  }

  var v = storage_offset;
  if (_isSpecialShape(m)) {
    xSIDE *= SIDE;
    SIDE = 1 + ((mm.maxy - mm.miny) / 90).floor();
    xSIDE = (xSIDE / SIDE).floor();
    v += _encodeSixWide(dx, SIDE - 1 - dy, xSIDE, SIDE);
  } else {
    v += (dx * SIDE + dy);
  }

  var result = _encodeBase31(v, codexlen + 1);

  if (codexlen == 3) {
    result = result.substring(0, 2) + '.' + result.substring(2);
  } else if (codexlen == 4) {
    if (codex == 22 && orgSIDE == 961 && !_isSpecialShape(m)) {
      result = result[0] + result[1] + result[3] + '.' + result[2] + result[4];
    } else if (codex == 13) {
      result = result.substring(0, 2) + '.' + result.substring(2);
    } else {
      result = result.substring(0, 3) + '.' + result.substring(3);
    }
  }

  return _encodeExtension(result, enc, extrax4, extray, dividerx4, dividery, extraDigits, -1);
} // nameless

_mzSet _decodeNameless(String input, String extensionchars, int m, int firstindex) {
  var codex = _coDex(m);
  if (codex == 22) {
    input = input.substring(0, 3) + input.substring(4);
  } else {
    input = input.substring(0, 2) + input.substring(3);
  }

  var A = _countNamelessRecords(m, firstindex);
  var F = _firstNamelessRecord(m, firstindex);
  var p = (31 / A).floor();
  int r = (31 % A);
  int? v = 0;
  int X = 0;
  var swapletters = false;

  if (codex != 21 && A <= 31) {
    var offset = _decodeChar[input.codeUnitAt(0)];

    if (offset < r * (p + 1)) {
      X = (offset / (p + 1)).floor();
    } else {
      swapletters = (p == 1 && codex == 22);
      X = r + ((offset - (r * (p + 1))) / p).floor();
    }
  } else if (codex != 21 && A < 62) {
    X = _decodeChar[input.codeUnitAt(0)];
    if (X < (62 - A)) {
      swapletters = (codex == 22);
    } else {
      X += (X - (62 - A));
    }
  } else {
    // codex==21 || A>=62
    var BASEPOWER = (codex == 21) ? 961 * 961 : 961 * 961 * 31;
    var BASEPOWERA = (BASEPOWER / A).floor();
    if (A == 62) {
      BASEPOWERA++;
    } else {
      BASEPOWERA = 961 * (BASEPOWERA / 961).floor();
    }

    // decode
    v = _decodeBase31(input);

    if (v != null) {
      X = (v / BASEPOWERA).floor();
      v %= BASEPOWERA;
    }
  }

  if (swapletters) {
    if (!_isSpecialShape(m + X)) {
      input = input[0] + input[1] + input[3] + input[2] + input[4];
    }
  }

  if (codex != 21 && A <= 31) {
    v = _decodeBase31(input);

    if (X > 0 && v != null) {
      v -= ((X * p + (X < r ? X : r)) * (961 * 961));
    }
  } else if (codex != 21 && A < 62) {
    v = _decodeBase31(input.substring(1));

    if (X >= (62 - A) && v != null) {
      if (v >= (16 * 961 * 31)) {
        v -= (16 * 961 * 31);
        X++;
      }
    }
  }

  if (X > A) {
    // past end!
    return _mzEmpty();
  }

  m = F + X;
  var mm = _minmaxSetup(m);

  var SIDE = _smartdiv(m);
  var xSIDE = SIDE;

  int dx = 0;
  int dy = 0;
  if (_isSpecialShape(m)) {
    xSIDE *= SIDE;
    SIDE = 1 + ((mm.maxy - mm.miny) / 90).floor();
    xSIDE = (xSIDE / SIDE).floor();

    if (v != null) {
      var d = _decodeSixWide(v, xSIDE, SIDE);
      dx = d.x;
      dy = SIDE - 1 - d.y;
    }
  } else if (v != null) {
    dy = (v % SIDE);
    dx = (v / SIDE).floor();
  }

  if (dx >= xSIDE) {
    // else out-of-range!
    return _mzEmpty();
  }

  var dividerx4 = _xDivider4(mm.miny, mm.maxy); // 4 times too large!
  var dividery = 90;

  var corner = _coord(
      // in microdegrees
      y: mm.maxy - (dy * dividery),
      x: mm.minx + ((dx * dividerx4) / 4).floor());
  return _decodeExtension(
      extensionchars, corner, dividerx4, -dividery, ((dx * dividerx4) % 4), mm.miny, mm.maxx); // nameless
}

String _encodeAutoHeader(_enc enc, int m, int extraDigits) {
  var STORAGE_START = 0;

  // search back to first of the group
  var codex = _coDex(m);
  var codexlen = _codexLen(m);
  var firstindex = m;
  while (_isAutoHeader(firstindex - 1) && _coDex(firstindex - 1) == codex) {
    firstindex--;
  }

  for (int i = firstindex; _coDex(i) == codex; i++) {
    var mm = _minmaxSetup(i);
    var H = ((mm.maxy - mm.miny + 89) / 90).floor();
    var xdiv = _xDivider4(mm.miny, mm.maxy);
    var W = (((mm.maxx - mm.minx) * 4 + (xdiv - 1)) / xdiv).floor();

    H = 176 * ((H + 176 - 1) / 176).floor();
    W = 168 * ((W + 168 - 1) / 168).floor();

    var product = (W / 168).floor() * (H / 176).floor() * 961 * 31;

    if (_recType(i) == 2) {
      // *+
      var GOODROUNDER = codex >= 23 ? (961 * 961 * 31) : (961 * 961);
      product =
          (((STORAGE_START + product + GOODROUNDER - 1) / GOODROUNDER).floor() * GOODROUNDER - STORAGE_START).toInt();
    }

    if (i == m && _fitsInside(enc.coord32, mm)) {
      var dividerx = ((mm.maxx - mm.minx + W - 1) / W).floor();
      var vx = ((enc.coord32.x - mm.minx) / dividerx).floor();
      var extrax = ((enc.coord32.x - mm.minx) % dividerx);

      var dividery = ((mm.maxy - mm.miny + H - 1) / H).floor();
      var vy = ((mm.maxy - enc.coord32.y) / dividery).floor();
      var extray = ((mm.maxy - enc.coord32.y) % dividery);

      var spx = vx % 168;
      vx = (vx / 168).floor();
      var value = vx * (H / 176).floor();

      if (extray == 0 && enc.fraclat > 0) {
        vy--;
        extray += dividery;
      }

      var spy = vy % 176;
      vy = (vy / 176).floor();
      value += vy;

      var mapc = _encodeBase31((STORAGE_START / (961 * 31)).floor() + value, codexlen - 2) +
          '.' +
          _encodeTriple(spx, spy, dividerx, dividery);

      return _encodeExtension(mapc, enc, extrax << 2, extray, dividerx << 2, dividery, extraDigits, -1);
    }
    STORAGE_START += product;
  }
  return '';
} // autoheader

_mzSet _decodeAutoHeader(String input, String extensionchars, int m) {
  var STORAGE_START = 0;
  var codex = _coDex(m);

  var value = _decodeBase31(input); // decode (before dot)

  if (value != null) {
    value *= (961 * 31);
  }
  var triple = _decodeTriple(input.substring(input.length - 3)); // decode bottom 3 chars

  for (; _coDex(m) == codex && _recType(m) > 1; m++) {
    var mm = _minmaxSetup(m);

    var H = ((mm.maxy - mm.miny + 89) / 90).floor();
    var xdiv = _xDivider4(mm.miny, mm.maxy);
    var W = (((mm.maxx - mm.minx) * 4 + (xdiv - 1)) / xdiv).floor();

    H = 176 * ((H + 176 - 1) / 176).floor();
    W = 168 * ((W + 168 - 1) / 168).floor();

    var product = (W / 168).floor() * (H / 176).floor() * 961 * 31;

    if (_recType(m) == 2) {
      var GOODROUNDER = codex >= 23 ? (961 * 961 * 31) : (961 * 961);
      product = ((STORAGE_START + product + GOODROUNDER - 1) / GOODROUNDER).floor() * GOODROUNDER - STORAGE_START;
    }

    if (value != null && value >= STORAGE_START && value < STORAGE_START + product) {
      // code belongs here?
      var dividerx = ((mm.maxx - mm.minx + W - 1) / W).floor();
      var dividery = ((mm.maxy - mm.miny + H - 1) / H).floor();

      value -= STORAGE_START;
      value = (value / (961 * 31)).floor();

      var vx = triple.x + 168 * (value / (H / 176).floor()).floor();
      var vy = triple.y + 176 * (value % (H / 176).floor());

      var corner = _coord(
          // in microdegrees
          y: mm.maxy - (vy * dividery),
          x: mm.minx + (vx * dividerx));
      if ((corner.y != mm.maxy) && (!_fitsInside(corner, mm))) {
        return _mzEmpty();
      }

      return _decodeExtension(extensionchars, corner, dividerx << 2, -dividery, 0, mm.miny, mm.maxx); // autoheader
    }
    STORAGE_START += product;
  }
  return _mzEmpty();
}

/// PRIVATE add vowels to prevent a mapcode r from being all-digit
String _aeu_pack(String r, {bool short = false}) /* v1.50 */ {
  var dotpos = -9;
  var rlen = r.length;
  var rest = '';
  for (int d = 0; d < rlen; d++) {
    if (!r[d].isNumber) {
      // not digit?
      if (r[d] == '.' && dotpos < 0) {
        dotpos = d; // first dot?
      } else if (r[d] == '-') {
        rest = r.substring(d);
        r = r.substring(0, d);
        rlen = d;
      } else {
        return r;
      }
    }
  }

  var v = 0;
  if (dotpos >= 2 && rlen - 2 > dotpos) {
    // does r have a dot, AND at least 2 chars after the dot?
    if (short) {
      /* v1.50 new way: use only A */
      v = (r.codeUnitAt(0) - 48) * 100 + (r.codeUnitAt(rlen - 2) - 48) * 10 + (r.codeUnitAt(rlen - 1) - 48);
      r = 'A' + r.substring(1, rlen - 2) + _encodeChar[(v / 32).floor()] + _encodeChar[v % 32]; // 1.50
    } else {
      /* old way: use A, E and U */
      v = (r.codeUnitAt(rlen - 2) - 48) * 10 + (r.codeUnitAt(rlen - 1) - 48);
      r = r.substring(0, rlen - 2) + _encodeChar[(v / 34).floor() + 31] + _encodeChar[v % 34]; // v1.50
    }
  }
  return r + rest;
}

_enc _getEncodeRec(double lat, double lon) {
  if (lat < -90) {
    lat = -90;
  } else if (lat > 90) {
    lat = 90;
  }
  lat += 90; // lat now [0..180]
  lat *= 810000000000;
  var fraclat = (lat + 0.1).floor();
  var d = fraclat / 810000;
  var lat32 = d.floor();
  fraclat -= (lat32 * 810000);
  lat32 -= 90000000;

  lon -= (360 * (lon / 360).floor()); // lon now in [0..360>
  lon *= 3240000000000;
  var fraclon = (lon + 0.1).floor();
  d = fraclon / 3240000;
  var lon32 = d.floor();
  fraclon -= (lon32 * 3240000);
  if (lon32 >= 180000000) {
    lon32 -= 360000000;
  }

  return _enc(coord32: _coord(y: lat32, x: lon32), fraclat: fraclat, fraclon: fraclon);
}

List<McInfo> _mapcoderEngine(_enc enc, int? tn, bool getshortest, int state_override, int extraDigits) {
  var results = <McInfo>[];

  var mcInfo = McInfo();

  var fromTerritory = 0;
  var uptoTerritory = _ccode_earth;
  if (tn != null) {
    if (tn < 0 || tn > _ccode_earth) {
      tn = _ccode_earth;
    }
    fromTerritory = tn;
    uptoTerritory = tn;
  }

  for (var territoryNumber = fromTerritory; territoryNumber <= uptoTerritory; territoryNumber++) {
    var original_length = results.length;
    var from = _dataFirstRecord(territoryNumber);
    if (_data_flags[from] == 0) {
      continue;
    } // 1.27 survive partially filled data_ array
    var upto = _dataLastRecord(territoryNumber);

    // make sure it fits the country
    if (territoryNumber != _ccode_earth) {
      if (!(_fitsInside(enc.coord32, _minmaxSetup(upto)))) {
        // does not fit encompassing rect?
        continue;
      }
    }

    for (var i = from; i <= upto; i++) {
      if (_coDex(i) < 54) {
        // exlude 54 and 55
        var mm = _minmaxSetup(i);
        if (_fitsInside(enc.coord32, mm)) {
          String r;
          if (_isNameless(i)) {
            r = _encodeNameless(enc, i, from, extraDigits);
          } else if (_recType(i) > 1) {
            r = _encodeAutoHeader(enc, i, extraDigits);
          } else if ((i == upto) && (getParentOf(territoryNumber.toString()) >= 0)) {
            var moreresults = _mapcoderEngine(
                enc, getParentOf(territoryNumber.toString()), getshortest, territoryNumber, extraDigits);
            if (moreresults.isNotEmpty) {
              results.addAll(moreresults);
            }
            continue;
          } else {
            if (isRestricted(i) && results.length == original_length) {
              r = ''; // restricted, and no shorter mapcodes exist: do not generate mapcodes
            } else {
              r = _encodeGrid(enc, i, mm, _headerLetter(i), extraDigits);
            }
          }

          if (r.length > 4) {
            r = _aeu_pack(r);

            var storecode = territoryNumber;
            if (state_override >= 0) {
              storecode = state_override;
            }

            mcInfo = McInfo();
            mcInfo.mapcode = r;

            mcInfo.territoryAlphaCode = _getTerritoryAlphaCode(storecode.toString(), null);
            mcInfo.fullmapcode = (storecode == _ccode_earth ? '' : mcInfo.territoryAlphaCode + ' ') + r;
            mcInfo.territoryNumber = storecode;
            results.add(mcInfo);

            if (getshortest) {
              break;
            }
          }
        } // inside territory rectangle
      }
    }
  }

  return results;
}

/// PRIVATE remove vowels from mapcode str into an all-digit mapcode (assumes str is already uppercase!)
String _aeu_unpack(String str) {
  var voweled = 0;
  var lastpos = str.length - 1;
  var dotpos = str.indexOf('.');
  if (dotpos < 2 || lastpos < dotpos + 2) {
    return str;
  } // Error: no dot, or less than 2 letters before dot, or less than 2 letters after dot

  if (str[0] == 'A') /* V1.50 */
  {
    var v1 = _decodeChar[str.codeUnitAt(lastpos)];
    if (v1 < 0) {
      v1 = 31;
    }
    var v2 = _decodeChar[str.codeUnitAt(lastpos - 1)];
    if (v2 < 0) {
      v2 = 31;
    }
    var s = (1000 + v1 + 32 * v2).toString();
    str = s[1] + str.substring(1, lastpos - 1) + s[2] + s[3];
    voweled = 1;
  } else if (str[0] == 'U') {
    /* V1.50 */
    voweled = 1;
    str = str.substring(1);
    dotpos--;
  } else {
    var vS = str[lastpos - 1];
    var v = 0;
    if (vS == 'A') {
      v = 0;
    } else if (vS == 'E') {
      v = 34;
    } else if (vS == 'U') {
      v = 68;
    } else {
      v = -1;
    }
    if (v >= 0) {
      var e = str[lastpos];
      if (e == 'A') {
        v += 31;
      } else if (e == 'E') {
        v += 32;
      } else if (e == 'U') {
        v += 33;
      } else {
        var ve = _decodeChar[str.codeUnitAt(lastpos)];
        if (ve < 0) {
          return '';
        }
        v += ve;
      }
      if (v >= 100) {
        return '';
      }
      voweled = 1;
      str = str.substring(0, lastpos - 1) + _encodeChar[(v / 10).floor()] + _encodeChar[(v % 10).floor()];
    }
  }

  if (dotpos < 2 || dotpos > 5) {
    return '';
  }

  var hasletters = 0;
  for (var v = 0; v <= lastpos; v++) {
    if (v != dotpos) {
      if (_decodeChar[str.codeUnitAt(v)] < 0) {
        return '';
      } else if (_decodeChar[str.codeUnitAt(v)] > 9) {
        // bad char!
        hasletters++;
      }
    }
  }
  if (voweled != 0 && hasletters != 0) {
    return '';
  }
  if (voweled == 0 && hasletters == 0) {
    return '';
  }
  return str;
}

/// PRIVATE decode a PROPER mapcode within a KNOWN territory number to an x,y coordinate (or false)
LatLng? _master_decode(String mapcode, int territoryNumber) {
  // returns object with y and x fields, or false
  mapcode = _to_ascii(mapcode);
  var extensionchars = '';
  var minpos = mapcode.indexOf('-');
  if (minpos > 0) {
    extensionchars = _trim(mapcode.substring(minpos + 1));
    mapcode = _trim(mapcode.substring(0, minpos));
  }

  mapcode = _aeu_unpack(mapcode);
  if (mapcode == '') {
    return null;
  } // failed to decode!

  var mclen = mapcode.length;

  if (mclen >= 10) {
    territoryNumber = _ccode_earth;
  }
  // *** long codes in states are handled by the country
  var parent = getParentOf(territoryNumber.toString());
  if (parent >= 0) {
    if (mclen >= 9 || (mclen >= 8 && (parent == _ccode_ind || parent == _ccode_mex))) {
      territoryNumber = parent;
    }
  }

  var from = _dataFirstRecord(territoryNumber);
  if (_data_flags[from] == 0) {
    return null;
  } // 1.27 survive partially filled data_ array
  var upto = _dataLastRecord(territoryNumber);

  var prefixlength = mapcode.indexOf('.');
  var postfixlength = mclen - 1 - prefixlength;
  var incodex = prefixlength * 10 + postfixlength;

  var zone = _mzEmpty();
  for (int m = from; m <= upto; m++) {
    var codex = _coDex(m);
    if (_recType(m) == 0 && !_isNameless(m) && (incodex == codex || (incodex == 22 && codex == 21))) {
      zone = _decodeGrid(mapcode, extensionchars, m);

      // first of all, make sure the zone fits the country
      zone = _mzRestrictZoneTo(zone, _minmaxSetup(upto));

      if (!_mzIsEmpty(zone) && isRestricted(m)) {
        var nrZoneOverlaps = 0;
        // get midpoint in microdegrees
        var coord32 = _convertFractionsToCoord32(_mzMidPointFractions(zone));
        for (int j = m - 1; j >= from; j--) {
          // look in previous rects
          if (!isRestricted(j)) {
            if (_fitsInside(coord32, _minmaxSetup(j))) {
              nrZoneOverlaps++;
              break;
            }
          }
        }

        if (nrZoneOverlaps == 0) {
          // see if mapcode zone OVERLAPS any sub-area...
          var zfound = _mzEmpty();
          for (var j = from; j < m; j++) {
            // try all smaller rectangles j
            if (!isRestricted(j)) {
              var z = _mzRestrictZoneTo(zone, _minmaxSetup(j));
              if (!_mzIsEmpty(z)) {
                nrZoneOverlaps++;
                if (nrZoneOverlaps == 1) {
                  // first fit! remember...
                  zfound = _mzCopy(z);
                } else {
                  // nrZoneOverlaps > 1
                  // more than one hit
                  break; // give up!
                }
              }
            }
          }
          if (nrZoneOverlaps == 1) {
            // intersected exactly ONE sub-area?
            zone = _mzCopy(zfound); // use the intersection found...
          }
        }

        if (nrZoneOverlaps == 0) {
          zone = _mzEmpty();
        }
      }
      break;
    } else if (_recType(m) == 1 && codex + 10 == incodex && _headerLetter(m) == mapcode[0]) {
      zone = _decodeGrid(mapcode.substring(1), extensionchars, m);
      break;
    } else if (_isNameless(m) &&
        ((codex == 21 && incodex == 22) || (codex == 22 && incodex == 32) || (codex == 13 && incodex == 23))) {
      zone = _decodeNameless(mapcode, extensionchars, m, from);
      break;
    } else if (_recType(m) > 1 && postfixlength == 3 && _codexLen(m) == prefixlength + 2) {
      zone = _decodeAutoHeader(mapcode, extensionchars, m);
      break;
    }
  }

  zone = _mzRestrictZoneTo(zone, _minmaxSetup(upto));
  if (_mzIsEmpty(zone)) {
    return null;
  }

  return _convertFractionsToDegrees(_wrap(_mzMidPointFractions(zone)));
}

// ******************** legacy interface *****************

const _maxErrorInMetersForDigits = [7.49, 1.39, 0.251, 0.0462, 0.00837, 0.00154, 0.00028, 0.000052, 0.0000093];

// ******************** public interface *****************

/// PUBLIC returns {distance,width,height}, the distance between two coordinates, and the longitudinal distance ("width") and latitudinal distance ("height") - all expressed in meters
/// Warning: accurate only for coordinates within a few hundred meters of each other
double distanceInMeters(double latDeg1, double lonDeg1, double latDeg2, double lonDeg2) {
  if (lonDeg1 < 0 && lonDeg2 > 1) {
    lonDeg1 += 360;
  }
  if (lonDeg2 < 0 && lonDeg1 > 1) {
    lonDeg2 += 360;
  }
  var dx = 111319.49079327 * (lonDeg2 - lonDeg1) * cos((latDeg1 + latDeg2) * pi / 360.0);
  var dy = 110946.25213273 * (latDeg2 - latDeg1);
  return sqrt(dx * dx + dy * dy);
}

/// PUBLIC convert a mapcode (skipping the territory abbreviation) into a particular alphabet
/// targetAlphabet: 0=roman, 1=greek etc.
/// returns: string
String convertToAlphabet(String mapcode, int targetAlphabet) {
  return _showinlan(mapcode, targetAlphabet, false);
}

/// PUBLIC decode a string (which may contain a full mapcode, including a territory)
/// the optional contextTerritoryNumber is used in case the mapcode specifies no (unambiguous) territory.
/// returns coordinate, or false.
LatLng? decode(String mapcodeString, String territory) {
  mapcodeString = _trim(mapcodeString);
  var contextTerritoryNumber = _getTerritoryNumber(_trim(territory));
  contextTerritoryNumber ??= _ccode_earth;
  var parts = mapcodeString.split(RegExp(r'\s+'));
  LatLng? dec;
  if (parts.length == 2) {
    if (_isSubdivision(contextTerritoryNumber.toString())) {
      contextTerritoryNumber = getParentOf(contextTerritoryNumber.toString());
    }
    var territoryNumber = _getTerritoryNumber(parts[0], contextTerritory: contextTerritoryNumber.toString());
    if (territoryNumber != null && territoryNumber >= 0) {
      dec = _master_decode(parts[1], territoryNumber);
    }
  } else if (parts.length == 1) {
    dec = _master_decode(parts[0], contextTerritoryNumber);
  }
  return dec;
}

/// PUBLIC encode variants.
/// return an array of mapcodes, each representing the specified coordinate.
/// if a territory number is specified, only mapcodes (if any) within that territory are returned.
/// the Shortest variants return at most one mapcode (the "default" and "shortest possible" mapcode) in any territory.
/// the International variants only return the 9-letter "international" mapcode
/// the WithPrecision variants produce mapcodes extended with high-precision letters (the parameter specifies how many letters: 0, 1, or 2).

List<McInfo> encodeWithPrecision(double latitudeDegrees, double longitudeDegrees, int precision, String territory) {
  return _mapcoderEngine(_getEncodeRec(latitudeDegrees, longitudeDegrees), _getTerritoryNumber(territory),
      false /*getshortest*/, -1 /*override*/, precision);
}

List<McInfo> encodeInternationalWithPrecision(double latitudeDegrees, double longitudeDegrees, int precision) {
  return encodeWithPrecision(latitudeDegrees, longitudeDegrees, precision, _ccode_earth.toString());
}

// returns true iff coordinate is near more than one territory border
bool multipleBordersNearby(double latitudeDegrees, double longitudeDegrees, String territory) {
  var territoryNumber = _getTerritoryNumber(territory);
  if (territoryNumber != null && (territoryNumber >= 0) && (territoryNumber < _ccode_earth)) {
    var parentTerritory = getParentOf(territoryNumber.toString());
    if (parentTerritory >= 0) {
      // there is a parent! check its borders as well...
      if (multipleBordersNearby(latitudeDegrees, longitudeDegrees, parentTerritory.toString())) {
        return true;
      }
    }
    var coord32 = _getEncodeRec(latitudeDegrees, longitudeDegrees).coord32;
    var nrFound = 0;
    var from = _dataFirstRecord(territoryNumber);
    var upto = _dataLastRecord(territoryNumber);
    for (var m = upto; m >= from; m--) {
      if (!isRestricted(m)) {
        if (_isNearBorderOf(coord32, _minmaxSetup(m))) {
          nrFound++;
          if (nrFound > 1) {
            return true;
          }
        }
      }
    }
  }
  return false;
}

/// PUBLIC returns the worst-case distance (in meters) between a decoded mapcode and the original encoded location,
/// given the number of high-precision digits after the hyphen of the mapcode.
double maxErrorInMeters(int extraDigits) {
  return _maxErrorInMetersForDigits[extraDigits];
}

/// PRIVATE convert a mapcode to an ABJAD-format (never more than 2 non-digits in a row)
String _convertToAbjad(String mapcode) {
  String str, rest;
  var h = mapcode.indexOf('-');
  if (h >= 0) {
    rest = mapcode.substring(h);
    str = _aeu_unpack(mapcode.substring(0, h));
  } else {
    rest = '';
    str = _aeu_unpack(mapcode);
  }

  var len = str.length;
  var dot = str.indexOf('.');
  if (dot < 2 || dot > 5) {
    return mapcode;
  }
  var form = 10 * dot + (len - dot - 1);

  // see if >2 non-digits in a row
  var inarow = 0;
  for (var i = 0; i < len; i++) {
    var c = str.codeUnitAt(i);
    if (c != 46) {
      inarow++;
      if (_decodeChar[c] <= 9) {
        inarow = 0;
      } else if (inarow > 2) {
        break;
      }
    }
  }
  if (inarow < 3 && (form == 22 || form == 32 || form == 33 || form == 42 || form == 43 || form == 44 || form == 54)) {
    // no need to do anything
    return mapcode;
  } else {
    var c = _decodeChar[str.codeUnitAt(2)];
    if (c < 0) {
      c = _decodeChar[str.codeUnitAt(3)];
      if (c < 0) {
        return mapcode;
      }
    }
    int c1, c2, c3 = 0;
    if (form >= 44) {
      c = (c * 31) + (_decodeChar[str.codeUnitAt(len - 1)] + 39);
      if (c < 39 || c > 999) {
        return mapcode;
      }
      c1 = (c / 100).floor();
      c2 = ((c % 100) / 10).floor();
      c3 = (c % 10);
    } else if (len == 7) {
      if (form == 24) {
        c += 7;
      } else if (form == 33) {
        c += 38;
      } else if (form == 42) {
        c += 69;
      }
      c1 = (c / 10).floor();
      c2 = (c % 10);
    } else {
      c1 = 2 + (c / 8).floor();
      c2 = 2 + (c % 8);
    }

    if (form == 22) {
      str = str[0] + str[1] + '.' + c1.toString() + c2.toString() + str[4];
    } else if (form == 23) {
      str = str[0] + str[1] + '.' + c1.toString() + c2.toString() + str[4] + str[5];
    } else if (form == 32) {
      str = str[0] + str[1] + '.' + (c1 + 4).toString() + c2.toString() + str[4] + str[5];
    } else if (form == 24) {
      str = str[0] + str[1] + c1.toString() + '.' + str[4] + c2.toString() + str[5] + str[6];
    } else if (form == 33) {
      str = str[0] + str[1] + c1.toString() + '.' + str[4] + c2.toString() + str[5] + str[6];
    } else if (form == 42) {
      str = str[0] + str[1] + c1.toString() + '.' + str[3] + c2.toString() + str[5] + str[6];
    } else if (form == 43) {
      str = str[0] + str[1] + (c1 + 4).toString() + '.' + str[3] + str[5] + c2.toString() + str[6] + str[7];
    } else if (form == 34) {
      str = str[0] + str[1] + c1.toString() + '.' + str[4] + str[5] + c2.toString() + str[6] + str[7];
    } else if (form == 44) {
      str = str[0] + str[1] + c1.toString() + str[3] + '.' + c2.toString() + str[5] + str[6] + c3.toString() + str[7];
    } else if (form == 54) {
      str = str[0] +
          str[1] +
          c1.toString() +
          str[3] +
          str[4] +
          '.' +
          c2.toString() +
          str[6] +
          str[7] +
          c3.toString() +
          str[8];
    } else {
      return mapcode;
    }
  }
  //alert(str+' ['+rest+'] = '+aeu_pack(str, false));
  return _aeu_pack(str, short: false) + rest;
}

/// PRIVATE returns true if str contains characters from an abjad-script
bool _isAbjadScript(String str) {
  for (var i = 0; i < str.length; i++) {
    var c = str.codeUnitAt(i);
    if (c >= 0x0628 && c <= 0x0649) {
      return true;
    } // arabic
    if (c >= 0x05d0 && c <= 0x05ea) {
      return true;
    } // hebrew
    if (c >= 0x0388 && c <= 0x03c9) {
      return true;
    } // greek uppercase and lowecase
    if ((c >= 0x1100 && c <= 0x1175) || (c >= 0xad6c && c <= 0xd314)) {
      return true;
    } // korean
  }
  return false;
}

/// PRIVATE convert a mapcode in ABJAD-format to normal format
String _convertFromAbjad(String result) {
  // split into prefix, s, postfix
  var p = result.lastIndexOf(' ');
  if (p < 0) {
    p = 0;
  } else {
    p++;
  }
  var prefix = result.substring(0, p);
  var s = result.substring(p);
  var postfix = '';
  var h = s.indexOf('-');
  if (h > 0) {
    postfix = s.substring(h);
    s = s.substring(0, h);
  }

  s = _aeu_unpack(s);
  var len = s.length;
  var dot = s.indexOf('.');
  if (dot < 2 || dot > 5) {
    return result;
  }
  var form = 10 * dot + (len - dot - 1);
  int c;

  if (form == 23) {
    c = (_toNumber(s[3]) * 8) + (_toNumber(s[4]) - 18);
    s = s[0] + s[1] + '.' + _encodeChar[c] + s[5];
  } else if (form == 24) {
    c = (_toNumber(s[3]) * 8) + (_toNumber(s[4]) - 18);
    if (c >= 32) {
      s = s[0] + s[1] + _encodeChar[c - 32] + '.' + s[5] + s[6];
    } else {
      s = s[0] + s[1] + '.' + _encodeChar[c] + s[5] + s[6];
    }
  } else if (form == 34) {
    c = (_toNumber(s[2]) * 10) + (_toNumber(s[5]) - 7);
    if (c < 31) {
      s = s[0] + s[1] + '.' + _encodeChar[c] + s[4] + s[6] + s[7];
    } else if (c < 62) {
      s = s[0] + s[1] + _encodeChar[c - 31] + '.' + s[4] + s[6] + s[7];
    } else {
      s = s[0] + s[1] + _encodeChar[c - 62] + s[4] + '.' + s[6] + s[7];
    }
  } else if (form == 35) {
    c = (_toNumber(s[2]) * 8) + (_toNumber(s[6]) - 18);
    if (c >= 32) {
      s = s[0] + s[1] + _encodeChar[c - 32] + s[4] + '.' + s[5] + s[7] + s[8];
    } else {
      s = s[0] + s[1] + _encodeChar[c] + '.' + s[4] + s[5] + s[7] + s[8];
    }
  } else if (form == 45) {
    c = (_toNumber(s[2]) * 100) + (_toNumber(s[5]) * 10) + (_toNumber(s[8]) - 39);
    s = s[0] + s[1] + _encodeChar[(c / 31).floor()] + s[3] + '.' + s[6] + s[7] + s[9] + _encodeChar[c % 31];
  } else if (form == 55) {
    c = (_toNumber(s[2]) * 100) + (_toNumber(s[6]) * 10) + (_toNumber(s[9]) - 39);
    s = s[0] + s[1] + _encodeChar[(c / 31).floor()] + s[3] + s[4] + '.' + s[7] + s[8] + s[10] + _encodeChar[c % 31];
  } else {
    return result;
  }
  return prefix + _aeu_pack(s, short: false) + postfix;
}

int _toNumber(String s) {
  return s.toNumber?.toInt() ?? 0;
}

class _mzSet {
  var fminx = 0;
  var fmaxx = 0;
  var fminy = 0;
  var fmaxy = 0;

  _mzSet({required this.fminx, required this.fmaxx, required this.fminy, required this.fmaxy});
}

class _mmSet {
  var minx = 0;
  var maxx = 0;
  var miny = 0;
  var maxy = 0;

  _mmSet({required this.minx, required this.maxx, required this.miny, required this.maxy});
}

class _coord {
  var y = 0;
  var x = 0;

  _coord({required this.y, required this.x});
}

class _enc {
  _coord coord32;
  var fraclat = 0;
  var fraclon = 0;
  var maxy = 0;

  _enc({required this.coord32, required this.fraclat, required this.fraclon});
}

class McInfo {
  String mapcode = '';
  String territoryAlphaCode = '';
  String fullmapcode = '';
  int territoryNumber = 0;
}
