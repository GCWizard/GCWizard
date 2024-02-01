import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/rotation/logic/rotation.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/rotation/widget/base_rot.dart';

const String _apiSpecification = '''
{
  "/rotation_rot18" : {
    "alternative_paths": ["rot18"],
    "get": {
      "summary": "Rot18 Tool",
      "responses": {
        "204": {
          "description": "Tool loaded. No response data."
        }
      },
      "parameters" : [
        {
          "in": "query",
          "name": "input",
          "required": true,
          "description": "Input data for Rot18 text",
          "schema": {
            "type": "string"
          }
        }
      ]
    }
  }
}
''';

class Rot18 extends AbstractRotation {
  Rot18({Key? key}) : super(key: key, rotate: Rotator().rot18, apiSpecification: _apiSpecification);
}
