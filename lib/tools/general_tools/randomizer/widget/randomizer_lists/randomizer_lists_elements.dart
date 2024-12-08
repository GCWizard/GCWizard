part of 'package:gc_wizard/tools/general_tools/randomizer/widget/randomizer_lists/randomizer_lists.dart';

class _RandomizerListsElements extends StatefulWidget {
  final List<String> list;

  const _RandomizerListsElements({Key? key, required this.list}) : super(key: key);

  @override
  _RandomizerListsElementsState createState() => _RandomizerListsElementsState();
}

class _RandomizerListsElementsState extends State<_RandomizerListsElements> {
  var _currentCount = 1;

  Widget _currentOutput = const GCWDefaultOutput();

  void _resetOutput() {
    _currentOutput = const GCWDefaultOutput();
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
        GCWIntegerSpinner(
          title: i18n(context, 'common_count'),
          min: 1,
          max: widget.list.length,
          value: _currentCount,
          onChanged: (int value) {
            setState(() {
              _currentCount = value;
              _resetOutput();
            });
          },
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

    var list = List<String>.from(widget.list);
    list.shuffle();
    var output = list.sublist(0, _currentCount);

    _currentOutput = GCWDefaultOutput(
      trailing: GCWIconButton(
        icon: Icons.copy,
        size: IconButtonSize.SMALL,
        onPressed: () {
          insertIntoGCWClipboard(
              context, list.join(' ')
          );
        },
      ),
      child: GCWColumnedMultilineOutput(data: output.map((String e) => [e]).toList()),
    );
  }
}
