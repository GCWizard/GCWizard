import 'dart:convert';

import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/application/i18n/supported_locales.dart';
import 'package:gc_wizard/application/settings/logic/preferences.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/category_views/favorites.dart';
import 'package:gc_wizard/common_widgets/dialogs/gcw_dialog.dart';
import 'package:gc_wizard/common_widgets/gcw_selection.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/substitution/logic/substitution.dart';
import 'package:gc_wizard/tools/symbol_tables/_common/widget/gcw_symbol_container.dart';
import 'package:gc_wizard/utils/data_type_utils/object_type_utils.dart';
import 'package:gc_wizard/utils/json_utils.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/common_widget_utils.dart';
import 'package:prefs/prefs.dart';

enum ToolCategory {
  CRYPTOGRAPHY,
  COORDINATES,
  FORMULA_SOLVER,
  GAMES,
  GENERAL_CODEBREAKERS,
  IMAGES_AND_FILES,
  SCIENCE_AND_TECHNOLOGY,
  SYMBOL_TABLES
}

final _SEARCH_BLACKLIST = {
  'code',
  'chiffre',
  'cipher',
  'chiffrement',
  'schlüssel',
  'calculator',
  'checker',
  'der',
  'die',
  'das',
  'the',
  'l',
  'le',
  'la',
  'ein',
  'eine',
  'a',
  'an',
  'une',
  'in',
  'und',
  'and',
  'eins',
  'zwei',
  'drei',
  'one',
  'two',
  'three',
  'un',
  'deux',
  'trois',
  'mit',
  'with',
  'avec',
  'of',
  'von',
  'from',
  'de',
  'd',
  'oder',
  //'or', is also gold in french - necessary for Phi
  'ou',
};

final _SEARCH_WHITELIST = {'d ni': "d'ni", 'd or': "d'or", 'mando a': "mando'a", 'kenny s': "kenny's"};

const HELP_BASE_URL = 'https://blog.gcwizard.net/manual/';

class GCWToolActionButtonsEntry {
  // to be used in registry to define a buttonlist which will be displayed in the app bar
  final bool showDialog; // - true, if the button should provide a dialog
  final String url; // - url for a download or website
  final String title; // - title-string to be shown in the dialog
  final String text; // - message-text to be shown in the dialog
  final IconData icon; // - icon tto be shown in the appbar
  final void Function()? onPressed;

  GCWToolActionButtonsEntry({required this.showDialog, required this.url, required this.title,
    required this.text, required this.icon, this.onPressed});
}

class GCWTool extends StatefulWidget {
  final Widget tool;
  final String id;
  final List<ToolCategory> categories;
  final bool autoScroll;
  final bool suppressToolMargin;
  final String? iconPath;
  final List<String> searchKeys;
  final List<GCWToolActionButtonsEntry> buttonList;
  final bool suppressHelpButton;
  final String helpSearchString;
  final bool isBeta;

  GCWSymbolContainer? icon;
  var longId = '';

  String? toolName;
  String? defaultLanguageToolName;
  String? description;
  String? example;
  String indexedSearchStrings = '';

  GCWTool(
      {Key? key,
        required this.tool,
        this.toolName,
        this.defaultLanguageToolName,
        required this.id,
        this.categories = const [],
        this.autoScroll = true,
        this.suppressToolMargin = false,
        this.iconPath,
        this.searchKeys = const [],
        this.buttonList = const [],
        this.helpSearchString = '',
        this.isBeta = false,
        this.suppressHelpButton = false})
      : super(key: key) {
    longId = className(tool) + '_' + (id);

    if (iconPath != null) {
      icon = GCWSymbolContainer(
        symbol: Image.asset(iconPath!, width: DEFAULT_LISTITEM_SIZE),
      );
    }
  }

  bool get isFavorite {
    return Favorites.isFavorite(longId);
  }

  @override
  _GCWToolState createState() => _GCWToolState();
}

class _GCWToolState extends State<GCWTool> {
  late String _toolName;
  late String _defaultLanguageToolName;

  @override
  void initState() {
    _setToolCount(widget.longId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // this is the case when tool is not called by Registry but as subpage of another tool
    _toolName = widget.toolName ?? i18n(context, widget.id + '_title');

    _defaultLanguageToolName =
        widget.defaultLanguageToolName ?? i18n(context, widget.id + '_title', useDefaultLanguage: true);

    return Scaffold(
        resizeToAvoidBottomInset: widget.autoScroll,
        appBar: AppBar(
          title: Text(_toolName),
          actions: _buildButtons(),
        ),
        body: _buildBody());
  }

  String _normalizeSearchString(String text) {
    text = text.trim().toLowerCase();
    text = text
        .replaceAll(RegExp(r"['`´]"), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll('**', '')
        .replaceAll('/', ' ')
        .replaceAll('-', ' ')
        .replaceAll(':', '')
        .replaceAll('bit)', '')
        .replaceAll('(', '')
        .replaceAll(')', '');
    //.replaceAll(RegExp(r"\([a-zA-Z0-9\s.]+\)"), ''); //remove e.g. (128 bits) in hashes-toolname
    text = substitution(text, _SEARCH_WHITELIST);
    text = text.split(' ').where((word) => !_SEARCH_BLACKLIST.contains(word)).join(' ');
    return text;
  }

  bool _needsDefaultHelp(Locale appLocale) {
    return !isLocaleSupported(appLocale) || (!SUPPORTED_HELPLOCALES.contains(appLocale.languageCode));
  }

  Widget? _buildHelpButton() {
    if (widget.suppressHelpButton) return null;

    // add button with url for searching knowledge base with toolName
    final Locale appLocale = Localizations.localeOf(context);

    String searchString = '';

    if (widget.helpSearchString.isEmpty) {
      if (_needsDefaultHelp(appLocale)) {
        // fallback to en if unsupported locale
        searchString = _defaultLanguageToolName;
      } else {
        searchString = _toolName;
      }
    } else {
      searchString = i18n(context, widget.helpSearchString, useDefaultLanguage: _needsDefaultHelp(appLocale), ifTranslationNotExists: widget.helpSearchString);
    }

    searchString = _normalizeSearchString(searchString);
    String locale = DEFAULT_LOCALE.languageCode;

    if (!_needsDefaultHelp(appLocale)) locale = Localizations.localeOf(context).languageCode;

    var url = HELP_BASE_URL + locale + '/search/' + searchString;
    url = Uri.encodeFull(url);

    return IconButton(
      icon: const Icon(Icons.help),
      onPressed: () {
        launchUrl(Uri.parse(url));
      },
    );
  }

  List<Widget> _buildButtons() {
    List<Widget> buttonList = <Widget>[];

    // add further buttons as defined in registry
    for (var button in widget.buttonList) {
      String url = '';
      if (button.url.isEmpty) {
        url = i18n(context, 'common_error_url'); // https://blog.gcwizard.net/manual/uncategorized/404/
      } else {
        url = button.url;
      }
      if (button.url.isNotEmpty) {
        buttonList.add(IconButton(
          icon: Icon(button.icon),
          onPressed: () {
            if (button.onPressed != null) {
              button.onPressed!();
              return;
            }

            if (button.showDialog) {
              showGCWAlertDialog(
                context,
                i18n(context, button.title),
                i18n(context, button.text),
                    () {
                  launchUrl(Uri.parse(i18n(context, url, ifTranslationNotExists: url)));
                },
              );
            } else {
              launchUrl(Uri.parse(i18n(context, url)));
            }
          },
        ));
      }
    }

    Widget? helpButton = _buildHelpButton();
    if (helpButton != null) buttonList.add(helpButton);

    return buttonList;
  }

  Widget _buildBody() {
    if (widget.tool is GCWSelection) return widget.tool;

    var tool = widget.tool;
    if (!widget.suppressToolMargin) {
      tool = Padding(
        padding: const EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 2),
        child: tool,
      );
    }

    if (widget.autoScroll == false) {
      return tool;
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      primary: true,
      child: tool,
    );
  }
}

void _setToolCount(String id) {
  var toolCountsRaw = Prefs.get(PREFERENCE_TOOL_COUNT);
  toolCountsRaw ??= '{}';

  var toolCounts = _toolCounts();
  var currentToolCount = toolCounts[id];

  currentToolCount ??= 0;

  currentToolCount++;
  toolCounts[id] = currentToolCount;

  Prefs.setString(PREFERENCE_TOOL_COUNT, jsonEncode(toolCounts));
}

int _sortToolListAlphabetically(GCWTool a, GCWTool b) {
  var aName = a.toolName;
  var bName = b.toolName;

  if (aName == null && bName == null) {
    return 0;
  }

  if (aName == null && bName != null) {
    return 1;
  }

  if (bName == null && aName != null) {
    return -1;
  }

  return removeDiacritics(aName!).toLowerCase().compareTo(removeDiacritics(bName!).toLowerCase());
}

int sortToolList(GCWTool a, GCWTool b) {
  if (!Prefs.getBool(PREFERENCE_TOOL_COUNT_SORT)) {
    return _sortToolListAlphabetically(a, b);
  }

  var toolCounts = _toolCounts();

  var toolCountA = toolCounts[a.longId];
  var toolCountB = toolCounts[b.longId];

  if (toolCountA == null && toolCountB == null) {
    return _sortToolListAlphabetically(a, b);
  }

  if (toolCountA == null && toolCountB != null) {
    return 1;
  }

  if (toolCountA != null && toolCountB == null) {
    return -1;
  }

  if (toolCountA != null && toolCountB != null) {
    if (toolCountA == toolCountB) {
      return _sortToolListAlphabetically(a, b);
    } else {
      return toolCountB.compareTo(toolCountA);
    }
  }

  return 0;
}

Map<String, int> _toolCounts() {
  var jsonString = Prefs.getString(PREFERENCE_TOOL_COUNT);
  var decoded = asJsonMap(jsonDecode(jsonString));
  return decoded.map((key, value) => MapEntry<String, int>(key, toIntOrNull(value) ?? 0));
}
