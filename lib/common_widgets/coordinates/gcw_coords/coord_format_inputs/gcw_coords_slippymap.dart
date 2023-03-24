part of 'package:gc_wizard/common_widgets/coordinates/gcw_coords/gcw_coords.dart';

class _GCWCoordsSlippyMap extends StatefulWidget {
  final void Function(SlippyMap?) onChanged;
  final SlippyMap coordinates;

  const _GCWCoordsSlippyMap({Key? key, required this.onChanged, required this.coordinates}) : super(key: key);

  @override
  _GCWCoordsSlippyMapState createState() => _GCWCoordsSlippyMapState();
}

class _GCWCoordsSlippyMapState extends State<_GCWCoordsSlippyMap> {
  late TextEditingController _xController;
  late TextEditingController _yController;

  var _currentX = defaultDoubleText;
  var _currentY = defaultDoubleText;

  late int _currentZoom;

  @override
  void initState() {
    super.initState();

    _currentZoom = _slippyMapZoom();

    _xController = TextEditingController(text: _currentX.text);
    _yController = TextEditingController(text: _currentY.text);
  }

  @override
  void dispose() {
    _xController.dispose();
    _yController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_subtypeChanged()) {
      _currentZoom = _slippyMapZoom();
      WidgetsBinding.instance.addPostFrameCallback((_) => _setCurrentValueAndEmitOnChange());
    } else {
      var slippyMap = widget.coordinates;
      _currentX.value = slippyMap.x;
      _currentY.value = slippyMap.y;

      _xController.text = _currentX.value.toString();
      _yController.text = _currentY.value.toString();
    }

    return Column(children: <Widget>[
      GCWDoubleTextField(
          hintText: 'X',
          min: 0.0,
          controller: _xController,
          onChanged: (ret) {
            setState(() {
              _currentX = ret;
              _setCurrentValueAndEmitOnChange();
            });
          }),
      GCWDoubleTextField(
          hintText: 'Y',
          min: 0.0,
          controller: _yController,
          onChanged: (ret) {
            setState(() {
              _currentY = ret;
              _setCurrentValueAndEmitOnChange();
            });
          }),
    ]);
  }

  bool _subtypeChanged() {
    return _currentZoom != _slippyMapZoom();
  }

  int _slippyMapZoom() {
    return switchMapKeyValue(SLIPPY_MAP_ZOOM)[widget.coordinates.format.subtype!]!;
  }

  void _setCurrentValueAndEmitOnChange() {
    widget.onChanged(SlippyMap(_currentX.value, _currentY.value, widget.coordinates.format.subtype!));
  }
}
