import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/logic/tools/crypto_and_encodings/hashes/hashes.dart';
import 'package:gc_wizard/widgets/common/base/gcw_textfield.dart';
import 'package:gc_wizard/widgets/common/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/widgets/common/gcw_default_output.dart';

class HashIdentification extends StatefulWidget {
  @override
  _HashIdentificationState createState() => _HashIdentificationState();
}

class _HashIdentificationState extends State<HashIdentification> {
  String _currentValue = '';

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
        _buildOutput(context)
      ],
    );
  }

  Widget _buildOutput(BuildContext context) {
    var rows = <List<String>>[];
    HASH_FUNCTIONS.forEach((key, function) {
      if (_possibleHash(function(_currentValue))) rows.add([i18n(context, key + '_title')]);
    });

    HASHKEY_FUNCTIONS.forEach((key, function) {
      if (_possibleHash(function(_currentValue, null))) rows.add([i18n(context, key + '_title')]);
    });

    return GCWDefaultOutput(child: GCWColumnedMultilineOutput(data: rows));
  }

  bool _possibleHash(String hash) {
    if (hash == null || _currentValue == null) return false;
    return hash?.length == _currentValue.length;
  }
}
