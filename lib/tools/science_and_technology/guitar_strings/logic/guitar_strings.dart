import 'dart:math';

import 'package:tuple/tuple.dart';

enum GuitarStringName { E4, H3, G3, D3, A2, E2 }

final GUITAR_STRING_NOTES = <Tuple2<GuitarStringName, int>, String>{
  Tuple2(GuitarStringName.E4, 0): 'symboltables_notes_names_trebleclef_17',
  Tuple2(GuitarStringName.E4, 1): 'symboltables_notes_names_trebleclef_18',
  Tuple2(GuitarStringName.E4, 2): 'symboltables_notes_names_trebleclef_18_k',
  Tuple2(GuitarStringName.E4, 3): 'symboltables_notes_names_trebleclef_19',
  Tuple2(GuitarStringName.E4, 4): 'symboltables_notes_names_trebleclef_19_k',
  Tuple2(GuitarStringName.E4, 5): 'symboltables_notes_names_trebleclef_20',
  Tuple2(GuitarStringName.E4, 6): 'symboltables_notes_names_trebleclef_20_k',
  Tuple2(GuitarStringName.E4, 7): 'symboltables_notes_names_trebleclef_21',
  Tuple2(GuitarStringName.E4, 8): 'symboltables_notes_names_trebleclef_22',
  Tuple2(GuitarStringName.E4, 9): 'symboltables_notes_names_trebleclef_22_k',
  Tuple2(GuitarStringName.E4, 10): 'symboltables_notes_names_trebleclef_23',
  Tuple2(GuitarStringName.E4, 11): 'symboltables_notes_names_trebleclef_23_k',
  Tuple2(GuitarStringName.E4, 12): 'symboltables_notes_names_trebleclef_24',
  Tuple2(GuitarStringName.H3, 0): 'symboltables_notes_names_trebleclef_14',
  Tuple2(GuitarStringName.H3, 1): 'symboltables_notes_names_trebleclef_15',
  Tuple2(GuitarStringName.H3, 2): 'symboltables_notes_names_trebleclef_15_k',
  Tuple2(GuitarStringName.H3, 3): 'symboltables_notes_names_trebleclef_16',
  Tuple2(GuitarStringName.H3, 4): 'symboltables_notes_names_trebleclef_16_k',
  Tuple2(GuitarStringName.H3, 5): 'symboltables_notes_names_trebleclef_17',
  Tuple2(GuitarStringName.H3, 6): 'symboltables_notes_names_trebleclef_18',
  Tuple2(GuitarStringName.H3, 7): 'symboltables_notes_names_trebleclef_18_k',
  Tuple2(GuitarStringName.H3, 8): 'symboltables_notes_names_trebleclef_19',
  Tuple2(GuitarStringName.H3, 9): 'symboltables_notes_names_trebleclef_19_k',
  Tuple2(GuitarStringName.H3, 10): 'symboltables_notes_names_trebleclef_20',
  Tuple2(GuitarStringName.H3, 11): 'symboltables_notes_names_trebleclef_20_k',
  Tuple2(GuitarStringName.H3, 12): 'symboltables_notes_names_trebleclef_21',
  Tuple2(GuitarStringName.G3, 0): 'symboltables_notes_names_trebleclef_12',
  Tuple2(GuitarStringName.G3, 1): 'symboltables_notes_names_trebleclef_12_k',
  Tuple2(GuitarStringName.G3, 2): 'symboltables_notes_names_trebleclef_13',
  Tuple2(GuitarStringName.G3, 3): 'symboltables_notes_names_trebleclef_13_k',
  Tuple2(GuitarStringName.G3, 4): 'symboltables_notes_names_trebleclef_14',
  Tuple2(GuitarStringName.G3, 5): 'symboltables_notes_names_trebleclef_15',
  Tuple2(GuitarStringName.G3, 6): 'symboltables_notes_names_trebleclef_15_k',
  Tuple2(GuitarStringName.G3, 7): 'symboltables_notes_names_trebleclef_16',
  Tuple2(GuitarStringName.G3, 8): 'symboltables_notes_names_trebleclef_16_k',
  Tuple2(GuitarStringName.G3, 9): 'symboltables_notes_names_trebleclef_17',
  Tuple2(GuitarStringName.G3, 10): 'symboltables_notes_names_trebleclef_18',
  Tuple2(GuitarStringName.G3, 11): 'symboltables_notes_names_trebleclef_18_k',
  Tuple2(GuitarStringName.G3, 12): 'symboltables_notes_names_trebleclef_19',
  Tuple2(GuitarStringName.D3, 0): 'symboltables_notes_names_trebleclef_9',
  Tuple2(GuitarStringName.D3, 1): 'symboltables_notes_names_trebleclef_9_k',
  Tuple2(GuitarStringName.D3, 2): 'symboltables_notes_names_trebleclef_10',
  Tuple2(GuitarStringName.D3, 3): 'symboltables_notes_names_trebleclef_11',
  Tuple2(GuitarStringName.D3, 4): 'symboltables_notes_names_trebleclef_11_k',
  Tuple2(GuitarStringName.D3, 5): 'symboltables_notes_names_trebleclef_12',
  Tuple2(GuitarStringName.D3, 6): 'symboltables_notes_names_trebleclef_12_k',
  Tuple2(GuitarStringName.D3, 7): 'symboltables_notes_names_trebleclef_13',
  Tuple2(GuitarStringName.D3, 8): 'symboltables_notes_names_trebleclef_13_k',
  Tuple2(GuitarStringName.D3, 9): 'symboltables_notes_names_trebleclef_14',
  Tuple2(GuitarStringName.D3, 10): 'symboltables_notes_names_trebleclef_15',
  Tuple2(GuitarStringName.D3, 11): 'symboltables_notes_names_trebleclef_15_k',
  Tuple2(GuitarStringName.D3, 12): 'symboltables_notes_names_trebleclef_16',
  Tuple2(GuitarStringName.A2, 0): 'symboltables_notes_names_trebleclef_6',
  Tuple2(GuitarStringName.A2, 1): 'symboltables_notes_names_trebleclef_6_k',
  Tuple2(GuitarStringName.A2, 2): 'symboltables_notes_names_trebleclef_7',
  Tuple2(GuitarStringName.A2, 3): 'symboltables_notes_names_trebleclef_8',
  Tuple2(GuitarStringName.A2, 4): 'symboltables_notes_names_trebleclef_8_k',
  Tuple2(GuitarStringName.A2, 5): 'symboltables_notes_names_trebleclef_9',
  Tuple2(GuitarStringName.A2, 6): 'symboltables_notes_names_trebleclef_9_k',
  Tuple2(GuitarStringName.A2, 7): 'symboltables_notes_names_trebleclef_10',
  Tuple2(GuitarStringName.A2, 8): 'symboltables_notes_names_trebleclef_11',
  Tuple2(GuitarStringName.A2, 9): 'symboltables_notes_names_trebleclef_11_k',
  Tuple2(GuitarStringName.A2, 10): 'symboltables_notes_names_trebleclef_12',
  Tuple2(GuitarStringName.A2, 11): 'symboltables_notes_names_trebleclef_12_k',
  Tuple2(GuitarStringName.A2, 12): 'symboltables_notes_names_trebleclef_13',
  Tuple2(GuitarStringName.E2, 0): 'symboltables_notes_names_trebleclef_3',
  Tuple2(GuitarStringName.E2, 1): 'symboltables_notes_names_trebleclef_4',
  Tuple2(GuitarStringName.E2, 2): 'symboltables_notes_names_trebleclef_4_k',
  Tuple2(GuitarStringName.E2, 3): 'symboltables_notes_names_trebleclef_5',
  Tuple2(GuitarStringName.E2, 4): 'symboltables_notes_names_trebleclef_5_k',
  Tuple2(GuitarStringName.E2, 5): 'symboltables_notes_names_trebleclef_6',
  Tuple2(GuitarStringName.E2, 6): 'symboltables_notes_names_trebleclef_6_k',
  Tuple2(GuitarStringName.E2, 7): 'symboltables_notes_names_trebleclef_7',
  Tuple2(GuitarStringName.E2, 8): 'symboltables_notes_names_trebleclef_8',
  Tuple2(GuitarStringName.E2, 9): 'symboltables_notes_names_trebleclef_8_k',
  Tuple2(GuitarStringName.E2, 10): 'symboltables_notes_names_trebleclef_9',
  Tuple2(GuitarStringName.E2, 11): 'symboltables_notes_names_trebleclef_9_k',
  Tuple2(GuitarStringName.E2, 12): 'symboltables_notes_names_trebleclef_10',
};

List<Tuple2<GuitarStringName, int>> textToGuitarTabs(String input) {
  if (input == null) return [];

  input = input.toLowerCase().replaceAll(RegExp(r'[^abcdefgh]'), '');

  if (input.isEmpty) return [];

  var rand = Random();
  int i;

  return input.split('').map((character) {
    switch (character) {
      case 'a':
        i = rand.nextInt(4);
        switch (i) {
          case 0:
            return Tuple2(GuitarStringName.G3, 2);
          case 1:
            return Tuple2(GuitarStringName.D3, 7);
          case 2:
            return Tuple2(GuitarStringName.A2, 12);
          case 3:
            return Tuple2(GuitarStringName.E2, 5);
        }
        break;
      case 'b':
      case 'h':
        i = rand.nextInt(4);
        switch (i) {
          case 0:
            return Tuple2(GuitarStringName.H3, 0);
          case 1:
            return Tuple2(GuitarStringName.G3, 4);
          case 2:
            return Tuple2(GuitarStringName.D3, 9);
          case 3:
            return Tuple2(GuitarStringName.E2, 7);
        }
        break;
      case 'c':
        i = rand.nextInt(2);
        switch (i) {
          case 0:
            return Tuple2(GuitarStringName.A2, 3);
          case 1:
            return Tuple2(GuitarStringName.E2, 8);
        }
        break;
      case 'd':
        i = rand.nextInt(3);
        switch (i) {
          case 0:
            return Tuple2(GuitarStringName.D3, 0);
          case 1:
            return Tuple2(GuitarStringName.A2, 5);
          case 2:
            return Tuple2(GuitarStringName.E2, 10);
        }
        break;
      case 'e':
        i = rand.nextInt(3);
        switch (i) {
          case 0:
            return Tuple2(GuitarStringName.D3, 2);
          case 1:
            return Tuple2(GuitarStringName.A2, 7);
          case 2:
            return Tuple2(GuitarStringName.E2, 12);
        }
        break;
      case 'f':
        i = rand.nextInt(2);
        switch (i) {
          case 0:
            return Tuple2(GuitarStringName.D3, 3);
          case 1:
            return Tuple2(GuitarStringName.A2, 8);
        }
        break;
      case 'g':
        i = rand.nextInt(3);
        switch (i) {
          case 0:
            return Tuple2(GuitarStringName.G3, 0);
          case 1:
            return Tuple2(GuitarStringName.D3, 5);
          case 2:
            return Tuple2(GuitarStringName.A2, 10);
        }
        break;
    }
  }).toList();
}
