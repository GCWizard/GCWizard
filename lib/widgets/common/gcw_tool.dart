import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/theme/theme.dart';
import 'package:gc_wizard/widgets/common/base/gcw_dialog.dart';
import 'package:gc_wizard/widgets/common/gcw_symbol_container.dart';
import 'package:gc_wizard/widgets/selector_lists/gcw_selection.dart';
import 'package:gc_wizard/widgets/utils/common_widget_utils.dart';
import 'package:prefs/prefs.dart';
import 'package:url_launcher/url_launcher.dart';

enum ToolCategory {CRYPTOGRAPHY, COORDINATES, FORMULA_SOLVER, GAMES, GENERAL_CODEBREAKERS, SCIENCE_AND_TECHNOLOGY, SYMBOL_TABLES}

class GCWTool extends StatefulWidget {
  final Widget tool;
  final String i18nPrefix;
  final ToolCategory category;
  final autoScroll;
  final iconPath;
  final String searchStrings;
  final List<GCWToolActionButtonsEntry> buttonList;

  var icon;
  var _id = '';
  var _isFavorite = false;

  var toolName;
  var description;
  var example;

  Widget titleTrailing;

  GCWTool({
    Key key,
    this.tool,
    this.toolName,
    this.i18nPrefix,
    this.category,
    this.autoScroll: true,
    this.iconPath,
    this.searchStrings: '',
    this.titleTrailing,
    this.buttonList
  }) : super(key: key) {
    this._id = className(tool) + '_' + (i18nPrefix ?? '');
    this._isFavorite = Prefs.getStringList('favorites').contains('$_id');

    if (iconPath != null) {
      this.icon = GCWSymbolContainer(
        symbol: Image.asset(iconPath, width: DEFAULT_LISTITEM_SIZE),
      );
    }
  }

  bool get isFavorite {
    return this._isFavorite;
  }

  void set isFavorite(bool isFavorite) {
    _isFavorite = isFavorite;

    var _favorites = Prefs.getStringList('favorites');
    if (isFavorite && !_favorites.contains(_id)) {
      _favorites.add(_id);
    } else if (!isFavorite) {
      while (_favorites.contains(_id))
        _favorites.remove(_id);
    }
    Prefs.setStringList('favorites', _favorites);
  }

  @override
  _GCWToolState createState() => _GCWToolState();
}

class GCWToolActionButtonsEntry {
  final bool showDialog;  // true, if the button should provide a dialog
  final String url;       // url for a download or website
  final String title;     // title-string to be shown in the dialog
  final String text;      // message-text to be shown in the dialog
  final IconData icon;    // icon tto be shown in the appbar

  GCWToolActionButtonsEntry(this.showDialog, this.url, this.title, this.text, this.icon);
  // Example for usage in the registry.dart
  //  GCWTool(
  //    tool: Chef(),
  //    i18nPrefix: 'chef',
  //    searchStrings: 'chef koch rezept recipe language programming sprache esoteric esoterisch programmiersprache',
  //    buttonList: [
  //      GCWToolActionButtonsEntry(true, 'chef_download_documentation_url', 'chef_download_documentation_title', 'chef_download_documentation_text', Icons.file_download),
  //      GCWToolActionButtonsEntry(false, 'chef_online_help_url', '', '', Icons.help)],
  //  ),
}

class _GCWToolState extends State<GCWTool> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.toolName),
        actions: _buildButtons(),
      body: _buildBody()
    );
  }

  _buildHelpButton() {
    if (widget.i18nPrefix == null)
      return Container();

    var onlineHelpKey = widget.i18nPrefix + '_onlinehelp';

    var onlineHelpUrl = i18n(context, onlineHelpKey);
    if (onlineHelpUrl == null || onlineHelpUrl.length == 0)
      return Container();

    return IconButton(
      icon: Icon(Icons.help),
      onPressed: () {
        launch(onlineHelpUrl);
      },
    );
  }

  List<Widget>_buildButtons() {
    List<Widget> buttonList = new List<Widget>();

    if (widget.titleTrailing.toString() != 'null')
      return [widget.titleTrailing];
  
    if (widget.buttonList == null)
      return [_buildHelpButton()];

    widget.buttonList.forEach((button) {
      buttonList.add(
        IconButton(
          icon: Icon(button.icon),
          onPressed: () {
            if (button.showDialog) {
              showGCWAlertDialog(
                context,
                i18n(context, button.title),
                i18n(context, button.text),
                () {
                  launch(i18n(context, button.url));
                },
              );
            }
            else
              launch(i18n(context, button.url));
          },
      ));
    });
    return buttonList;
  }
      
  Widget _buildBody() {
    if (widget.tool is GCWSelection)
      return widget.tool;

    if (widget.autoScroll == false)
      return widget.tool;

    return SingleChildScrollView(
      child: Padding(
        child: widget.tool,
        padding: EdgeInsets.all(10)
      )
    );
  }
}

