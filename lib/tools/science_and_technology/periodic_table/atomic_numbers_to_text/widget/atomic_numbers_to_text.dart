import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_integer_list_textfield.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/science_and_technology/periodic_table/_common/logic/elements_of_geocaching.dart';
import 'package:gc_wizard/tools/science_and_technology/periodic_table/_common/logic/periodic_table.dart';
import 'package:gc_wizard/utils/constants.dart';

enum _AtomicNumbersToTextDataSet{NORMAL_PSE, ELEMENTS_OF_GEOCACHING}

class AtomicNumbersToText extends StatefulWidget {
  const AtomicNumbersToText({super.key});

  @override
  _AtomicNumbersToTextState createState() => _AtomicNumbersToTextState();
}

class _AtomicNumbersToTextState extends State<AtomicNumbersToText> {
  late TextEditingController _encryptController;

  String _currentEncryptInput = '';
  List<int> _currentDecryptInput = [];

  var _currentMode = GCWSwitchPosition.left;
  var _currentDataSet = _AtomicNumbersToTextDataSet.NORMAL_PSE;

  @override
  void initState() {
    super.initState();
    _encryptController = TextEditingController(text: _currentEncryptInput);
  }

  @override
  void dispose() {
    _encryptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWDropDown<_AtomicNumbersToTextDataSet>(
            value: _currentDataSet,
            items: _AtomicNumbersToTextDataSet.values.map((_AtomicNumbersToTextDataSet dataSet) {
              String childText;
              switch (dataSet) {
                case _AtomicNumbersToTextDataSet.NORMAL_PSE:
                  childText = 'periodictable_title';
                  break;
                case _AtomicNumbersToTextDataSet.ELEMENTS_OF_GEOCACHING:
                  childText = 'elementsofgeocaching_title';
                  break;
              }

              return GCWDropDownMenuItem<_AtomicNumbersToTextDataSet>(
                  value: dataSet,
                  child: i18n(context, childText)
              );
            }).toList(),
            onChanged: (_AtomicNumbersToTextDataSet value) {
              setState(() {
                _currentDataSet = value;
              });
            }
        ),
        Container(height: 2 * DOUBLE_DEFAULT_MARGIN),
        if (_currentMode == GCWSwitchPosition.left)
          GCWText(
            text: i18n(context, 'atomicnumberstotext_casematters'),
            style: gcwTextStyle().copyWith(fontSize: fontSizeSmall()),
          ),
        _currentMode == GCWSwitchPosition.left
            ? GCWTextField(
                controller: _encryptController,
                onChanged: (text) {
                  setState(() {
                    _currentEncryptInput = text;
                  });
                },
              )
            : GCWIntegerListTextField(
                onChanged: (result) {
                  setState(() {
                    _currentDecryptInput = result.value;
                  });
                },
              ),
        GCWTwoOptionsSwitch(
          value: _currentMode,
          leftValue: i18n(context, 'atomicnumberstotext_symboltonumber'),
          rightValue: i18n(context, 'atomicnumberstotext_numbertosymbol'),
          onChanged: (value) {
            setState(() {
              _currentMode = value;
            });
          },
        ),
        GCWDefaultOutput(child: _buildOutput())
      ],
    );
  }

  String _buildOutput() {
    if (_currentDataSet == _AtomicNumbersToTextDataSet.NORMAL_PSE) {
      if (_currentMode == GCWSwitchPosition.left) {
        return textToAtomicNumbers(_currentEncryptInput).map((
            number) => number ?? UNKNOWN_ELEMENT).join(' ');
      } else {
        return atomicNumbersToText(_currentDecryptInput);
      }
    } else {
      if (_currentMode == GCWSwitchPosition.left) {
        return elementsOfGeocachingTextToAtomicNumbers(_currentEncryptInput).map((
            number) => number ?? UNKNOWN_ELEMENT).join(' ');
      } else {
        return elementsOfGeocachingAtomicNumbersToText(_currentDecryptInput);
      }
    }
  }
}
