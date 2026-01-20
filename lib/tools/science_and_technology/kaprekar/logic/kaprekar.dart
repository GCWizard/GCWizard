class KaprekarRoutine{
  final int count;
  final List<List<String>> numbers;

  KaprekarRoutine({required this.count, required this.numbers});
}

KaprekarRoutine kaprekarsRoutine(int number){
  int count = 0;
  String currentNumber = number.toString().padLeft(4, '0');
  List<List<String>> numbers = [];
  while (number != 6174) {
    count++;
    number = kaprekarsRoutineStep(currentNumber);
    currentNumber = number.toString().padLeft(4, '0');
    numbers.add([currentNumber]);
  }
  return KaprekarRoutine(count: count, numbers: numbers);
}

int kaprekarsRoutineStep(String number){
  List<String> numberDesc = number.split('');
  List<String> numberAsc = number.split('');

  numberAsc.sort();
  numberDesc.sort();
  numberDesc = numberDesc.reversed.toList();
  return int.parse(numberDesc.join('')) - int.parse(numberAsc.join(''));
}