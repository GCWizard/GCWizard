import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output_text.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_onoff_switch.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/text_input_formatters/wrapper_for_masktextinputformatter.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/chef_language/logic/chef_language.dart';

class Chef extends StatefulWidget {
  const Chef({Key? key}) : super(key: key);

  @override
  _ChefState createState() => _ChefState();
}

class _ChefState extends State<Chef> {
  late TextEditingController _recipeController;
  late TextEditingController _inputController;
  late TextEditingController _titleController;
  late TextEditingController _remarkController;
  late TextEditingController _timeController;
  late TextEditingController _temperatureController;
  late TextEditingController _outputController;

  var _currentRecipe = '';
  var _currentInput = '';
  var _currentTitle = '';
  var _currentRemark = '';
  var _currentTime = '';
  var _currentTemperature = '';
  var _currentOutput = '';

  var TimeInputFormatter = GCWMaskTextInputFormatter(
      mask: '#' * 3, // allow 3 characters input
      filter: {"#": RegExp(r'\d')});
  var TemperatureInputFormatter = GCWMaskTextInputFormatter(
      mask: '#' * 3, // allow 3 characters input
      filter: {"#": RegExp(r'\d')});
  var DigitSpacesInputFormatter = GCWMaskTextInputFormatter(
      mask: '#' * 1000, // allow 1000 characters input
      filter: {"#": RegExp(r'\d ')});

  GCWSwitchPosition _currentMode = GCWSwitchPosition.left; // interpret
  GCWSwitchPosition _currentLanguage = GCWSwitchPosition.right; // english
  bool _auxilaryRecipes = false;
  var init = true;

  @override
  void initState() {
    super.initState();
    _recipeController = TextEditingController(text: _currentRecipe);
    _inputController = TextEditingController(text: _currentInput);
    _titleController = TextEditingController(text: _currentTitle);
    _remarkController = TextEditingController(text: _currentRemark);
    _timeController = TextEditingController(text: _currentTime);
    _temperatureController = TextEditingController(text: _currentTemperature);
    _outputController = TextEditingController(text: _currentOutput);
  }

  @override
  void dispose() {
    _recipeController.dispose();
    _inputController.dispose();
    _titleController.dispose();
    _remarkController.dispose();
    _timeController.dispose();
    _temperatureController.dispose();
    _outputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (init) {
      _currentLanguage = _defaultLanguage(context);
      init = false;
    }
    return Column(
      children: <Widget>[
        GCWTwoOptionsSwitch(
          leftValue: i18n(context, 'common_language_german'),
          rightValue: i18n(context, 'common_language_english'),
          value: _currentLanguage,
          onChanged: (value) {
            setState(() {
              _currentLanguage = value;
            });
          },
        ),
        GCWTwoOptionsSwitch(
          leftValue: i18n(context, 'common_programming_mode_interpret'),
          rightValue: i18n(context, 'common_programming_mode_generate'),
          value: _currentMode,
          onChanged: (value) {
            setState(() {
              _currentMode = value;
            });
          },
        ),
        _currentMode == GCWSwitchPosition.right // generate Chef-programm
            ? Column(
                children: <Widget>[
                  GCWTextField(
                    controller: _outputController,
                    hintText: i18n(context, 'common_programming_hint_output'),
                    onChanged: (text) {
                      setState(() {
                        _currentOutput = text;
                      });
                    },
                  ),
                  GCWTextField(
                    controller: _titleController,
                    hintText: i18n(context, 'chef_recipetitle'),
                    onChanged: (text) {
                      setState(() {
                        _currentTitle = text;
                      });
                    },
                  ),
                  GCWTextDivider(text: i18n(context, 'chef_options')),
                  GCWTextField(
                    controller: _remarkController,
                    hintText: i18n(context, 'chef_remark'),
                    onChanged: (text) {
                      setState(() {
                        _currentRemark = text;
                      });
                    },
                  ),
                  GCWTextField(
                    controller: _timeController,
                    inputFormatters: [TimeInputFormatter],
                    hintText: i18n(context, 'chef_time'),
                    onChanged: (text) {
                      setState(() {
                        _currentTime = text;
                      });
                    },
                  ),
                  GCWTextField(
                    controller: _temperatureController,
                    inputFormatters: [TemperatureInputFormatter],
                    hintText: i18n(context, 'chef_temperature'),
                    onChanged: (text) {
                      setState(() {
                        _currentTemperature = text;
                      });
                    },
                  ),
                  GCWOnOffSwitch(
                    notitle: false,
                    title: i18n(context, 'chef_generate_auxiliary_recipe'),
                    value: _auxilaryRecipes,
                    onChanged: (value) {
                      setState(() {
                        _auxilaryRecipes = value;
                      });
                    },
                  ),
                  GCWTextDivider(text: i18n(context, 'common_programming_hint_sourcecode')),
                ],
              )
            : Column(
                children: <Widget>[
                  GCWTextField(
                    controller: _recipeController,
                    hintText: i18n(context, 'common_programming_hint_sourcecode'),
                    onChanged: (text) {
                      setState(() {
                        _currentRecipe = text;
                      });
                    },
                  ),
                  GCWTextDivider(text: i18n(context, 'chef_refrigerator')),
                  GCWTextField(
                    controller: _inputController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9 ]')),
                    ],
                    hintText: i18n(context, 'common_programming_hint_input'),
                    onChanged: (text) {
                      setState(() {
                        _currentInput = text;
                      });
                    },
                  ),
                  GCWTextDivider(text: i18n(context, 'common_programming_hint_output')),
                ],
              ),
        _buildOutput(context)
      ],
    );
  }

  Widget _buildOutput(BuildContext context) {
    String output = '';

    String language = 'ENG';
    if (_currentLanguage == GCWSwitchPosition.left) language = 'DEU';
    if (_currentMode == GCWSwitchPosition.right) {
      // generate chef
      if (_currentTitle.isEmpty) {
        output =
            chefBuildOutputText(context, ['chef_error_structure_recipe', 'chef_error_structure_recipe_missing_title']);
      } else if (_currentOutput.isEmpty) {
        output =
            chefBuildOutputText(context, ['chef_error_structure_recipe', 'chef_error_structure_recipe_missing_output']);
      } else {
        output = generateChef(language, _currentTitle, _currentRemark, _currentTime, _currentTemperature,
            _currentOutput, _auxilaryRecipes);
      }
    } else {
      // interpret chef
      if (isValid(_currentInput)) {
        try {
          output = chefBuildOutputText(context, interpretChef(language, _currentRecipe, _currentInput));
        } catch (e) {
          output = chefBuildOutputText(context, [
            'common_programming_error_runtime',
            'chef_error_runtime_exception',
            'chef_error_structure_recipe_missing_title'
          ]);
        }
      } else {
        output = chefBuildOutputText(context, ['common_programming_error_runtime', 'chef_error_runtime_invalid_input']);
      }
    }
    return GCWOutputText(
      text: output.trim(),
      isMonotype: true,
    );
  }

  GCWSwitchPosition _defaultLanguage(BuildContext context) {
    final Locale appLocale = Localizations.localeOf(context);
    if (appLocale == const Locale('de')) {
      return GCWSwitchPosition.left;
    } else {
      return GCWSwitchPosition.right;
    }
  }
}

String chefBuildOutputText(BuildContext context, List<String> outputList) {
  String output = '';
  for (var element in outputList) {
    if (element.startsWith('chef_') || element.startsWith('common_programming')) {
      output = output + i18n(context, element) + '\n';
    } else {
      output = output + element + '\n';
    }
  }
  return output;
}
