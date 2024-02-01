part of 'package:gc_wizard/tools/coords/_common/widget/gcw_coords.dart';

class _GCWCoordWidgetInfoMaidenhead extends GCWCoordWidgetInfo {
  @override
  CoordinateFormatKey get type => CoordinateFormatKey.MAIDENHEAD;
  @override
  String get i18nKey => maidenheadKey;
  @override
  String get name => 'Maidenhead Locator (QTH)';
  @override
  String get example => 'CN85TG09JU';

  @override
  _GCWCoordWidget mainWidget({
    Key? key,
    required void Function(BaseCoordinate?) onChanged,
    required BaseCoordinate? coordinates,
    bool? initialize
  }) {
    return _GCWCoordsMaidenhead(key: key, onChanged: onChanged, coordinates: coordinates, initialize: initialize ?? false);
  }
}

class _GCWCoordsMaidenhead extends _GCWCoordWidget {

  _GCWCoordsMaidenhead({super.key, required super.onChanged, required BaseCoordinate? coordinates, super.initialize}) :
        super(coordinates: coordinates is MaidenheadCoordinate ? coordinates : MaidenheadFormatDefinition.defaultCoordinate);

  @override
  _GCWCoordsMaidenheadState createState() => _GCWCoordsMaidenheadState();
}

class _GCWCoordsMaidenheadState extends State<_GCWCoordsMaidenhead> {
  late TextEditingController _controller;
  var _currentCoord = '';

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
    if (widget.initialize) {
      var maidenhead = widget.coordinates as MaidenheadCoordinate;
      _currentCoord = maidenhead.text;

      _controller.text = _currentCoord;
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

    widget.onChanged(MaidenheadCoordinate.parse(maidenhead));
  }
}
