import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/theme/theme.dart';
import 'package:gc_wizard/theme/theme_colors.dart';
import 'package:gc_wizard/widgets/common/base/gcw_iconbutton.dart';
import 'package:gc_wizard/widgets/common/base/gcw_textfield.dart';
import 'package:gc_wizard/widgets/common/gcw_buttonbar.dart';
import 'package:gc_wizard/widgets/common/gcw_default_output.dart';
import 'package:gc_wizard/widgets/common/gcw_onoff_switch.dart';
import 'package:gc_wizard/widgets/common/gcw_symbol_container.dart';
import 'package:gc_wizard/widgets/common/gcw_twooptions_switch.dart';
import 'package:gc_wizard/widgets/utils/common_widget_utils.dart';
import 'package:prefs/prefs.dart';

final SYMBOLTABLES_ASSETPATH = 'assets/symbol_tables/';
final _SYMBOL_NOT_FOUND_PATH = SYMBOLTABLES_ASSETPATH + '404.png';

class SymbolTable extends StatefulWidget {
  final String symbolKey;
  final bool isCaseSensitive;

  const SymbolTable({Key key, this.symbolKey, this.isCaseSensitive: false}) : super(key: key);

  @override
  SymbolTableState createState() => SymbolTableState();
}

class SymbolTableState extends State<SymbolTable> {
  final SPECIAL_MARKER = '[#*?SPECIAL_MARKER%&]';

  String _output = '';

  var _images = <Map<String, Image>>[]; //SplayTreeMap<String, Widget>();
  var _currentMode = GCWSwitchPosition.right;

  var _currentShowOverlayedSymbols = true;

  var _currentInput = '';
  var _inputController;

  var _alphabetMap = <String, Image>{};
  var _maxSymbolTextLength = 0;

  @override
  void initState() {
    super.initState();

    _initImages();
    _inputController = TextEditingController(text: _currentInput);
  }

  @override
  void dispose() {
    _inputController.dispose();

    super.dispose();
  }

  Future _initImages() async {
    //AssetManifest.json keeps the information about all asset files
    final manifestContent = await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    var pathKey = SYMBOLTABLES_ASSETPATH + widget.symbolKey + '/';
    var imageSuffixes = RegExp(r'\.(png|jpg|bmp|gif)', caseSensitive: false);
    
    final imagePaths = manifestMap.keys
      .where((String key) => key.contains(pathKey))
      .where((String key) => imageSuffixes.hasMatch(key))
      .toList();

    setState(() {
      _images = imagePaths
        .map((filePath) {
            var imageKey = filePath.split(pathKey)[1].split(imageSuffixes)[0];

            var ascii = int.tryParse(imageKey.split('_')[0]);
            String key = ascii == null ? _getSpecialText(imageKey) : String.fromCharCode(ascii);

            var imagePath = imageSuffixes.hasMatch(filePath) ? filePath : null;
            var value = Image.asset(imagePath);

            return {key : value};
          })
        .where((element) => element.values.first != null)
        .toList();

      _images.sort((a, b) {
        var keyA = a.keys.first;
        var keyB = b.keys.first;

        var intA = int.tryParse(keyA);
        var intB = int.tryParse(keyB);

        if (intA == null) {
          if (intB == null) {
            if (keyA.startsWith(SPECIAL_MARKER)) {
              if (keyB.startsWith(SPECIAL_MARKER)) {
                return keyA.compareTo(keyB);
              } else {
                return 1;
              }
            } else {
              if (keyB.startsWith(SPECIAL_MARKER)) {
                return -1;
              } else {
                return keyA.compareTo(keyB);
              }
            }
          } else {
            return 1;
          }
        } else {
          if (intB == null) {
            return -1;
          } else {
            return intA.compareTo(intB);
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    var countColumns = mediaQueryData.orientation == Orientation.portrait
      ? Prefs.get('symboltables_countcolumns_portrait')
      : Prefs.get('symboltables_countcolumns_landscape');

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: GCWTwoOptionsSwitch(
                value: _currentMode,
                onChanged: (value) {
                  setState(() {
                    _currentMode = value;
                  });
                },
              )
            ),
            Container(
              width: 2 * 40.0,
            )
          ],
        ),
        _currentMode == GCWSwitchPosition.left
          //Encryption
          ? Column(
              children: <Widget>[
                GCWTextField(
                  controller: _inputController,
                  onChanged: (text) {
                    setState(() {
                      _currentInput = text;
                    });
                  },
                ),
                GCWDefaultOutput(
                  child: _buildEncryptionOutput(countColumns, widget.isCaseSensitive)
                ),
              ],
            )
          //Decryption
          : Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: GCWOnOffSwitch (
                        value: _currentShowOverlayedSymbols,
                        title: i18n(context, 'symboltables_showoverlay'),
                        onChanged: (value) {
                          setState(() {
                            _currentShowOverlayedSymbols = value;
                          });
                        },
                      ),
                      flex: 4
                    ),
                    GCWIconButton(
                      iconData: Icons.zoom_in,
                      onPressed: () {
                        setState(() {
                          int newCountColumn = max(countColumns - 1, 1);

                          mediaQueryData.orientation == Orientation.portrait
                            ? Prefs.setInt('symboltables_countcolumns_portrait', newCountColumn)
                            : Prefs.setInt('symboltables_countcolumns_landscape', newCountColumn);
                        });
                      },
                    ),
                    GCWIconButton(
                      iconData: Icons.zoom_out,
                      onPressed: () {
                        setState(() {
                          int newCountColumn = countColumns + 1;

                          mediaQueryData.orientation == Orientation.portrait
                            ? Prefs.setInt('symboltables_countcolumns_portrait', newCountColumn)
                            : Prefs.setInt('symboltables_countcolumns_landscape', newCountColumn);
                        });
                      },
                    )
                  ],
                ),
                _buildDecryptionButtonMatrix(countColumns, widget.isCaseSensitive),
                GCWDefaultOutput(
                  child: _output
                )
              ],
            )
      ],
    );
  }

  List<Image> _getImagePaths(bool isCaseSensitive) {
    var _text = _currentInput;
    var imagePaths = <Image>[];

    while (_text.length > 0) {
      var imagePath;
      int i;
      for (i = min(_maxSymbolTextLength, _text.length); i > 0; i--) {
        var chunk = _text.substring(0, i);

        if (isCaseSensitive) {
          if (_alphabetMap.containsKey(chunk)) {
            imagePath = _alphabetMap[chunk];
            break;
          }
        } else {
          if (_alphabetMap.containsKey(chunk.toUpperCase())) {
            imagePath = _alphabetMap[chunk.toUpperCase()];
            break;
          }
        }
      }

      imagePaths.add(imagePath);

      if (imagePath == null)
        _text = _text.substring(1, _text.length);
      else
        _text = _text.substring(i, _text.length);
    }

    return imagePaths;
  }

  _buildEncryptionOutput(countColumns, isCaseSensitive) {
    var rows = <Widget>[];
    var countRows = (_currentInput.length / countColumns).floor();

    var images = _getImagePaths(isCaseSensitive);

    for (var i = 0; i <= countRows; i++) {
      var columns = <Widget>[];

      for (var j = 0; j < countColumns; j++) {
        var widget;
        var imageIndex = i * countColumns + j;

        if (imageIndex < images.length) {
          var image = images[imageIndex];

          if (image == null) {
            image = Image.asset(_SYMBOL_NOT_FOUND_PATH);
          }

          widget = GCWSymbolContainer(
            symbol: image,
          );

        } else {
          widget = Container();
        }

        columns.add(Expanded(
          child: Container(
            child: widget,
            padding: EdgeInsets.all(3),
          )
        ));
      }

      rows.add(Row(
        children: columns,
      ));
    }

    return Column(
      children: rows,
    );
  }

  _getSpecialText(String key) {
    return (key.startsWith('special_') ? SPECIAL_MARKER : '') + i18n(context, 'symboltables_' + widget.symbolKey + '_' + key);
  }
  
  _showSpaceSymbolInOverlay(text) {
    return text == ' ' ? String.fromCharCode(9251) : text;
  }

  _buildDecryptionButtonMatrix(countColumns, isCaseSensitive) {
    var rows = <Widget>[];
    var countRows = (_images.length / countColumns).floor();

    ThemeColors colors = themeColors();

    for (var i = 0; i <= countRows; i++) {
      var columns = <Widget>[];

      for (var j = 0; j < countColumns; j++) {
        var widget;
        var imageIndex = i * countColumns + j;

        if (imageIndex < _images.length) {
          var symbolText = _images.map((element) => element.keys.first).toList()[imageIndex].replaceAll(SPECIAL_MARKER, '');
          var image = _images.map((element) => element.values.first).toList()[imageIndex];

          if (symbolText.length > _maxSymbolTextLength)
            _maxSymbolTextLength = symbolText.length;

          if (isCaseSensitive)
            _alphabetMap.putIfAbsent(symbolText, () => image);
          else
            _alphabetMap.putIfAbsent(symbolText.toUpperCase(), () => image);

          widget = InkWell(
            child: Stack(
              overflow: Overflow.clip,
              children: <Widget>[
                GCWSymbolContainer(
                  symbol: image,
                ),
                _currentShowOverlayedSymbols
                  ? Opacity(
                      child:  Container(
                        //TODO: Using GCWText instead: Currently it would expand the textfield width to max.
                        child: Text(
                          _showSpaceSymbolInOverlay(symbolText),
                          style: gcwTextStyle().copyWith(
                            color: colors.dialogText(),
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        height: defaultFontSize() + 5,
                        decoration: ShapeDecoration(
                          color: colors.dialog(),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(roundedBorderRadius)),
                          )
                        ),
                      ),
                      opacity: 0.85
                    )
                  : Container()
              ],
            ),
            onTap: () {
              setState(() {
                _output += symbolText;
              });
            },
          );
        } else {
          widget = Container();
        }

        columns.add(Expanded(
          child: Container(
            child: widget,
            padding: EdgeInsets.all(3),
          )
        ));
      }

      rows.add(Row(
        children: columns,
      ));
    }

    rows.add(
      GCWToolBar(
        children: [
          GCWIconButton(
            iconData: Icons.space_bar,
            onPressed: () {
              setState(() {
                _output += ' ';
              });
            },
          ),
          GCWIconButton(
            iconData: Icons.backspace,
            onPressed: () {
              setState(() {
                if (_output.length > 0)
                  _output = _output.substring(0, _output.length - 1) ;
              });
            },
          ),
          GCWIconButton(
            iconData: Icons.clear,
            onPressed: () {
              setState(() {
                _output = '';
              });
            },
          )
        ]
      )
    );

    return Column(
      children: rows,
    );
  }
}