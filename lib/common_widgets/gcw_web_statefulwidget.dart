import 'package:flutter/material.dart';
import 'package:gc_wizard/utils/string_utils.dart';

enum WEBPARAMETER {
  input,
  modeencode,
  parameter1,
  parameter2,
  fromformat,
  toformat,
  result
}

abstract class GCWWebStatefulWidget extends StatefulWidget {
  Map<String, String>? webParameter;
  bool webParameterInitActive = true;
  final String? parameterInfo;

  GCWWebStatefulWidget({Key? key, this.webParameter, this.parameterInfo}): super(key: key);

  set webQueryParameter(Map<String, String> parameter) {
    webParameter = parameter;
  }

  bool hasWebParameter() {
    return webParameter != null && webParameter!.isNotEmpty;
  }

  String? getWebParameter(WEBPARAMETER parameter) {
    return webParameter?[enumName(parameter.toString())];
  }
}

