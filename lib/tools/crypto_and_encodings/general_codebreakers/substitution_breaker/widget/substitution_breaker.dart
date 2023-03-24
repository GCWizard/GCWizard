import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/application/navigation/no_animation_material_page_route.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_button.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer.dart';
import 'package:gc_wizard/common_widgets/gcw_toast.dart';
import 'package:gc_wizard/common_widgets/gcw_tool.dart';
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
import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer_parameters.dart';

class SubstitutionBreaker extends StatefulWidget {
  const SubstitutionBreaker({Key? key}) : super(key: key);

  @override
  SubstitutionBreakerState createState() => SubstitutionBreakerState();
}

class SubstitutionBreakerState extends State<SubstitutionBreaker> {
  String _currentInput = '';
  SubstitutionBreakerAlphabet _currentAlphabet = SubstitutionBreakerAlphabet.GERMAN;
  SubstitutionBreakerResult? _currentOutput;

  final _quadgrams = <SubstitutionBreakerAlphabet, Quadgrams>{};
  final _isLoading = <bool>[false];

  @override
  void initState() {
    super.initState();

    loadQuadgramsAssets(_currentAlphabet, context, _quadgrams, _isLoading);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTextField(
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
              height: 220,
              width: 150,
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
      showToast(i18n(context, 'substitutionbreaker_error', parameters: [_currentOutput!.errorCode]));
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
