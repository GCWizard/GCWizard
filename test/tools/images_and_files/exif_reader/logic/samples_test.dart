import "package:flutter_test/flutter_test.dart";

import 'samples_run.dart';
import 'test_util.dart';

Future<void> main() async {
  for (var file in readSamples()) {
    test(file.path, () async {
      await runSamplesTest(file, file.path.contains('test4.jpg'));
    });
  }
}
