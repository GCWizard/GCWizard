part of 'package:gc_wizard/common_widgets/color_pickers/gcw_colors.dart';

class _GCWColorHexCode extends StatefulWidget {
  final void Function(HexCode) onChanged;
  final HexCode? color;

  const _GCWColorHexCode({Key? key, required this.onChanged, this.color}) : super(key: key);

  @override
  _GCWColorHexCodeState createState() => _GCWColorHexCodeState();
}

class _GCWColorHexCodeState extends State<_GCWColorHexCode> {
  String _currentHexCode = '#F0F0F0';

  late TextEditingController _controller;

  final _maskInputFormatter = GCWMaskTextInputFormatter(mask: '#......', filter: {".": RegExp(r'[A-Fa-f0-9]')});

  @override
  void initState() {
    super.initState();

    if (widget.color != null) {
      _currentHexCode = widget.color!.hexCode;
    }
    _controller = TextEditingController(text: '#' + _currentHexCode);
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.color != null) {
      _currentHexCode = widget.color!.hexCode;
    }

    return Column(
      children: [
        GCWTextField(
          controller: _controller,
          inputFormatters: [_maskInputFormatter],
          onChanged: (text) {
            _currentHexCode = text;
            _emitOnChange();
          },
        )
      ],
    );
  }

  void _emitOnChange() {
    widget.onChanged(HexCode(_currentHexCode));
  }
}
