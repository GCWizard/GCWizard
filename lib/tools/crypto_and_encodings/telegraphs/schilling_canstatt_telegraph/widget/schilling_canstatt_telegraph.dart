import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/telegraphs/gauss_weber_telegraph/logic/gauss_weber_telegraph.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/telegraphs/gauss_weber_telegraph/widget/gauss_weber_telegraph.dart';

class SchillingCanstattTelegraph extends GaussWeberTelegraph {
  SchillingCanstattTelegraph({Key key}) : super(key: key, mode: GaussWeberTelegraphMode.SCHILLING_CANSTATT);
}
