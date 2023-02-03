part of 'package:gc_wizard/tools/images_and_files/stegano/logic/stegano.dart';

class _SteganoBaseRequest {
  final Uint8List imageData;
  final String key;

  _SteganoBaseRequest(this.imageData, {this.key});

  bool canEncrypt() {
    return (key != null && key.isNotEmpty);
  }
}
