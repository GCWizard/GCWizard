part of 'package:gc_wizard/tools/coords/_common/widget/gcw_coords.dart';

class _GCWCoordWidgetInfoGARS extends GCWCoordWidgetInfo {
  @override
  CoordinateFormatKey get type => CoordinateFormatKey.GARS;
  @override
  String get i18nKey => garsKey;
  @override
  String get name => 'GARS (Global Area Reference System)';
  @override
  String get example => '116MG18';

  @override
  _GCWCoordWidget mainWidget(
      {Key? key,
      required void Function(BaseCoordinate?) onChanged,
      required BaseCoordinate? coordinates,
      bool? initialize}) {
    return _GCWCoordsGARS(
        key: key, onChanged: onChanged, coordinates: coordinates, initialize: initialize ?? false);
  }
}

class _GCWCoordsGARS extends _GCWCoordWidget {
  _GCWCoordsGARS({super.key, required super.onChanged, required BaseCoordinate? coordinates, super.initialize})
      : super(
            coordinates: coordinates is GARSCoordinate ? coordinates : GARSFormatDefinition.defaultCoordinate);

  @override
  _GCWCoordsGARSState createState() => _GCWCoordsGARSState();
}

class _GCWCoordsGARSState extends State<_GCWCoordsGARS> {
  late TextEditingController _controller;
  var _currentCoord = '';

  final _maskInputFormatter = GCWMaskTextInputFormatter(mask: '***##**', filter: {"#": RegExp(r'[ABCDEFGHJKLMNPQRSTUVWXYZ]'), '*': RegExp(r'[0-9]')});

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
      var gars = widget.coordinates as GARSCoordinate;
      _currentCoord = gars.toString();

      _controller.text = _currentCoord;
    }

    return Column(children: <Widget>[
      GCWTextField(
          controller: _controller,
          inputFormatters: [_maskInputFormatter],
          onChanged: (ret) {
            setState(() {
              _currentCoord = ret;
              _setCurrentValueAndEmitOnChange();
            });
          }),
    ]);
  }

  void _setCurrentValueAndEmitOnChange() {
    try {
      widget.onChanged(GARSCoordinate.parse(_currentCoord));
    } catch (e) {}
  }
}
