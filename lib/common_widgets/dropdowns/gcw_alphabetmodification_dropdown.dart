import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/_common/logic/crypt_alphabet_modification.dart';

class GCWAlphabetModificationDropDown extends StatefulWidget {
  final void Function(AlphabetModificationMode) onChanged;
  final AlphabetModificationMode? value;
  final List<AlphabetModificationMode>? allowedModifications;
  final bool suppressTitle;

  const GCWAlphabetModificationDropDown(
      {Key? key, required this.onChanged, required this.value, this.allowedModifications, this.suppressTitle = false})
      : super(key: key);

  @override
  GCWAlphabetModificationDropDownState createState() => GCWAlphabetModificationDropDownState();
}

class GCWAlphabetModificationDropDownState extends State<GCWAlphabetModificationDropDown> {
  AlphabetModificationMode? _currentValue;
  late Map<AlphabetModificationMode, String> modifications;

  final allModifications = <AlphabetModificationMode, String> {
    AlphabetModificationMode.J_TO_I: 'common_alphabetmodification_jtoi',
    AlphabetModificationMode.C_TO_K: 'common_alphabetmodification_ctok',
    AlphabetModificationMode.W_TO_VV: 'common_alphabetmodification_wtovv',
    AlphabetModificationMode.REMOVE_Q: 'common_alphabetmodification_removeq',
  };

  @override
  void initState() {
    super.initState();

    if (widget.allowedModifications == null) {
      modifications = allModifications;
    } else {
      modifications = {};
      for (var modification in allModifications.entries) {
        if (widget.allowedModifications!.contains(modification.key)) {
          modifications.putIfAbsent(modification.key, () => modification.value);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        if (!widget.suppressTitle)
          Expanded(flex: 1, child: GCWText(text: i18n(context, 'common_alphabetmodification_title') + ':')),
        Expanded(
            flex: 2,
            child: GCWDropDown<AlphabetModificationMode>(
              value: _currentValue ?? widget.value ?? AlphabetModificationMode.J_TO_I,
              onChanged: (AlphabetModificationMode newValue) {
                setState(() {
                  _currentValue = newValue;
                  widget.onChanged(_currentValue!);
                });
              },
              items: modifications.entries.map((entry) {
                return GCWDropDownMenuItem(
                  value: entry.key,
                  child: i18n(context, entry.value),
                );
              }).toList(),
            ))
      ],
    );
  }
}
