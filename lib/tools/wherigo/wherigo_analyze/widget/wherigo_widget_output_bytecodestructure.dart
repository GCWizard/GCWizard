part of 'package:gc_wizard/tools/wherigo/wherigo_analyze/widget/wherigo_analyze.dart';

List<Widget> _buildOutputListByteCodeStructure(BuildContext context, Uint8List bytes) {

  int numberOfObjects = readShort(bytes, 7);
  int offset = 0;
  List<Widget> result = [];

  Widget _buildSectionSignature(int numberOfObjects){
    List<List<String>> content = [];
    content = [
      [
        i18n(context, 'wherigo_bytecode_offset'),
        i18n(context, 'wherigo_bytecode_bytes'),
        i18n(context, 'wherigo_bytecode_content'),
      ],
      ['', i18n(context, 'wherigo_header_signature'), ''],
      [
        '0000',
        bytes.sublist(0, 7).join('.'),
        bytes[0].toString() + '.' + bytes[1].toString() + readString(bytes, 2).ASCIIZ
      ],
      ['', i18n(context, 'wherigo_header_numberofobjects'), ''],
      ['0007', bytes.sublist(7, 9).join('.'), numberOfObjects.toString()],
      ['', i18n(context, 'wherigo_data_luabytecode'), 'ID Offset'],
      [
        '0009',
        bytes.sublist(9, 11).join('.') + ' ' + bytes.sublist(11, 15).join('.'),
        readShort(bytes, 9).toString() + ' ' + readInt(bytes, 11).toString()
      ],
    ];
    return GCWExpandableTextDivider(
      text: i18n(context, 'wherigo_header_signature'),
      expanded: false,
      child: GCWColumnedMultilineOutput(
          data: content,
          suppressCopyButtons: true,
          flexValues: const [1, 3, 2],
          hasHeader: true
      ),
    );
  }
  Widget _buildSectionMediaFiles(int numberOfObjects){
    // id and offset of media files
    // 2 Bytes ID
    // 4 Bytes offset

    List<List<String>> content = [];

    offset = 15;
    for (int i = 1; i < numberOfObjects; i++) {
      if (i == 1) {
        content.add(
          ['', i18n(context, 'wherigo_data_mediafiles'), 'ID Offset'],
        );
      }

      content.add([
        offset.toString().padLeft(7, ' '),
        bytes.sublist(offset, offset + 2).join('.') + ' ' + bytes.sublist(offset + 2, offset + 2 + 4).join('.'),
        readShort(bytes, offset).toString() + ' ' + readInt(bytes, offset + 2).toString()
      ]);
      offset = offset + 2 + 4;
    }
    return GCWExpandableTextDivider(
      text: i18n(context, 'wherigo_data_mediafiles'),
      expanded: false,
      child: GCWColumnedMultilineOutput(
          data: content,
          suppressCopyButtons: true,
          flexValues: const [1, 3, 2],
          hasHeader: true
      ),
    );
  }
  Widget _buildSectionHeader(){
    List<List<String>> content = [];
    content.add(['', i18n(context, 'wherigo_header_headerlength'), 'Bytes']);
    content.add([
      offset.toString().padLeft(7, ' '), // offset begin of Header
      bytes.sublist(offset, offset + LENGTH_INT).join('.'), // 4 Bytes Size of Header
      readInt(bytes, offset).toString() // size of Header
    ]);

    content.add(['', i18n(context, 'wherigo_header_latitude'), '8 byte']); // 8 byte double
    content.add(['', i18n(context, 'wherigo_header_longitude'), '8 byte']); // 8 byte double
    content.add(['', i18n(context, 'wherigo_header_altitude'), '8 byte']); // 8 byte double
    content.add(['', i18n(context, 'wherigo_header_creationdate'), '8 byte']); // 8 byte long
    content.add(['', i18n(context, 'wherigo_header_unknown'), '8 byte']); //8 byte long
    content.add(['', i18n(context, 'wherigo_header_splashscreen'), '2 byte']); // 2 byte short
    content.add(['', i18n(context, 'wherigo_header_splashicon'), '2 byte']); // 2 byte short
    content.add(['', i18n(context, 'wherigo_header_typeofcartridge'), '']); //ASCIIZ
    content.add(['', i18n(context, 'wherigo_header_player'), 'ASCIIZ']); //ASCIIZ
    content.add(['', i18n(context, 'wherigo_header_playerid'), '8 byte']); // 8 byte long
    content.add(['', i18n(context, 'wherigo_header_cartridgename'), 'ASCIIZ']); //ASCIIZ
    content.add(['', i18n(context, 'wherigo_header_cartridgeguid'), 'ASCIIZ']); //ASCIIZ
    content.add(['', i18n(context, 'wherigo_header_cartridgedescription'), '']); //ASCIIZ
    content.add(['', i18n(context, 'wherigo_header_startinglocation'), 'ASCIIZ']); //ASCIIZ
    content.add(['', i18n(context, 'wherigo_header_version'), 'ASCIIZ']); //ASCIIZ
    content.add(['', i18n(context, 'wherigo_header_author'), 'ASCIIZ']); //ASCIIZ
    content.add(['', i18n(context, 'wherigo_header_company'), 'ASCIIZ']); //ASCIIZ
    content.add(['', i18n(context, 'wherigo_header_device'), 'ASCIIZ']); //ASCIIZ
    content.add(['', i18n(context, 'wherigo_header_lengthcompletion'), '4 byte']); // 4 byte int
    content.add(['', i18n(context, 'wherigo_header_completion'), 'ASCIIZ']); //ASCIIZ

    return GCWExpandableTextDivider(
      text: i18n(context, 'wherigo_data_header'),
      expanded: false,
      child: GCWColumnedMultilineOutput(
          data: content,
          suppressCopyButtons: true,
          flexValues: const [1, 3, 2],
          hasHeader: true
      ),
    );
  }
  Widget _buildSectionLUAByteCode(){
    // LUA Bytecode
    // 4 Bytes Size
    // ? bytes LUA Bytecode
    List<List<String>> content = [];
    content.add(['', i18n(context, 'wherigo_data_luabytecode'), i18n(context, 'wherigo_header_size')]);
    content.add([
      offset.toString().padLeft(7, ' '), // offset begin of LUABytecode
      bytes.sublist(offset, offset + LENGTH_INT).join('.'), // 4 Bytes Size of LUABytecode
      readInt(bytes, offset).toString() // size of LUABytecode
    ]);
    return GCWExpandableTextDivider(
      text: i18n(context, 'wherigo_data_luabytecode'),
      expanded: false,
      child: GCWColumnedMultilineOutput(
          data: content,
          suppressCopyButtons: true,
          flexValues: const [1, 3, 2],
          hasHeader: true
      ),
    );
  }
  Widget _buildSectionMediaFilesDetails(){
    // Media files
    // 1 Byte Valid Object (0 = nothing, else Object
    // 4 Byte Object Type
    // 4 Byte size
    // ? bytes Object Data
    List<List<String>> content = [];
    for (int i = 1; i < numberOfObjects; i++) {
      if (i == 1) {
        content.add(
          ['', i18n(context, 'wherigo_data_mediafiles'), i18n(context, 'wherigo_header_valid')],
        );
      }
      try {
        if (readByte(bytes, offset) != 0) {
          content.add([
            offset.toString().padLeft(7, ' '),
            bytes.sublist(offset, offset + 1).join('.') +
                ' ' +
                bytes.sublist(offset + 1, offset + 5).join('.') +
                ' ' +
                bytes.sublist(offset + 5, offset + 9).join('.'),
            readByte(bytes, offset).toString() +
                ' ' +
                readInt(bytes, offset + 1).toString() +
                ' ' +
                readInt(bytes, offset + 5).toString()
          ]);
          offset = offset + LENGTH_BYTE + LENGTH_INT + LENGTH_INT + readInt(bytes, offset + 5);
        } else {
          content.add([
            offset.toString().padLeft(7, ' '),
            bytes.sublist(offset, offset + 1).join('.'),
            readByte(bytes, offset).toString()
          ]);
          offset = offset + LENGTH_BYTE;
        }
      } catch (exception) {
        i = numberOfObjects;
        content.add([
          '',
          i18n(context, 'wherigo_error_runtime') +
              '\n' +
              i18n(context, 'wherigo_error_runtime_exception') +
              '\n' +
              i18n(context, 'wherigo_error_invalid_gwc') +
              '\n' +
              i18n(context, 'wherigo_error_gwc_luabytecode') +
              '\n' +
              i18n(context, 'wherigo_error_gwc_mediafiles') +
              '\n' +
              exception.toString(),
          ''
        ]);
      }
    }
    return GCWExpandableTextDivider(
      text: i18n(context, 'wherigo_data_mediafiles'),
      expanded: false,
      child: GCWColumnedMultilineOutput(
          data: content,
          suppressCopyButtons: true,
          flexValues: const [1, 3, 2],
          hasHeader: true
      ),
    );
  }

  result.add(_buildSectionSignature(numberOfObjects));
  result.add(_buildSectionMediaFiles(numberOfObjects));
  result.add(_buildSectionHeader());

  offset = offset + LENGTH_INT + readInt(bytes, offset);

  result.add(_buildSectionLUAByteCode());

  offset = offset + LENGTH_INT + readInt(bytes, offset);

  result.add(_buildSectionMediaFilesDetails());

  return result;
} // end _outputBytecodeStructure
