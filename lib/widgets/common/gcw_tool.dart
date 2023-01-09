import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/i18n/supported_locales.dart';
import 'package:gc_wizard/logic/tools/crypto_and_encodings/substitution.dart';
import 'package:gc_wizard/theme/theme.dart';
import 'package:gc_wizard/utils/settings/preferences.dart';
import 'package:gc_wizard/widgets/common/base/gcw_dialog.dart';
import 'package:gc_wizard/widgets/common/gcw_symbol_container.dart';
import 'package:gc_wizard/widgets/favorites.dart';
import 'package:gc_wizard/widgets/selector_lists/gcw_selection.dart';
import 'package:gc_wizard/widgets/utils/common_widget_utils.dart';
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
  final Function onPressed;

  GCWToolActionButtonsEntry({this.showDialog, this.url, this.title, this.text, this.icon, this.onPressed});
}

class GCWTool extends StatefulWidget {
  final Widget tool;
  final String i18nPrefix;
  final List<ToolCategory> categories;
  final autoScroll;
  final suppressToolMargin;
  final iconPath;
  final List<String> searchKeys;
  String indexedSearchStrings;
  final List<GCWToolActionButtonsEntry> buttonList;
  final bool suppressHelpButton;
  final String helpSearchString;
  final isBeta;

  var icon;
  var id = '';

  var toolName;
  var defaultLanguageToolName;
  var description;
  var example;

  GCWTool(
      {Key key,
      this.tool,
      this.toolName,
      this.defaultLanguageToolName,
      this.i18nPrefix,
      this.categories,
      this.autoScroll: true,
      this.suppressToolMargin: false,
      this.iconPath,
      this.searchKeys,
      this.buttonList,
      this.helpSearchString,
      this.isBeta: false,
      this.suppressHelpButton: false})
      : super(key: key) {
    this.id = className(tool) + '_' + (i18nPrefix ?? '');

    if (iconPath != null) {
      this.icon = GCWSymbolContainer(
        symbol: Image.asset(iconPath, width: DEFAULT_LISTITEM_SIZE),
      );
    }
  }

  bool get isFavorite {
    return Favorites.isFavorite(id);
  }

  @override
  _GCWToolState createState() => _GCWToolState();
}

class _GCWToolState extends State<GCWTool> {
  var _toolName;
  var _defaultLanguageToolName;

  @override
  void initState() {
    _setToolCount(widget.id);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // this is the case when Tool is not called by Registry but as subpage of another tool
    if (_toolName == null) _toolName = widget.toolName ?? i18n(context, widget.i18nPrefix + '_title');

    if (_defaultLanguageToolName == null)
      _defaultLanguageToolName =
          widget.defaultLanguageToolName ?? i18n(context, widget.i18nPrefix + '_title', useDefaultLanguage: true);

    return Scaffold(
        resizeToAvoidBottomInset: widget.autoScroll,
        appBar: AppBar(
          title: Text(_toolName),
          actions: _buildButtons(),
        ),
        body: _buildBody());
  }

  String _normalizeSearchString(String text) {
    if (text == null) return '';

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
    return !isLocaleSupported(appLocale) ||
        (SUPPORTED_HELPLOCALES == null || !SUPPORTED_HELPLOCALES.contains(appLocale.languageCode));
  }

  Widget _buildHelpButton() {
    if (widget.suppressHelpButton) return null;

    // add button with url for searching knowledge base with toolName
    final Locale appLocale = Localizations.localeOf(context);

    String searchString = '';

    if (widget.helpSearchString == null || widget.helpSearchString.isEmpty) {
      if (_needsDefaultHelp(appLocale)) {
        // fallback to en if unsupported locale
        searchString = _defaultLanguageToolName;
      } else {
        searchString = _toolName;
      }
    } else {
      searchString = i18n(context, widget.helpSearchString, useDefaultLanguage: _needsDefaultHelp(appLocale)) ??
          widget.helpSearchString;
    }

    searchString = _normalizeSearchString(searchString);
    String locale = DEFAULT_LOCALE.languageCode;

    if (!_needsDefaultHelp(appLocale)) locale = Localizations.localeOf(context).languageCode;

    var url = HELP_BASE_URL + locale + '/search/' + searchString;
    url = Uri.encodeFull(url);

    return IconButton(
      icon: Icon(Icons.help),
      onPressed: () {
        launchUrl(Uri.parse(url));
      },
    );
  }

  List<Widget> _buildButtons() {
    List<Widget> buttonList = <Widget>[];

    // add further buttons as defined in registry
    if (widget.buttonList != null) {
      widget.buttonList.forEach((button) {
        String url = '';
        if (button.url == '') // 404-Page asking for help
          url = i18n(context, 'common_error_url'); // https://blog.gcwizard.net/manual/uncategorized/404/
        else
          url = button.url;
        if (button.url != null && button.url.length != 0)
          buttonList.add(IconButton(
            icon: Icon(button.icon),
            onPressed: () {
              if (button.onPressed != null) {
                button.onPressed();
                return;
              }

              if (button.showDialog) {
                showGCWAlertDialog(
                  context,
                  i18n(context, button.title),
                  i18n(context, button.text),
                  () {
                    launchUrl(Uri.parse(i18n(context, url) ?? url));
                  },
                );
              } else
                launchUrl(Uri.parse(i18n(context, url)));
            },
          ));
      });
    }

    Widget helpButton = _buildHelpButton();
    if (helpButton != null) buttonList.add(helpButton);

    return buttonList;
  }

  Widget _buildBody() {
    if (widget.tool is GCWSelection) return widget.tool;

    var tool = widget.tool;
    if (!widget.suppressToolMargin) {
      tool = Padding(
        child: tool,
        padding: EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 2),
      );
    }

    if (widget.autoScroll == false) {
      return tool;
    }

    return SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        primary: true,
        child: tool,
    );
  }
}

_setToolCount(String i18nPrefix) {
  var toolCountsRaw = Prefs.get(PREFERENCE_TOOL_COUNT);
  if (toolCountsRaw == null) toolCountsRaw = '{}';

  Map<String, int> toolCounts = Map<String, int>.from(jsonDecode(toolCountsRaw));
  var currentToolCount = toolCounts[i18nPrefix];

  if (currentToolCount == null) currentToolCount = 0;

  currentToolCount++;
  toolCounts[i18nPrefix] = currentToolCount;

  Prefs.setString(PREFERENCE_TOOL_COUNT, jsonEncode(toolCounts));
}
