import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/_common/logic/crypt_alphabet_modification.dart';

class GCWAlphabetModificationDropDown extends StatefulWidget {
  final Function onChanged;
  final value;
  final List<AlphabetModificationMode> allowedModifications;
  final bool suppressTitle;

  const GCWAlphabetModificationDropDown(
      {Key key, this.onChanged, this.value, this.allowedModifications, this.suppressTitle: false})
      : super(key: key);

  @override
  GCWAlphabetModificationDropDownState createState() => GCWAlphabetModificationDropDownState();
}

class GCWAlphabetModificationDropDownState extends State<GCWAlphabetModificationDropDown> {
  AlphabetModificationMode _currentValue;
  List<Map<String, dynamic>> modifications;

  var allModifications = [
    {'mode': AlphabetModificationMode.J_TO_I, 'text': 'common_alphabetmodification_jtoi'},
    {'mode': AlphabetModificationMode.C_TO_K, 'text': 'common_alphabetmodification_ctok'},
    {'mode': AlphabetModificationMode.W_TO_VV, 'text': 'common_alphabetmodification_wtovv'},
    {'mode': AlphabetModificationMode.REMOVE_Q, 'text': 'common_alphabetmodification_removeq'},
  ];

  @override
  void initState() {
    super.initState();

    if (widget.allowedModifications == null) {
      modifications = allModifications;
    } else {
      modifications = [];
      allModifications.forEach((modification) {
        if (widget.allowedModifications.contains(modification['mode'])) modifications.add(modification);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        if (!widget.suppressTitle)
          Expanded(child: GCWText(text: i18n(context, 'common_alphabetmodification_title') + ':'), flex: 1),
        Expanded(
            child: GCWDropDown(
              value: _currentValue ?? widget.value ?? AlphabetModificationMode.J_TO_I,
              onChanged: (newValue) {
                setState(() {
                  _currentValue = newValue;
                  widget.onChanged(_currentValue);
                });
              },
              items: modifications.map((entry) {
                return GCWDropDownMenuItem(
                  value: entry['mode'],
                  child: i18n(context, entry['text']),
                );
              }).toList(),
            ),
            flex: 2)
      ],
    );
  }
}
