import 'dart:isolate';

class GCWAsyncExecuterParameters {
  SendPort? sendAsyncPort;
  final Object? parameters;

  GCWAsyncExecuterParameters(this.parameters);
}