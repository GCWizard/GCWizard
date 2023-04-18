part of 'package:gc_wizard/common_widgets/coordinates/gcw_coords/gcw_coords.dart';

class _GCWCoordsMaidenhead extends StatefulWidget {
  final void Function(Maidenhead?) onChanged;
  final Maidenhead coordinates;
  final bool isDefault;

  const _GCWCoordsMaidenhead({Key? key, required this.onChanged, required this.coordinates, this.isDefault = true}) : super(key: key);

  @override
  _GCWCoordsMaidenheadState createState() => _GCWCoordsMaidenheadState();
}

class _GCWCoordsMaidenheadState extends State<_GCWCoordsMaidenhead> {
  late TextEditingController _controller;
  var _currentCoord = '';

  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _currentCoord);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isDefault && !_initialized) {
      var maidenhead = widget.coordinates;
      _currentCoord = maidenhead.text;

      _controller.text = _currentCoord;

      _initialized = true;
    }

    return Column(children: <Widget>[
      GCWTextField(
          hintText: i18n(context, 'coords_formatconverter_maidenhead_locator'),
          controller: _controller,
          inputFormatters: [_MaidenheadTextInputFormatter()],
          onChanged: (ret) {
            setState(() {
              _currentCoord = ret;
              _setCurrentValueAndEmitOnChange();
            });
          }),
    ]);
  }

  void _setCurrentValueAndEmitOnChange() {
    var maidenhead = _currentCoord;
    if (maidenhead.length % 2 == 1) maidenhead = maidenhead.substring(0, maidenhead.length - 1);

    widget.onChanged(Maidenhead.parse(maidenhead));
  }
}
