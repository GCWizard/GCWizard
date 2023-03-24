part of 'package:gc_wizard/common_widgets/coordinates/gcw_coords/gcw_coords.dart';

class _GCWCoordsMercator extends StatefulWidget {
  final void Function(Mercator) onChanged;
  final Mercator coordinates;

  const _GCWCoordsMercator({Key? key, required this.onChanged, required this.coordinates}) : super(key: key);

  @override
  _GCWCoordsMercatorState createState() => _GCWCoordsMercatorState();
}

class _GCWCoordsMercatorState extends State<_GCWCoordsMercator> {
  late TextEditingController _EastingController;
  late TextEditingController _NorthingController;

  var _currentEasting = defaultDoubleText;
  var _currentNorthing = defaultDoubleText;

  @override
  void initState() {
    super.initState();
    _EastingController = TextEditingController(text: _currentEasting.text);
    _NorthingController = TextEditingController(text: _currentNorthing.text);
  }

  @override
  void dispose() {
    _EastingController.dispose();
    _NorthingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mercator = widget.coordinates;
    _currentEasting.value = mercator.easting;
    _currentNorthing.value = mercator.northing;

    _EastingController.text = _currentEasting.value.toString();
    _NorthingController.text = _currentNorthing.value.toString();

    return Column(children: <Widget>[
      GCWDoubleTextField(
          hintText: i18n(context, 'coords_formatconverter_easting'),
          controller: _EastingController,
          onChanged: (ret) {
            setState(() {
              _currentEasting = ret;
              _setCurrentValueAndEmitOnChange();
            });
          }),
      GCWDoubleTextField(
          hintText: i18n(context, 'coords_formatconverter_northing'),
          controller: _NorthingController,
          onChanged: (ret) {
            setState(() {
              _currentNorthing = ret;
              _setCurrentValueAndEmitOnChange();
            });
          }),
    ]);
  }

  void _setCurrentValueAndEmitOnChange() {
    var mercator = Mercator(_currentEasting.value, _currentNorthing.value);

    widget.onChanged(mercator);
  }
}
