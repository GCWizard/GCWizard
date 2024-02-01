import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/rotation/logic/rotation.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/rotation/widget/base_rot.dart';

const String _apiSpecification = '''
{
  "/rotation_rot47" : {
    "alternative_paths": ["rot47"],
    "get": {
      "summary": "Rot47 Tool",
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
          "description": "Input data for Rot47 text",
          "schema": {
            "type": "string"
          }
        }
      ]
    }
  }
}
''';

class Rot47 extends AbstractRotation {
  Rot47({Key? key}) : super(key: key, rotate: Rotator().rot47, apiSpecification: _apiSpecification);
}
