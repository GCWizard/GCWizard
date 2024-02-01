import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/app_builder.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/navigation/no_animation_material_page_route.dart';
import 'package:gc_wizard/application/settings/logic/default_settings.dart';
import 'package:gc_wizard/application/settings/logic/preferences_utils.dart';
import 'package:gc_wizard/application/settings/widget/settings_preferences.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_button.dart';
import 'package:gc_wizard/common_widgets/dialogs/gcw_dialog.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_divider.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/gcw_openfile.dart';
import 'package:gc_wizard/common_widgets/gcw_snackbar.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/gcw_tool.dart';
import 'package:gc_wizard/utils/file_utils/file_utils.dart';
import 'package:gc_wizard/utils/file_utils/gcw_file.dart';
import 'package:gc_wizard/utils/json_utils.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/file_widget_utils.dart';
import 'package:prefs/prefs.dart';

class SaveRestoreSettings extends StatefulWidget {
  const SaveRestoreSettings({Key? key}) : super(key: key);

  @override
  _SaveRestoreSettingsState createState() => _SaveRestoreSettingsState();
}

class _SaveRestoreSettingsState extends State<SaveRestoreSettings> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTextDivider(
          text: i18n(context, 'settings_saverestore_save'),
        ),
        GCWButton(
          text: i18n(context, 'settings_saverestore_save_button'),
          onPressed: () {
            var keys = Set<String>.from(Prefs.getKeys());
            var prefsMap = <String, Object>{};
            for (var key in keys) {
              var value = Prefs.get(key);
              if (value == null) continue;

              prefsMap.putIfAbsent(key, () => value);
            }
            var json = jsonEncode(prefsMap);
            _exportSettings(context, json.toString());
          },
        ),
        GCWTextDivider(
          text: i18n(context, 'settings_saverestore_restore'),
        ),
        GCWButton(
          text: i18n(context, 'settings_saverestore_restore_button'),
          onPressed: () {
            showGCWAlertDialog(
              context,
              i18n(context, 'settings_saverestore_restore_warning_title'),
              i18n(context, 'settings_saverestore_restore_warning_text'),
              () {
                openFileExplorer(allowedFileTypes: [FileType.GCW]).then((GCWFile? file) {
                  if (file == null) {
                    showSnackBar(i18n(context, 'common_loadfile_exception_nofile'), context);
                    return;
                  }

                  try {
                    var jsonString = convertBytesToString(file.bytes);
                    var decoded = jsonDecode(jsonString);
                    Map<String, Object?>? prefsMap = asJsonMapOrNull(decoded);
                    if (prefsMap == null || prefsMap.isEmpty) {
                      throw Exception();
                    }

                    restoreAllDefaultPreferences();
                    for (var entry in prefsMap.entries) {
                      if (!isValidPreference(entry.key)) continue;
                      if (!isCorrectType(entry.key, entry.value)) continue;

                      setUntypedPref(entry.key, entry.value!);
                    }

                    setState(() {
                      afterRestorePreferences(context);
                    });

                    showSnackBar(i18n(context, 'settings_saverestore_restore_success'), context);
                  } catch (e) {
                    showSnackBar(i18n(context, 'settings_saverestore_restore_failed'), context);
                  }
                });
              },
            );
          },
        ),
        GCWTextDivider(
          text: i18n(context, 'settings_preferences_resetall_button_title'),
        ),
        GCWButton(
          text: i18n(context, 'settings_saverestore_reset_button'),
          onPressed: () {
            showGCWAlertDialog(context, i18n(context, 'settings_preferences_warning_resetall_title'),
                i18n(context, 'settings_preferences_warning_resetall_text'), () {
              setState(() {
                restoreAllDefaultPreferencesAndRebuild(context);
              });
            });
          },
        ),
        const GCWDivider(),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Icon(Icons.warning_amber, color: themeColors().secondary()),
                Container(padding: const EdgeInsets.symmetric(horizontal: DOUBLE_DEFAULT_MARGIN)),
                Flexible(
                    child: GCWText(
                        text: i18n(context, 'settings_saverestore_restore_restart'),
                        style: gcwTextStyle().copyWith(fontSize: defaultFontSize() - 2))),
              ],
            )),

        // always on bottom
        Container(margin: const EdgeInsets.only(top: 50.0), child: const GCWDivider()),
        InkWell(
          child: const Icon(Icons.more_horiz, size: 20.0),
          onTap: () {
            showGCWAlertDialog(
              context,
              i18n(context, 'settings_preferences_warning_title'),
              i18n(context, 'settings_preferences_warning_text'),
              () {
                Navigator.of(context)
                    .push(NoAnimationMaterialPageRoute<GCWTool>(
                        builder: (context) => GCWTool(tool: const SettingsPreferences(), id: 'settings_preferences')))
                    .whenComplete(() {
                  setState(() {
                    AppBuilder.of(context).rebuild();
                  });

                  showGCWAlertDialog(context, i18n(context, 'settings_preferences_aftermath_title'),
                      i18n(context, 'settings_preferences_aftermath_text'), () {},
                      cancelButton: false);
                });
              },
            );
          },
        )
      ],
    );
  }

  Future<void> _exportSettings(BuildContext context, String data) async {
    await saveStringToFile(context, data, buildFileNameWithDate('settings_', FileType.GCW)).then((value) {
      if (value) showSnackBar(i18n(context, 'settings_saverestore_save_success'), context);
    });
  }
}
