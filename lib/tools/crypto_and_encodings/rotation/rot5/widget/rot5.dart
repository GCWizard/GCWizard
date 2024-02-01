import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/rotation/logic/rotation.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/rotation/widget/base_rot.dart';

const String _apiSpecification = '''
{
  "/rotation_rot5" : {
    "alternative_paths": ["rot5"],
    "get": {
      "summary": "Rot5 Tool",
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
          "description": "Input data for Rot5 text",
          "schema": {
            "type": "string"
          }
        }
      ]
    }
  }
}
''';

class Rot5 extends AbstractRotation {
  Rot5({Key? key}) : super(key: key, rotate: Rotator().rot5, apiSpecification: _apiSpecification);
}
