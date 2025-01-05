// ported and adjusted for Dart2+ from https://github.com/dartist/sudoku_solver
/**
    Copyright (c) 2013, Demis Bellot
    Copyright (c) 2013, Adam Singer
    Copyright (c) 2013, Matias Meno
    All rights reserved.

    Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 */

int _MAX_SOLUTIONS = 1000;
int _FOUND_SOLUTIONS = 0;

List<String> _cross(String A, String B) => A.split('').expand((a) => B.split('').map((b) => a + b)).toList();

const String _digits = '123456789';
const String _rows = 'ABCDEFGHI';
const String _cols = _digits;
final List<String> _squares = _cross(_rows, _cols);

final List<List<String>> _unitlist = _cols.split('').map((c) => _cross(_rows, c)).toList()
  ..addAll(_rows.split('').map((r) => _cross(r, _cols)))
  ..addAll(['ABC', 'DEF', 'GHI'].expand((rs) => ['123', '456', '789'].map((cs) => _cross(rs, cs))));

final Map<String, List<List<String>>> _units = _squares
    .map((s) => MapEntry<String, List<List<String>>>(s, _unitlist.where((u) => u.contains(s)).toList()))
    .fold(<String, List<List<String>>>{}, (map, kv) => map..putIfAbsent(kv.key, () => kv.value));

final Map<String, Set<String>> _peers = _squares
    .map((s) => MapEntry<String, Set<String>>(s, _units[s]!.expand((u) => u).toSet()..removeAll([s])))
    .fold(<String, Set<String>>{}, (map, kv) => map..putIfAbsent(kv.key, () => kv.value));

/// Parse a Grid
Map<String, String>? _parse_grid(List<List<int>> grid) {
  Map<String, String> values = _squares
      .map((String s) => <String>[s, _digits])
      .fold(<String, String>{}, (map, kv) => map..putIfAbsent(kv[0], () => kv[1]));
  var gridValues = _grid_values(grid);

  for (var s in gridValues.keys) {
    var d = gridValues[s]!;
    if (_digits.contains(d) && _assign(values, s, d) == null) return null;
  }

  return values;
}

Map<String, String> _grid_values(List<List<int>> grid) {
  Map<String, String> gridMap = {};
  for (int i = 0; i < 9; i++) {
    for (int j = 0; j < 9; j++) {
      gridMap.putIfAbsent(_rows[i] + _cols[j], () => grid[i][j].toString());
    }
  }

  return gridMap;
}

/// Constraint Propagation
Map<String, String>? _assign(Map<String, String> values, String s, String d) {
  var other_values = values[s]!.replaceAll(d, '');

  if (_all(other_values.split('').map((d2) => _eliminate(values, s, d2)))) return values;
  return null;
}

Map<String, String>? _eliminate(Map<String, String> values, String s, String d) {
  if (!values[s]!.contains(d)) return values;
  values[s] = values[s]!.replaceAll(d, '');
  if (values[s]!.isEmpty) {
    return null;
  } else if (values[s]!.length == 1) {
    var d2 = values[s]!;
    if (!_all(_peers[s]!.map((s2) => _eliminate(values, s2, d2)))) return null;
  }

  for (List<String> u in _units[s]!) {
    var dplaces = u.where((s) => values[s]!.contains(d));
    if (dplaces.isEmpty) {
      return null;
    } else if (dplaces.length == 1) {
      if (_assign(values, dplaces.elementAt(0), d) == null) {
        return null;
      }
    }
  }
  return values;
}

/// Search
List<List<List<int>>>? solve(List<List<int>> grid, {int? maxSolutions}) {
  if (maxSolutions != null && maxSolutions > 0) _MAX_SOLUTIONS = maxSolutions;

  _FOUND_SOLUTIONS = 0;

  var results = _searchAll(_parse_grid(grid));
  if (results == null || results.isEmpty) return null;

  List<List<List<int>>> outputs = [];

  for (Map<String, String> result in results) {
    List<List<int>> output = [];
    for (int i = 0; i < 9; i++) {
      var column = <int>[];
      for (int j = 0; j < 9; j++) {
        column.add(int.parse(result[_rows[i] + _cols[j]]!));
      }
      output.add(column);
    }
    outputs.add(output);
  }

  return outputs;
}

List<Map<String, String>>? _searchAll(Map<String, String>? values) {
  if (values == null || _FOUND_SOLUTIONS >= _MAX_SOLUTIONS) return null;

  if (_squares.every((String s) => values[s]!.length == 1)) {
    _FOUND_SOLUTIONS++;
    return <Map<String, String>>[values];
  }

  var s2 =
      _order(_squares.where((String s) => values[s]!.length > 1).toList(), on: (String s) => values[s]!.length).first;

  var output = <Map<String, String>>[];

  values[s2]!.split('').forEach((d) {
    var result = _searchAll(_assign(Map<String, String>.from(values), s2, d));
    if (result == null) return;

    output.addAll(result);
  });

  return output;
}

List<String> _order(List<String> seq,
        {Comparator<String>? by, List<Comparator<String>>? byAll, required int Function(String x) on}) =>
    by != null
        ? (seq..sort(by))
        : byAll != null
            ? (seq..sort((a, b) => byAll.firstWhere((compare) => compare(a, b) != 0, orElse: () => (x, y) => 0)(a, b)))
            : (seq..sort((a, b) => on(a).compareTo(on(b))));

bool _all(Iterable<Map<String, String>?> seq) => seq.every((e) => e != null);
