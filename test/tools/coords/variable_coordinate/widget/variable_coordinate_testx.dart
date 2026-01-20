// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:gc_wizard/common_widgets/key_value_editor/gcw_key_value_editor.dart';
// import 'package:gc_wizard/tools/coords/variable_coordinate/widget/variable_coordinate.dart';
// import 'package:gc_wizard/tools/coords/variable_coordinate/persistence/model.dart';
//
// // root path not available
// import '../../../../_test_utils/test_widget_utils.dart';
//
//
// void main() {
//   testWidgets('VarCoords: New entry value; can enter a complex interpolation string', (WidgetTester tester) async {
//     await tester.pumpWidget(MaterialApp(home: VariableCoordinate(formula: VariableCoordinateFormula('A'))));
//     final newVariableValueInput = find.byKey(const Key('gcwtextfield_keyvalueinput_newentry_value'));
//
//     expect(newVariableValueInput, findsOneWidget);
//
//     var input = '1, 23-12 #  4,7 -8#10';
//     var _testInput = '';
//     for (int i = 0; i < input.length; i++) {
//       _testInput += input[i];
//
//       await tester.enterText(newVariableValueInput, _testInput);
//       await tester.pump();
//       expect(find.text(_testInput), findsOneWidget);
//     }
//   });
//
//   //TODO
//   testWidgets('VarCoords: New entry value; invalid string yields alertdialog on adding', (WidgetTester tester) async {
//     await tester.pumpWidget(createTestWidget(VariableCoordinate(formula: VariableCoordinateFormula('A'))));
//
//     final newVariableValueInput = find.byKey(const Key('gcwtextfield_keyvalueinput_newentry_value'));
//     final newVariableKeyInput = find.byKey(const Key('gcwtextfield_keyvalueinput_newentry_key'));
//     final newVariableAddButton = find.byKey(const Key('gcwiconbutton_keyvalueinput_newentry_add'));
//
//     expect(newVariableAddButton, findsOneWidget);
//
//     expect(find.byType(AlertDialog), findsNothing);
//     expect(find.byType(GCWKeyValueItem), findsNothing);
//
//     // // valid case
//     var inputKey = 'A';
//     var inputValue = '1, 23-12 #  4,7 -8#10';
//     await tester.enterText(newVariableKeyInput, inputKey);
//     await tester.enterText(newVariableValueInput, inputValue);
//     await tester.pumpAndSettle();
//     await tester.tap(newVariableAddButton);
//     await tester.pumpAndSettle();
//
//     expect(find.byType(AlertDialog), findsNothing);
//     expect(find.byType(GCWKeyValueItem), findsOneWidget);
//     expect(find.text(inputKey), findsOneWidget);
//     expect(find.text(inputValue), findsOneWidget);
//
//     // invalid case
//     // await tester.enterText(newVariableKeyInput, 'B');
//     // await tester.enterText(newVariableValueInput, inputValue + ',');
//     // await tester.pumpAndSettle();
//     // expect(find.text(inputValue + ','), findsOneWidget);
//     // // await tester.runAsync(() async {
//     //   await tester.tap(newVariableAddButton);
//     // // });
//     // await tester.pumpAndSettle();
//     // expect(find.byType(AlertDialog), findsOneWidget);
//   });
// }