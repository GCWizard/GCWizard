import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_button.dart';
import 'package:gc_wizard/common_widgets/gcw_expandable.dart';
import 'package:gc_wizard/common_widgets/image_viewers/gcw_imageview.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/base/_common/logic/base.dart';
import 'package:gc_wizard/tools/images_and_files/id3_tag/logic/id3_tag.dart';
import 'package:gc_wizard/common_widgets/gcw_openfile.dart';
import 'package:gc_wizard/common_widgets/gcw_snackbar.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/utils/file_utils/gcw_file.dart';
import 'package:id3_codec/encode_metadata.dart';
import 'package:id3_codec/id3_encoder.dart';

class ID3Tag extends StatefulWidget {
  final GCWFile? file;

  const ID3Tag({Key? key, this.file}) : super(key: key);

  @override
  _ID3TagState createState() => _ID3TagState();
}

class _ID3TagState extends State<ID3Tag> {
  GCWFile? _file;
  GCWFile? _currentImageFile;

  ID3TagList _ID3TagList = EMPTY_ID3TAGLIST;

  bool _fileLoaded = false;

  ID3_VERSION _versionID3 = ID3_VERSION.V24;

  GCWSwitchPosition _currentMode = GCWSwitchPosition.left;

  @override
  initState() {
    super.initState();

    if (widget.file != null) {
      _file = widget.file;
      _ID3TagList = decodeID3MetaData(_file!.bytes);
      _fileLoaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        GCWTwoOptionsSwitch(
          leftValue: i18n(context, 'metadata_read'),
          rightValue: i18n(context, 'metadata_write'),
          value: _currentMode,
          onChanged: (value) {
            _currentMode = value;
          },
        ),
        GCWOpenFile(
          supportedFileTypes: SUPPORTED_SOUND_TYPES,
          suppressGallery: false,
          onLoaded: (_file) {
            if (_file == null) {
              showSnackBar(i18n(context, 'common_loadfile_exception_notloaded'),
                  context);
              return;
            }
            _fileLoaded = true;

            _ID3TagList = decodeID3MetaData(_file.bytes);

            setState(() {});
          },
        ),
        (_currentMode == GCWSwitchPosition.right)
            ? _buildWidgetInputMetaData()
            : Container(),
        _buildOutput()
      ],
    );
  }

  Widget _buildOutput() {
    if (!_fileLoaded) {
      return Container();
    }

    return GCWDefaultOutput(
      child: Column(
        children: [
          GCWExpandableTextDivider(
            text: 'Header',
            child:
                GCWColumnedMultilineOutput(data: _ID3TagList.tableTagsHeader),
          ),
          GCWExpandableTextDivider(
            text: 'Frames',
            child:
                GCWColumnedMultilineOutput(data: _ID3TagList.tableTagsFrames),
          ),
          GCWExpandableTextDivider(
            text: 'Padding',
            child:
                GCWColumnedMultilineOutput(data: _ID3TagList.tableTagsPadding),
          ),
          _ID3TagList.tableTagsImages.isNotEmpty
              ? _buildImageOutput(_ID3TagList.tableTagsImages)
              : Container(),
          _ID3TagList.tableTagsMisc.isNotEmpty
              ? GCWExpandableTextDivider(
                  text: '?',
                  child: GCWColumnedMultilineOutput(
                      data: _ID3TagList.tableTagsMisc),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _buildImageOutput(List<List<String>> imageData) {
    if (imageData.isEmpty) return Container();

    List<Widget> result = [];

    for (var imageEntry in imageData) {
      result.add(GCWImageView(
          imageData: GCWImageViewData(GCWFile(
              bytes:
                  Uint8List.fromList(decodeBase64(imageEntry[2]).codeUnits)))));
    }

    return GCWExpandableTextDivider(
        text: 'Images',
        child: Column(
          children: result,
        ));
  }

  Widget _buildWidgetInputMetaData() {
    List<int> resultBytes = [];
    if (_fileLoaded) {
      return Column(
        children: [
          GCWOpenFile(
            supportedFileTypes: SUPPORTED_IMAGE_TYPES,
            suppressGallery: false,
            onLoaded: (_imageFile) {
              if (_imageFile == null) {
                showSnackBar(i18n(context, 'common_loadfile_exception_notloaded'),
                    context);
                return;
              }
              _currentImageFile = _imageFile;
              setState(() {});
            },
          ),
          GCWButton(
              text: i18n(context, 'metadata_write'),
              onPressed: () {
                final encoder = ID3Encoder(_file!.bytes);
                switch (_versionID3) {
                  case ID3_VERSION.V1:
                  case ID3_VERSION.V11:
                    resultBytes = encoder.encodeSync(MetadataV1Body(
                        title: 'Ting wo shuo,xiexie ni',
                        artist: 'Wu ming',
                        album: 'Gan en you ni',
                        year: '2021',
                        comment: 'I am very happy!',
                        track: 1,
                        genre: 2));
                    break;
                  case ID3_VERSION.V23:
                    resultBytes = encoder.encodeSync(MetadataV2p3Body(
                      title: '听我说谢谢你！',
                      imageBytes: _currentImageFile?.bytes,
                      artist: '歌手ijinfeng',
                      userDefines: {
                        "时长": '2:48',
                        "userId": "ijinfeng"
                      },
                      album: 'ijinfeng的专辑',
                    ));                     break;
                  case ID3_VERSION.V24:
                    resultBytes = encoder.encodeSync(MetadataV2p4Body(
                      title: '听我说谢谢你！',
                      imageBytes: _currentImageFile?.bytes,
                      artist: '歌手ijinfeng',
                      userDefines: {
                        "时长": '2:48',
                        "userId": "ijinfeng"
                      },
                      album: 'ijinfeng的专辑',
                    ));                     break;
                }
                setState(() {
                  _ID3TagList = decodeID3MetaData(Uint8List.fromList(resultBytes));
                });
              })
        ],
      );
    } else {
      return Container();
    }
  }
}
