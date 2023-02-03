import 'package:gc_wizard/tools/science_and_technology/numeral_bases/logic/numeral_bases.dart';
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/_common/logic/teletypewriter.dart';

List<String> decenary2segments(String decenary, bool order12345, TeletypewriterCodebook language) {
  // 0 ... 31 => 00000 ... 11111
  String binary = convertBase(decenary, 10, 2).padLeft(BINARY_LENGTH[language], '0');
  List<String> result = [];
  if (!order12345) {
    binary = binary.split('').reversed.join('');
  }

  if (REVERSE_CODEBOOK.contains(language)) {
    binary = binary.split('').reversed.join('');
  }
  for (int i = 0; i < binary.length; i++) if (binary[i] == '1') result.add((i + 1).toString());
  return result;
}

List<String> binary2segments(String binary, TeletypewriterCodebook language) {
  // 00000 ... 11111 => [1,2,3,4,5]
  binary = binary.padLeft(BINARY_LENGTH[language], '0');

  List<String> result = [];

  for (int i = 0; i < binary.length; i++) if (binary[i] == '1') result.add((i + 1).toString());
  return result;
}

String segments2binary(List<String> segments2convert, TeletypewriterCodebook language, bool order12345) {
  // [1,2,3,4,5] => 00000 ... 11111
  List<String> segments = [];
  if (order12345) {
    segments.addAll(segments2convert);
  } else {
    switch (BINARY_LENGTH[language]) {
      case 5:
        if (segments2convert.contains('1')) segments.add('5');
        if (segments2convert.contains('2')) segments.add('4');
        if (segments2convert.contains('3')) segments.add('3');
        if (segments2convert.contains('4')) segments.add('2');
        if (segments2convert.contains('5')) segments.add('1');
        break;
      case 6:
        if (segments2convert.contains('1')) segments.add('6');
        if (segments2convert.contains('2')) segments.add('5');
        if (segments2convert.contains('3')) segments.add('4');
        if (segments2convert.contains('4')) segments.add('3');
        if (segments2convert.contains('5')) segments.add('2');
        if (segments2convert.contains('6')) segments.add('1');
        break;
      case 7:
        if (segments2convert.contains('1')) segments.add('7');
        if (segments2convert.contains('2')) segments.add('6');
        if (segments2convert.contains('3')) segments.add('5');
        if (segments2convert.contains('4')) segments.add('4');
        if (segments2convert.contains('5')) segments.add('3');
        if (segments2convert.contains('6')) segments.add('2');
        if (segments2convert.contains('7')) segments.add('1');
        break;
      case 8:
        if (segments2convert.contains('1')) segments.add('8');
        if (segments2convert.contains('2')) segments.add('7');
        if (segments2convert.contains('3')) segments.add('6');
        if (segments2convert.contains('4')) segments.add('5');
        if (segments2convert.contains('5')) segments.add('4');
        if (segments2convert.contains('6')) segments.add('3');
        if (segments2convert.contains('7')) segments.add('2');
        if (segments2convert.contains('8')) segments.add('1');
        break;
    }
  }
  String result = '';
  if (segments.contains('1'))
    result = result + '1';
  else
    result = result + '0';

  if (segments.contains('2'))
    result = result + '1';
  else
    result = result + '0';

  if (segments.contains('3'))
    result = result + '1';
  else
    result = result + '0';

  if (segments.contains('4'))
    result = result + '1';
  else
    result = result + '0';

  if (segments.contains('5'))
    result = result + '1';
  else
    result = result + '0';

  if (BINARY_LENGTH[language] == 6) {
    if (segments.contains('6'))
      result = result + '1';
    else
      result = result + '0';
  }

  if (BINARY_LENGTH[language] == 7) {
    if (segments.contains('6'))
      result = result + '1';
    else
      result = result + '0';

    if (segments.contains('7'))
      result = result + '1';
    else
      result = result + '0';
  }

  if (BINARY_LENGTH[language] == 8) {
    if (segments.contains('6'))
      result = result + '1';
    else
      result = result + '0';

    if (segments.contains('7'))
      result = result + '1';
    else
      result = result + '0';

    if (segments.contains('8'))
      result = result + '1';
    else
      result = result + '0';
  }
  return result;
}

String segments2decenary(List<String> segments, bool order54321, TeletypewriterCodebook language) {
  // [1,2,3,4,5] => 0 ... 31
  String result = '';

  if (segments.contains('1'))
    result = result + '1';
  else
    result = result + '0';

  if (segments.contains('2'))
    result = result + '1';
  else
    result = result + '0';

  if (segments.contains('3'))
    result = result + '1';
  else
    result = result + '0';

  if (segments.contains('4'))
    result = result + '1';
  else
    result = result + '0';

  if (segments.contains('5'))
    result = result + '1';
  else
    result = result + '0';

  if (BINARY_LENGTH[language] == 6) {
    if (segments.contains('6'))
      result = result + '1';
    else
      result = result + '0';
  }

  if (BINARY_LENGTH[language] == 7) {
    if (segments.contains('6'))
      result = result + '1';
    else
      result = result + '0';

    if (segments.contains('7'))
      result = result + '1';
    else
      result = result + '0';
  }

  if (BINARY_LENGTH[language] == 8) {
    if (segments.contains('6'))
      result = result + '1';
    else
      result = result + '0';

    if (segments.contains('7'))
      result = result + '1';
    else
      result = result + '0';

    if (segments.contains('8'))
      result = result + '1';
    else
      result = result + '0';
  }

  if (order54321) result = result.split('').reversed.join('');
  return convertBase(result, 2, 10);
}

List<List<String>> encodePunchtape(String input, TeletypewriterCodebook language, bool order12345) {
  if (input == null) return [];

  List<List<String>> result = [];
  List<String> code = [];
  code = encodeTeletypewriter(input, language).split(' ');
  code.forEach((element) {
    if (int.tryParse(element) != null) result.add(decenary2segments(element, order12345, language));
  });
  return result;
}

Map<String, dynamic> decodeTextPunchtape(String inputs, TeletypewriterCodebook language, bool order12345) {
  if (inputs == null || inputs.length == 0)
    return {
      'displays': <List<String>>[],
      'text': '',
    };
  var displays = <List<String>>[];
  List<String> text = [];
  List<int> intList = List<int>(1);

  inputs.split(' ').forEach((element) {
    if (int.tryParse(convertBase(element, 2, 10)) != null) {
      intList[0] = int.parse(convertBase(element, 2, 10));
      text.add(decodeTeletypewriter(intList, language));
    }
    if (!order12345) element = element.split('').reversed.join('');

    displays.add(binary2segments(element, language));
  });
  return {'displays': displays, 'text': text.join('')};
}

Map<String, dynamic> decodeVisualPunchtape(List<String> inputs, TeletypewriterCodebook language, bool order12345) {
  if (inputs == null || inputs.length == 0) return {'displays': <List<String>>[], 'text': ''};

  var displays = <List<String>>[];

  List<String> text = inputs.where((input) => input != null).map((input) {
    var display = <String>[];

    input.split('').forEach((element) {
      display.add(element);
    });
    displays.add(display);
  }).toList();

  // convert list of displays to list of decimal using String segments2decenary(List<String> segments)
  List<int> intList = [];
  displays.forEach((element) {
    intList.add(int.parse(segments2decenary(element, order12345, language)));
  });

  // convert list of decimal to character using String decodeCCITT(List<int> values, TeletypewriterCodebook language)
  return {'displays': displays, 'text': decodeTeletypewriter(intList, language)};
}
