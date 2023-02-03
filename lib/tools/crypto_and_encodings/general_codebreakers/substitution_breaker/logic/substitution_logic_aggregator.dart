import 'dart:io';
import 'dart:math';

import 'package:gc_wizard/tools/crypto_and_encodings/substitution/logic/substitution.dart';
import 'package:gc_wizard/utils/file_utils/file_utils.dart';
import 'package:path/path.dart';
import 'package:tuple/tuple.dart';

part 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/substitution_breaker/logic/external_libs/guballa/breaker.dart';
part 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/substitution_breaker/logic/external_libs/guballa/generate_quadgrams.dart';
part 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/substitution_breaker/logic/external_libs/guballa/key.dart';
part 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/substitution_breaker/logic/external_libs/guballa/quadgrams.dart';
part 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/substitution_breaker/logic/quadgrams/dutch_quadgrams.dart';
part 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/substitution_breaker/logic/quadgrams/english_quadgrams.dart';
part 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/substitution_breaker/logic/quadgrams/french_quadgrams.dart';
part 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/substitution_breaker/logic/quadgrams/generator/generate_quadgrams.dart';
part 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/substitution_breaker/logic/quadgrams/german_quadgrams.dart';
part 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/substitution_breaker/logic/quadgrams/greek_quadgrams.dart';
part 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/substitution_breaker/logic/quadgrams/polish_quadgrams.dart';
part 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/substitution_breaker/logic/quadgrams/quadgrams.dart';
part 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/substitution_breaker/logic/quadgrams/russian_quadgrams.dart';
part 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/substitution_breaker/logic/quadgrams/spanish_quadgrams.dart';