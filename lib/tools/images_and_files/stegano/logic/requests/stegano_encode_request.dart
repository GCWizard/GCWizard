part of 'package:gc_wizard/tools/images_and_files/stegano/logic/stegano.dart';

class _SteganoEncodeRequest extends _SteganoBaseRequest {
  final String message;
  final String? filename;

  _SteganoEncodeRequest(Uint8List imageData, this.message, {String? key, this.filename}) : super(imageData, key: key);
}
