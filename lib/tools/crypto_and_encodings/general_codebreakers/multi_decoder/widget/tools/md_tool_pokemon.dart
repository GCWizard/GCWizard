import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/pokemon/logic/pokemon.dart';
import 'package:gc_wizard/utils/constants.dart';

const MDT_INTERNALNAMES_POKEMON = 'pokemon_code_title';

class MultiDecoderToolPokemon extends AbstractMultiDecoderTool {
  MultiDecoderToolPokemon({super.key, required super.id, required super.name, required super.options})
      : super(
            internalToolName: MDT_INTERNALNAMES_POKEMON,
            onDecode: (String input, String key) {
              var output = decodePokemon(input);
              var _output = output.replaceAll(UNKNOWN_ELEMENT, '');
              return _output.trim().isEmpty ? null : output;
            });
  @override
  State<StatefulWidget> createState() => _MultiDecoderToolPokemonState();
}

class _MultiDecoderToolPokemonState extends State<MultiDecoderToolPokemon> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
