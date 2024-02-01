import 'dart:isolate';

const PROGRESS = 'progress';

class GCWAsyncExecuterParameters {
  SendPort? sendAsyncPort;
  final Object? parameters;

  GCWAsyncExecuterParameters(this.parameters);
}
