part of 'package:gc_wizard/tools/images_and_files/stegano/logic/stegano.dart';

class _SteganoEncodeRequest extends _SteganoBaseRequest {
  final String message;
  final String? filename;

  _SteganoEncodeRequest(super.imageData, this.message, {super.key, this.filename});
}
