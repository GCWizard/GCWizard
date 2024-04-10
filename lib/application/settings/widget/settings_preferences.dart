import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/settings/logic/default_settings.dart';
import 'package:gc_wizard/application/settings/logic/preferences_utils.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_button.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/clipboard/gcw_clipboard.dart';
import 'package:gc_wizard/common_widgets/dialogs/gcw_dialog.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_double_spinner.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_onoff_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:prefs/prefs.dart';

const _PREF_VALUE_MAX_LENGTH = 300;

class SettingsPreferences extends StatefulWidget {
  const SettingsPreferences({Key? key}) : super(key: key);

  @override
  _SettingsPreferencesState createState() => _SettingsPreferencesState();
}

class _SettingsPreferencesState extends State<SettingsPreferences> {
  late List<String> _keys;
  String? _editKey;
  Object? _editedValue;

  final List<String> _expandedValues = [];

  List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    _keys = List<String>.from(Prefs.getKeys());
    _keys.sort();
  }

  @override
  void dispose() {
    for (var i = 0; i < _controllers.length; i++) {
      _controllers[i].dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[
      GCWButton(
        text: i18n(context, 'settings_preferences_resetall_button_title'),
        onPressed: () {
          showGCWAlertDialog(context, i18n(context, 'settings_preferences_warning_resetall_title'),
              i18n(context, 'settings_preferences_warning_resetall_text'), () {
            setState(() {
              restoreAllDefaultPreferencesAndRebuild(context);
            });
          });
        },
      ),
    ];

    children.addAll(_keys.map((String key) {
      return _buildPreferencesView(key);
    }).toList());

    return Column(
      children: children,
    );
  }

  Widget _buildPreferencesView(String key) {
    var prefValue = Prefs.get(key).toString();

    return Container(
        color: _keys.indexOf(key) % 2 == 0 ? themeColors().outputListOddRows() : null,
        child: Column(
          children: [
            Container(
              height: 2 * DOUBLE_DEFAULT_MARGIN,
            ),
            GCWTextDivider(
              text: key,
              style: gcwMonotypeTextStyle(),
              suppressBottomSpace: true,
              suppressTopSpace: true,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildEditSaveButton(key),
                if (_editKey != null && _editKey == key)
                  Row(
                    children: [
                      _buildEmptyButton(key),
                      _buildUndoButton(key),
                      Container(width: DEFAULT_MARGIN),
                      _buildDefaultButton(key),
                    ],
                  ),
                Container(
                  width: 3 * DOUBLE_DEFAULT_MARGIN,
                ),
                _buildCopyButton(key)
              ],
            ),
            _editKey != null && _editKey == key
                ? _buildEditView(key)
                : Column(
                    children: [
                      GCWText(
                        text: !_expandedValues.contains(key) && prefValue.length > _PREF_VALUE_MAX_LENGTH
                            ? prefValue.substring(0, _PREF_VALUE_MAX_LENGTH) + '...'
                            : prefValue,
                        style: gcwMonotypeTextStyle().copyWith(fontSize: defaultFontSize() - 3),
                      ),
                      prefValue.length > _PREF_VALUE_MAX_LENGTH
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GCWIconButton(
                                  icon: _expandedValues.contains(key) ? Icons.arrow_drop_up : Icons.more_horiz,
                                  size: IconButtonSize.SMALL,
                                  onPressed: () {
                                    setState(() {
                                      _expandedValues.contains(key)
                                          ? _expandedValues.remove(key)
                                          : _expandedValues.add(key);
                                    });
                                  },
                                )
                              ],
                            )
                          : Container()
                    ],
                  ),
            Container(
              height: 2 * DOUBLE_DEFAULT_MARGIN,
            )
          ],
        ));
  }

  GCWIconButton _buildEditSaveButton(String key) {
    return GCWIconButton(
      icon: _editKey != null && _editKey == key ? (_prefValueHasChanged(key) ? Icons.save : Icons.close) : Icons.edit,
      onPressed: () {
        setState(() {
          if (_editKey == key) {
            _doOnSave(key);
          } else {
            _editKey = key;
            _editedValue = null;
          }
        });
      },
    );
  }

  void _doOnSave(String key) {
    if (!_prefValueHasChanged(key)) {
      setState(() {
        _editKey = null;
        _editedValue = null;
      });

      return;
    }

    showGCWAlertDialog(context, i18n(context, 'settings_preferences_warning_save_title'),
        i18n(context, 'settings_preferences_warning_save_text'), () {
      if (_editedValue == null) return;

      setUntypedPref(key, _editedValue!);

      setState(() {
        _editKey = null;
        _editedValue = null;
      });
    });
  }

  bool _prefValueHasChanged(String key) {
    if (_editedValue == null) return false;

    switch (getPrefType(key)) {
      case PrefType.STRING:
      case PrefType.INT:
      case PrefType.DOUBLE:
      case PrefType.BOOL:
        return _editedValue != Prefs.get(key);
      case PrefType.STRINGLIST:
        if (_editedValue is! List<String> && _editedValue is! List<Object>) return false;

        var list = Prefs.get(key);
        if (list == null) return true;
        if ((_editedValue as List).length != (list as List<String>).length) return true;

        for (var i = 0; i < list.length; i++) {
          if ((_editedValue as List)[i].toString() != list[i].toString()) {
            return true;
          }
        }

        return false;
    }
  }

  Widget _buildEmptyButton(String key) {
    switch (getPrefType(key)) {
      case PrefType.STRING:
      case PrefType.STRINGLIST:
        return GCWIconButton(
            icon: Icons.delete,
            onPressed: () {
              setState(() {
                if (getPrefType(key) == PrefType.STRING) {
                  _editedValue = '';
                  _controllers.first.text = '';
                } else {
                  _editedValue = <String>[];
                  _controllers = [];
                }
              });
            });
      default:
        return Container();
    }
  }

  GCWIconButton _buildUndoButton(String key) {
    return GCWIconButton(
      icon: Icons.refresh,
      iconColor: _prefValueHasChanged(key) ? null : themeColors().inActive(),
      onPressed: () {
        setState(() {
          _editedValue = null;
        });
      },
    );
  }

  GCWButton _buildDefaultButton(String key) {
    return GCWButton(
      text: i18n(context, 'settings_preferences_resetsingle_button_title'),
      onPressed: () {
        showGCWAlertDialog(context, i18n(context, 'settings_preferences_warning_resetsingle_title'),
            i18n(context, 'settings_preferences_warning_resetsingle_text'), () {
          restoreSingleDefaultPreferenceAndRebuild(key, context);

          setState(() {
            _editKey = null;
            _editedValue = null;
          });
        });
      },
    );
  }

  GCWIconButton _buildCopyButton(String key) {
    return GCWIconButton(
      icon: Icons.copy,
      onPressed: () {
        insertIntoGCWClipboard(context, _editedValue != null ? _editedValue.toString() : Prefs.get(key).toString());
      },
    );
  }

  Widget _buildEditView(String key) {
    switch (getPrefType(key)) {
      case PrefType.STRING:
        if (_editedValue == null || _editedValue is! String) {
          _controllers = [TextEditingController(text: Prefs.getString(key))];
        }
        return GCWTextField(
          controller: _controllers.first,
          onChanged: (text) {
            setState(() {
              _editedValue = text;
            });
          },
        );
      case PrefType.INT:
        if (_editedValue == null || _editedValue is! int) {
          _editedValue = Prefs.getInt(key);
        }

        return GCWIntegerSpinner(
          value: _editedValue as int,
          onChanged: (value) {
            setState(() {
              _editedValue = value;
            });
          },
        );
      case PrefType.DOUBLE:
        if (_editedValue == null || _editedValue is! double) {
          _editedValue = Prefs.getDouble(key);
        }

        return GCWDoubleSpinner(
          value: _editedValue as double,
          onChanged: (value) {
            setState(() {
              _editedValue = value;
            });
          },
        );
      case PrefType.BOOL:
        if (_editedValue == null || _editedValue is! bool) {
          _editedValue = Prefs.getBool(key);
        }

        return GCWOnOffSwitch(
          value: _editedValue as bool,
          onChanged: (value) {
            setState(() {
              _editedValue = value;
            });
          },
        );
      case PrefType.STRINGLIST:
        if (_editedValue == null || _editedValue is! List) {
          _editedValue = List<String>.from(Prefs.getStringList(key)).map((e) => e.toString()).toList();
          _controllers = [];
        }

        var children = <Widget>[
          Row(
            children: [
              Expanded(
                child: Container(),
              ),
              GCWIconButton(
                icon: Icons.add,
                onPressed: () {
                  setState(() {
                    (_editedValue as List).add('');
                    _controllers = [];
                  });
                },
              )
            ],
          )
        ];

        if ((_editedValue as List).isEmpty) {
          return Column(
            children: children,
          );
        }

        for (var i = 0; i < (_editedValue as List).length; i++) {
          _controllers.add(TextEditingController(text: (_editedValue as List)[i].toString()));
        }

        children.addAll((_editedValue as List)
            .asMap()
            .map<int, Widget>((index, item) {
              return MapEntry<int, Widget>(
                  index,
                  Row(
                    children: [
                      Expanded(
                        child: GCWTextField(
                          controller: _controllers[index],
                          onChanged: (value) {
                            setState(() {
                              (_editedValue as List)[index] = value;
                            });
                          },
                        ),
                      ),
                      Container(width: DOUBLE_DEFAULT_MARGIN),
                      GCWIconButton(
                        icon: Icons.remove,
                        onPressed: () {
                          setState(() {
                            (_editedValue as List).removeAt(index);
                            _controllers = [];
                          });
                        },
                      )
                    ],
                  ));
            })
            .values
            .toList());

        return Column(
          children: children,
        );
    }
  }
}
