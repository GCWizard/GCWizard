import 'dart:math';

enum GuitarStringName { E4, H3, G3, D3, A2, E2 }

final GUITAR_STRING_NOTES = <({GuitarStringName string, int fret}), String>{
  const (string: GuitarStringName.E4, fret: 0): 'symboltables_notes_names_trebleclef_17',
  const (string: GuitarStringName.E4, fret: 1): 'symboltables_notes_names_trebleclef_18',
  const (string: GuitarStringName.E4, fret: 2): 'symboltables_notes_names_trebleclef_18_k',
  const (string: GuitarStringName.E4, fret: 3): 'symboltables_notes_names_trebleclef_19',
  const (string: GuitarStringName.E4, fret: 4): 'symboltables_notes_names_trebleclef_19_k',
  const (string: GuitarStringName.E4, fret: 5): 'symboltables_notes_names_trebleclef_20',
  const (string: GuitarStringName.E4, fret: 6): 'symboltables_notes_names_trebleclef_20_k',
  const (string: GuitarStringName.E4, fret: 7): 'symboltables_notes_names_trebleclef_21',
  const (string: GuitarStringName.E4, fret: 8): 'symboltables_notes_names_trebleclef_22',
  const (string: GuitarStringName.E4, fret: 9): 'symboltables_notes_names_trebleclef_22_k',
  const (string: GuitarStringName.E4, fret: 10): 'symboltables_notes_names_trebleclef_23',
  const (string: GuitarStringName.E4, fret: 11): 'symboltables_notes_names_trebleclef_23_k',
  const (string: GuitarStringName.E4, fret: 12): 'symboltables_notes_names_trebleclef_24',
  const (string: GuitarStringName.H3, fret: 0): 'symboltables_notes_names_trebleclef_14',
  const (string: GuitarStringName.H3, fret: 1): 'symboltables_notes_names_trebleclef_15',
  const (string: GuitarStringName.H3, fret: 2): 'symboltables_notes_names_trebleclef_15_k',
  const (string: GuitarStringName.H3, fret: 3): 'symboltables_notes_names_trebleclef_16',
  const (string: GuitarStringName.H3, fret: 4): 'symboltables_notes_names_trebleclef_16_k',
  const (string: GuitarStringName.H3, fret: 5): 'symboltables_notes_names_trebleclef_17',
  const (string: GuitarStringName.H3, fret: 6): 'symboltables_notes_names_trebleclef_18',
  const (string: GuitarStringName.H3, fret: 7): 'symboltables_notes_names_trebleclef_18_k',
  const (string: GuitarStringName.H3, fret: 8): 'symboltables_notes_names_trebleclef_19',
  const (string: GuitarStringName.H3, fret: 9): 'symboltables_notes_names_trebleclef_19_k',
  const (string: GuitarStringName.H3, fret: 10): 'symboltables_notes_names_trebleclef_20',
  const (string: GuitarStringName.H3, fret: 11): 'symboltables_notes_names_trebleclef_20_k',
  const (string: GuitarStringName.H3, fret: 12): 'symboltables_notes_names_trebleclef_21',
  const (string: GuitarStringName.G3, fret: 0): 'symboltables_notes_names_trebleclef_12',
  const (string: GuitarStringName.G3, fret: 1): 'symboltables_notes_names_trebleclef_12_k',
  const (string: GuitarStringName.G3, fret: 2): 'symboltables_notes_names_trebleclef_13',
  const (string: GuitarStringName.G3, fret: 3): 'symboltables_notes_names_trebleclef_13_k',
  const (string: GuitarStringName.G3, fret: 4): 'symboltables_notes_names_trebleclef_14',
  const (string: GuitarStringName.G3, fret: 5): 'symboltables_notes_names_trebleclef_15',
  const (string: GuitarStringName.G3, fret: 6): 'symboltables_notes_names_trebleclef_15_k',
  const (string: GuitarStringName.G3, fret: 7): 'symboltables_notes_names_trebleclef_16',
  const (string: GuitarStringName.G3, fret: 8): 'symboltables_notes_names_trebleclef_16_k',
  const (string: GuitarStringName.G3, fret: 9): 'symboltables_notes_names_trebleclef_17',
  const (string: GuitarStringName.G3, fret: 10): 'symboltables_notes_names_trebleclef_18',
  const (string: GuitarStringName.G3, fret: 11): 'symboltables_notes_names_trebleclef_18_k',
  const (string: GuitarStringName.G3, fret: 12): 'symboltables_notes_names_trebleclef_19',
  const (string: GuitarStringName.D3, fret: 0): 'symboltables_notes_names_trebleclef_9',
  const (string: GuitarStringName.D3, fret: 1): 'symboltables_notes_names_trebleclef_9_k',
  const (string: GuitarStringName.D3, fret: 2): 'symboltables_notes_names_trebleclef_10',
  const (string: GuitarStringName.D3, fret: 3): 'symboltables_notes_names_trebleclef_11',
  const (string: GuitarStringName.D3, fret: 4): 'symboltables_notes_names_trebleclef_11_k',
  const (string: GuitarStringName.D3, fret: 5): 'symboltables_notes_names_trebleclef_12',
  const (string: GuitarStringName.D3, fret: 6): 'symboltables_notes_names_trebleclef_12_k',
  const (string: GuitarStringName.D3, fret: 7): 'symboltables_notes_names_trebleclef_13',
  const (string: GuitarStringName.D3, fret: 8): 'symboltables_notes_names_trebleclef_13_k',
  const (string: GuitarStringName.D3, fret: 9): 'symboltables_notes_names_trebleclef_14',
  const (string: GuitarStringName.D3, fret: 10): 'symboltables_notes_names_trebleclef_15',
  const (string: GuitarStringName.D3, fret: 11): 'symboltables_notes_names_trebleclef_15_k',
  const (string: GuitarStringName.D3, fret: 12): 'symboltables_notes_names_trebleclef_16',
  const (string: GuitarStringName.A2, fret: 0): 'symboltables_notes_names_trebleclef_6',
  const (string: GuitarStringName.A2, fret: 1): 'symboltables_notes_names_trebleclef_6_k',
  const (string: GuitarStringName.A2, fret: 2): 'symboltables_notes_names_trebleclef_7',
  const (string: GuitarStringName.A2, fret: 3): 'symboltables_notes_names_trebleclef_8',
  const (string: GuitarStringName.A2, fret: 4): 'symboltables_notes_names_trebleclef_8_k',
  const (string: GuitarStringName.A2, fret: 5): 'symboltables_notes_names_trebleclef_9',
  const (string: GuitarStringName.A2, fret: 6): 'symboltables_notes_names_trebleclef_9_k',
  const (string: GuitarStringName.A2, fret: 7): 'symboltables_notes_names_trebleclef_10',
  const (string: GuitarStringName.A2, fret: 8): 'symboltables_notes_names_trebleclef_11',
  const (string: GuitarStringName.A2, fret: 9): 'symboltables_notes_names_trebleclef_11_k',
  const (string: GuitarStringName.A2, fret: 10): 'symboltables_notes_names_trebleclef_12',
  const (string: GuitarStringName.A2, fret: 11): 'symboltables_notes_names_trebleclef_12_k',
  const (string: GuitarStringName.A2, fret: 12): 'symboltables_notes_names_trebleclef_13',
  const (string: GuitarStringName.E2, fret: 0): 'symboltables_notes_names_trebleclef_3',
  const (string: GuitarStringName.E2, fret: 1): 'symboltables_notes_names_trebleclef_4',
  const (string: GuitarStringName.E2, fret: 2): 'symboltables_notes_names_trebleclef_4_k',
  const (string: GuitarStringName.E2, fret: 3): 'symboltables_notes_names_trebleclef_5',
  const (string: GuitarStringName.E2, fret: 4): 'symboltables_notes_names_trebleclef_5_k',
  const (string: GuitarStringName.E2, fret: 5): 'symboltables_notes_names_trebleclef_6',
  const (string: GuitarStringName.E2, fret: 6): 'symboltables_notes_names_trebleclef_6_k',
  const (string: GuitarStringName.E2, fret: 7): 'symboltables_notes_names_trebleclef_7',
  const (string: GuitarStringName.E2, fret: 8): 'symboltables_notes_names_trebleclef_8',
  const (string: GuitarStringName.E2, fret: 9): 'symboltables_notes_names_trebleclef_8_k',
  const (string: GuitarStringName.E2, fret: 10): 'symboltables_notes_names_trebleclef_9',
  const (string: GuitarStringName.E2, fret: 11): 'symboltables_notes_names_trebleclef_9_k',
  const (string: GuitarStringName.E2, fret: 12): 'symboltables_notes_names_trebleclef_10',
};

List<({GuitarStringName string, int fret})?> textToGuitarTabs(String input) {
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
            return const (string: GuitarStringName.G3, fret: 2);
          case 1:
            return const (string: GuitarStringName.D3, fret: 7);
          case 2:
            return const (string: GuitarStringName.A2, fret: 12);
          case 3:
            return const (string: GuitarStringName.E2, fret: 5);
        }
        break;
      case 'b':
      case 'h':
        i = rand.nextInt(4);
        switch (i) {
          case 0:
            return const (string: GuitarStringName.H3, fret: 0);
          case 1:
            return const (string: GuitarStringName.G3, fret: 4);
          case 2:
            return const (string: GuitarStringName.D3, fret: 9);
          case 3:
            return const (string: GuitarStringName.E2, fret: 7);
        }
        break;
      case 'c':
        i = rand.nextInt(2);
        switch (i) {
          case 0:
            return const (string: GuitarStringName.A2, fret: 3);
          case 1:
            return const (string: GuitarStringName.E2, fret: 8);
        }
        break;
      case 'd':
        i = rand.nextInt(3);
        switch (i) {
          case 0:
            return const (string: GuitarStringName.D3, fret: 0);
          case 1:
            return const (string: GuitarStringName.A2, fret: 5);
          case 2:
            return const (string: GuitarStringName.E2, fret: 10);
        }
        break;
      case 'e':
        i = rand.nextInt(3);
        switch (i) {
          case 0:
            return const (string: GuitarStringName.D3, fret: 2);
          case 1:
            return const (string: GuitarStringName.A2, fret: 7);
          case 2:
            return const (string: GuitarStringName.E2, fret: 12);
        }
        break;
      case 'f':
        i = rand.nextInt(2);
        switch (i) {
          case 0:
            return const (string: GuitarStringName.D3, fret: 3);
          case 1:
            return const (string: GuitarStringName.A2, fret: 8);
        }
        break;
      case 'g':
        i = rand.nextInt(3);
        switch (i) {
          case 0:
            return const (string: GuitarStringName.G3, fret: 0);
          case 1:
            return const (string: GuitarStringName.D3, fret: 5);
          case 2:
            return const (string: GuitarStringName.A2, fret: 10);
        }
        break;
    }
  }).toList();
}
