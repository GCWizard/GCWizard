import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_button.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/gcw_openfile.dart';
import 'package:gc_wizard/common_widgets/image_viewers/gcw_imageview.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output_text.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/images_and_files/stegano/logic/stegano.dart';
import 'package:gc_wizard/utils/file_utils/file_utils.dart';
import 'package:gc_wizard/utils/file_utils/gcw_file.dart' as local;

class Stegano extends StatefulWidget {
  final local.GCWFile? file;

  const Stegano({Key? key, this.file}) : super(key: key);

  @override
  _SteganoState createState() => _SteganoState();
}

class _SteganoState extends State<Stegano> {
  local.GCWFile? _file;
  Uint8List? _bytesSource;
  String _currentInput = '';
  String _currentKey = '';
  String? _filenameTarget = 'output.png'; //TODO choose output filename (sample.jpg, output.png, ..)
  final String _extensionTarget = '.png'; //TODO  output extension (jpg, png..)

  String? _decodedText;
  String? _decodingErrorText;
  String? _encodingErrorText;
  String? _error2Text;
  GCWImageViewData? _encodedPictureData;
  bool _encoding = false;

  late TextEditingController _inputController;
  late TextEditingController _keyController;

  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;

  @override
  initState() {
    super.initState();
    _inputController = TextEditingController(text: _currentInput);
    _keyController = TextEditingController(text: _currentKey);
    _file = widget.file;
  }

  @override
  void dispose() {
    _inputController.dispose();
    _keyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        GCWTwoOptionsSwitch(
          value: _currentMode,
          onChanged: (value) {
            setState(() {
              _currentMode = value;
            });
          },
        ),
        isEncode()
            ? GCWTextField(
                labelText: i18n(context, 'stegano_input'),
                controller: _inputController,
                onChanged: (text) {
                  setState(() {
                    _currentInput = text;
                  });
                },
              )
            : Container(),
        GCWTextField(
          labelText: i18n(context, 'stegano_key'),
          controller: _keyController,
          onChanged: (text) {
            setState(() {
              _currentKey = text;
            });
          },
        ),
        GCWOpenFile(
          supportedFileTypes: SUPPORTED_IMAGE_TYPES,
          onLoaded: (file) {
            if (file == null) return;
            setState(() {
              _file = file;
              _bytesSource = file.bytes;
              // clear previous decoded text
              _encodedPictureData = null;
              _decodedText = null;
            });
          },
        ),
        ..._buildImageSource(),
        GCWButton(
          text: i18n(context, isEncode() ? 'stegano_encode' : 'stegano_decode'),
          onPressed: () {
            setState(() {
              _calculateOutput();
            });
          },
        ),
        Container(),
        ..._buildOutput()
      ],
    );
  }

  void _calculateOutput() async {
    setState(() {
      // clear previous encoded picture
      _encodedPictureData = null;
      // clear previous decoded text
      _decodedText = null;
      // disable Loader for now
      // _encoding = true;
      _encodingErrorText = null;
      _decodingErrorText = null;
    });

    if (isEncode()) {
      _calculateOutputEncoding();
    } else {
      _calculateOutputDecoding();
    }
  }

  ///
  /// Decoding section
  ///
  void _calculateOutputDecoding() async {
    String? _text;
    String? _error;
    String? _error2;
    if (_file == null) {
      _error = i18n(context, 'stegano_decode_image_required');
    } else {
      try {
        _text = await decodeStegano(_file!, _currentKey);
      } catch (e) {
        _error = i18n(context, 'stegano_decoding_error');
        _error2 = e.toString();
      }
    }
    setState(() {
      _encoding = false;
      _decodedText = _text;
      _decodingErrorText = _error;
      _error2Text = _error2;
    });
  }

  ///
  /// Encoding section
  ///
  void _calculateOutputEncoding() async {
    Uint8List? bytes;
    String? _error;
    String? _error2;

    if (_file == null) {
      _error = i18n(context, 'stegano_encode_image_required');
    } else if (_currentInput.isEmpty) {
      _error = i18n(context, 'stegano_encode_message_required');
    } else {
      try {
        bytes = await encodeStegano(_file!, _currentInput, _currentKey, _file?.name);
      } catch (e) {
        _error = i18n(context, 'stegano_encoding_error');
        _error2 = e.toString();
      }
    }

    setState(() {
      _encoding = false;
      _encodedPictureData = (bytes != null) ? GCWImageViewData(local.GCWFile(bytes: bytes)) : null;
      _encodingErrorText = _error;
      _error2Text = _error2;
      _filenameTarget = (_file?.name != null) ? changeExtension(_file!.name!, _extensionTarget) : null;
    });
  }

  bool isEncode() => (_currentMode == GCWSwitchPosition.left);

  List<Widget> _buildOutput() {
    return isEncode() ? _buildOutputEncode() : _buildOutputDecode();
  }

  List<Widget> _buildOutputEncode() {
    if (_encodingErrorText != null) {
      var texts = [Text(_encodingErrorText!)];
      if (_error2Text != null) {
        texts.add(Text(_error2Text!));
      }
      return texts;
    }

    if (_encoding) {
      return loading();
    }

    if (_encodedPictureData == null) {
      return [];
    }
    return [
      GCWTextDivider(text: i18n(context, 'stegano_encoded_image')),
      GCWImageView(imageData: _encodedPictureData, /*extension: _extensionTarget,*/ fileName: _filenameTarget),
    ];
  }

  List<Widget> _buildOutputDecode() {
    if (_decodingErrorText != null) {
      var texts = [Text(_decodingErrorText!)];
      if (_error2Text != null) {
        texts.add(Text(_error2Text!));
      }
      return texts;
    }

    if (_encoding) {
      return loading();
    }

    if (_decodedText == null) {
      return [];
    }
    return [
      GCWTextDivider(text: i18n(context, 'stegano_decoded_message')),
      GCWOutputText(
        text: _decodedText ?? '',
      )
    ];
  }

  List<Widget> _buildImageSource() {
    if (_bytesSource == null) {
      return [];
    }
    return [
      GCWTextDivider(text: i18n(context, 'stegano_source_image')),
      //GCWImageView(imageData: GCWImageViewData(_bytesSource))
      Image.memory(_bytesSource!)
    ];
  }

  List<Widget> loading() {
    return [
      const Center(
        //child: CircularProgressIndicator(),
        child: CircularProgressIndicator(
          backgroundColor: Colors.white,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
          strokeWidth: 8, //20,
        ),
      )
    ];
  }
}
