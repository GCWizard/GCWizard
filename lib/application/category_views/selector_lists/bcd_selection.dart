import 'package:flutter/material.dart';
import 'package:gc_wizard/application/registry.dart';
import 'package:gc_wizard/common_widgets/gcw_selection.dart';
import 'package:gc_wizard/common_widgets/gcw_tool.dart';
import 'package:gc_wizard/common_widgets/gcw_toollist.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bcd/bcd1of10/widget/bcd1of10.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bcd/bcd20f5postnet/widget/bcd20f5postnet.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bcd/bcd2of5/widget/bcd2of5.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bcd/bcd2of5planet/widget/bcd2of5planet.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bcd/bcdaiken/widget/bcdaiken.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bcd/bcdbiquinary/widget/bcdbiquinary.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bcd/bcdglixon/widget/bcdglixon.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bcd/bcdgray/widget/bcdgray.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bcd/bcdgrayexcess/widget/bcdgrayexcess.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bcd/bcdhamming/widget/bcdhamming.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bcd/bcdlibawcraig/widget/bcdlibawcraig.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bcd/bcdobrien/widget/bcdobrien.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bcd/bcdoriginal/widget/bcdoriginal.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bcd/bcdpetherick/widget/bcdpetherick.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bcd/bcdstibitz/widget/bcdstibitz.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bcd/bcdtompkins/widget/bcdtompkins.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/common_widget_utils.dart';

class BCDSelection extends GCWSelection {
  @override
  Widget build(BuildContext context) {
    final List<GCWTool> _toolList = registeredTools.where((element) {
      return [
        className(BCDOriginal()),
        className(BCDAiken()),
        className(BCDGlixon()),
        className(BCDGray()),
        className(BCDGrayExcess()),
        className(BCDPetherick()),
        className(BCDOBrien()),
        className(BCDStibitz()),
        className(BCDTompkins()),
        className(BCDLibawCraig()),
        className(BCD2of5()),
        className(BCD2of5Postnet()),
        className(BCD2of5Planet()),
        className(BCDHamming()),
        className(BCDBiquinary()),
        className(BCD1of10()),
      ].contains(className(element.tool));
    }).toList();

    return Container(child: GCWToolList(toolList: _toolList));
  }
}
