import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_onoff_switch.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/book_cipher/logic/book_cipher.dart';

class BookCipher extends StatefulWidget {
  const BookCipher({Key? key}) : super(key: key);

  @override
  BookCipherState createState() => BookCipherState();
}

class BookCipherState extends State<BookCipher> {
  var _currentInput = '';
  var _currentSearchMode = GCWSwitchPosition.right;
  var _currentMode = GCWSwitchPosition.left;
  var _currentSimpleMode = GCWSwitchPosition.left;
  var _spacesOn = true;
  var _emptyLinesOn = false;
  var _ignoreSymbolsOn = true;
  var _ignoreSymbols = '.;+-:!?\'‘"&(){}[]/\\_';
  var _diacriticsOn = true;
  var _azOn = true;
  var _numbersOn = true;
  var _onlyFirstWordLetter = false;

  var _currentText = '';
  var _currentWord = '';
  var _currentPositions = '';
  var _currentSearchFormat = searchFormat.SectionRowWord;
  var _currentDecodeOutFormat = decodeOutFormat.SectionRowWord;
  var _currentEncodeOutFormat = encodeOutFormat.RowWordCharacter;
  late TextEditingController _textController;
  late TextEditingController _wordController;
  late TextEditingController _positionsController;
  late TextEditingController _ignoreSymbolsController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: _currentText);
    _wordController = TextEditingController(text: _currentWord);
    _positionsController = TextEditingController(text: _currentPositions);
    _ignoreSymbolsController = TextEditingController(text: _ignoreSymbols);
  }

  @override
  void dispose() {
    _textController.dispose();
    _wordController.dispose();
    _positionsController.dispose();
    _ignoreSymbolsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _Book_CipherSearchFormatItems = {
      searchFormat.SectionRowWord: i18n(context, 'book_cipher_section') +
          ", " +
          i18n(context, 'book_cipher_row') +
          ", " +
          i18n(context, 'book_cipher_word'),
      searchFormat.SectionCharacter:
          i18n(context, 'book_cipher_section') + ", " + i18n(context, 'book_cipher_character'),
      searchFormat.RowWord: i18n(context, 'book_cipher_row') + ", " + i18n(context, 'book_cipher_word'),
      searchFormat.Word: i18n(context, 'book_cipher_word'),
      searchFormat.SectionRowWordCharacter: i18n(context, 'book_cipher_section') +
          ", " +
          i18n(context, 'book_cipher_row') +
          ", " +
          i18n(context, 'book_cipher_word') +
          ", " +
          i18n(context, 'book_cipher_character'),
      searchFormat.RowWordCharacter: i18n(context, 'book_cipher_row') +
          ", " +
          i18n(context, 'book_cipher_word') +
          ", " +
          i18n(context, 'book_cipher_character'),
      searchFormat.RowCharacter: i18n(context, 'book_cipher_row') + ", " + i18n(context, 'book_cipher_character'),
      searchFormat.WordCharacter: i18n(context, 'book_cipher_word') + ", " + i18n(context, 'book_cipher_character'),
      searchFormat.Character: i18n(context, 'book_cipher_character'),
    };

    var _Book_CipherdDecodeOutFormatItems = {
      decodeOutFormat.SectionRowWord: i18n(context, 'book_cipher_section') +
          ", " +
          i18n(context, 'book_cipher_row') +
          ", " +
          i18n(context, 'book_cipher_word'),
      decodeOutFormat.RowWord: i18n(context, 'book_cipher_row') + ", " + i18n(context, 'book_cipher_word'),
      decodeOutFormat.Word: i18n(context, 'book_cipher_word'),
    };

    var _Book_CipherdEncodeOutFormatItems = {
      encodeOutFormat.SectionRowWordCharacter: i18n(context, 'book_cipher_section') +
          "." +
          i18n(context, 'book_cipher_row') +
          "." +
          i18n(context, 'book_cipher_word') +
          "." +
          i18n(context, 'book_cipher_character'),
      encodeOutFormat.RowWordCharacter: i18n(context, 'book_cipher_row') +
          "." +
          i18n(context, 'book_cipher_word') +
          "." +
          i18n(context, 'book_cipher_character'),
      encodeOutFormat.WordCharacter: i18n(context, 'book_cipher_word') + "." + i18n(context, 'book_cipher_character'),
      encodeOutFormat.Character: i18n(context, 'book_cipher_character'),
    };

    return Column(
      children: <Widget>[
        GCWTextField(onChanged: (text) {
          setState(() {
            _currentInput = text;
          });
        }),
        GCWTwoOptionsSwitch(
          value: _currentSearchMode,
          onChanged: (value) {
            setState(() {
              _currentSearchMode = value;
            });
          },
        ),
        GCWOnOffSwitch(
            title: i18n(context, 'book_cipher_only_first_word_letter'),
            value: _onlyFirstWordLetter,
            onChanged: (value) {
              setState(() {
                _onlyFirstWordLetter = value;
              });
            }),
        GCWTwoOptionsSwitch(
          value: _currentSimpleMode,
          leftValue: i18n(context, 'common_mode_simple'),
          rightValue: i18n(context, 'common_mode_advanced'),
          onChanged: (value) {
            setState(() {
              _currentSimpleMode = value;
            });
          },
        ),
        _currentSimpleMode == GCWSwitchPosition.left ? Container() : _buildAdvancedModeControl(context),
        _currentSearchMode == GCWSwitchPosition.left ? Container() : _buildDecodeModusControl(context),
        _currentSearchMode == GCWSwitchPosition.left
            ? _buildEncodeInputControl(context)
            : _buildDecodeInputControl(context),
        _currentSearchMode == GCWSwitchPosition.left
            ? _buildEncodeFormatDividerControl(context)
            : _buildDecodeFormatDividerControl(context),
        _currentSearchMode == GCWSwitchPosition.left
            ? _buildEncodeFormatControl(context, _Book_CipherdEncodeOutFormatItems)
            : _buildDecodeFormatControl(context, _Book_CipherdDecodeOutFormatItems, _Book_CipherSearchFormatItems),
        GCWDefaultOutput(child: _buildOutput())
      ],
    );
  }

  Widget _buildDecodeModusControl(BuildContext context) {
    return GCWTwoOptionsSwitch(
      leftValue: i18n(context, 'book_cipher_searchposition'),
      rightValue: i18n(context, 'book_cipher_searchword'),
      value: _currentMode,
      onChanged: (value) {
        setState(() {
          _currentMode = value;
        });
      },
    );
  }

  Widget _buildDecodeInputControl(BuildContext context) {
    return _currentMode == GCWSwitchPosition.left
        ? GCWTextField(
            controller: _positionsController,
            hintText: i18n(context, 'book_cipher_searchposition'),
            onChanged: (text) {
              setState(() {
                _currentPositions = text;
              });
            })
        : GCWTextField(
            controller: _wordController,
            hintText: i18n(context, 'book_cipher_searchword'),
            onChanged: (text) {
              setState(() {
                _currentWord = text;
              });
            });
  }

  Widget _buildDecodeFormatDividerControl(BuildContext context) {
    return _currentMode == GCWSwitchPosition.left
        ? GCWTextDivider(text: i18n(context, 'book_cipher_input_format'))
        : GCWTextDivider(text: i18n(context, 'book_cipher_output_format'));
  }

  Widget _buildDecodeFormatControl(BuildContext context, Map<decodeOutFormat, String> _bookChiffredDecodeOutFormatItems,
      Map<searchFormat, String> _bookChiffreSearchFormatItems) {
    return _currentMode == GCWSwitchPosition.left
        ? GCWDropDown<searchFormat>(
            value: _currentSearchFormat,
            onChanged: (value) {
              setState(() {
                _currentSearchFormat = value;
              });
            },
            items: _bookChiffreSearchFormatItems.entries.map((item) {
              return GCWDropDownMenuItem(
                value: item.key,
                child: item.value,
              );
            }).toList(),
          )
        : GCWDropDown<decodeOutFormat>(
            value: _currentDecodeOutFormat,
            onChanged: (value) {
              setState(() {
                _currentDecodeOutFormat = value;
              });
            },
            items: _bookChiffredDecodeOutFormatItems.entries.map((item) {
              return GCWDropDownMenuItem(
                value: item.key,
                child: item.value,
              );
            }).toList());
  }

  Widget _buildEncodeInputControl(BuildContext context) {
    return GCWTextField(
      controller: _textController,
      hintText: i18n(context, 'book_cipher_random_output_hint'),
      onChanged: (text) {
        setState(() {
          _currentText = text;
        });
      },
    );
  }

  Widget _buildEncodeFormatDividerControl(BuildContext context) {
    return GCWTextDivider(text: i18n(context, 'book_cipher_output_format'));
  }

  Widget _buildAdvancedModeControl(BuildContext context) {
    return Column(children: <Widget>[
      GCWOnOffSwitch(
          title: 'A-Z',
          value: _azOn,
          onChanged: (value) {
            setState(() {
              _azOn = value;
            });
          }),
      GCWOnOffSwitch(
          title: '0-9',
          value: _numbersOn,
          onChanged: (value) {
            setState(() {
              _numbersOn = value;
            });
          }),
      GCWOnOffSwitch(
          title: 'ÄÂÃÇ...',
          value: _diacriticsOn,
          onChanged: (value) {
            setState(() {
              _diacriticsOn = value;
            });
          }),
      GCWOnOffSwitch(
          title: i18n(context, 'book_cipher_spaces'),
          value: _spacesOn,
          onChanged: (value) {
            setState(() {
              _spacesOn = value;
            });
          }),
      GCWOnOffSwitch(
          title: i18n(context, 'book_cipher_empty_lines'),
          value: _emptyLinesOn,
          onChanged: (value) {
            setState(() {
              _emptyLinesOn = value;
            });
          }),
      GCWOnOffSwitch(
          title: i18n(context, 'book_cipher_ignore_symbols'),
          value: _ignoreSymbolsOn,
          onChanged: (value) {
            setState(() {
              _ignoreSymbolsOn = value;
            });
          }),
      GCWTextField(
          controller: _ignoreSymbolsController,
          hintText: '.;+-:!?' '‘"&(){}[]/\\_',
          onChanged: (text) {
            setState(() {
              _ignoreSymbols = text;
            });
          }),
    ]);
  }

  Widget _buildEncodeFormatControl(
      BuildContext context, Map<encodeOutFormat, String> _bookChiffredEncodeOutFormatItems) {
    return GCWDropDown<encodeOutFormat>(
      value: _currentEncodeOutFormat,
      onChanged: (value) {
        setState(() {
          _currentEncodeOutFormat = value;
        });
      },
      items: _bookChiffredEncodeOutFormatItems.entries.map((item) {
        return GCWDropDownMenuItem(
          value: item.key,
          child: item.value,
        );
      }).toList(),
    );
  }

  String _buildOutput() {
    if (_currentSearchMode == GCWSwitchPosition.left) {
      return encodeText(_currentInput, _currentText, _currentEncodeOutFormat,
          spacesOn: _spacesOn,
          emptyLinesOn: _emptyLinesOn,
          ignoreSymbols: _ignoreSymbolsOn ? _ignoreSymbols : '',
          diacriticsOn: _diacriticsOn,
          azOn: _azOn,
          numbersOn: _numbersOn,
          onlyFirstWordLetter: _onlyFirstWordLetter);
    } else {
      if (_currentMode == GCWSwitchPosition.left) {
        return decodeFindWord(_currentInput, _currentPositions, _currentSearchFormat,
            spacesOn: _spacesOn,
            emptyLinesOn: _emptyLinesOn,
            ignoreSymbols: _ignoreSymbolsOn ? _ignoreSymbols : '',
            diacriticsOn: _diacriticsOn,
            azOn: _azOn,
            numbersOn: _numbersOn,
            onlyFirstWordLetter: _onlyFirstWordLetter);
      } else {
        return decodeSearchWord(_currentInput, _currentWord, _currentDecodeOutFormat,
            i18n(context, 'book_cipher_section'), i18n(context, 'book_cipher_row'), i18n(context, 'book_cipher_word'),
            spacesOn: _spacesOn,
            emptyLinesOn: _emptyLinesOn,
            ignoreSymbols: _ignoreSymbolsOn ? _ignoreSymbols : '',
            diacriticsOn: _diacriticsOn,
            azOn: _azOn,
            numbersOn: _numbersOn,
            onlyFirstWordLetter: _onlyFirstWordLetter);
      }
    }
  }
}
