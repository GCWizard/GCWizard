import 'package:flutter/material.dart';

abstract class GCWWebStatefulWidget extends StatefulWidget {
  Map<String, String>? webParameter;
  final String? apiSpecification;

  GCWWebStatefulWidget({Key? key, this.webParameter, required this.apiSpecification}) : super(key: key);

  set webQueryParameter(Map<String, String> parameter) {
    webParameter = parameter;
  }

  bool hasWebParameter() {
    return webParameter != null && webParameter!.isNotEmpty;
  }

  String? getWebParameter(String parameter) {
    return webParameter?[parameter];
  }
}
