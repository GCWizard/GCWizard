import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/pokemon/logic/pokemon.dart';

const MDT_INTERNALNAMES_POKEMON = 'pokemon_code_title';

class MultiDecoderToolPokemon extends AbstractMultiDecoderTool {
  MultiDecoderToolPokemon({
    Key? key,
    required int id,
    required String name,
    required Map<String, Object?> options})
      : super(
            key: key,
            id: id,
            name: name,
            internalToolName: MDT_INTERNALNAMES_POKEMON,
            onDecode: (String input, String key) {
              var output = decodePokemon(input);
              return output.isEmpty || output == '<?>' ? null : output;
            },
            options: options);
}
