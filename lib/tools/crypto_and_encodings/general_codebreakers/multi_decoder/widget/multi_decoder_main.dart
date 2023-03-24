part of 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';

class MultiDecoder extends StatefulWidget {
  const MultiDecoder({Key? key}) : super(key: key);

  @override
  MultiDecoderState createState() => MultiDecoderState();
}

class MultiDecoderState extends State<MultiDecoder> {
  late TextEditingController _controller;
  List<AbstractMultiDecoderTool> mdtTools = [];

  String _currentInput = '';
  Widget _currentOutput = Container();

  var _firstBuild = true;
  var _currentExpanded = false;
  String _currentKey = '';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _currentInput);

    refreshMultiDecoderTools();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _refreshMDTTools() {
    mdtTools = multiDecoderTools.map((mdtTool) {
      return _multiDecoderToolToGCWMultiDecoderTool(context, mdtTool);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_firstBuild && multiDecoderTools.isEmpty) {
      _initializeMultiToolDecoder(context);
      _firstBuild = false;
    }

    _refreshMDTTools();

    return Column(
      children: <Widget>[
        Row(
          children: [
            Expanded(
                child: Container(
                    padding: const EdgeInsets.only(right: DOUBLE_DEFAULT_MARGIN),
                    child: GCWTextField(
                      controller: _controller,
                      onChanged: (text) {
                        _currentInput = text;
                        if (_currentInput.isEmpty) {
                          setState(() {
                            _currentOutput = Container();
                          });
                        }
                      },
                    ))),
            GCWIconButton(
              icon: Icons.settings,
              onPressed: () {
                Navigator.push(
                        context,
                        NoAnimationMaterialPageRoute<GCWTool>(
                            builder: (context) =>
                                GCWTool(tool: _MultiDecoderConfiguration(), id: 'multidecoder_configuration')))
                    .whenComplete(() {
                  setState(() {
                    _currentOutput = Container();
                  });
                });
              },
            )
          ],
        ),
        _buildKeyWidget(),
        GCWSubmitButton(
          onPressed: () {
            setState(() {
              _calculateOutput();
            });
          },
        ),
        _currentOutput
      ],
    );
  }

  Widget _buildKeyWidget() {
    return Column(
      children: [
        GCWExpandableTextDivider(
          text: i18n(context, 'common_mode_advanced'),
          expanded: _currentExpanded,
          onChanged: (value) {
            setState(() {
              _currentExpanded = value;
            });
          },
          child: Row(
            children: [
              Expanded(flex: 1, child: GCWText(text: i18n(context, 'multidecoder_key'))),
              Expanded(
                  flex: 3,
                  child: GCWTextField(
                    onChanged: (text) {
                      setState(() {
                        _currentKey = text;
                      });
                    },
                  ))
            ],
          ),
        ),
      ],
    );
  }

  String _toolTitle(AbstractMultiDecoderTool tool) {
    var optionValues = tool.options.values.map((Object? value) {
      String result = value.toString();

      if (tool.internalToolName == MDT_INTERNALNAMES_COORDINATEFORMATS) {
        if (CoordinateFormatKey.values.contains(value)) {
          result = coordinateFormatMetadataByKey(value as CoordinateFormatKey).name;
        }
      }
      if ([MDT_INTERNALNAMES_BASE, MDT_INTERNALNAMES_BCD].contains(tool.internalToolName)) {
        result += '_title';
      }

      return i18n(context, result, ifTranslationNotExists: result);
    }).join(', ');

    var result = tool.name;
    if (optionValues.isNotEmpty) result += ' ($optionValues)';

    return result;
  }

  void _calculateOutput() {
    var results = mdtTools.map((tool) {
      Object? result;

      try {
        if (!tool.optionalKey &&
            ((tool.requiresKey && _currentKey.isEmpty) || !tool.requiresKey && (_currentKey.isNotEmpty))) {
          result = null;
        } else {
          result = tool.onDecode(_currentInput, _currentKey);
        }
      } catch (e) {}

      if (result is Future<String>) {
        return FutureBuilder<String>(
            future: result,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.hasData && (snapshot.data is String) && (snapshot.data!.isNotEmpty)) {
                return GCWOutput(title: _toolTitle(tool), child: snapshot.data);
              } else {
                return Container();
              }
            });
      } else if (result is Future<String?>) {
        return FutureBuilder<String?>(
            future: result,
            builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
              if (snapshot.hasData && snapshot.data != null &&
                  snapshot.data!.isNotEmpty) {
                return GCWOutput(title: _toolTitle(tool), child: snapshot.data);
              } else {
                return Container();
              }
            });
      } else if (result is Future<Uint8List>) {
        return FutureBuilder<Uint8List>(
            future: result,
            builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
              if (snapshot.hasData && snapshot.data is Uint8List && ((snapshot.data as Uint8List).isNotEmpty)) {
                return GCWOutput(
                    title: _toolTitle(tool),
                    child: GCWImageView(
                        imageData:
                            GCWImageViewData(GCWFile(bytes: (snapshot.data as Uint8List), name: _toolTitle(tool)))));
              } else {
                return Container();
              }
            });
      } else if (result is Future<Uint8List?>) {
        return FutureBuilder<Uint8List?>(
            future: result,
            builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
              if (snapshot.hasData && snapshot.data is Uint8List && ((snapshot.data as Uint8List).isNotEmpty)) {
                return GCWOutput(
                    title: _toolTitle(tool),
                    child: GCWImageView(
                        imageData:
                        GCWImageViewData(GCWFile(bytes: (snapshot.data as Uint8List), name: _toolTitle(tool)))));
              } else {
                return Container();
              }
            });
      } else if (result != null && result.toString().isNotEmpty) {
        return GCWOutput(
          title: _toolTitle(tool),
          child: result.toString(),
        );
      } else {
        return Container();
      }
    }).toList();

    _currentOutput = Column(children: results);
  }
}
