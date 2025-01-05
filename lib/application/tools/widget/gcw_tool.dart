import 'dart:convert';

import 'package:diacritic/diacritic.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gc_wizard/application/category_views/favorites.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/i18n/logic/supported_locales.dart';
import 'package:gc_wizard/application/navigation/no_animation_material_page_route.dart';
import 'package:gc_wizard/application/settings/logic/preferences.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/tools/tool_licenses/widget/tool_license_types.dart';
import 'package:gc_wizard/application/tools/tool_licenses/widget/tool_licenses.dart';
import 'package:gc_wizard/common_widgets/clipboard/gcw_clipboard.dart';
import 'package:gc_wizard/common_widgets/gcw_popup_menu.dart';
import 'package:gc_wizard/common_widgets/gcw_selection.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/substitution/logic/substitution.dart';
import 'package:gc_wizard/tools/symbol_tables/_common/widget/gcw_symbol_container.dart';
import 'package:gc_wizard/utils/data_type_utils/object_type_utils.dart';
import 'package:gc_wizard/utils/json_utils.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/common_widget_utils.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/deeplink_utils.dart';
import 'package:prefs/prefs.dart';

enum ToolCategory {
  CRYPTOGRAPHY,
  COORDINATES,
  FORMULA_SOLVER,
  GAMES,
  GENERAL_CODEBREAKERS,
  IMAGES_AND_FILES,
  SCIENCE_AND_TECHNOLOGY,
  SYMBOL_TABLES,
  MISCELLANEOUS,
}

final _MANUAL_SEARCH_BLACKLIST = {
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

final _MANUAL_SEARCH_WHITELIST = {'d ni': "d'ni", 'd or': "d'or", 'mando a': "mando'a", 'kenny s': "kenny's"};

const HELP_BASE_URL = 'https://blog.gcwizard.net/manual/';

class GCWTool extends StatefulWidget {
  final Widget tool;
  final String id;
  final String? id_prefix;
  final List<ToolCategory> categories;
  final bool autoScroll;
  final bool suppressToolMargin;
  final String? iconPath;
  final List<String> searchKeys;
  final List<GCWPopupMenuItem> toolBarItemList;
  final bool suppressHelpButton;
  final bool suppressAppBarButtons;
  final String helpSearchString;
  final bool isBeta;
  final List<String>? deeplinkAlias;
  final List<ToolLicenseEntry>? licenses;

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
      this.id_prefix,
      this.categories = const [],
      this.autoScroll = true,
      this.suppressToolMargin = false,
      this.iconPath,
      this.searchKeys = const [],
      this.helpSearchString = '',
      this.isBeta = false,
      this.suppressHelpButton = false,
      this.suppressAppBarButtons = false,
      this.deeplinkAlias,
      this.licenses,
      this.toolBarItemList = const []})
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

String toolName(BuildContext context, GCWTool tool) {
  return tool.toolName ?? i18n(context, tool.id + '_title');
}

class _GCWToolState extends State<GCWTool> {
  late String _toolName;
  late String _defaultLanguageToolName;
  late FocusNode _focusNode;

  @override
  void initState() {
    _setToolCount(widget.longId);
    _focusNode = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // this is the case when tool is not called by Registry but as subpage of another tool
    _toolName = toolName(context, widget);

    _defaultLanguageToolName =
        widget.defaultLanguageToolName ?? i18n(context, widget.id + '_title', useDefaultLanguage: true);

    return Scaffold(
        resizeToAvoidBottomInset: widget.autoScroll,
        appBar: AppBar(title: Text(_toolName), actions: [
          widget.suppressAppBarButtons == false ? GCWPopupMenu(
            icon: Icons.more_vert,
            buttonNoBorder: true,
            menuItemBuilder: (context) => _buildToolBarItems(),
          ) : Container()
        ]),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(_focusNode),
        child: Focus(
          focusNode: _focusNode,
          child: _buildBody(),
        ),
      ),
    );
  }

  String _normalizeManualSearchString(String text) {
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
    text = substitution(text, _MANUAL_SEARCH_WHITELIST);
    text = text.split(' ').where((word) => !_MANUAL_SEARCH_BLACKLIST.contains(word)).join(' ');
    return text;
  }

  bool _needsDefaultHelp(Locale appLocale) {
    return !isLocaleSupported(appLocale) || (!SUPPORTED_HELPLOCALES.contains(appLocale.languageCode));
  }

  GCWPopupMenuItem? _buildHelpMenuItem() {
    if (widget.suppressHelpButton) return null;

    // add button with url for searching knowledge base with toolName
    final Locale appLocale = Localizations.localeOf(context);

    String manualSearchString = '';

    if (widget.helpSearchString.isEmpty) {
      if (_needsDefaultHelp(appLocale)) {
        // fallback to en if unsupported locale
        manualSearchString = _defaultLanguageToolName;
      } else {
        manualSearchString = _toolName;
      }
    } else {
      manualSearchString = i18n(context, widget.helpSearchString,
          useDefaultLanguage: _needsDefaultHelp(appLocale), ifTranslationNotExists: widget.helpSearchString);
    }

    manualSearchString = _normalizeManualSearchString(manualSearchString);
    String locale = DEFAULT_LOCALE.languageCode;

    if (!_needsDefaultHelp(appLocale)) locale = Localizations.localeOf(context).languageCode;

    var url = HELP_BASE_URL + locale + '/search/' + manualSearchString;
    url = Uri.encodeFull(url);

    return GCWPopupMenuItem(
        child: iconedGCWPopupMenuItem(context, Icons.help, 'gcwtool_help'),
        action: (index) => setState(() {
              launchUrl(Uri.parse(url));
            }));
  }

  List<GCWPopupMenuItem> _buildToolBarItems() {
    var menuItems = <GCWPopupMenuItem>[];

    menuItems.addAll(widget.toolBarItemList);

    menuItems.add(GCWPopupMenuItem(
        child: iconedGCWPopupMenuItem(context, Icons.link, kIsWeb ? 'gcwtool_weblink' : 'gcwtool_copyweblink'),
        action: (index) => setState(() {
              var url = deepLinkURL(widget);
              if (kIsWeb) {
                launchUrl(Uri.parse(url));
              } else {
                insertIntoGCWClipboard(context, url);
              }
            })));

    var helpItem = _buildHelpMenuItem();
    if (helpItem != null) menuItems.add(helpItem);

    if (widget.licenses != null && widget.licenses!.isNotEmpty) {
      menuItems.add(GCWPopupMenuItem(
          child: iconedGCWPopupMenuItem(context, Icons.text_snippet_outlined, i18n(context, 'toollicenses_title')),
          action: (index) => setState(() {
            Navigator.push(
              context,
              NoAnimationMaterialPageRoute<GCWTool>(
                builder: (context) =>
                  GCWTool(
                    tool: ToolLicenses(licenses: widget.licenses!),
                    toolName: i18n(context, 'toollicenses_title') + ': ' + _toolName,
                    suppressAppBarButtons: true,
                    id: 'toollicenses',
                  )
              )
            );
          }))
      );
    }

    return menuItems;
  }

  Widget _buildBody() {
    if (widget.tool is GCWSelection) return widget.tool;

    var tool = widget.tool;
    if (!widget.suppressToolMargin) {
      tool = Padding(
        padding: const EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 50),
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
