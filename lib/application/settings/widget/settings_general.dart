import 'package:flutter/material.dart';
import 'package:gc_wizard/application/app_builder.dart';
import 'package:gc_wizard/application/category_views/all_tools_view.dart';
import 'package:gc_wizard/application/i18n/logic/app_language.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/i18n/logic/supported_locales.dart';
import 'package:gc_wizard/application/settings/logic/preferences.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_onoff_switch.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/units/gcw_unit_dropdown.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/default_units_getter.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/length.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/common_widget_utils.dart';
import 'package:prefs/prefs.dart';
import 'package:provider/provider.dart';

class GeneralSettings extends StatefulWidget {
  const GeneralSettings({Key? key}) : super(key: key);

  @override
  _GeneralSettingsState createState() => _GeneralSettingsState();
}

class _GeneralSettingsState extends State<GeneralSettings> {
  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);

    return Column(
      children: <Widget>[
        GCWTextDivider(text: i18n(context, 'settings_general_i18n_title')),
        Row(
          children: [
            Expanded(child: GCWText(text: i18n(context, 'settings_general_i18n_language'))),
            Expanded(
                child: FutureBuilder<Locale>(
                    future: appLanguage.fetchLocale(),
                    builder: (BuildContext context, AsyncSnapshot<Locale> snapshot) {
                      if (!snapshot.hasData) {
                        // while data is loading:
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        // data loaded:
                        final Locale? currentLocale = snapshot.data;

                        return GCWDropDown<String>(
                            items: SUPPORTED_LOCALES.entries.map((locale) {
                              String languageName = locale.value['name_native'] as String;

                              String? subtitle;
                              if (locale.value['percent_translated'] as int < 90) {
                                subtitle = i18n(context, 'settings_general_i18n_language_partlytranslated',
                                    parameters: [locale.value['percent_translated']]);
                              }

                              return GCWDropDownMenuItem(
                                  value: locale.key.languageCode, child: languageName, subtitle: subtitle);
                            }).toList(),
                            value: currentLocale != null && isLocaleSupported(currentLocale)
                                ? currentLocale.languageCode
                                : DEFAULT_LOCALE.languageCode,
                            onChanged: (newValue) {
                              setState(() {
                                appLanguage.changeLanguage(newValue);
                              });
                            });
                      }
                    })),
          ],
        ),
        Container(
          padding: const EdgeInsets.only(bottom: 10 * DEFAULT_MARGIN, top: 5 * DEFAULT_MARGIN),
          child: InkWell(
            child: Text(
              i18n(context, 'settings_general_i18n_language_contributetranslation'),
              style: gcwHyperlinkTextStyle(),
            ),
            onTap: () {
              launchUrl(Uri.parse(i18n(context, 'about_crowdin_url')));
            },
          ),
        ),
        Row(children: [
          Expanded(child: GCWText(text: i18n(context, 'settings_general_i18n_defaultlengthunit'))),
          Expanded(
            child: GCWUnitDropDown<Length>(
                unitList: allLengths(),
                value: defaultLengthUnit,
                onChanged: (Length value) {
                  setState(() {
                    Prefs.setString(PREFERENCE_DEFAULT_LENGTH_UNIT, value.symbol);
                  });
                }),
          ),
        ]),
        GCWTextDivider(text: i18n(context, 'settings_general_theme')),
        GCWTwoOptionsSwitch(
          title: i18n(context, 'settings_general_theme_color'),
          value: Prefs.getString(PREFERENCE_THEME_COLOR) == ThemeType.DARK.toString()
              ? GCWSwitchPosition.left
              : GCWSwitchPosition.right,
          leftValue: i18n(context, 'settings_general_theme_color_dark'),
          rightValue: i18n(context, 'settings_general_theme_color_light'),
          onChanged: (value) {
            setState(() {
              if (value == GCWSwitchPosition.left) {
                Prefs.setString(PREFERENCE_THEME_COLOR, ThemeType.DARK.toString());
                setThemeColors(ThemeType.DARK);
              } else {
                Prefs.setString(PREFERENCE_THEME_COLOR, ThemeType.LIGHT.toString());
                setThemeColors(ThemeType.LIGHT);
              }

              AppBuilder.of(context).rebuild();
            });
          },
        ),
        GCWIntegerSpinner(
          title: i18n(context, 'settings_general_theme_font_size'),
          value: Prefs.getDouble(PREFERENCE_THEME_FONT_SIZE).floor(),
          min: 10,
          max: 30,
          onChanged: (value) {
            setState(() {
              Prefs.setDouble(PREFERENCE_THEME_FONT_SIZE, value.toDouble());

              // source: https://hillel.dev/2018/08/15/flutter-how-to-rebuild-the-entire-app-to-change-the-theme-or-locale/
              AppBuilder.of(context).rebuild();
            });
          },
        ),
        GCWTextDivider(text: i18n(context, 'settings_general_toollist')),
        GCWOnOffSwitch(
          value: Prefs.getBool(PREFERENCE_TOOLLIST_SHOW_DESCRIPTIONS),
          title: i18n(context, 'settings_general_toollist_showdescriptions'),
          onChanged: (value) {
            setState(() {
              Prefs.setBool(PREFERENCE_TOOLLIST_SHOW_DESCRIPTIONS, value);
              AppBuilder.of(context).rebuild();
            });
          },
        ),
        GCWOnOffSwitch(
          value: Prefs.getBool(PREFERENCE_TOOLLIST_SHOW_EXAMPLES),
          title: i18n(context, 'settings_general_toollist_showexamples'),
          onChanged: (value) {
            setState(() {
              Prefs.setBool(PREFERENCE_TOOLLIST_SHOW_EXAMPLES, value);
              AppBuilder.of(context).rebuild();
            });
          },
        ),
        GCWTwoOptionsSwitch(
          value: Prefs.getBool(PREFERENCE_TOOL_COUNT_SORT) ? GCWSwitchPosition.left : GCWSwitchPosition.right,
          leftValue: i18n(context, 'settings_general_toollist_toolcount_sort_on'),
          rightValue: i18n(context, 'settings_general_toollist_toolcount_sort_off'),
          title: i18n(context, 'settings_general_toollist_toolcount_sort'),
          onChanged: (value) {
            setState(() {
              Prefs.setBool(PREFERENCE_TOOL_COUNT_SORT, value == GCWSwitchPosition.left);
              refreshToolLists();
              AppBuilder.of(context).rebuild();
            });
          },
        ),
        GCWTextDivider(text: i18n(context, 'settings_general_defaulttab')),
        GCWTwoOptionsSwitch(
          title: i18n(context, 'settings_general_defaulttab_atstart'),
          value: Prefs.getBool(PREFERENCE_TABS_USE_DEFAULT_TAB) ? GCWSwitchPosition.right : GCWSwitchPosition.left,
          leftValue: i18n(context, 'settings_general_defaulttab_uselasttab'),
          rightValue: i18n(context, 'settings_general_defaulttab_usedefaulttab'),
          onChanged: (value) {
            setState(() {
              Prefs.setBool(PREFERENCE_TABS_USE_DEFAULT_TAB, value == GCWSwitchPosition.right);
            });
          },
        ),
        Prefs.getBool(PREFERENCE_TABS_USE_DEFAULT_TAB)
            ? GCWDropDown<int>(
                value: Prefs.getInt(PREFERENCE_TABS_DEFAULT_TAB),
                items: {
                  0: Row(children: [
                    Icon(Icons.category, color: themeColors().mainFont()),
                    Container(width: 10),
                    Text(i18n(context, 'common_tabs_categories'))
                  ]),
                  1: Row(children: [
                    Icon(Icons.list, color: themeColors().mainFont()),
                    Container(width: 10),
                    Text(i18n(context, 'common_tabs_all'))
                  ]),
                  2: Row(children: [
                    Icon(Icons.star, color: themeColors().mainFont()),
                    Container(width: 10),
                    Text(i18n(context, 'common_tabs_favorites'))
                  ])
                }.entries.map((MapEntry<int, Row> item) {
                  return GCWDropDownMenuItem(
                    value: item.key,
                    child: item.value,
                  );
                }).toList(),
                onChanged: (int value) {
                  setState(() {
                    Prefs.setInt(PREFERENCE_TABS_DEFAULT_TAB, value);
                  });
                },
              )
            : Container(),
        GCWTextDivider(text: i18n(context, 'settings_general_clipboard')),
        GCWIntegerSpinner(
          title: i18n(context, 'settings_general_clipboard_maxitems'),
          value: Prefs.getInt(PREFERENCE_CLIPBOARD_MAX_ITEMS),
          min: 1,
          max: 100,
          onChanged: (value) {
            setState(() {
              Prefs.setInt(PREFERENCE_CLIPBOARD_MAX_ITEMS, value);
            });
          },
        ),
        GCWIntegerSpinner(
          title: i18n(context, 'settings_general_clipboard_keep.entries.in.days'),
          value: Prefs.getInt(PREFERENCE_CLIPBOARD_KEEP_ENTRIES_IN_DAYS),
          min: 1,
          max: 1000,
          onChanged: (value) {
            setState(() {
              Prefs.setInt(PREFERENCE_CLIPBOARD_KEEP_ENTRIES_IN_DAYS, value);
            });
          },
        )
      ],
    );
  }
}
