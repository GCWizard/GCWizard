part of 'package:gc_wizard/tools/general_tools/randomizer/widget/randomizer_lists/randomizer_lists.dart';

class _RandomizerListsList extends StatefulWidget {
  final String name;
  final List<String> list;

  const _RandomizerListsList({Key? key, required this.name, required this.list}) : super(key: key);

  @override
  _RandomizerListsListState createState() => _RandomizerListsListState();
}

class _RandomizerListsListState extends State<_RandomizerListsList> {

  final List<TextEditingController> _controllers = [];

  @override
  void dispose() {
    for (var i = 0; i < _controllers.length; i++) {
      _controllers[i].dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWText(
          align: Alignment.center,
          text: i18n(context, 'randomizer_lists_list_contains', parameters: [widget.list.length]),
          style: gcwDescriptionTextStyle(),
        ),
        Row(
          children: [
            Expanded(
              child: GCWButton(
                text: i18n(context, 'randomizer_lists_list_elements'),
                enabled: widget.list.isNotEmpty,
                onPressed: () {
                  Navigator.push(
                      context,
                      NoAnimationMaterialPageRoute<GCWTool>(
                          builder: (context) => GCWTool(
                            tool: _RandomizerListsElements(list: widget.list),
                            toolName: i18n(context, 'randomizer_lists_list_elements'),
                            id: '',
                            suppressHelpButton: true,
                          )));
                }
              )
            ),
            Container(width: DOUBLE_DEFAULT_MARGIN),
            Expanded(
              child: GCWButton(
                text: i18n(context, 'randomizer_lists_list_shuffle'),
                enabled: widget.list.isNotEmpty,
                onPressed: () {
                  Navigator.push(
                      context,
                      NoAnimationMaterialPageRoute<GCWTool>(
                          builder: (context) => GCWTool(
                            tool: _RandomizerListsShuffle(list: widget.list),
                            toolName: i18n(context, 'randomizer_lists_list_shuffle'),
                            id: '',
                            suppressHelpButton: true,
                          )));
                }
              )
            ),
            Container(width: DOUBLE_DEFAULT_MARGIN),
            Expanded(
              child: GCWButton(
                text: i18n(context, 'randomizer_lists_list_groups'),
                enabled: widget.list.isNotEmpty,
                onPressed: () {
                  Navigator.push(
                      context,
                      NoAnimationMaterialPageRoute<GCWTool>(
                          builder: (context) => GCWTool(
                            tool: _RandomizerListsGroups(list: widget.list),
                            toolName: i18n(context, 'randomizer_lists_list_groups'),
                            id: '',
                            suppressHelpButton: true,
                          )));
                }
              )
            ),
          ],
        ),
        GCWTextDivider(text: i18n(context, 'randomizer_lists_list_createdelements')),
        GCWStringlistEditor(
          list: widget.list,
          controllers: _controllers,
          onChanged: () {
            setState(() {
              updateRandomizerLists();
            });
          },
        )
      ],
    );
  }
}
