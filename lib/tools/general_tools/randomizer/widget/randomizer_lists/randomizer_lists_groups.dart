part of 'package:gc_wizard/tools/general_tools/randomizer/widget/randomizer_lists/randomizer_lists.dart';

class _RandomizerListsGroups extends StatefulWidget {
  final List<String> list;

  const _RandomizerListsGroups({Key? key, required this.list}) : super(key: key);

  @override
  _RandomizerListsGroupsState createState() => _RandomizerListsGroupsState();
}

class _RandomizerListsGroupsState extends State<_RandomizerListsGroups> {
  var _currentGroupCount = -1;
  var _maxGroupCount = -1;
  var _currentElementsPerGroupCount = 1;
  var _maxElementsPerGroupCount = -1;

  var _currentGroupMode = GCWSwitchPosition.left;


  Widget _currentOutput = const GCWDefaultOutput();

  void _resetOutput() {
    _currentOutput = const GCWDefaultOutput();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentGroupCount < 0) {
      _currentGroupCount = min(1, widget.list.length);
      _maxElementsPerGroupCount = (widget.list.length.toDouble() / _currentGroupCount).ceil();
      _currentElementsPerGroupCount = _maxElementsPerGroupCount;
    }

    return Column(
      children: <Widget>[
        GCWText(
          align: Alignment.center,
          text: i18n(context, 'randomizer_lists_list_contains', parameters: [widget.list.length]),
          style: gcwDescriptionTextStyle(),
        ),
        GCWTwoOptionsSwitch(
            value: _currentGroupMode,
            leftValue: i18n(context, 'randomizer_lists_list_groups_count'),
            rightValue: i18n(context, 'randomizer_lists_list_groups_size'),
            onChanged: (value) {
              setState(() {
                _currentGroupMode = value;
                if (_currentGroupMode == GCWSwitchPosition.left) {
                  _currentGroupCount = min(1, widget.list.length);
                  _maxElementsPerGroupCount = (widget.list.length.toDouble() / _currentGroupCount).ceil();
                  _currentElementsPerGroupCount = _maxElementsPerGroupCount;
                } else {
                  _currentElementsPerGroupCount = (widget.list.length.toDouble() / 2).ceil();
                  _currentGroupCount = min(1, widget.list.length);
                  _maxGroupCount = (widget.list.length.toDouble() / _currentElementsPerGroupCount).ceil();
                }

                _resetOutput();
              });
            }),
        _currentGroupMode == GCWSwitchPosition.left
          ? Column(
              children: [
                GCWIntegerSpinner(
                  title: i18n(context, 'randomizer_lists_list_groups_count'),
                  min: 1,
                  max: widget.list.length,
                  value: _currentGroupCount,
                  onChanged: (int value) {
                    setState(() {
                      _currentGroupCount = value;
                      _maxElementsPerGroupCount = (widget.list.length.toDouble() / _currentGroupCount).ceil();
                      if (_currentElementsPerGroupCount > _maxElementsPerGroupCount) {
                        _currentElementsPerGroupCount = _maxElementsPerGroupCount;
                      }
                      _resetOutput();
                    });
                  },
                ),
                GCWIntegerSpinner(
                  title: i18n(context, 'randomizer_lists_list_groups_maxsize'),
                  min: 1,
                  max: _maxElementsPerGroupCount,
                  value: _currentElementsPerGroupCount,
                  onChanged: (int value) {
                    setState(() {
                      _currentElementsPerGroupCount = value;
                      _resetOutput();
                    });
                  },
                ),
              ],
            )
          : Column(
              children: [
                GCWIntegerSpinner(
                  title: i18n(context, 'randomizer_lists_list_groups_size'),
                  min: 1,
                  max: widget.list.length,
                  value: _currentElementsPerGroupCount,
                  onChanged: (int value) {
                    setState(() {
                      _currentElementsPerGroupCount = value;
                      _resetOutput();

                      _maxGroupCount = (widget.list.length.toDouble() / _currentElementsPerGroupCount).ceil();
                      if (_currentGroupCount > _maxGroupCount) {
                        _currentGroupCount = _maxGroupCount;
                      }
                    });
                  },
                ),
                GCWIntegerSpinner(
                  title: i18n(context, 'randomizer_lists_list_groups_maxcount'),
                  min: 1,
                  max: _maxGroupCount,
                  value: _currentGroupCount,
                  onChanged: (int value) {
                    setState(() {
                      _currentGroupCount = value;
                      _resetOutput();
                    });
                  },
                ),

              ],
            ),
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

  void _calculateOutput() {
    if (widget.list.isEmpty) {
      _resetOutput();
      return;
    }

    List<List<String>> groups = [];
    if (_currentGroupMode == GCWSwitchPosition.left) { // Group Count
      groups = shuffledSublistsByGroupCount(widget.list, _currentGroupCount);
      groups = groups.map((List<String> group) => group.sublist(0, min(group.length, _currentElementsPerGroupCount))).toList();
    } else {
      groups = shuffledSublistsByElementCount(widget.list, _currentElementsPerGroupCount);
      groups = groups.sublist(0, min(groups.length, _currentGroupCount));
    }

    var output = groups.asMap().map((index, List<String> group) {
      return MapEntry(index,
          GCWOutput(
            title: i18n(context, 'common_group') + ' #' + (index + 1).toString(),
            trailing: GCWIconButton(
              icon: Icons.copy,
              size: IconButtonSize.SMALL,
              onPressed: () {
                insertIntoGCWClipboard(
                    context, group.join(' ')
                );
              },
            ),
            child: GCWColumnedMultilineOutput(data: group.map((String e) => [e]).toList()),
          )
      );
    }).values.toList();

    _currentOutput = GCWDefaultOutput(
      child: Column(children: output),
    );
  }
}
