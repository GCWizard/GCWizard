import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/miscellaneous/gcwizardscript/logic/gcwizard_script.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

part 'gcwizard_script_codes.dart';
part 'gcwizard_script_const.dart';
part 'gcwizard_script_functions_codes_base.dart';
part 'gcwizard_script_functions_codes_crypto.dart';
part 'gcwizard_script_functions_codes_hash.dart';
part 'gcwizard_script_functions_coordinates.dart';
part 'gcwizard_script_functions_datetime.dart';
part 'gcwizard_script_functions_geocaching.dart';
part 'gcwizard_script_functions_graphic.dart';
part 'gcwizard_script_functions_math.dart';
part 'gcwizard_script_functions_math_nested.dart';
part 'gcwizard_script_functions_string.dart';
part 'gcwizard_script_functions_waypoints.dart';
part 'gcwizard_script_functions_files.dart';
part 'gcwizard_script_commands_loops.dart';
part 'gcwizard_script_commands_nested_loops.dart';
part 'gcwizard_script_commands_print.dart';
part 'gcwizard_script_commands_if.dart';
part 'gcwizard_script_commands_nested_loop_if.dart';
part 'gcwizard_script_commands_nested_loop_case.dart';

void main() {
  group("gcwizard_script.interpretScript:", () {
    List<Map<String, Object?>> _inputsToExpected = [];

   // _inputsToExpected.addAll(_inputsCodesToExpected); // take a lot of time! passed 05.05.2024
   // _inputsToExpected.addAll(_inputsMathToExpected);  // passed 20.07.2024
   // _inputsToExpected.addAll(_inputsBaseToExpected);  // passed 05.05.2024
   // _inputsToExpected.addAll(_inputsLoopsToExpected); // passed 05.05.2024
   // _inputsToExpected.addAll(_inputsHashToExpected);  // passed 05.05.2024
   // _inputsToExpected.addAll(_inputsCryptoToExpected); // passed 05.05.2024
   // _inputsToExpected.addAll(_inputsGeocachingToExpected); // passed 05.05.2024
   // _inputsToExpected.addAll(_inputsDateTimeToExpected); // passed 05.05.2024
    _inputsToExpected.addAll(_inputsStringToExpected); // passed 05.05.2024
/*
    _inputsToExpected.addAll(_inputsGraphicToExpected);
*/
   // _inputsToExpected.addAll(_inputsWaypoinsToExpected); // passed 05.05.2024
   // _inputsToExpected.addAll(_inputsFilesToExpected);
   // _inputsToExpected.addAll(_inputsMathNestedFunctionsToExpected); // passed 05.05.2024
   // _inputsToExpected.addAll(_inputsNestedLoopsToExpected); // passed 05.05.2024
   // _inputsToExpected.addAll(_inputsConstToExpected); // passed 05.05.2024
   // _inputsToExpected.addAll(_inputsCoordinatesToExpected); // passed 05.05.2024
   // _inputsToExpected.addAll(_inputsCommandsPRINTToExpected); // passed 22.05.2024
   // _inputsToExpected.addAll(_inputsCommandsIFToExpected); // passed 20.07.2024
   // _inputsToExpected.addAll(_inputsCommandsFORIFToExpected); // passed 20.07.2024
   // _inputsToExpected.addAll(_inputsCommandsFORCASEToExpected); // passed 20.07.2024


    for (var elem in _inputsToExpected) {
      test('code: ${elem['code']}, input: ${elem['input']}', () async {
        var _actual = await GCWizardScriptInterpretScript(elem['code'] as String, (elem['input'] as String?) ?? '', const LatLng(0.0, 0.0), null);

        expect(_actual.STDOUT, (elem['expectedOutput'] as String));
        expect(_actual.ErrorMessage, elem['error'] ?? '');
      });
    }
  });
}