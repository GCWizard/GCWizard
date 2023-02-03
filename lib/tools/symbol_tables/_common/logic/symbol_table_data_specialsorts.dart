import 'package:gc_wizard/tools/symbol_tables/_common/logic/symbol_table_data.dart';

int specialSortNoteNames(Map<String, SymbolData> a, Map<String, SymbolData> b) {
  var keyA = filenameWithoutSuffix(a.values.first.path); // get filename from path without suffix
  var keyB = filenameWithoutSuffix(b.values.first.path);

  var aSplit = keyA.split('_');
  var aMain = int.tryParse(aSplit[0]);
  var aSign = '';
  if (aSplit.length > 1) aSign = aSplit[1];

  var bSplit = keyB.split('_');
  var bMain = int.tryParse(bSplit[0]);
  var bSign = '';
  if (bSplit.length > 1) bSign = bSplit[1];

  var compareSign = aSign.compareTo(bSign);
  if (compareSign != 0) return compareSign;

  return aMain.compareTo(bMain);
}

int specialSortNoteValues(Map<String, SymbolData> a, Map<String, SymbolData> b) {
  var keyA = filenameWithoutSuffix(a.values.first.path); // get filename from path without suffix
  var keyB = filenameWithoutSuffix(b.values.first.path);

  var aSplit = keyA.replaceAll(RegExp(r'(^_*|_*$)'), '').split('_');
  var aDotted = int.tryParse(aSplit[0]);
  var aValue = int.tryParse(aSplit[1]);

  var bSplit = keyB.replaceAll(RegExp(r'(^_*|_*$)'), '').split('_');
  var bDotted = int.tryParse(bSplit[0]);
  var bValue = int.tryParse(bSplit[1]);

  var compareDotted = aDotted.compareTo(bDotted);
  if (compareDotted != 0) return compareDotted;

  return bValue.compareTo(aValue);
}

int specialSortTrafficSignsGermany(Map<String, SymbolData> a, Map<String, SymbolData> b) {
  var keyA = a.keys.first;
  var keyB = b.keys.first;

  var aSplitDash = keyA.split('-').toList();
  var bSplitDash = keyB.split('-').toList();
  var aSplitDot = aSplitDash[0].split('.').toList();
  var bSplitDot = bSplitDash[0].split('.').toList();

  var aMain = int.tryParse(aSplitDot[0]);
  var aDot = 0;
  if (aSplitDot.length > 1) aDot = int.tryParse(aSplitDot[1]);
  var aDash = 0;
  if (aSplitDash.length > 1) aDash = int.tryParse(aSplitDash[1]);

  var bMain = int.tryParse(bSplitDot[0]);
  var bDot = 0;
  if (bSplitDot.length > 1) bDot = int.tryParse(bSplitDot[1]);
  var bDash = 0;
  if (bSplitDash.length > 1) bDash = int.tryParse(bSplitDash[1]);

  var compareMain = aMain.compareTo(bMain);
  if (compareMain != 0) return compareMain;

  var compareDot = aDot.compareTo(bDot);
  if (compareDot != 0) return compareDot;

  var compareDash = aDash.compareTo(bDash);
  if (compareDash != 0) return compareDash;

  return 0;
}
