import 'dart:math';

import 'package:tuple/tuple.dart';

enum GuitarStringName { E4, H3, G3, D3, A2, E2 }

final GUITAR_STRING_NOTES = <Tuple2<GuitarStringName, int>, String>{
  const Tuple2(GuitarStringName.E4, 0): 'symboltables_notes_names_trebleclef_17',
  const Tuple2(GuitarStringName.E4, 1): 'symboltables_notes_names_trebleclef_18',
  const Tuple2(GuitarStringName.E4, 2): 'symboltables_notes_names_trebleclef_18_k',
  const Tuple2(GuitarStringName.E4, 3): 'symboltables_notes_names_trebleclef_19',
  const Tuple2(GuitarStringName.E4, 4): 'symboltables_notes_names_trebleclef_19_k',
  const Tuple2(GuitarStringName.E4, 5): 'symboltables_notes_names_trebleclef_20',
  const Tuple2(GuitarStringName.E4, 6): 'symboltables_notes_names_trebleclef_20_k',
  const Tuple2(GuitarStringName.E4, 7): 'symboltables_notes_names_trebleclef_21',
  const Tuple2(GuitarStringName.E4, 8): 'symboltables_notes_names_trebleclef_22',
  const Tuple2(GuitarStringName.E4, 9): 'symboltables_notes_names_trebleclef_22_k',
  const Tuple2(GuitarStringName.E4, 10): 'symboltables_notes_names_trebleclef_23',
  const Tuple2(GuitarStringName.E4, 11): 'symboltables_notes_names_trebleclef_23_k',
  const Tuple2(GuitarStringName.E4, 12): 'symboltables_notes_names_trebleclef_24',
  const Tuple2(GuitarStringName.H3, 0): 'symboltables_notes_names_trebleclef_14',
  const Tuple2(GuitarStringName.H3, 1): 'symboltables_notes_names_trebleclef_15',
  const Tuple2(GuitarStringName.H3, 2): 'symboltables_notes_names_trebleclef_15_k',
  const Tuple2(GuitarStringName.H3, 3): 'symboltables_notes_names_trebleclef_16',
  const Tuple2(GuitarStringName.H3, 4): 'symboltables_notes_names_trebleclef_16_k',
  const Tuple2(GuitarStringName.H3, 5): 'symboltables_notes_names_trebleclef_17',
  const Tuple2(GuitarStringName.H3, 6): 'symboltables_notes_names_trebleclef_18',
  const Tuple2(GuitarStringName.H3, 7): 'symboltables_notes_names_trebleclef_18_k',
  const Tuple2(GuitarStringName.H3, 8): 'symboltables_notes_names_trebleclef_19',
  const Tuple2(GuitarStringName.H3, 9): 'symboltables_notes_names_trebleclef_19_k',
  const Tuple2(GuitarStringName.H3, 10): 'symboltables_notes_names_trebleclef_20',
  const Tuple2(GuitarStringName.H3, 11): 'symboltables_notes_names_trebleclef_20_k',
  const Tuple2(GuitarStringName.H3, 12): 'symboltables_notes_names_trebleclef_21',
  const Tuple2(GuitarStringName.G3, 0): 'symboltables_notes_names_trebleclef_12',
  const Tuple2(GuitarStringName.G3, 1): 'symboltables_notes_names_trebleclef_12_k',
  const Tuple2(GuitarStringName.G3, 2): 'symboltables_notes_names_trebleclef_13',
  const Tuple2(GuitarStringName.G3, 3): 'symboltables_notes_names_trebleclef_13_k',
  const Tuple2(GuitarStringName.G3, 4): 'symboltables_notes_names_trebleclef_14',
  const Tuple2(GuitarStringName.G3, 5): 'symboltables_notes_names_trebleclef_15',
  const Tuple2(GuitarStringName.G3, 6): 'symboltables_notes_names_trebleclef_15_k',
  const Tuple2(GuitarStringName.G3, 7): 'symboltables_notes_names_trebleclef_16',
  const Tuple2(GuitarStringName.G3, 8): 'symboltables_notes_names_trebleclef_16_k',
  const Tuple2(GuitarStringName.G3, 9): 'symboltables_notes_names_trebleclef_17',
  const Tuple2(GuitarStringName.G3, 10): 'symboltables_notes_names_trebleclef_18',
  const Tuple2(GuitarStringName.G3, 11): 'symboltables_notes_names_trebleclef_18_k',
  const Tuple2(GuitarStringName.G3, 12): 'symboltables_notes_names_trebleclef_19',
  const Tuple2(GuitarStringName.D3, 0): 'symboltables_notes_names_trebleclef_9',
  const Tuple2(GuitarStringName.D3, 1): 'symboltables_notes_names_trebleclef_9_k',
  const Tuple2(GuitarStringName.D3, 2): 'symboltables_notes_names_trebleclef_10',
  const Tuple2(GuitarStringName.D3, 3): 'symboltables_notes_names_trebleclef_11',
  const Tuple2(GuitarStringName.D3, 4): 'symboltables_notes_names_trebleclef_11_k',
  const Tuple2(GuitarStringName.D3, 5): 'symboltables_notes_names_trebleclef_12',
  const Tuple2(GuitarStringName.D3, 6): 'symboltables_notes_names_trebleclef_12_k',
  const Tuple2(GuitarStringName.D3, 7): 'symboltables_notes_names_trebleclef_13',
  const Tuple2(GuitarStringName.D3, 8): 'symboltables_notes_names_trebleclef_13_k',
  const Tuple2(GuitarStringName.D3, 9): 'symboltables_notes_names_trebleclef_14',
  const Tuple2(GuitarStringName.D3, 10): 'symboltables_notes_names_trebleclef_15',
  const Tuple2(GuitarStringName.D3, 11): 'symboltables_notes_names_trebleclef_15_k',
  const Tuple2(GuitarStringName.D3, 12): 'symboltables_notes_names_trebleclef_16',
  const Tuple2(GuitarStringName.A2, 0): 'symboltables_notes_names_trebleclef_6',
  const Tuple2(GuitarStringName.A2, 1): 'symboltables_notes_names_trebleclef_6_k',
  const Tuple2(GuitarStringName.A2, 2): 'symboltables_notes_names_trebleclef_7',
  const Tuple2(GuitarStringName.A2, 3): 'symboltables_notes_names_trebleclef_8',
  const Tuple2(GuitarStringName.A2, 4): 'symboltables_notes_names_trebleclef_8_k',
  const Tuple2(GuitarStringName.A2, 5): 'symboltables_notes_names_trebleclef_9',
  const Tuple2(GuitarStringName.A2, 6): 'symboltables_notes_names_trebleclef_9_k',
  const Tuple2(GuitarStringName.A2, 7): 'symboltables_notes_names_trebleclef_10',
  const Tuple2(GuitarStringName.A2, 8): 'symboltables_notes_names_trebleclef_11',
  const Tuple2(GuitarStringName.A2, 9): 'symboltables_notes_names_trebleclef_11_k',
  const Tuple2(GuitarStringName.A2, 10): 'symboltables_notes_names_trebleclef_12',
  const Tuple2(GuitarStringName.A2, 11): 'symboltables_notes_names_trebleclef_12_k',
  const Tuple2(GuitarStringName.A2, 12): 'symboltables_notes_names_trebleclef_13',
  const Tuple2(GuitarStringName.E2, 0): 'symboltables_notes_names_trebleclef_3',
  const Tuple2(GuitarStringName.E2, 1): 'symboltables_notes_names_trebleclef_4',
  const Tuple2(GuitarStringName.E2, 2): 'symboltables_notes_names_trebleclef_4_k',
  const Tuple2(GuitarStringName.E2, 3): 'symboltables_notes_names_trebleclef_5',
  const Tuple2(GuitarStringName.E2, 4): 'symboltables_notes_names_trebleclef_5_k',
  const Tuple2(GuitarStringName.E2, 5): 'symboltables_notes_names_trebleclef_6',
  const Tuple2(GuitarStringName.E2, 6): 'symboltables_notes_names_trebleclef_6_k',
  const Tuple2(GuitarStringName.E2, 7): 'symboltables_notes_names_trebleclef_7',
  const Tuple2(GuitarStringName.E2, 8): 'symboltables_notes_names_trebleclef_8',
  const Tuple2(GuitarStringName.E2, 9): 'symboltables_notes_names_trebleclef_8_k',
  const Tuple2(GuitarStringName.E2, 10): 'symboltables_notes_names_trebleclef_9',
  const Tuple2(GuitarStringName.E2, 11): 'symboltables_notes_names_trebleclef_9_k',
  const Tuple2(GuitarStringName.E2, 12): 'symboltables_notes_names_trebleclef_10',
};

List<Tuple2<GuitarStringName, int>?> textToGuitarTabs(String input) {
  if (input.isEmpty) return [];

  input = input.toLowerCase().replaceAll(RegExp(r'[^abcdefgh]'), '');

  var rand = Random();
  int i;

  return input.split('').map((character) {
    switch (character) {
      case 'a':
        i = rand.nextInt(4);
        switch (i) {
          case 0:
            return const Tuple2(GuitarStringName.G3, 2);
          case 1:
            return const Tuple2(GuitarStringName.D3, 7);
          case 2:
            return const Tuple2(GuitarStringName.A2, 12);
          case 3:
            return const Tuple2(GuitarStringName.E2, 5);
        }
        break;
      case 'b':
      case 'h':
        i = rand.nextInt(4);
        switch (i) {
          case 0:
            return const Tuple2(GuitarStringName.H3, 0);
          case 1:
            return const Tuple2(GuitarStringName.G3, 4);
          case 2:
            return const Tuple2(GuitarStringName.D3, 9);
          case 3:
            return const Tuple2(GuitarStringName.E2, 7);
        }
        break;
      case 'c':
        i = rand.nextInt(2);
        switch (i) {
          case 0:
            return const Tuple2(GuitarStringName.A2, 3);
          case 1:
            return const Tuple2(GuitarStringName.E2, 8);
        }
        break;
      case 'd':
        i = rand.nextInt(3);
        switch (i) {
          case 0:
            return const Tuple2(GuitarStringName.D3, 0);
          case 1:
            return const Tuple2(GuitarStringName.A2, 5);
          case 2:
            return const Tuple2(GuitarStringName.E2, 10);
        }
        break;
      case 'e':
        i = rand.nextInt(3);
        switch (i) {
          case 0:
            return const Tuple2(GuitarStringName.D3, 2);
          case 1:
            return const Tuple2(GuitarStringName.A2, 7);
          case 2:
            return const Tuple2(GuitarStringName.E2, 12);
        }
        break;
      case 'f':
        i = rand.nextInt(2);
        switch (i) {
          case 0:
            return const Tuple2(GuitarStringName.D3, 3);
          case 1:
            return const Tuple2(GuitarStringName.A2, 8);
        }
        break;
      case 'g':
        i = rand.nextInt(3);
        switch (i) {
          case 0:
            return const Tuple2(GuitarStringName.G3, 0);
          case 1:
            return const Tuple2(GuitarStringName.D3, 5);
          case 2:
            return const Tuple2(GuitarStringName.A2, 10);
        }
        break;
    }
  }).toList();
}
