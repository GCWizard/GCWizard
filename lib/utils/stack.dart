class Stack<E> {
  final _list = <E>[];

  /// push element in top of the stack.
  void push(E value) => _list.add(value);

  /// get the top of the stack and delete it.
  E pop() => _list.removeLast();

  /// get the top of the stack without deleting it.
  E top() {
    return _list.last;
  }

  /// get the top of the stack.
  E get peek => _list.last;

  bool get isEmpty => _list.isEmpty;
  bool get isNotEmpty => _list.isNotEmpty;

  /// Returns a list of T elements contained in the Stack
  List<E> toList() => _list.toList();

  /// get the length of the stack.
  int get length => _list.length;

  /// removes all elements from the stack
  void clear() {
    _list.clear();
  }

  @override
  String toString() => _list.toString();
}