import 'package:flutter/material.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_bell_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_carmichaelnumber_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_catalan_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_factorial_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_fermat_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_fibonacci_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_happynumbers_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_harshadnumber_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_jacobsthal_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_jacobsthallucas_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_jacobsthaloblong_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_lonelynumbers_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_lucas_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_luckynumbers_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_lychrel_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_memorableprimes_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_memorableprimesindexes_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_mersenne_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_mersenneexponents_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_mersennefermat_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_mersenneprimes_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_palindromeprimes_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_pell_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_pelllucas_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_perfectnumbers_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_permutableprimes_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_primarypseudoperfectnumbers_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_primes_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_recaman_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_sphenicnumber_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_sublimenumbers_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_superperfectnumbers_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_taxicab_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_weirdnumbers_selection.dart';
import 'package:gc_wizard/application/registry.dart';
import 'package:gc_wizard/application/tools/widget/gcw_tool.dart';
import 'package:gc_wizard/application/tools/widget/gcw_toollist.dart';
import 'package:gc_wizard/common_widgets/gcw_selection.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/common_widget_utils.dart';

class NumberSequenceSelection extends GCWSelection {
  const NumberSequenceSelection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<GCWTool> _toolList = registeredTools.where((element) {
      return [
        className(const NumberSequenceFactorialSelection()),
        className(const NumberSequenceFibonacciSelection()),
        className(const NumberSequencePrimesSelection()),
        className(const NumberSequenceMersenneSelection()),
        className(const NumberSequenceMersennePrimesSelection()),
        className(const NumberSequenceMersenneExponentsSelection()),
        className(const NumberSequenceMersenneFermatSelection()),
        className(const NumberSequenceFermatSelection()),
        className(const NumberSequencePerfectNumbersSelection()),
        className(const NumberSequenceSuperPerfectNumbersSelection()),
        className(const NumberSequencePrimaryPseudoPerfectNumbersSelection()),
        className(const NumberSequenceWeirdNumbersSelection()),
        className(const NumberSequenceSublimeNumbersSelection()),
        className(const NumberSequencePermutablePrimesSelection()),
        className(const NumberSequenceMemorablePrimesSelection()),
        className(const NumberSequenceMemorablePrimesIndexesSelection()),
        className(const NumberSequenceLuckyNumbersSelection()),
        className(const NumberSequenceHappyNumbersSelection()),
        className(const NumberSequenceBellSelection()),
        className(const NumberSequenceCatalanSelection()),
        className(const NumberSequenceJacobsthalSelection()),
        className(const NumberSequenceJacobsthalLucasSelection()),
        className(const NumberSequenceJacobsthalOblongSelection()),
        className(const NumberSequenceLucasSelection()),
        className(const NumberSequencePellSelection()),
        className(const NumberSequencePellLucasSelection()),
        className(const NumberSequenceRecamanSelection()),
        className(const NumberSequenceLychrelSelection()),
        className(const NumberSequenceSphenicNumbersSelection()),
        className(const NumberSequenceCarmichaelNumbersSelection()),
        className(const NumberSequenceTaxicabNumbersSelection()),
        className(const NumberSequenceHarshadNumbersSelection()),
        className(const NumberSequenceLonelyNumbersSelection()),
        className(const NumberSequencePalindromePrimesSelection()),
      ].contains(className(element.tool));
    }).toList();

    _toolList.sort((a, b) => sortToolList(a, b));

    return GCWToolList(toolList: _toolList);
  }
}
