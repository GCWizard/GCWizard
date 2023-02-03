import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/application/main_menu/about.dart';
import 'package:gc_wizard/application/main_menu/call_for_contribution.dart';
import 'package:gc_wizard/application/main_menu/changelog.dart';
import 'package:gc_wizard/application/navigation/no_animation_material_page_route.dart';
import 'package:gc_wizard/application/registry.dart';
import 'package:gc_wizard/application/settings/widget/settings_coordinates.dart';
import 'package:gc_wizard/application/settings/widget/settings_general.dart';
import 'package:gc_wizard/application/settings/widget/settings_tools.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/gcw_tool.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/common_widget_utils.dart';

buildMainMenu(BuildContext context) {
  var header = SizedBox(
    height: 120.0,
    child: DrawerHeader(
      child: Row(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(2.5),
            child: Image.asset(
              'assets/logo/circle_border_128.png',
            ),
            width: 50.0,
            height: 50.0,
            decoration: BoxDecoration(
              color: themeColors().dialogText(),
              shape: BoxShape.circle,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: GCWText(
              text: i18n(context, 'common_app_title'),
              style: TextStyle(color: themeColors().dialogText(), fontSize: 22.0),
            ),
          )
        ],
      ),
      decoration: BoxDecoration(
        color: themeColors().dialog(),
      ),
    ),
  );

  var menuEntries = <Widget>[];
  menuEntries.add(_buildSettingsItem(context));

  final otherMenuItems = [
    {
      'tool': registeredTools.firstWhere((tool) => className(tool.tool) == className(Changelog())),
      'icon': Icons.show_chart
    },
    {'tool': registeredTools.firstWhere((tool) => className(tool.tool) == className(About())), 'icon': Icons.info},
  ];

  menuEntries.addAll(otherMenuItems.map((item) {
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
                    child: Icon(Icons.group, color: themeColors().dialogText()),
                    padding: EdgeInsets.only(left: 15, right: 15),
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
            Navigator.of(context).push(NoAnimationMaterialPageRoute(
                builder: (context) =>
                    registeredTools.firstWhere((tool) => className(tool.tool) == className(CallForContribution()))));
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
            children: menuEntries
            ),
          ),
      footer,
    ],
  ));
}

_buildSettingsItem(BuildContext context) {
  final settingsItems = [
    {
      'tool': registeredTools.firstWhere((tool) => className(tool.tool) == className(GeneralSettings())),
      'toolName': i18n(context, 'mainmenu_settings_general_title'),
      'icon': Icons.settings
    },
    {
      'tool': registeredTools.firstWhere((tool) => className(tool.tool) == className(CoordinatesSettings())),
      'toolName': i18n(context, 'mainmenu_settings_coordinates_title'),
      'icon': Icons.language
    },
    {
      'tool': registeredTools.firstWhere((tool) => className(tool.tool) == className(ToolSettings())),
      'toolName': i18n(context, 'mainmenu_settings_tools_title'),
      'icon': Icons.category
    },
    // ML 12/2022: Postponed to 3.0.0 because of encoding issues
    // {
    //   'tool': registeredTools.firstWhere((tool) => className(tool.tool) == className(SaveRestoreSettings())),
    //   'toolName': i18n(context, 'mainmenu_settings_saverestore_title'),
    //   'icon': Icons.save
    // },
  ];

  return ExpansionTile(
      title: Text(i18n(context, 'mainmenu_settings_title'), style: _menuItemStyle()),
      iconColor: themeColors().accent(),
      collapsedIconColor: themeColors().accent(),
      leading: Icon(
        Icons.settings,
        color: themeColors().mainFont(),
      ),
      children: settingsItems.map((item) {
        return Padding(padding: EdgeInsets.only(left: 25), child: _buildMenuItem(context, item));
      }).toList());
}

ListTile _buildMenuItem(BuildContext context, item) {
  return ListTile(
      leading: Icon(
        item['icon'],
        color: themeColors().mainFont(),
      ),
      title: Text(item['toolName'] ?? (item['tool'] as GCWTool).toolName, style: _menuItemStyle()),
      onTap: () {
        Navigator.pop(context); //close Drawer
        Navigator.of(context).push(NoAnimationMaterialPageRoute(builder: (context) => item['tool']));
      });
}

_menuItemStyle() {
  return TextStyle(color: themeColors().mainFont(), fontSize: defaultFontSize(), fontWeight: FontWeight.normal);
}
