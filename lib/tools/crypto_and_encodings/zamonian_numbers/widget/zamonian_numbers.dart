import 'package:gc_wizard/tools/crypto_and_encodings/zamonian_numbers/logic/zamonian_numbers.dart';
import 'package:gc_wizard/tools/symbol_tables/_common/widget/symbol_table.dart';

class ZamonianNumbers extends SymbolTable {
  ZamonianNumbers({super.key})
      : super(
            symbolKey: 'zamonian',
            onDecrypt: (input) => decodeZamonian(input),
            onEncrypt: (input) => encodeZamonian(input),
            alwaysIgnoreUnknown: true);
}
