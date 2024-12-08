import 'dart:convert';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/navigation/no_animation_material_page_route.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_button.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_paste_button.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/common_widgets/clipboard/gcw_clipboard.dart';
import 'package:gc_wizard/common_widgets/dialogs/gcw_delete_alertdialog.dart';
import 'package:gc_wizard/common_widgets/dialogs/gcw_dialog.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/gcw_popup_menu.dart';
import 'package:gc_wizard/common_widgets/gcw_snackbar.dart';
import 'package:gc_wizard/common_widgets/gcw_stringlisteditor.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/application/tools/widget/gcw_tool.dart';
import 'package:gc_wizard/common_widgets/gcw_text_export.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/general_tools/randomizer/logic/randomizer_lists.dart';
import 'package:gc_wizard/tools/general_tools/randomizer/persistance/json_provider.dart';
import 'package:gc_wizard/tools/general_tools/randomizer/persistance/model.dart';
import 'package:gc_wizard/utils/file_utils/file_utils.dart';
import 'package:gc_wizard/utils/json_utils.dart';
import 'package:gc_wizard/utils/string_utils.dart';

part 'package:gc_wizard/tools/general_tools/randomizer/widget/randomizer_lists/randomizer_lists_elements.dart';
part 'package:gc_wizard/tools/general_tools/randomizer/widget/randomizer_lists/randomizer_lists_list.dart';
part 'package:gc_wizard/tools/general_tools/randomizer/widget/randomizer_lists/randomizer_lists_groups.dart';
part 'package:gc_wizard/tools/general_tools/randomizer/widget/randomizer_lists/randomizer_lists_shuffle.dart';

class RandomizerLists extends StatefulWidget {
  const RandomizerLists({Key? key}) : super(key: key);

  @override
  _RandomizerListsState createState() => _RandomizerListsState();
}

class _RandomizerListsState extends State<RandomizerLists> {
  late TextEditingController _newEntryController;
  late TextEditingController _editEntryController;
  var _currentNewName = '';
  var _currentEditedName = '';

  String? _currentEditName;

  @override
  void initState() {
    super.initState();

    _newEntryController = TextEditingController(text: _currentNewName);
    _editEntryController = TextEditingController(text: _currentEditedName);

    refreshRandomizerLists();
  }

  @override
  void dispose() {
    _newEntryController.dispose();
    _editEntryController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTextDivider(
            text: i18n(context, 'randomizer_lists_addnewlist'),
            trailing: GCWPasteButton(
                iconSize: IconButtonSize.SMALL,
                onSelected: (String data) {
                  try {
                    setState(() {
                      _importLists(data);
                    });

                    showSnackBar(i18n(context, 'randomizer_lists_imported'), context);
                  } catch (e) {
                    showSnackBar(i18n(context, 'randomizer_lists_importerror'), context);
                  }

                })),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 2,
                ),
                child: GCWTextField(
                  hintText: i18n(context, 'randomizer_lists_listname_hint'),
                  controller: _newEntryController,
                  onChanged: (text) {
                    setState(() {
                      _currentNewName = text;
                    });
                  },
                ),
              ),
            ),
            GCWIconButton(
              icon: Icons.add,
              onPressed: () {
                _addNewList(_currentNewName);

                setState(() {
                  _currentNewName = '';
                  _newEntryController.clear();
                });
              },
            )
          ],
        ),
        GCWTextDivider(text: i18n(context, 'randomizer_lists_lists')),
        _buildList()
      ],
    );
  }

  Widget _buildList() {
    var odd = false;
    return Column(
      children: randomizerLists.map((RandomizerList list) {
        odd = !odd;
        return _buildRow(list, odd);
      }).toList()
    );
  }

  Widget _buildRow(RandomizerList list, bool odd) {
    Widget output;

    var row = InkWell(
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: _currentEditName == list.name
               ? Padding(
                  padding: const EdgeInsets.only(
                    right: 2,
                  ),
                  child: GCWTextField(
                    controller: _editEntryController,
                    autofocus: true,
                    onChanged: (text) {
                      setState(() {
                        _currentEditedName = text;
                      });
                    },
                  ),
                )
               : IgnorePointer(
                  child: Column(
                    children: [
                      GCWText(text: list.name),
                      Container(
                        padding: const EdgeInsets.only(left: DEFAULT_DESCRIPTION_MARGIN),
                        child: GCWText(
                          text: list.list.length.toString() + ' ' + (list.list.length == 1 ? i18n(context, 'common_element') : i18n(context, 'common_elements')),
                          style: gcwDescriptionTextStyle()
                        )
                      ),
                    ],
                  )
                ),
            ),
            _currentEditName == list.name
              ? GCWIconButton(
                  icon: Icons.check,
                  onPressed: () {
                    if (_currentEditName != _currentEditedName) {
                      _updateList(_currentEditName!, _currentEditedName);
                    }

                    setState(() {
                      _currentEditName = null;
                      _editEntryController.clear();
                    });
                  }
                )
              : Container(),
            GCWPopupMenu(
                icon: Icons.settings,
                menuItemBuilder: (context) => [
                  GCWPopupMenuItem(
                      child: iconedGCWPopupMenuItem(
                        context,
                        Icons.edit,
                        'randomizer_lists_editlist'
                      ),
                      action: (index) => setState(() {
                        _currentEditName = list.name;
                        _currentEditedName = list.name;
                        _editEntryController.text = list.name;
                      })),
                  GCWPopupMenuItem(
                      child: iconedGCWPopupMenuItem(
                          context,
                          Icons.delete,
                          'randomizer_lists_deletelist'
                      ),
                      action: (index) => showDeleteAlertDialog(context, list.name, () {
                        if (list.name.isNotEmpty) {
                          _removeList(list.name);
                        }
                          setState(() {});
                      })),
                  GCWPopupMenuItem(
                      child: iconedGCWPopupMenuItem(
                        context,
                        Icons.forward,
                        'randomizer_lists_exportlist'
                      ),
                      action: (index) => _exportList(list.name)),
                ])
          ],
        ),
        onTap: () {
          if (list.name.isNotEmpty) {
            var listTool = _buildNavigateGCWTool(list.name);
            if (listTool != null) {
              Navigator.push(context, NoAnimationMaterialPageRoute<GCWTool>(builder: (context) => listTool))
                  .whenComplete(() {
                setState(() {});
              });
            }
          }
          //_navigateToSubPage(context);
        });

    if (odd) {
      output = Container(color: themeColors().outputListOddRows(), child: row);
    } else {
      output = Container(child: row);
    }
    odd = !odd;

    return output;
  }

  void _exportList(String name) {
    var list = randomizerLists.firstWhereOrNull((list) => list.name == name);
    if (list == null) {
      return;
    }

    String text = jsonEncode(list.toMap()).toString();
    text = normalizeCharacters(text);
    var mode = text.length > MAX_QR_TEXT_LENGTH_FOR_EXPORT ? TextExportMode.TEXT : TextExportMode.QR;

    var contentWidget = GCWTextExport(
        text: text,
        initMode: mode,
        saveFileTypeText: FileType.JSON,
        onModeChanged: (TextExportMode value) {
          mode = value;
        }
    );
    showGCWDialog(
        context,
        i18n(context, 'randomizer_lists_exportlist'),
        contentWidget,
        [
          GCWDialogButton(
            text: i18n(context, 'common_ok'),
          )
        ],
        cancelButton: false);
  }

  void _removeList(String name) {
    randomizerLists.removeWhere((RandomizerList list) => list.name == name);
    updateRandomizerLists();
  }

  void _updateList(String oldName, String newName) {
    for (var list in randomizerLists) {
      if (list.name == oldName) {
        list.name = _sanitizeListName(newName);
      }
    }

    updateRandomizerLists();
  }

  void _addNewList(String name) {
    if (name.isNotEmpty) {
      _insertLists([RandomizerList(name)]);
    }
  }

  String _sanitizeListName(String name) {
    var existingNames = randomizerLists.map((RandomizerList list) => list.name).toList();

    int i = 1;
    var betterName = name;
    while (existingNames.contains(betterName)) {
      betterName = name + ' ($i)';
      i++;
    }

    return betterName;
  }

  void _insertLists(List<RandomizerList> lists) {
    for (var list in lists) {
      if (list.name.isEmpty) {
        continue;
      }

      list.name = _sanitizeListName(list.name);
      randomizerLists.add(list);
    }

    updateRandomizerLists();
  }

  void _importLists(String data) {
    data = normalizeCharacters(data);
    if (data.isEmpty) {
      throw Exception();
    }

    List<RandomizerList> lists;
    try {
      lists = randomizerListsFromJson(asJsonMap(jsonDecode(data))).toList();
    } catch (e) {
      var newList = RandomizerList(i18n(context, 'randomizer_lists_importedtitle'));
      newList.list = data.split(RegExp(r'[ ,]+')).toList();
      lists = [newList];
    }

    _insertLists(lists);
  }

  GCWTool? _buildNavigateGCWTool(String name) {
    var entry = randomizerLists.firstWhereOrNull((list) => list.name == name);

    if (entry != null) {
      return GCWTool(
        tool: _RandomizerListsList(name: name, list: entry.list),
        toolName: '${entry.name} - ${i18n(context, 'randomizer_lists_list')}',
        defaultLanguageToolName: '${entry.name} - ${i18n(context, 'randomizer_lists_list', useDefaultLanguage: true)}',
        id: '',
      );
    } else {
      return null;
    }
  }
}