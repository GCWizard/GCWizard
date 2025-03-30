import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/gcw_expandable.dart';
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
  late TextEditingController _outputToGenerateController;

  String _currentRecipe = '';
  String _currentInputFromFridge = '';
  String _currentTitle = '';
  String _currentRemark = '';
  String _currentTime = '';
  String _currentTemperature = '';
  String _currentOutputToGenerate = '';
  String _currentOutput = '';

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
    _inputController = TextEditingController(text: _currentInputFromFridge);
    _titleController = TextEditingController(text: _currentTitle);
    _remarkController = TextEditingController(text: _currentRemark);
    _timeController = TextEditingController(text: _currentTime);
    _temperatureController = TextEditingController(text: _currentTemperature);
    _outputToGenerateController = TextEditingController(text: _currentOutputToGenerate);
  }

  @override
  void dispose() {
    _recipeController.dispose();
    _inputController.dispose();
    _titleController.dispose();
    _remarkController.dispose();
    _timeController.dispose();
    _temperatureController.dispose();
    _outputToGenerateController.dispose();
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
        _buildWidgetLanguageMode(context),
        _buildWidgetProgramMode(context),
        _currentMode == GCWSwitchPosition.right // generate Chef-programm
            ? _buildWidgetGenerateChefProgram(context)
            : _buildWidgetInterpretChefProgram(context),
        _buildOutput(context)
      ],
    );
  }

  Widget _buildWidgetLanguageMode(BuildContext context){
    return GCWTwoOptionsSwitch(
      leftValue: i18n(context, 'common_language_german'),
      rightValue: i18n(context, 'common_language_english'),
      value: _currentLanguage,
      onChanged: (value) {
        setState(() {
          _currentLanguage = value;
        });
      },
    );
  }

  Widget _buildWidgetProgramMode(BuildContext context){
    return GCWTwoOptionsSwitch(
      leftValue: i18n(context, 'common_programming_mode_interpret'),
      rightValue: i18n(context, 'common_programming_mode_generate'),
      value: _currentMode,
      onChanged: (value) {
        setState(() {
          _currentMode = value;
        });
      },
    );
  }

  Widget _buildWidgetGenerateChefProgram(BuildContext context){
    return Column(
      children: <Widget>[
        GCWTextField(
          controller: _outputToGenerateController,
          hintText: i18n(context, 'common_programming_hint_output'),
          onChanged: (text) {
            setState(() {
              _currentOutputToGenerate = text;
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
    );
  }

  Widget _buildWidgetInterpretChefProgram(BuildContext context){
    return Column(
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
              _currentInputFromFridge = text;
            });
          },
        ),
        GCWSubmitButton(
          onPressed: () {
            setState(() {
              //_currentRecipe = _adjustRecipe(_currentRecipe);
            });
          },
        ),
      ],
    );
  }

  Widget _buildOutput(BuildContext context) {

    Widget outputWidget;

    String language = 'ENG';
    if (_currentLanguage == GCWSwitchPosition.left) language = 'DEU';
    if (_currentMode == GCWSwitchPosition.right) {
      // generate chef
      if (_currentTitle.isEmpty) {
        _currentOutput =
            chefBuildOutputText(context, ['chef_error_structure_recipe', 'chef_error_structure_recipe_missing_title']);
      } else if (_currentOutput.isEmpty) {
        _currentOutput =
            chefBuildOutputText(context, ['chef_error_structure_recipe', 'chef_error_structure_recipe_missing_output']);
      } else {
        _currentOutput = generateChef(language, _currentTitle, _currentRemark, _currentTime, _currentTemperature,
            _currentOutput, _auxilaryRecipes);
      }
      outputWidget = GCWOutputText(
        text: _currentOutput.trim(),
        isMonotype: true,
      );
    } else {
      // interpret chef
      if (isValid(_currentInputFromFridge)) {
        try {
          _currentOutput = chefBuildOutputText(context, interpretChef(language, _currentRecipe, _currentInputFromFridge));
        } catch (e) {
          _currentOutput = chefBuildOutputText(context, [
            'common_programming_error_runtime',
            'chef_error_runtime_exception',
          ]);
        }
      } else {
        _currentOutput = chefBuildOutputText(context, ['common_programming_error_runtime', 'chef_error_runtime_invalid_input']);
      }
      outputWidget = Column(
        children: [
          GCWExpandableTextDivider(
            expanded: false,
            text: i18n(context, 'chef_recipe_adjusted'),
            child: GCWOutputText(
              text: _currentRecipe,
              isMonotype: true,
            ),
          ),
          GCWOutputText(
            text: _currentOutput.trim(),
            isMonotype: true,
          ),
        ],
      );
    }

    return Column(
      children: [
        GCWTextDivider(text: i18n(context, 'common_programming_hint_output')),
        outputWidget,
      ],
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

String _adjustRecipe(String readRecipe){

  // remove blank lines at start and trim lines
  List<String> recipe = readRecipe.split('\n');
  while (recipe[0].isEmpty) {
    for (int i = 1; i < recipe.length; i++) {
      recipe[i - 1] = recipe[i].trim();
    }
  }

  // remove blank lines at end
  while (recipe[recipe.length - 1].isEmpty) {
    recipe.removeAt(recipe.length - 1);
  }

  // trim lines
  for (int i = 0; i < recipe.length; i++) {
    recipe[i] = recipe[i].trim();
    // add dot at end of line where necessary
    if (recipe[i].isNotEmpty && !recipe[i].endsWith('.') && !recipe[i].endsWith(':')) {
      recipe[i] = recipe[i] + '.';
    }
  }
  readRecipe = recipe.join('\n');

  // check and add missing title if necessary
  if (readRecipe.startsWith('ingredients') || readRecipe.startsWith('zutaten')) {
    readRecipe = 'nouvelle cuisine.\n\n' + readRecipe;
  }

  // check and repair recipe regarding blank lines, whitespace
  recipe = readRecipe.split('\n');

  // remove blank lines inside sections ingredients, methods
  bool ingredientSection = false;
  bool methodSection = false;
  bool auxRecipe = false;

  for (int i = 0; i < recipe.length - 1; i++) {
    if (recipe[i].startsWith("ingredients") || recipe[i].startsWith("zutaten")) ingredientSection = true;

    if (recipe[i].startsWith("cooking time") ||
        recipe[i].startsWith("garzeit") ||
        recipe[i].startsWith("pre-heat oven") ||
        recipe[i].startsWith("pre heat oven") ||
        recipe[i].startsWith("ofen auf") ||
        recipe[i].startsWith("method") ||
        recipe[i].startsWith("zubereitung")) {
      ingredientSection = false;
    }

    if (recipe[i].startsWith("method") || recipe[i].startsWith("zubereitung")) methodSection = true;

    if (recipe[i].startsWith("serves") || recipe[i].startsWith("portionen")) {
      methodSection = false;
      auxRecipe = true;
    }

    if ((recipe[i].isEmpty || recipe[i] == '\n') && ingredientSection) {
      if (recipe[i + 1].startsWith('method') ||
          recipe[i + 1].startsWith('zubereitung') ||
          recipe[i + 1].startsWith("cooking time") ||
          recipe[i + 1].startsWith("garzeit") ||
          recipe[i + 1].startsWith("pre-heat oven") ||
          recipe[i + 1].startsWith("pre heat oven") ||
          recipe[i + 1].startsWith("ofen auf") ||
          recipe[i + 1].startsWith("serves") ||
          recipe[i + 1].startsWith("portionen")) {
      } else {
        recipe.removeAt(i);
      }
    }

    if ((recipe[i] == '' || recipe[i] == '\n') && methodSection) {
      if (recipe[i + 1].startsWith('method') ||
          recipe[i + 1].startsWith('zubereitung') ||
          recipe[i + 1].startsWith("cooking time") ||
          recipe[i + 1].startsWith("garzeit") ||
          recipe[i + 1].startsWith("pre-heat oven") ||
          recipe[i + 1].startsWith("pre heat oven") ||
          recipe[i + 1].startsWith("ofen auf") ||
          recipe[i + 1].startsWith("serves") ||
          recipe[i + 1].startsWith("portionen") ||
          _isMethod(recipe[i + 1])) {
      } else {
        if (!auxRecipe) recipe.removeAt(i);
      }
    }
  }
  recipe = recipe.join('\n').split('\n');

  // add blank lines to build the necessary sections
  String s0 = recipe[0];
  for (int i = 1; i < recipe.length; i++) {
    if (recipe[i].startsWith("ingredients") ||
        recipe[i].startsWith("zutaten") ||
        recipe[i].startsWith("cooking time") ||
        recipe[i].startsWith("garzeit") ||
        recipe[i].startsWith("pre-heat oven") ||
        recipe[i].startsWith("pre heat oven") ||
        recipe[i].startsWith("ofen auf") ||
        recipe[i].startsWith("method") ||
        recipe[i].startsWith("zubereitung") ||
        recipe[i].startsWith("serves") ||
        recipe[i].startsWith("portionen")) {
      if (s0.isNotEmpty) {
        recipe[i] = '\n' + recipe[i];
      }
    }
    s0 = recipe[i];
  }

  // remove unnecessary sections like cooking time and oven temperature
  int endIngredientSection = 0;
  methodSection = false;
  for (int i = 1; i < recipe.length; i++) {
    if (recipe[i].startsWith("ingredients") ||
        recipe[i].startsWith("zutaten")) {
      ingredientSection = true;
    }
    if (ingredientSection && recipe[i].isEmpty) {
      endIngredientSection = i;
      ingredientSection = false;
    }
    if (recipe[i].startsWith("method") ||
        recipe[i].startsWith("zubereitung")) {
    }
  }

  int i = endIngredientSection + 1;
  while (!methodSection) {
    if (recipe[i].startsWith("method") ||
        recipe[i].startsWith("zubereitung")) {
      methodSection = true;
    } else {
      recipe.removeAt(i);
    }
  }

  // handle ' und '
  readRecipe = recipe.join('\n');
  readRecipe = readRecipe.replaceAll(' und ', '. ').replaceAll(RegExp(r'\n(\n)+'), '\n\n');

  return readRecipe;
}
