part of 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';

abstract class AbstractMultiDecoderTool {
  final int id;
  String name;
  final String internalToolName;
  final Function onDecode;
  final MultiDecoderToolConfiguration configurationWidget;
  final bool requiresKey;
  final bool optionalKey;
  Map<String, dynamic> options = {};

  AbstractMultiDecoderTool(
      {Key key,
      this.id,
      this.name,
      this.internalToolName,
      this.onDecode,
      this.requiresKey: false,
      this.optionalKey: false,
      this.configurationWidget,
      this.options});
}
