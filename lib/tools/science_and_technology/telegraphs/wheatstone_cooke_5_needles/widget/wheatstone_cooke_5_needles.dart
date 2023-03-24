import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/science_and_technology/telegraphs/gauss_weber_telegraph/logic/gauss_weber_telegraph.dart';
import 'package:gc_wizard/tools/science_and_technology/telegraphs/gauss_weber_telegraph/widget/gauss_weber_telegraph.dart';

class WheatstoneCookeNeedleTelegraph extends GaussWeberTelegraph {
  const WheatstoneCookeNeedleTelegraph({Key? key}) : super(key: key, mode: GaussWeberTelegraphMode.WHEATSTONE_COOKE_5);
}
