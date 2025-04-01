import 'package:flutter/material.dart';

abstract class GCWWebStatefulWidget extends StatefulWidget {
  Map<String, String>? webParameter;
  final String? apiSpecification;

  GCWWebStatefulWidget({super.key, this.webParameter, required this.apiSpecification});

  set webQueryParameter(Map<String, String> parameter) {
    webParameter = parameter;
  }

  Map<String, dynamic>? get deepLinkParameter {
    return null;
  }

  bool hasWebParameter() {
    return webParameter != null && webParameter!.isNotEmpty;
  }

  String? getWebParameter(String parameter) {
    return webParameter?[parameter];
  }
}
