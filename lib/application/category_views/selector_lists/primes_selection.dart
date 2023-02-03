import 'package:flutter/material.dart';
import 'package:gc_wizard/application/registry.dart';
import 'package:gc_wizard/common_widgets/gcw_selection.dart';
import 'package:gc_wizard/common_widgets/gcw_tool.dart';
import 'package:gc_wizard/common_widgets/gcw_toollist.dart';
import 'package:gc_wizard/tools/science_and_technology/primes/primes_integerfactorization/widget/primes_integerfactorization.dart';
import 'package:gc_wizard/tools/science_and_technology/primes/primes_isprime/widget/primes_isprime.dart';
import 'package:gc_wizard/tools/science_and_technology/primes/primes_nearestprime/widget/primes_nearestprime.dart';
import 'package:gc_wizard/tools/science_and_technology/primes/primes_nthprime/widget/primes_nthprime.dart';
import 'package:gc_wizard/tools/science_and_technology/primes/primes_primeindex/widget/primes_primeindex.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/common_widget_utils.dart';

class PrimesSelection extends GCWSelection {
  @override
  Widget build(BuildContext context) {
    final List<GCWTool> _toolList = registeredTools.where((element) {
      return [
        className(NthPrime()),
        className(IsPrime()),
        className(NearestPrime()),
        className(PrimeIndex()),
        className(IntegerFactorization())
      ].contains(className(element.tool));
    }).toList();

    return Container(child: GCWToolList(toolList: _toolList));
  }
}
