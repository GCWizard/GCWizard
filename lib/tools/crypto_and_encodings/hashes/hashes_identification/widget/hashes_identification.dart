import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/hashes/logic/hashes.dart';

class HashIdentification extends StatefulWidget {
  const HashIdentification({Key? key}) : super(key: key);

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
      if (_possibleHash(function(_currentValue, ''))) rows.add([i18n(context, key + '_title')]);
    });

    return GCWDefaultOutput(child: GCWColumnedMultilineOutput(data: rows));
  }

  bool _possibleHash(String hash) {
    return hash.length == _currentValue.length;
  }
}
