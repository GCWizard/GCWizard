import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/utils/method_limiter.dart';

Future<void> main() async {

  group("MethodLimiter.callMethod:", () {
    var result = '';
    Future<void> _doWork(int index) async {
      result += (' s' + index.toString());

      await Future.delayed(Duration(milliseconds: 10 + index % 1), () =>
        result += (' f' + index.toString()));
    }

    List<Map<String, Object?>> _inputsToExpected = [
      {'count' : 10, 'parallel': 2, 'expectedOutput' : ' s0 s1 f0 f1 s2 s3 f2 f3 s4 s5 f4 f5 s6 s7 f6 f7 s8 s9 f8 f9'},
      {'count' : 10, 'parallel': 3, 'expectedOutput' : ' s0 s1 s2 f0 f1 f2 s3 s4 s5 f3 f4 f5 s6 s7 s8 f6 f7 f8 s9 f9'},
      {'count' : 10, 'parallel': 4, 'expectedOutput' : ' s0 s1 s2 s3 f0 f1 f2 f3 s4 s5 s6 s7 f4 f5 f6 f7 s8 s9 f8 f9'},

    ];

    for (var elem in _inputsToExpected) {
      test('count: ${elem['count']}, parallel: ${elem['parallel']}', () async {
        var limiter = MethodLimiter((elem['parallel'] as int));

        result = '';
        for (var i = 0; i < (elem['count'] as int); i++) {
          limiter.callMethod(() => _doWork(i));
        }

        await Future<String>.delayed(Duration(milliseconds: (elem['count'] as int) * 10), () => result);
        expect(result, elem['expectedOutput']);
      });
    }
  });



}