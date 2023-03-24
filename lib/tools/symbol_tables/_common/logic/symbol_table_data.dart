import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/tools/symbol_tables/_common/logic/symbol_table_data_specialsorts.dart';
import 'package:gc_wizard/utils/data_type_utils/object_type_utils.dart';
import 'package:gc_wizard/utils/json_utils.dart';

const SYMBOLTABLES_ASSETPATH = 'assets/symbol_tables/';

class SymbolTableConstants {
  static final IMAGE_SUFFIXES = RegExp(r'\.(png|jpg|bmp|gif)', caseSensitive: false);
  static final ARCHIVE_SUFFIX = RegExp(r'\.(zip)', caseSensitive: false);

  static const CONFIG_FILENAME = 'config.file';
  static const CONFIG_SPECIALMAPPINGS = 'special_mappings';
  static const CONFIG_TRANSLATE = 'translate';
  static const CONFIG_TRANSLATION_PREFIX = 'translation_prefix';
  static const CONFIG_CASESENSITIVE = 'case_sensitive';
  static const CONFIG_IGNORE = 'ignore';

  static const Map<String, String> CONFIG_SPECIAL_CHARS = {
    "ampersand": "&",
    "asterisk": "*",
    "apostrophe": "'",
    "apostrophe_in": "'",
    "apostrophe_out": "'",
    "backslash": "\\",
    "backtick": "`",
    "brace_close": "}",
    "brace_open": "{",
    "bracket_close": "]",
    "bracket_open": "[",
    "bullet": "•",
    "caret": "^",
    "cedille": "¸",
    "cent": "¢",
    "colon": ":",
    "comma": ",",
    "copyright": "©",
    "cross": "†",
    "dash": "-",
    "degree": "°",
    "division": "÷",
    "dollar": "\$",
    "dot": ".",
    "doublecross": "‡",
    "ellipse": "…",
    "equals": "=",
    "euro": "€",
    "exclamation": "!",
    "function": "ƒ",
    "greaterthan": ">",
    "guillemet_in": "«",
    "guillemet_out": "»",
    "hard_space": " ",
    "hashtag": "#",
    "high_1": "¹",
    "high_2": "²",
    "high_3": "³",
    "high_a": "ª",
    "hyphen": "-",
    "inverted_exclamation": "¡",
    "inverted_question": "¿",
    "lessthan": "<",
    "middle_dot": "·",
    "minus": "-",
    "my": "µ",
    "number": "N°",
    "not": "¬",
    "one_fourth": "¼",
    "one_half": "½",
    "open_pipe": "¦",
    "paragraph": "§",
    "parentheses_open": "(",
    "parentheses_close": ")",
    "parentheses": "()",
    "percent": "%",
    "pi": "π",
    "pipe": "|",
    "plus": "+",
    "plus_minus": "±",
    "pound": "£",
    "promille": "‰",
    "quotation": "\"",
    "quotation_in": "“",
    "quotation_out": "”",
    "question": "?",
    "register": "®",
    "semicolon": ";",
    "slash": "/",
    "space": " ",
    "tilde": "~",
    "times": "×",
    "three_fourth": "¾",
    "trademark": "™",
    "trema": "¨",
    "underscore": "_",
    "web_at": "@",
    "yen": "¥",
    "A_acute": "Á",
    "A_grave": "À",
    "A_circumflex": "Â",
    "A_ring": "Å",
    "A_tilde": "Ã",
    "AE_together": "Æ",
    "AE_umlaut": "Ä",
    "C_acute": "Ć",
    "C_cedille": "Ç",
    "E_acute": "É",
    "E_circumflex": "Ê",
    "E_grave": "È",
    "E_eth": "Ð",
    "E_trema": "Ë",
    "I_acute": "Í",
    "I_grave": "Ì",
    "I_circumflex": "Î",
    "I_trema": "Ï",
    "N_acute": "Ń",
    "N_tilde": "Ñ",
    "O_acute": "Ó",
    "O_grave": "Ò",
    "O_circumflex": "Ô",
    "O_slash": "Ø",
    "O_tilde": "Õ",
    "OE_together": "Œ",
    "OE_umlaut": "Ö",
    "R_acute": "Ŕ",
    "S_acute": "Ś",
    "S_caron": "Š",
    "SZ_umlaut": "ß",
    "T_thorn": "Þ",
    "U_acute": "Ú",
    "U_circumflex": "Û",
    "U_grave": "Ù",
    "UE_umlaut": "Ü",
    "Y_acute": "Ý",
    "Y_trema": "Ÿ",
    "Z_acute": "Ź",
    "Z_caron": "Ž",
    "a_acute": "á",
    "a_circumflex": "â",
    "a_grave": "à",
    "a_ring": "å",
    "a_tilde": "ã",
    "ae_umlaut": "ä",
    "ae_together": "æ",
    "c_cedille": "ç",
    "e_acute": "é",
    "e_circumflex": "ê",
    "e_grave": "è",
    "e_eth": "ð",
    "e_trema": "ë",
    "i_acute": "í",
    "i_circumflex": "î",
    "i_grave": "ì",
    "i_trema": "ï",
    "n_tilde": "ñ",
    "o_acute": "ó",
    "o_circumflex": "o",
    "o_grave": "ò",
    "o_slash": "ø",
    "o_tilde": "õ",
    "oe_together": "œ",
    "oe_umlaut": "ö",
    "t_thorn": "þ",
    "s_caron": "š",
    "u_acute": "ú",
    "u_circumflex": "û",
    "u_grave": "ù",
    "ue_umlaut": "ü",
    "y_acute": "ý",
    "y_trema": "ÿ",
    "z_caron": "ž",
  };
}

class SymbolData {
  final String path;
  final Uint8List bytes;
  bool primarySelected = false;
  bool secondarySelected = false;
  final String? displayName;
  ui.Image? standardImage;
  ui.Image? specialEncryptionImage;

  SymbolData({
    required this.path,
    required this.bytes,
    this.displayName,
    this.standardImage,
    this.specialEncryptionImage});

  Size? imageSize() {
    if (standardImage == null) return null;
    return Size(standardImage!.width.toDouble(), standardImage!.height.toDouble());
  }
}

class _SymbolTableConfig {
  var caseSensitive = false;
  var ignore = <String>[];
  var specialMappings = <String, String>{};
  var translate = <String>[];
  var translationPrefix = '';
  int Function(Map<String, SymbolData>, Map<String, SymbolData>)? sort;
  final translateables = <String>[];
}

class SymbolTableData {
  final BuildContext _context;
  final String symbolKey;

  SymbolTableData(this._context, this.symbolKey);

  final _config = _SymbolTableConfig();
  List<Map<String, SymbolData>> images = [];
  int maxSymbolTextLength = 0;

  Future<void> initialize({bool importEncryption = true}) async {
    await _loadConfig();
    await _initializeImages(importEncryption);
  }

  Size? imageSize() {
    return images.first.values.first.imageSize();
  }

  bool isCaseSensitive() {
    return _config.caseSensitive;
  }

  String _pathKey() {
    return SYMBOLTABLES_ASSETPATH + symbolKey + '/';
  }

  Future<void> _loadConfig() async {
    String? file;
    try {
      file = await DefaultAssetBundle.of(_context).loadString(_pathKey() + SymbolTableConstants.CONFIG_FILENAME);
    } catch (e) {}

    file ??= '{}';

    var jsonConfig = asJsonMap(json.decode(file));

    _config.caseSensitive = jsonConfig[SymbolTableConstants.CONFIG_CASESENSITIVE] != null;
    _config.translationPrefix = toStringOrNull(jsonConfig[SymbolTableConstants.CONFIG_TRANSLATION_PREFIX]) ?? '';

    if (jsonConfig[SymbolTableConstants.CONFIG_IGNORE] == null) {
      _config.ignore = toStringListOrNull(jsonConfig[SymbolTableConstants.CONFIG_IGNORE]) ?? [];
    }

    var map = asJsonMapOrNull(jsonConfig[SymbolTableConstants.CONFIG_SPECIALMAPPINGS]);
    if (map != null) {
      _config.specialMappings = toStringMapOrNull(map) ?? {};
    }

    switch (symbolKey) {
      case "notes_names_altoclef":
        _config.sort = specialSortNoteNames;
        break;
      case "notes_names_bassclef":
        _config.sort = specialSortNoteNames;
        break;
      case "notes_names_trebleclef":
        _config.sort = specialSortNoteNames;
        break;
      case "notes_notevalues":
        _config.sort = specialSortNoteValues;
        break;
      case "notes_restvalues":
        _config.sort = specialSortNoteValues;
        break;
      case "trafficsigns_germany":
        _config.sort = specialSortTrafficSignsGermany;
        break;
      default:
        _config.sort = defaultSymbolSort;
        break;
    }
  }

  String _createKey(String filename) {
    var imageKey = filenameWithoutSuffix(filename);
    imageKey = imageKey.replaceAll(RegExp(r'(^_*|_*$)'), '');

    var setTranslateable = false;

    String key;

    if (SymbolTableConstants.CONFIG_SPECIAL_CHARS.containsKey(imageKey)) {
      key = SymbolTableConstants.CONFIG_SPECIAL_CHARS[imageKey]!;
    } else if ((_config.translate.contains(imageKey))) {
      if (_config.translationPrefix.isNotEmpty) {
        key = i18n(_context, _config.translationPrefix + imageKey);
      } else {
        key = i18n(_context, 'symboltables_' + symbolKey + '_' + imageKey);
      }
      setTranslateable = true;
    } else {
      key = imageKey;
    }

    if (!isCaseSensitive()) key = key.toUpperCase();

    if (setTranslateable) _config.translateables.add(key);

    if (key.length > maxSymbolTextLength) maxSymbolTextLength = key.length;

    return key;
  }

  Future<void> _initializeImages(bool importEncryption) async {
    //AssetManifest.json holds the information about all asset files
    final manifestContent = await DefaultAssetBundle.of(_context).loadString('AssetManifest.json');
    final manifestMap = asJsonMap(json.decode(manifestContent));

    final imageArchivePaths = manifestMap.keys
        .where((String key) => key.contains(_pathKey()))
        .where((String key) => SymbolTableConstants.ARCHIVE_SUFFIX.hasMatch(key))
        .toList();

    if (imageArchivePaths.isEmpty) return;

    // Read the Zip file from disk.
    final bytes = await DefaultAssetBundle.of(_context)
        .load(imageArchivePaths.firstWhere((path) => !path.contains('_encryption')));
    InputStream input = InputStream(bytes.buffer.asByteData());
    // Decode the Zip file
    final Archive archive = ZipDecoder().decodeBuffer(input);

    Archive? encryptionArchive;
    if (importEncryption) {
      ByteData encryptionBytes;
      var encryptionImageArchivePaths = imageArchivePaths.where((path) => path.contains('_encryption')).toList();
      if (encryptionImageArchivePaths.isNotEmpty) {
        encryptionBytes = await DefaultAssetBundle.of(_context).load(encryptionImageArchivePaths.first);
        input = InputStream(encryptionBytes.buffer.asByteData());
        encryptionArchive = ZipDecoder().decodeBuffer(input);
      }
    }

    images = [];
    for (ArchiveFile file in archive) {
      var key = _createKey(file.name);

      if (_config.ignore.contains(key)) continue;

      var imagePath = (file.isFile && SymbolTableConstants.IMAGE_SUFFIXES.hasMatch(file.name)) ? file.name : null;
      if (imagePath == null) continue;

      var data = toUint8ListOrNull(file.content);
      if (data != null) {
        var standardImage = await _initializeImage(data);
        ui.Image? specialEncryptionImage;
        if (encryptionArchive != null && encryptionArchive.isNotEmpty) {
          var specialFile = encryptionArchive.firstWhere((encryptionFile) => encryptionFile.name == file.name);
          var specialFileData = toUint8ListOrNull(specialFile.content);
          if (specialFileData != null) {
            specialEncryptionImage = await _initializeImage(specialFileData);
          }
        }

        images.add({
          key: SymbolData(
              path: imagePath,
              bytes: data,
              standardImage: standardImage,
              specialEncryptionImage: specialEncryptionImage)
        });
      }
    }

    images.sort(_config.sort);
  }

  Future<ui.Image> _initializeImage(Uint8List bytes) async {
    return decodeImageFromList(bytes);
  }

  int defaultSymbolSort(Map<String, SymbolData> a, Map<String, SymbolData> b) {
    var keyA = a.keys.first;
    var keyB = b.keys.first;

    var intA = int.tryParse(keyA);
    var intB = int.tryParse(keyB);

    if (intA == null) {
      if (intB == null) {
        if (_config.translateables.contains(keyA)) {
          if (_config.translateables.contains(keyB)) {
            return keyA.compareTo(keyB);
          } else {
            return 1;
          }
        } else {
          if (_config.translateables.contains(keyB)) {
            return -1;
          } else {
            return keyA.compareTo(keyB);
          }
        }
      } else {
        return 1;
      }
    } else {
      if (intB == null) {
        return -1;
      } else {
        return intA.compareTo(intB);
      }
    }
  }
}

String filenameWithoutSuffix(String filename) {
  return filename.split('.').first;
}

class defaultSymbolTableData extends SymbolTableData {
  defaultSymbolTableData(BuildContext context) : super (context, '');
}
