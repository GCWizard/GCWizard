part of 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';

class _MultiDecoderConfiguration extends StatefulWidget {
  @override
  _MultiDecoderConfigurationState createState() => _MultiDecoderConfigurationState();
}

class _MultiDecoderConfigurationState extends State<_MultiDecoderConfiguration> {
  TextEditingController _editingToolNameController;

  int _currentChosenTool;
  String _editingToolName = '';

  int _currentEditId;

  List<String> _sortedToolRegistry;
  List<AbstractMultiDecoderTool> mdtTools;

  @override
  void initState() {
    super.initState();
    _editingToolNameController = TextEditingController(text: _editingToolName);

    refreshMultiDecoderTools();
  }

  @override
  void dispose() {
    _editingToolNameController.dispose();

    super.dispose();
  }

  _nameExists(name) {
    return mdtTools.indexWhere((tool) => tool.name == name) >= 0;
  }

  String _createName(String chosenInternalName) {
    var baseName = i18n(context, chosenInternalName);
    var name = baseName;

    int nameCounter = 1;
    while (_nameExists(name)) {
      name = '$baseName ${++nameCounter}';
    }

    return name;
  }

  _addNewTool() {
    var chosenInternalName = _sortedToolRegistry[_currentChosenTool];
    var name = _createName(chosenInternalName);

    var nameOccurrences = mdtTools.where((tool) => tool.name == name).length;
    if (nameOccurrences > 0) name = '$name ${nameOccurrences + 1}';

    var tool = model.MultiDecoderToolEntity(
      name,
      chosenInternalName,
    );

    var mdtTool = _multiDecoderToolToGCWMultiDecoderTool(context, tool);
    tool.options = mdtTool.options.entries.map((option) {
      return model.MultiDecoderToolOption(option.key, option.value);
    }).toList();

    _currentEditId = insertMultiDecoderTool(tool);
    _editingToolNameController.text = name;
    _editingToolName = name;

    mdtTools.insert(0, _multiDecoderToolToGCWMultiDecoderTool(context, tool));
  }

  _updateTool(AbstractMultiDecoderTool tool) {
    var multiDecoderTool = model.findMultiDecoderToolById(tool.id);
    multiDecoderTool.name = tool.name;
    multiDecoderTool.options = tool.options.entries.map((option) {
      return model.MultiDecoderToolOption(option.key, option.value);
    }).toList();

    updateMultiDecoderTool(multiDecoderTool);
  }

  _deleteTool(int id) {
    deleteMultiDecoderTool(id);
    mdtTools.removeWhere((tool) => tool.id == id);
  }

  _clearTools() {
    clearMultiDecoderTools();
    mdtTools.clear();
  }

  _refreshMDTTools() {
    mdtTools = model.multiDecoderTools.map((mdtTool) {
      return _multiDecoderToolToGCWMultiDecoderTool(context, mdtTool);
    }).toList();
    mdtTools.removeWhere((mdtTool) => mdtTool == null);
  }

  _moveUp(int id) {
    var oldIndex = moveMultiDecoderToolUp(id);
    if (oldIndex > 0) {
      var mdtTool = mdtTools.removeAt(oldIndex);
      mdtTools.insert(oldIndex - 1, mdtTool);
    }
  }

  _moveDown(int id) {
    var oldIndex = moveMultiDecoderToolDown(id);
    if (oldIndex < mdtTools.length - 1) {
      var mdtTool = mdtTools.removeAt(oldIndex);
      mdtTools.insert(oldIndex + 1, mdtTool);
    }
  }

  @override
  Widget build(BuildContext context) {
    _refreshMDTTools();

    if (_sortedToolRegistry == null) {
      _sortedToolRegistry = List.from(_mdtToolsRegistry);
      _sortedToolRegistry.sort((a, b) {
        return i18n(context, a).compareTo(i18n(context, b));
      });

      _currentChosenTool = _sortedToolRegistry.indexOf(MDT_INTERNALNAMES_ROTATION);
    }

    return Column(
      children: <Widget>[
        GCWButton(
          text: i18n(context, 'multidecoder_configuration_reset'),
          onPressed: () {
            showGCWAlertDialog(context, i18n(context, 'multidecoder_configuration_reset_title'),
                i18n(context, 'multidecoder_configuration_reset_text'), () {
              _clearTools();
              _initializeMultiToolDecoder(context);
              setState(() {});
            });
          },
        ),
        GCWTextDivider(
          text: i18n(context, 'multidecoder_configuration_addtool'),
        ),
        Row(children: [
          Expanded(
            child: Container(
                child: GCWDropDown(
                  value: _currentChosenTool,
                  onChanged: (value) {
                    setState(() {
                      _currentChosenTool = value;
                    });
                  },
                  items: _sortedToolRegistry
                      .asMap()
                      .map((index, toolName) {
                        return MapEntry(
                            index,
                            GCWDropDownMenuItem(
                                value: index,
                                child: i18n(context, toolName),
                                subtitle: i18n(context, 'multidecoder_configuration_counttoolused',
                                    parameters: [mdtTools.where((tool) => tool.internalToolName == toolName).length])));
                      })
                      .values
                      .toList(),
                ),
                padding: EdgeInsets.only(right: DOUBLE_DEFAULT_MARGIN)),
          ),
          GCWIconButton(
            icon: Icons.add,
            iconColor: _currentEditId == null ? null : themeColors().inActive(),
            onPressed: _currentEditId == null
                ? () {
                    setState(() {
                      _addNewTool();
                    });
                  }
                : null,
          ),
        ]),
        GCWTextDivider(
          text: i18n(context, 'multidecoder_configuration_configurecreated'),
        ),
        _buildToollist()
      ],
    );
  }

  _buildToollist() {
    var odd = true;
    var rows = mdtTools.map((tool) {
      var row = Row(
        children: [
          Expanded(
              child: _currentEditId == tool.id
                  ? Container(
                      child: Column(children: [
                        Row(
                          children: [
                            Expanded(child: GCWText(text: i18n(context, 'multidecoder_configuration_name')), flex: 1),
                            Expanded(
                                child: GCWTextField(
                                  controller: _editingToolNameController,
                                  onChanged: (value) {
                                    _editingToolName = value;
                                  },
                                ),
                                flex: 3)
                          ],
                        ),
                        tool.configurationWidget ?? Container()
                      ]),
                      padding: EdgeInsets.only(right: DOUBLE_DEFAULT_MARGIN))
                  : Column(
                      children: [
                        GCWText(text: tool.name),
                        Container(
                          child: GCWText(
                            text: tool.options.entries.map((entry) {
                              var value = entry.value;

                              if (tool.internalToolName == MDT_INTERNALNAMES_COORDINATEFORMATS) {
                                value = getCoordinateFormatByKey(entry.value).name;
                              } else if ([MDT_INTERNALNAMES_BASE, MDT_INTERNALNAMES_BCD]
                                  .contains(tool.internalToolName)) {
                                value += '_title';
                              }

                              return '${i18n(context, entry.key)}: ${i18n(context, value.toString()) ?? value}';
                            }).join('\n'),
                            style: gcwDescriptionTextStyle(),
                          ),
                          padding: EdgeInsets.only(left: DEFAULT_DESCRIPTION_MARGIN),
                        )
                      ],
                    )),
          Column(
            children: [
              _currentEditId == tool.id
                  ? GCWIconButton(
                      icon: Icons.check,
                      onPressed: () {
                        if (_editingToolName.length > 0) {
                          tool.name = _editingToolName;
                        }
                        _updateTool(tool);

                        setState(() {
                          _currentEditId = null;
                          _editingToolNameController.text = '';
                          _editingToolName = '';
                        });
                      },
                    )
                  : GCWIconButton(
                      icon: Icons.edit,
                      onPressed: () {
                        setState(() {
                          _currentEditId = tool.id;
                          _editingToolNameController.text = tool.name;
                          _editingToolName = tool.name;
                        });
                      },
                    ),
              GCWIconButton(
                icon: Icons.remove,
                onPressed: () {
                  setState(() {
                    showDeleteAlertDialog(context, tool.name, () {
                      setState(() {
                        if (_currentEditId == tool.id) _currentEditId = null;
                        _deleteTool(tool.id);
                      });
                    });
                  });
                },
              )
            ],
          ),
          Column(
            children: [
              GCWIconButton(
                icon: Icons.arrow_drop_up,
                onPressed: () {
                  setState(() {
                    _moveUp(tool.id);
                  });
                },
              ),
              GCWIconButton(
                icon: Icons.arrow_drop_down,
                onPressed: () {
                  setState(() {
                    _moveDown(tool.id);
                  });
                },
              )
            ],
          )
        ],
      );

      Widget output;
      if (odd) {
        output = Container(color: themeColors().outputListOddRows(), child: row);
      } else {
        output = Container(child: row);
      }
      odd = !odd;

      return output;
    }).toList();

    return Column(
      children: rows,
    );
  }
}
