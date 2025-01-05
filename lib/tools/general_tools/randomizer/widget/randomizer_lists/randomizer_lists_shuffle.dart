part of 'package:gc_wizard/tools/general_tools/randomizer/widget/randomizer_lists/randomizer_lists.dart';

class _RandomizerListsShuffle extends StatefulWidget {
  final List<String> list;

  const _RandomizerListsShuffle({Key? key, required this.list}) : super(key: key);

  @override
  _RandomizerListsShuffleState createState() => _RandomizerListsShuffleState();
}

class _RandomizerListsShuffleState extends State<_RandomizerListsShuffle> {
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
      child: GCWColumnedMultilineOutput(data: list.map((String e) => [e]).toList()),
    );
  }
}
