part of 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';

class MultiDecoder extends StatefulWidget {
  @override
  MultiDecoderState createState() => MultiDecoderState();
}

class MultiDecoderState extends State<MultiDecoder> {
  var _controller;
  List<AbstractMultiDecoderTool> mdtTools;

  String _currentInput = '';
  Widget _currentOutput;

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

  _refreshMDTTools() {
    mdtTools = model.multiDecoderTools.map((mdtTool) {
      return _multiDecoderToolToGCWMultiDecoderTool(context, mdtTool);
    }).toList();
    mdtTools.removeWhere((mdtTool) => mdtTool == null);
  }

  @override
  Widget build(BuildContext context) {
    if (_firstBuild && model.multiDecoderTools.length == 0) {
      _initializeMultiToolDecoder(context);
      _firstBuild = false;
    }

    _refreshMDTTools();

    if (_currentOutput == null) _initOutput();

    return Column(
      children: <Widget>[
        Row(
          children: [
            Expanded(
                child: Container(
                    child: GCWTextField(
                      controller: _controller,
                      onChanged: (text) {
                        _currentInput = text;
                        if (_currentInput == null || _currentInput.length == 0) {
                          setState(() {
                            _currentOutput = null;
                          });
                        }
                      },
                    ),
                    padding: EdgeInsets.only(right: DOUBLE_DEFAULT_MARGIN))),
            GCWIconButton(
              icon: Icons.settings,
              onPressed: () {
                Navigator.push(
                        context,
                        NoAnimationMaterialPageRoute(
                            builder: (context) =>
                                GCWTool(tool: _MultiDecoderConfiguration(), i18nPrefix: 'multidecoder_configuration')))
                    .whenComplete(() {
                  setState(() {
                    _currentOutput = null;
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
              Expanded(child: GCWText(text: i18n(context, 'multidecoder_key')), flex: 1),
              Expanded(
                  child: GCWTextField(
                    onChanged: (text) {
                      setState(() {
                        _currentKey = text;
                      });
                    },
                  ),
                  flex: 3)
            ],
          ),
        ),
      ],
    );
  }

  _toolTitle(AbstractMultiDecoderTool tool) {
    var optionValues = tool.options.values.map((value) {
      var result = value;

      if (tool.internalToolName == MDT_INTERNALNAMES_COORDINATEFORMATS) {
        result = getCoordinateFormatByKey(value).name;
      }
      if ([MDT_INTERNALNAMES_BASE, MDT_INTERNALNAMES_BCD].contains(tool.internalToolName)) {
        result += '_title';
      }

      return i18n(context, result.toString()) ?? result;
    }).join(', ');

    var result = tool.name;
    if (optionValues != null && optionValues.length > 0) result += ' ($optionValues)';

    return result;
  }

  _initOutput() {
    _currentOutput = Column(
        children: mdtTools.map((tool) {
      return GCWTextDivider(text: _toolTitle(tool));
    }).toList());
  }

  _calculateOutput() {
    var results = mdtTools.map((tool) {
      var result;

      try {
        if (!tool.optionalKey &&
            ((tool.requiresKey && (_currentKey ?? '').isEmpty) ||
                !tool.requiresKey && (_currentKey != null && _currentKey.isNotEmpty))) {
          result = null;
        } else {
          result = tool.onDecode(_currentInput, _currentKey);
        }
      } catch (e) {}

      if (result is Future<String>) {
        return FutureBuilder(
            future: result,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData && snapshot.data is String && ((snapshot.data as String).length != 0)) {
                return GCWOutput(title: _toolTitle(tool), child: snapshot.data);
              } else
                return Container();
            });
      } else if (result is Future<Uint8List>) {
        return FutureBuilder(
            future: result,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData && snapshot.data is Uint8List && ((snapshot.data as Uint8List).length > 0)) {
                return GCWOutput(
                    title: _toolTitle(tool),
                    child: GCWImageView(
                        imageData:
                            GCWImageViewData(GCWFile(bytes: (snapshot.data as Uint8List), name: _toolTitle(tool)))));
              } else
                return Container();
            });
      } else if (result != null && result.toString().isNotEmpty) {
        return GCWOutput(
          title: _toolTitle(tool),
          child: result.toString(),
        );
      } else
        return Container();
    }).toList();

    _currentOutput = Column(children: results);
  }
}
