import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/rotation/logic/rotation.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/rotation/widget/base_rot.dart';

const String _apiSpecification = '''
{
  "/rotation_rot13" : {
    "alternative_paths": ["rot13"],
    "get": {
      "summary": "Rot13 Tool",
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
          "description": "Input data for Rot13 text",
          "schema": {
            "type": "string"
          }
        }
      ]
    }
  }
}
''';

class Rot13 extends AbstractRotation {
  Rot13({Key? key}) : super(key: key, rotate: Rotator().rot13, apiSpecification: _apiSpecification);
}
