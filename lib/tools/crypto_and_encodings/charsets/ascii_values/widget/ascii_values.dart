import 'package:gc_wizard/tools/crypto_and_encodings/charsets/ascii_values/logic/ascii_values.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/charsets/general_charset_values/widget/general_charset_values.dart';

class ASCIIValues extends GeneralCharsetValues {
  const ASCIIValues({super.key})
      : super(charsetName: 'asciivalues_name', encode: asciiEncode, decode: asciiDecode);
}
