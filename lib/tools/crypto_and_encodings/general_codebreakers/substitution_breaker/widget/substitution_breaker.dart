import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/navigation/no_animation_material_page_route.dart';
import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer.dart';
import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer_parameters.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_button.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/gcw_snackbar.dart';
import 'package:gc_wizard/application/tools/widget/gcw_tool.dart';
import 'package:gc_wizard/common_widgets/gcw_web_statefulwidget.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_multiple_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output_text.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/substitution_breaker/logic/substitution_breaker.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/substitution_breaker/logic/substitution_breaker_enums.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/substitution_breaker/logic/substitution_breaker_result.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/substitution_breaker/logic/substitution_logic_aggregator.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/substitution_breaker/widget/quadgram_loader.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/substitution_breaker/widget/substitution_breaker_items.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/substitution/widget/substitution.dart';

const String _apiSpecification = '''
{
  "/substitutionbreaker" : {
    "alternative_paths": ["substitution_breaker", "substbreaker", "substbreak", "subst_breaker", "subst_break"],
    "get": {
      "summary": "Substitution Breaker Tool",
      "responses": {
        "204": {
          "description": "Tool loaded. No response data."
        }
      },
      "parameters" : [
        {
          "in": "query",
          "name": "input",
          "required": true,
          "description": "Input data",
          "schema": {
            "type": "string"
          }
        },
        {
          "in": "query",
          "name": "lang",
          "description": "Defines language to break",
          "schema": {
            "type": "string",
            "enum": [
              "de", "en", "nl", "es", "pl", "gr", "el", "fr", "ru"
            ],
            "default": "en"
          }
        }
      ]
    }
  }
}
''';

class SubstitutionBreaker extends GCWWebStatefulWidget {
  SubstitutionBreaker({Key? key}) : super(key: key, apiSpecification: _apiSpecification);

  @override
  _SubstitutionBreakerState createState() => _SubstitutionBreakerState();
}

class _SubstitutionBreakerState extends State<SubstitutionBreaker> {
  late TextEditingController _controller;

  String _currentInput = '';
  SubstitutionBreakerAlphabet _currentAlphabet = SubstitutionBreakerAlphabet.GERMAN;
  SubstitutionBreakerResult? _currentOutput;

  final _quadgrams = <SubstitutionBreakerAlphabet, Quadgrams>{};
  final _isLoading = <bool>[false];

  @override
  void initState() {
    super.initState();

    if (widget.hasWebParameter()) {
      _currentInput = widget.getWebParameter('input') ?? _currentInput;

      var lang = widget.getWebParameter('lang') ?? 'en';
      switch (lang.toLowerCase()) {
        case 'de':
          _currentAlphabet = SubstitutionBreakerAlphabet.GERMAN;
          break;
        case 'en':
          _currentAlphabet = SubstitutionBreakerAlphabet.ENGLISH;
          break;
        case 'nl':
          _currentAlphabet = SubstitutionBreakerAlphabet.DUTCH;
          break;
        case 'es':
          _currentAlphabet = SubstitutionBreakerAlphabet.SPANISH;
          break;
        case 'pl':
          _currentAlphabet = SubstitutionBreakerAlphabet.POLISH;
          break;
        case 'gr':
        case 'el':
          _currentAlphabet = SubstitutionBreakerAlphabet.GREEK;
          break;
        case 'fr':
          _currentAlphabet = SubstitutionBreakerAlphabet.FRENCH;
          break;
        case 'ru':
          _currentAlphabet = SubstitutionBreakerAlphabet.RUSSIAN;
          break;
        default:
          _currentAlphabet = SubstitutionBreakerAlphabet.ENGLISH;
          break;
      }

      widget.webParameter = null;
    }

    loadQuadgramsAssets(_currentAlphabet, context, _quadgrams, _isLoading);

    _controller = TextEditingController(text: _currentInput);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTextField(
          controller: _controller,
          onChanged: (text) {
            setState(() {
              _currentInput = text;
            });
          },
        ),
        GCWTextDivider(text: i18n(context, 'common_alphabet')),
        GCWDropDown<SubstitutionBreakerAlphabet>(
          value: _currentAlphabet,
          onChanged: (value) {
            setState(() {
              _currentAlphabet = value;
            });
          },
          items: SubstitutionBreakerAlphabetItems(context).entries.map((alphabet) {
            return GCWDropDownMenuItem(
              value: alphabet.key,
              child: alphabet.value,
            );
          }).toList(),
        ),
        _buildSubmitButton(),
        _buildOutput(context),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return GCWSubmitButton(onPressed: () async {
      await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Center(
            child: SizedBox(
              height: GCW_ASYNC_EXECUTER_INDICATOR_HEIGHT,
              width: GCW_ASYNC_EXECUTER_INDICATOR_WIDTH,
              child: GCWAsyncExecuter<SubstitutionBreakerResult?>(
                isolatedFunction: break_cipherAsync,
                parameter: _buildJobData,
                onReady: (data) => _showOutput(data),
                isOverlay: true,
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildOutput(BuildContext context) {
    if (_currentInput.isEmpty) return const GCWDefaultOutput();

    if (_currentOutput == null) return const GCWDefaultOutput();

    if (_currentOutput!.errorCode != SubstitutionBreakerErrorCode.OK) {
      showSnackBar(i18n(context, 'substitutionbreaker_error', parameters: [_currentOutput!.errorCode]), context);
      return const GCWDefaultOutput();
    }

    return GCWMultipleOutput(
      children: [
        _currentOutput!.plaintext,
        Column(
          children: [
            GCWOutput(
              title: i18n(context, 'common_key'),
              child: GCWOutputText(
                text: _currentOutput!.alphabet.toUpperCase() + '\n' + _currentOutput!.key.toUpperCase(),
                isMonotype: true,
              ),
            ),
            GCWButton(
              text: i18n(context, 'substitutionbreaker_exporttosubstition'),
              onPressed: () {
                Map<String, String> substitutions = {};
                for (int i = 0; i < _currentOutput!.alphabet.length; i++) {
                  substitutions.putIfAbsent(
                      _currentOutput!.key[i].toUpperCase(), () => _currentOutput!.alphabet[i].toUpperCase());
                }

                Navigator.push(
                    context,
                    NoAnimationMaterialPageRoute<GCWTool>(
                        builder: (context) => GCWTool(
                            tool: Substitution(input: _currentOutput!.ciphertext, substitutions: substitutions),
                            id: 'substitution')));
              },
            )
          ],
        )
      ],
    );
  }

  Future<GCWAsyncExecuterParameters?> _buildJobData() async {
    _currentOutput = null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
    if (_currentInput.isEmpty) return null;

    var quadgram = await loadQuadgramsAssets(_currentAlphabet, context, _quadgrams, _isLoading);

    return GCWAsyncExecuterParameters(SubstitutionBreakerJobData(input: _currentInput, quadgrams: quadgram));
  }

  void _showOutput(SubstitutionBreakerResult? output) {
    if (output == null) {
      _currentOutput = null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
      return;
    }

    _currentOutput = output;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }
}
