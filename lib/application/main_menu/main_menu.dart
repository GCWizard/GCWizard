import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/main_menu/about.dart';
import 'package:gc_wizard/application/main_menu/call_for_contribution.dart';
import 'package:gc_wizard/application/main_menu/changelog.dart';
import 'package:gc_wizard/application/navigation/no_animation_material_page_route.dart';
import 'package:gc_wizard/application/registry.dart';
import 'package:gc_wizard/application/settings/widget/settings_coordinates.dart';
import 'package:gc_wizard/application/settings/widget/settings_general.dart';
import 'package:gc_wizard/application/settings/widget/settings_saverestore.dart';
import 'package:gc_wizard/application/settings/widget/settings_tools.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/gcw_tool.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/common_widget_utils.dart';

Drawer buildMainMenu(BuildContext context) {
  var header = SizedBox(
    height: 120.0,
    child: DrawerHeader(
      decoration: BoxDecoration(
        color: themeColors().dialog(),
      ),
      child: Row(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(2.5),
            width: 50.0,
            height: 50.0,
            decoration: BoxDecoration(
              color: themeColors().dialogText(),
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              applogoFilename(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: GCWText(
              text: i18n(context, 'common_app_title'),
              style: TextStyle(color: themeColors().dialogText(), fontSize: 22.0),
            ),
          )
        ],
      ),
    ),
  );

  var menuEntries = <Widget>[];
  menuEntries.add(_buildSettingsItem(context));

  final otherMenuItems = [
    _CategoryMetaData(
        registeredTools.firstWhere((tool) => className(tool.tool) == className(const Changelog())), Icons.show_chart),
    _CategoryMetaData(
        registeredTools.firstWhere((tool) => className(tool.tool) == className(const About())), Icons.info)
  ];

  menuEntries.addAll(otherMenuItems.map((_CategoryMetaData item) {
    return _buildMenuItem(context, item);
  }).toList());

  var footer = Column(
    children: <Widget>[
      InkWell(
          child: Container(
              color: themeColors().dialog(),
              width: double.infinity,
              height: 50,
              child: Row(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Icon(Icons.group, color: themeColors().dialogText()),
                  ),
                  Text(
                    i18n(context, 'mainmenu_callforcontribution_title'),
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: themeColors().dialogText(), fontSize: defaultFontSize()),
                  ),
                ],
              )),
          onTap: () {
            Navigator.pop(context); //close Drawer
            Navigator.of(context).push(NoAnimationMaterialPageRoute<GCWTool>(
                builder: (context) => registeredTools
                    .firstWhere((tool) => className(tool.tool) == className(const CallForContribution()))));
          })
    ],
  );

  return Drawer(
      child: Column(
    children: <Widget>[
      header,
      Expanded(
        child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.zero, // Remove any padding from the ListView.
            children: menuEntries),
      ),
      footer,
    ],
  ));
}

class _CategoryMetaData {
  final GCWTool tool;
  final String? toolName;
  final IconData icon;

  _CategoryMetaData(this.tool, this.icon, [this.toolName]);
}

ExpansionTile _buildSettingsItem(BuildContext context) {
  // TODO class type
  final settingsItems = [
    _CategoryMetaData(
      registeredTools.firstWhere((tool) => className(tool.tool) == className(const GeneralSettings())),
      Icons.settings,
      i18n(context, 'mainmenu_settings_general_title'),
    ),
    _CategoryMetaData(
      registeredTools.firstWhere((tool) => className(tool.tool) == className(const CoordinatesSettings())),
      Icons.language,
      i18n(context, 'mainmenu_settings_coordinates_title'),
    ),
    _CategoryMetaData(
      registeredTools.firstWhere((tool) => className(tool.tool) == className(const ToolSettings())),
      Icons.category,
      i18n(context, 'mainmenu_settings_tools_title'),
    ),
    _CategoryMetaData(
      registeredTools.firstWhere((tool) => className(tool.tool) == className(const SaveRestoreSettings())),
      Icons.save,
      i18n(context, 'mainmenu_settings_saverestore_title'),
    )
  ];

  return ExpansionTile(
      title: Text(i18n(context, 'mainmenu_settings_title'), style: _menuItemStyle()),
      iconColor: themeColors().secondary(),
      collapsedIconColor: themeColors().secondary(),
      leading: Icon(
        Icons.settings,
        color: themeColors().mainFont(),
      ),
      children: settingsItems.map((item) {
        return Padding(padding: const EdgeInsets.only(left: 25), child: _buildMenuItem(context, item));
      }).toList());
}

ListTile _buildMenuItem(BuildContext context, _CategoryMetaData item) {
  return ListTile(
      leading: Icon(
        item.icon,
        color: themeColors().mainFont(),
      ),
      title: Text(item.toolName ?? item.tool.toolName ?? '', style: _menuItemStyle()),
      onTap: () {
        Navigator.pop(context); //close Drawer
        Navigator.of(context).push(NoAnimationMaterialPageRoute<GCWTool>(builder: (BuildContext context) => item.tool));
      });
}

TextStyle _menuItemStyle() {
  return TextStyle(color: themeColors().mainFont(), fontSize: defaultFontSize(), fontWeight: FontWeight.normal);
}
