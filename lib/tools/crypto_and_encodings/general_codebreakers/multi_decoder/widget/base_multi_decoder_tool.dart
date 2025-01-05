part of 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';

abstract class AbstractMultiDecoderTool extends StatefulWidget {
  final int id;
  String name;
  final String internalToolName;
  final Object? Function(String, String) onDecode;
  final bool requiresKey;
  final bool optionalKey;
  late final Map<String, Object?> options;

  AbstractMultiDecoderTool(
      {Key? key,
      required this.id,
      required this.name,
      required this.internalToolName,
      required this.onDecode,
      this.requiresKey = false,
      this.optionalKey = false,
      required this.options})
      : super(key: key);
}

class MultiDecoderToolDummy extends AbstractMultiDecoderTool {
  MultiDecoderToolDummy()
      : super(
            key: null,
            id: -1,
            name: '',
            internalToolName: '',
            onDecode: (String input, String key) {
              return null;
            },
            options: {});

  @override
  State<StatefulWidget> createState() => _MultiDecoderToolDummyState();
}

class _MultiDecoderToolDummyState extends State<MultiDecoderToolDummy> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

String? stringNullableTypeCheck(Object? value, String? defaultValue) {
  return (isString(value) || value == null) ? value as String? : defaultValue;
}
