
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/gcw_expandable.dart';
import 'package:gc_wizard/common_widgets/image_viewers/gcw_imageview.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/base/_common/logic/base.dart';
import 'package:gc_wizard/tools/images_and_files/id3_tag/logic/id3_tag.dart';
import 'package:gc_wizard/common_widgets/gcw_openfile.dart';
import 'package:gc_wizard/common_widgets/gcw_snackbar.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/utils/file_utils/gcw_file.dart';

class ID3Tag extends StatefulWidget {
  final GCWFile? file;

  const ID3Tag({Key? key, this.file}) : super(key: key);

  @override
  _ID3TagState createState() => _ID3TagState();
}

class _ID3TagState extends State<ID3Tag> {
  GCWFile? _file;

  ID3TagList _ID3TagList = ID3TagList(
      tableTagsHeader: [],
      tableTagsFrames: [],
      tableTagsPadding: [],
      tableTagsImages: [],
      tableTagsMisc: []);

  var _fileLoaded = false;

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

    imageData.forEach((imageEntry){

      result.add(
          GCWImageView(
            imageData: GCWImageViewData(
              GCWFile(bytes: Uint8List.fromList(decodeBase64(imageEntry[2]).codeUnits))
            )
          )
      );
    });

    return GCWExpandableTextDivider(
      text: 'Images',
      child: Column(
        children: result,
      )
    );
  }
}
