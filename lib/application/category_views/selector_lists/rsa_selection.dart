import 'package:flutter/material.dart';
import 'package:gc_wizard/application/registry.dart';
import 'package:gc_wizard/common_widgets/gcw_selection.dart';
import 'package:gc_wizard/common_widgets/gcw_tool.dart';
import 'package:gc_wizard/common_widgets/gcw_toollist.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/rsa/rsa/widget/rsa.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/rsa/rsa_d_calculator/widget/rsa_d_calculator.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/rsa/rsa_d_checker/widget/rsa_d_checker.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/rsa/rsa_e_checker/widget/rsa_e_checker.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/rsa/rsa_n_calculator/widget/rsa_n_calculator.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/rsa/rsa_phi_calculator/widget/rsa_phi_calculator.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/rsa/rsa_primes_calculator/widget/rsa_primes_calculator.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/common_widget_utils.dart';

class RSASelection extends GCWSelection {
  @override
  Widget build(BuildContext context) {
    final List<GCWTool> _toolList = registeredTools.where((element) {
      return [
        className(RSA()),
        className(RSAEChecker()),
        className(RSADChecker()),
        className(RSADCalculator()),
        className(RSANCalculator()),
        className(RSAPhiCalculator()),
        className(RSAPrimesCalculator()),
      ].contains(className(element.tool));
    }).toList();

    return Container(child: GCWToolList(toolList: _toolList));
  }
}
