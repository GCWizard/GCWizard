part of 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';

class _MultiDecoderConfiguration extends StatefulWidget {
  @override
  _MultiDecoderConfigurationState createState() => _MultiDecoderConfigurationState();
}

class _MultiDecoderConfigurationState extends State<_MultiDecoderConfiguration> {
  late TextEditingController _editingToolNameController;

  int? _currentChosenTool;
  String _editingToolName = '';

  int? _currentEditId;

  List<String> _sortedToolRegistry = [];
  List<AbstractMultiDecoderTool> mdtTools = [];

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

  bool _nameExists(String name) {
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

  void _addNewTool() {
    var chosenInternalName =  _currentChosenTool != null ? _sortedToolRegistry[_currentChosenTool!] : '';
    var name = _createName(chosenInternalName);

    var nameOccurrences = mdtTools.where((tool) => tool.name == name).length;
    if (nameOccurrences > 0) name = '$name ${nameOccurrences + 1}';

    var tool = MultiDecoderToolEntity(
      name,
      chosenInternalName,
    );

    var mdtTool = _multiDecoderToolToGCWMultiDecoderTool(context, tool);
    tool.options = mdtTool.options.entries.map((option) {
      return MultiDecoderToolOption(option.key, option.value);
    }).toList();

    _currentEditId = insertMultiDecoderTool(tool);
    _editingToolNameController.text = name;
    _editingToolName = name;

    mdtTools.insert(0, _multiDecoderToolToGCWMultiDecoderTool(context, tool));
  }

  void _updateTool(AbstractMultiDecoderTool tool) {
    var multiDecoderTool = findMultiDecoderToolById(tool.id);
    multiDecoderTool.name = tool.name;
    multiDecoderTool.options = tool.options.entries.map((option) {
      return MultiDecoderToolOption(option.key, option.value);
    }).toList();

    updateMultiDecoderTool(multiDecoderTool);
  }

  void _deleteTool(int id) {
    deleteMultiDecoderTool(id);
    mdtTools.removeWhere((tool) => tool.id == id);
  }

  void _clearTools() {
    clearMultiDecoderTools();
    mdtTools.clear();
  }

  void _refreshMDTTools() {
    mdtTools = multiDecoderTools.map((mdtTool) {
      return _multiDecoderToolToGCWMultiDecoderTool(context, mdtTool);
    }).toList();
  }

  void _moveUp(int id) {
    var oldIndex = moveMultiDecoderToolUp(id);
    if (oldIndex > 0) {
      var mdtTool = mdtTools.removeAt(oldIndex);
      mdtTools.insert(oldIndex - 1, mdtTool);
    }
  }

  void _moveDown(int id) {
    var oldIndex = moveMultiDecoderToolDown(id);
    if (oldIndex < mdtTools.length - 1) {
      var mdtTool = mdtTools.removeAt(oldIndex);
      mdtTools.insert(oldIndex + 1, mdtTool);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (mdtTools.isEmpty) {
      _refreshMDTTools();

      if (_sortedToolRegistry.isEmpty) {
        _sortedToolRegistry = List.from(_mdtToolsRegistry);
        _sortedToolRegistry.sort((a, b) {
          return i18n(context, a).compareTo(i18n(context, b));
        });

        _currentChosenTool = _sortedToolRegistry.indexOf(MDT_INTERNALNAMES_ROTATION);
      }
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
                padding: const EdgeInsets.only(right: DOUBLE_DEFAULT_MARGIN),
                child: GCWDropDown<int>(
                  value: _currentChosenTool ?? -1,
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
                )),
          ),
          GCWIconButton(
            icon: Icons.add,
            iconColor: _currentEditId == null ? null : themeColors().inActive(),
            onPressed: () {
                if (_currentEditId == null) {
                  setState(() {
                    _addNewTool();
                  });
                }
              }
          ),
        ]),
        GCWTextDivider(
          text: i18n(context, 'multidecoder_configuration_configurecreated'),
        ),
        _buildToollist()
      ],
    );
  }

  Widget _buildToollist() {
    var odd = true;
    var rows = mdtTools.map((tool) {
      var row = Row(
        children: [
          Expanded(
              child: _currentEditId == tool.id
                  ? Container(
                      padding: const EdgeInsets.only(right: DOUBLE_DEFAULT_MARGIN),
                      child: Column(children: [
                        Row(
                          children: [
                            Expanded(flex: 1, child: GCWText(text: i18n(context, 'multidecoder_configuration_name'))),
                            Expanded(
                                flex: 3,
                                child: GCWTextField(
                                  controller: _editingToolNameController,
                                  onChanged: (value) {
                                    _editingToolName = value;
                                  },
                                ))
                          ],
                        ),
                        tool.configurationWidget ?? Container()
                      ]))
                  : Column(
                      children: [
                        GCWText(text: tool.name),
                        Container(
                          padding: const EdgeInsets.only(left: DEFAULT_DESCRIPTION_MARGIN),
                          child: GCWText(
                            text: tool.options.entries.map((entry) {
                              var value = entry.value.toString();

                              if (tool.internalToolName == MDT_INTERNALNAMES_COORDINATEFORMATS) {
                                value = coordinateFormatMetadataByPersistenceKey(value)?.name ?? UNKNOWN_ELEMENT;
                              } else if ([MDT_INTERNALNAMES_BASE, MDT_INTERNALNAMES_BCD]
                                  .contains(tool.internalToolName)) {
                                value += '_title';
                              }

                              return '${i18n(context, entry.key)}: ${i18n(context, value.toString(), ifTranslationNotExists: value)}';
                            }).join('\n'),
                            style: gcwDescriptionTextStyle(),
                          ),
                        )
                      ],
                    )),
          Column(
            children: [
              _currentEditId == tool.id
                  ? GCWIconButton(
                      icon: Icons.check,
                      onPressed: () {
                        if (_editingToolName.isNotEmpty) {
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
