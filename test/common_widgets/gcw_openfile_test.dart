import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer_parameters.dart';
import 'package:gc_wizard/common_widgets/gcw_openfile.dart';

void main() {
  group("_GCWOoenFile.downloadFileAsync:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'url' : 'https://s3.amazonaws.com/gs-geo-images/cab6d299-7f28-4791-9df3-d904e46e7d5e.jpg', 'expectedOutput' : 17723},
      {'url' : 'https://img.geocaching.com/cab6d299-7f28-4791-9df3-d904e46e7d5e.jpg', 'expectedOutput' : 17723},
      {'url' : 'img.geocaching.com/cab6d299-7f28-4791-9df3-d904e46e7d5e.jpg', 'expectedOutput' : 17723},
      {'url' : 'http://up.picr.de/18592631jk.gif', 'expectedOutput' : 1046925},
    ];
    for (var elem in _inputsToExpected) {
      test('url: ${elem['url']}', () async {
        var jobData = GCWAsyncExecuterParameters(await getAndValidateUri(elem['url'] as String));
        var _actual = await downloadFileAsync(jobData);

        expect(_actual!.value.length, elem['expectedOutput'] as int);
      });
    }
  });
}