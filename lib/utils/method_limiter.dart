import 'dart:async';
import 'dart:collection';

class MethodLimiter {
  final int _maxConcurrentCalls;
  final Queue<Completer<void>> _waitingQueue = Queue();
  int _currentCalls = 0;

  MethodLimiter(this._maxConcurrentCalls);

  Future<void> callMethod(Future<void> Function() method) async {
    if (_currentCalls >= _maxConcurrentCalls) {
      final completer = Completer<void>();
      _waitingQueue.add(completer);
      await completer.future;
    }

    _currentCalls++;
    try {
      await method();
    } finally {
      _currentCalls--;
      _processNext();
    }
  }

  void _processNext() {
    if (_waitingQueue.isNotEmpty) {
      final nextCompleter = _waitingQueue.removeFirst();
      nextCompleter.complete();
    }
  }
}
