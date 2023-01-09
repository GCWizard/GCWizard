import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/logic/tools/crypto_and_encodings/hashes/hashes.dart';
import 'package:gc_wizard/widgets/common/base/gcw_textfield.dart';
import 'package:gc_wizard/widgets/common/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/widgets/common/gcw_default_output.dart';
import 'package:gc_wizard/widgets/common/gcw_expandable.dart';

class HashOverview extends StatefulWidget {
  @override
  _HashOverviewState createState() => _HashOverviewState();
}

class _HashOverviewState extends State<HashOverview> {
  String _currentValue = '';
  String _currentKey = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTextField(
          onChanged: (value) {
            setState(() {
              _currentValue = value;
            });
          },
        ),
        GCWExpandableTextDivider(
          text: i18n(context, 'hashes_overview_hmacoptions'),
          suppressTopSpace: false,
          expanded: false,
          child: GCWTextField(
            hintText: i18n(context, 'common_key'),
            onChanged: (value) {
              setState(() {
                _currentKey = value;
              });
            },
          ),
        ),
        _buildOutput(context)
      ],
    );
  }

  Widget _buildOutput(BuildContext context) {
    var rows = <List<String>>[];
    if (_currentKey == null || _currentKey == '') {
      HASH_FUNCTIONS.forEach((key, function) {
        rows.add([i18n(context, key + '_title'), function(_currentValue)]);
      });
    }

    HASHKEY_FUNCTIONS.forEach((key, function) {
      rows.add([i18n(context, key + '_title'), function(_currentValue, _currentKey)]);
    });

    return GCWDefaultOutput(child: GCWColumnedMultilineOutput(data: rows));
  }
}
