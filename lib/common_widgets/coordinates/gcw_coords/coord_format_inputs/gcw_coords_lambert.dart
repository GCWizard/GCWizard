part of 'package:gc_wizard/common_widgets/coordinates/gcw_coords/gcw_coords.dart';

class _GCWCoordsLambert extends StatefulWidget {
  final void Function(Lambert) onChanged;
  final Lambert coordinates;
  final bool isDefault;

  const _GCWCoordsLambert({Key? key, required this.onChanged, required this.coordinates, this.isDefault = true})
      : super(key: key);

  @override
  _GCWCoordsLambertState createState() => _GCWCoordsLambertState();
}

class _GCWCoordsLambertState extends State<_GCWCoordsLambert> {
  late TextEditingController _eastingController;
  late TextEditingController _northingController;

  var _currentEasting = defaultDoubleText;
  var _currentNorthing = defaultDoubleText;

  var _currentSubtype = defaultLambertType;

  bool _initialized = false;

  @override
  void initState() {
    super.initState();

    _eastingController = TextEditingController(text: _currentEasting.text);
    _northingController = TextEditingController(text: _currentNorthing.text);
  }

  @override
  void dispose() {
    _eastingController.dispose();
    _northingController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _currentSubtype = widget.coordinates.format.subtype!;

    if (_subtypeChanged()) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _setCurrentValueAndEmitOnChange());
    } else if (!widget.isDefault && !_initialized) {
      var lambert = widget.coordinates;
      _currentEasting.value = lambert.easting;
      _currentNorthing.value = lambert.northing;

      _eastingController.text = _currentEasting.value.toString();
      _northingController.text = _currentNorthing.value.toString();

      _initialized = true;
    }

    return Column(children: <Widget>[
      GCWDoubleTextField(
          hintText: i18n(context, 'coords_formatconverter_easting'),
          controller: _eastingController,
          onChanged: (ret) {
            setState(() {
              _currentEasting = ret;
              _setCurrentValueAndEmitOnChange();
            });
          }),
      GCWDoubleTextField(
          hintText: i18n(context, 'coords_formatconverter_northing'),
          controller: _northingController,
          onChanged: (ret) {
            setState(() {
              _currentNorthing = ret;
              _setCurrentValueAndEmitOnChange();
            });
          }),
    ]);
  }

  bool _subtypeChanged() {
    return _currentSubtype != widget.coordinates.format.subtype;
  }

  void _setCurrentValueAndEmitOnChange() {
    var lambert = Lambert(_currentSubtype, _currentEasting.value, _currentNorthing.value);
    widget.onChanged(lambert);
  }
}
