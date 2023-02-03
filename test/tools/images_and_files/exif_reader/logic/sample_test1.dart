import "package:flutter_test/flutter_test.dart";

import 'samples_run.dart';
import 'test_util.dart';

main() async {
  for (FileSample sample in readSampleTest1()) {
    test(sample.file.path, () async {
      await runSamplesTestGps(sample.file, sample.expectedLatitude, sample.expectedLongitude);
    });
  }
}
