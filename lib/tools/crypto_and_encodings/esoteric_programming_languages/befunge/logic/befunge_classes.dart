part of 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/befunge/logic/befunge.dart';

class BefungeOutput {
  String Output = '';
  String Error = '';
  String Iteration = '';
  String curPosX = '';
  String curPosY = '';
  List<String> BefungeStack;
  List<String> PC;
  List<String> Command;
  List<String> Mnemonic;

  BefungeOutput(
      {required this.Output,
      required this.Error,
      required this.Iteration,
      required this.curPosX,
      required this.curPosY,
      required this.BefungeStack,
      required this.PC,
      required this.Command,
      required this.Mnemonic});
}

class BefungeStack {
  List<BigInt> content;

  void push(BigInt element) {
    content.add(element);
  }

  BigInt pop() {
    if (isEmpty()) {
      return BigInt.zero;
    } else {
      BigInt element = content[content.length - 1];
      content.removeAt(content.length - 1);
      return element;
    }
  }

  bool isEmpty() {
    return (content.isEmpty);
  }

  @override
  String toString() {
    return content.join(' ');
  }

  BefungeStack(this.content);
}
