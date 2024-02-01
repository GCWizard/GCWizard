import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/pokemon/logic/pokemon.dart';
import 'package:gc_wizard/utils/constants.dart';

const MDT_INTERNALNAMES_POKEMON = 'pokemon_code_title';

class MultiDecoderToolPokemon extends AbstractMultiDecoderTool {
  MultiDecoderToolPokemon({Key? key, required int id, required String name, required Map<String, Object?> options})
      : super(
            key: key,
            id: id,
            name: name,
            internalToolName: MDT_INTERNALNAMES_POKEMON,
            onDecode: (String input, String key) {
              var output = decodePokemon(input);
              var _output = output.replaceAll(UNKNOWN_ELEMENT, '');
              return _output.trim().isEmpty ? null : output;
            },
            options: options);
  @override
  State<StatefulWidget> createState() => _MultiDecoderToolPokemonState();
}

class _MultiDecoderToolPokemonState extends State<MultiDecoderToolPokemon> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
