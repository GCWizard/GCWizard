

List<List<List<String>>>decodeID3String(String dataString){



  List<String> data = dataString.split('\n');
  for (int i = 0; i < data.length; i++) {
    if (data[i].contains('Header')) {

    }
    else if (data[i].contains('Frames')) {

    }
    else if (data[i].contains('Padding')) {

    }
    else {

    }
  }

  return [_tableTagsHeader, _tableTagsFrames, _tableTagsPadding, _tableTagsMisc];
}