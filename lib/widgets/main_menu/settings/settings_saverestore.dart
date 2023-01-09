import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/utils/common_utils.dart';
import 'package:gc_wizard/widgets/common/base/gcw_button.dart';
import 'package:gc_wizard/widgets/common/base/gcw_text.dart';
import 'package:gc_wizard/widgets/common/base/gcw_dialog.dart';
import 'package:gc_wizard/widgets/common/gcw_openfile.dart';
import 'package:gc_wizard/widgets/common/gcw_text_divider.dart';
import 'package:gc_wizard/widgets/main_menu/settings/preferences_utils.dart';
import 'package:gc_wizard/widgets/utils/app_builder.dart';
import 'package:gc_wizard/widgets/utils/file_utils.dart';
import 'package:gc_wizard/widgets/utils/gcw_file.dart';
import 'package:intl/intl.dart';
import 'package:prefs/prefs.dart';
import 'package:gc_wizard/utils/settings/preferences.dart';
import 'package:gc_wizard/theme/theme_colors.dart';
import 'package:gc_wizard/theme/theme.dart';
import 'package:gc_wizard/widgets/utils/common_widget_utils.dart';
import 'package:gc_wizard/utils/settings/default_settings.dart';
import 'package:gc_wizard/widgets/common/base/gcw_toast.dart';

class SaveRestoreSettings extends StatefulWidget {
  @override
  SaveRestoreSettingsState createState() => SaveRestoreSettingsState();
}

class SaveRestoreSettingsState extends State<SaveRestoreSettings> {
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
            var prefsMap = <String, dynamic>{};
            keys.forEach((key) {
              prefsMap.putIfAbsent(key, () => Prefs.get(key));
            });
            var json = jsonEncode(prefsMap);

            //Uint8 is not enough here for special some special characters or Korean characters!!!
            var outputData = Uint8List.fromList(json.codeUnits);

            _exportSettings(context, outputData);
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
              i18n(context, 'settings_saverestore_restore_warning_text'), () {

                showOpenFileDialog(context, [FileType.GCW], (GCWFile file) {
                  try {
                    var jsonString = String.fromCharCodes(file.bytes);
                    Map<String, dynamic> prefsMap = jsonDecode(jsonString);

                    initDefaultSettings(PreferencesInitMode.REINIT_ALL);
                    prefsMap.entries.forEach((entry) {
                      setUntypedPref(entry.key, entry.value);
                    });

                    setState(() {
                      setThemeColorsByName(Prefs.get(PREFERENCE_THEME_COLOR));
                      AppBuilder.of(context).rebuild();
                    });

                    showToast(i18n(context, 'settings_saverestore_restore_success'));
                  } catch(e) {
                    showToast(i18n(context, 'settings_saverestore_restore_failed'));
                  }
                  return false;
                });
              },
            );
          },
        ),
        Container(
            child: GCWText(
                text: i18n(context, 'settings_saverestore_restore_restart'),
                style: gcwTextStyle().copyWith(fontSize: defaultFontSize() - 2)
            ),
            padding: EdgeInsets.symmetric(horizontal: 15)
        ),
      ],
    );
  }

  _exportSettings(BuildContext context, Uint8List data) async {
    String timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    String outputFilename = 'settings_${timestamp}.gcw';

    await saveByteDataToFile(context, data, outputFilename);

    showToast(i18n(context, 'settings_saverestore_save_success'));
  }
}
