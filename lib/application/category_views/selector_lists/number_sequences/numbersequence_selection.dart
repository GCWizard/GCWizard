import 'package:flutter/material.dart';
import 'package:gc_wizard/application/registry.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_bell_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_catalan_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_factorial_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_fermat_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_fibonacci_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_happynumbers_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_jacobsthal_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_jacobsthallucas_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_jacobsthaloblong_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_lucas_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_luckynumbers_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_lychrel_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_mersenne_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_mersenneexponents_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_mersennefermat_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_mersenneprimes_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_pell_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_pelllucas_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_perfectnumbers_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_permutableprimes_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_primarypseudoperfectnumbers_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_recaman_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_sublimenumbers_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_superperfectnumbers_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/number_sequences/numbersequence_weirdnumbers_selection.dart';
import 'package:gc_wizard/common_widgets/gcw_selection.dart';
import 'package:gc_wizard/common_widgets/gcw_tool.dart';
import 'package:gc_wizard/common_widgets/gcw_toollist.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/common_widget_utils.dart';

class NumberSequenceSelection extends GCWSelection {
  @override
  Widget build(BuildContext context) {
    final List<GCWTool> _toolList = registeredTools.where((element) {
      return [
        className(NumberSequenceFactorialSelection()),
        className(NumberSequenceFibonacciSelection()),
        className(NumberSequenceMersenneSelection()),
        className(NumberSequenceMersennePrimesSelection()),
        className(NumberSequenceMersenneExponentsSelection()),
        className(NumberSequenceMersenneFermatSelection()),
        className(NumberSequenceFermatSelection()),
        className(NumberSequencePerfectNumbersSelection()),
        className(NumberSequenceSuperPerfectNumbersSelection()),
        className(NumberSequencePrimaryPseudoPerfectNumbersSelection()),
        className(NumberSequenceWeirdNumbersSelection()),
        className(NumberSequenceSublimeNumbersSelection()),
        className(NumberSequencePermutablePrimesSelection()),
        className(NumberSequenceLuckyNumbersSelection()),
        className(NumberSequenceHappyNumbersSelection()),
        className(NumberSequenceBellSelection()),
        className(NumberSequenceCatalanSelection()),
        className(NumberSequenceJacobsthalSelection()),
        className(NumberSequenceJacobsthalLucasSelection()),
        className(NumberSequenceJacobsthalOblongSelection()),
        className(NumberSequenceLucasSelection()),
        className(NumberSequencePellSelection()),
        className(NumberSequencePellLucasSelection()),
        className(NumberSequenceRecamanSelection()),
        className(NumberSequenceLychrelSelection()),
      ].contains(className(element.tool));
    }).toList();

    return Container(child: GCWToolList(toolList: _toolList));
  }
}
