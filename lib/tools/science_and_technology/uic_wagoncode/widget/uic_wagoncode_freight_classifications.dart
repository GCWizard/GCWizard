import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/gcw_expandable.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/science_and_technology/uic_wagoncode/logic/uic_wagoncode.dart';

class UICWagonCodeFreightClassifications extends StatefulWidget {
  const UICWagonCodeFreightClassifications({Key? key}) : super(key: key);

  @override
  _UICWagonCodeFreightClassificationsState createState() => _UICWagonCodeFreightClassificationsState();
}

class _UICWagonCodeFreightClassificationsState extends State<UICWagonCodeFreightClassifications> {
  String _currentCategory = '-';
  String _currentClassification = '';
  String _currentUICNumber = '';

  late TextEditingController _uicNumberController;
  late TextEditingController _uicClassificationController;

  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;

  @override
  void initState() {
    super.initState();
    _uicNumberController = TextEditingController(text: _currentUICNumber);
    _uicClassificationController = TextEditingController(text: _currentClassification);
  }

  @override
  void dispose() {
    _uicNumberController.dispose();
    _uicClassificationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTwoOptionsSwitch(
          value: _currentMode,
          leftValue: i18n(context, 'uic_wagoncode_freight_classification_letterstonumbers'),
          rightValue: i18n(context, 'uic_wagoncode_freight_classification_numberstoletters'),
          onChanged: (value) {
            setState(() {
              _currentMode = value;
            });
          },
        ),
        _currentMode == GCWSwitchPosition.left ?
            Column(
              children: [
                GCWDropDown(
                    title: i18n(context, 'uic_category'),
                    value: _currentCategory,
                    items: ['-', 'E', 'F', 'G', 'H', 'I', 'K', 'L', 'O', 'R', 'S', 'T', 'U', 'Z'].map((category) {
                      return GCWDropDownMenuItem(
                          value: category,
                          child: category
                      );
                    }).toList(),
                    onChanged: (String value) {
                      setState(() {
                        _currentCategory = value;
                      });
                    }
                ),
                GCWTextField(
                  title: i18n(context, 'uic_classification'),
                  controller: _uicClassificationController,
                  onChanged: (value) {
                    setState(() {
                      _currentClassification = value;
                    });
                  },
                )
              ],
            )
        : Column(
          children: [
            GCWTextField(
              controller: _uicNumberController,
              onChanged: (value) {
                setState(() {
                  _currentUICNumber = value;
                });
              },
            )
          ],
        ),
        _buildOutput()
      ],
    );
  }

  String _letterToNumberCategory(String letter) {
    return {
      'E': '5',
      'F': '6',
      'G': '1',
      'H': '2',
      'I': '8',
      'K': '3',
      'L': '4',
      'O': '3',
      'R': '3',
      'S': '4',
      'T': '0',
      'U': '9',
      'Z': '7'
    }[letter]!;
  }

  Widget _buildOutput() {
    if (_currentMode == GCWSwitchPosition.left) {
      var category = '';
      if (_currentCategory != '-') {
        category = _letterToNumberCategory(_currentCategory);
      }

      var searchableCategories = category.isEmpty ? '1234567890'.split('').toList() : [category];
      var uicNumbers = <String>[];
      for (var cat in searchableCategories) {
        var classifications = <String>[];
        for (var classification in UICWagonCodesFreightClassificationCodes[cat]!.entries) {
          classifications.addAll(
            classification.value.entries.where((element) => element.value == _currentClassification).map((e) => e.key + classification.key)
          );
        }
        uicNumbers.addAll(classifications.map((e) => cat + e));
      }

      uicNumbers.sort();

      List<List<String>> classificationData = [];
      if (uicNumbers.isNotEmpty) {
        var uic = UICWagonCodeFreightWagon(('0' * 4) + uicNumbers.first + ('0' * 4));
        classificationData = category.isEmpty ? [] : [
          [uic.category.letterCode, i18n(context, uic.category.name)]
        ];
        for (var description in uic.classification.descriptions.entries) {
          classificationData.add([description.key, i18n(context, description.value)]);
        }
      }

      if (classificationData.isEmpty) {
        return GCWDefaultOutput(
          child: Column(
            children: uicNumbers.map((e) => GCWOutput(child: e)).toList(),
          ),
        );
      } else {
        return Column(
            children: [
              GCWExpandableTextDivider(
                suppressTopSpace: false,
                text: i18n(context, 'common_output'),
                child: Column(
                  children: uicNumbers.map((e) => GCWOutput(child: e)).toList(),
                ),
              ),
              Column(
                children: [
                  GCWTextDivider(text: i18n(context, 'common_details')),
                  GCWColumnedMultilineOutput(data: classificationData, flexValues: const [1, 4],)
                ],
              )
            ],
          );
      }
    } else {
      String uicInput = _currentUICNumber.replaceAll(RegExp(r'[^0-9]'), '');
      switch (uicInput.length) {
        case 0:
          return const GCWDefaultOutput();
        case 12:
          break;
        case 4:
          uicInput = ('0' * 4) + uicInput + ('0' * 4);
          break;
        default:
          return GCWDefaultOutput(
            child: i18n(context, ''),
          );
      }

      var uic = UICWagonCodeFreightWagon(uicInput);

      List<List<String>> classificationData = [
        [uic.category.letterCode, i18n(context, uic.category.name)]
      ];
      for (var description in uic.classification.descriptions.entries) {
        classificationData.add([description.key, i18n(context, description.value)]);
      }

      return Column(
        children: [
          GCWDefaultOutput(
            child: uic.category.letterCode + uic.classification.uicLetterCode.join(),
          ),
          GCWTextDivider(text: i18n(context, 'common_details')),
          GCWColumnedMultilineOutput(data: classificationData, flexValues: const [1, 4])
        ],
      );
    }
  }
}
