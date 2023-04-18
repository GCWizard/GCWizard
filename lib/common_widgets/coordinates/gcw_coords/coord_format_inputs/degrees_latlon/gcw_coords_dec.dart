part of 'package:gc_wizard/common_widgets/coordinates/gcw_coords/gcw_coords.dart';

class _GCWCoordsDEC extends StatefulWidget {
  final void Function(DEC) onChanged;
  DEC coordinates;
  final bool isDefault;

  _GCWCoordsDEC({Key? key, required this.onChanged, required this.coordinates, this.isDefault = true}) : super(key: key);

  @override
  _GCWCoordsDECState createState() => _GCWCoordsDECState();
}

class _GCWCoordsDECState extends State<_GCWCoordsDEC> {
  late TextEditingController _LatDegreesController;
  late TextEditingController _LatMilliDegreesController;
  late TextEditingController _LonDegreesController;
  late TextEditingController _LonMilliDegreesController;

  final FocusNode _latMilliDegreesFocusNode = FocusNode();
  final FocusNode _lonMilliDegreesFocusNode = FocusNode();

  int _currentLatSign = defaultHemiphereLatitude();
  int _currentLonSign = defaultHemiphereLongitude();

  String _currentLatDegrees = '';
  String _currentLatMilliDegrees = '';
  String _currentLonDegrees = '';
  String _currentLonMilliDegrees = '';

  bool _initialized = false;

  @override
  void initState() {
    super.initState();

    _LatDegreesController = TextEditingController(text: _currentLatDegrees);
    _LatMilliDegreesController = TextEditingController(text: _currentLatMilliDegrees);

    _LonDegreesController = TextEditingController(text: _currentLonDegrees);
    _LonMilliDegreesController = TextEditingController(text: _currentLonMilliDegrees);
  }

  @override
  void dispose() {
    _LatDegreesController.dispose();
    _LatMilliDegreesController.dispose();
    _LonDegreesController.dispose();
    _LonMilliDegreesController.dispose();

    _latMilliDegreesFocusNode.dispose();
    _lonMilliDegreesFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isDefault && !_initialized) {
      var dec = widget.coordinates;
      _currentLatDegrees = dec.latitude.abs().floor().toString();
      _currentLatMilliDegrees = dec.latitude.toString().split('.')[1];
      _currentLatSign = sign(dec.latitude);

      _currentLonDegrees = dec.longitude.abs().floor().toString();
      _currentLonMilliDegrees = dec.longitude.toString().split('.')[1];
      _currentLonSign = sign(dec.longitude);

      _LatDegreesController.text = _currentLatDegrees;
      _LatMilliDegreesController.text = _currentLatMilliDegrees;

      _LonDegreesController.text = _currentLonDegrees;
      _LonMilliDegreesController.text = _currentLonMilliDegrees;

      _initialized = true;
    }

    return Column(children: <Widget>[
      Row(
        children: <Widget>[
          Expanded(
            flex: 6,
            child: GCWSignDropDown(
                itemList: const ['+', '-'],
                value: _currentLatSign,
                onChanged: (value) {
                  setState(() {
                    _currentLatSign = value;
                    _setCurrentValueAndEmitOnChange();
                  });
                }),
          ),
          Expanded(
              flex: 6,
              child: Container(
                padding: const EdgeInsets.only(left: DOUBLE_DEFAULT_MARGIN),
                child: GCWIntegerTextField(
                    hintText: 'DD',
                    textInputFormatter: _DegreesLatTextInputFormatter(allowNegativeValues: false),
                    controller: _LatDegreesController,
                    onChanged: (IntegerText ret) {
                      setState(() {
                        _currentLatDegrees = ret.text;
                        _setCurrentValueAndEmitOnChange();

                        if (_currentLatDegrees.length == 2) {
                          FocusScope.of(context).requestFocus(_latMilliDegreesFocusNode);
                        }
                      });
                    }),
              )),
          const Expanded(
            flex: 1,
            child: GCWText(align: Alignment.center, text: '.'),
          ),
          Expanded(
            flex: 20,
            child: GCWIntegerTextField(
                hintText: 'DDD',
                min: 0,
                controller: _LatMilliDegreesController,
                focusNode: _latMilliDegreesFocusNode,
                onChanged: (ret) {
                  setState(() {
                    _currentLatMilliDegrees = ret.text;
                    _setCurrentValueAndEmitOnChange();
                  });
                }),
          ),
          const Expanded(
            flex: 1,
            child: GCWText(align: Alignment.center, text: '°'),
          ),
        ],
      ),
      Row(
        children: <Widget>[
          Expanded(
            flex: 6,
            child: GCWSignDropDown(
                itemList: const ['+', '-'],
                value: _currentLonSign,
                onChanged: (value) {
                  setState(() {
                    _currentLonSign = value;
                    _setCurrentValueAndEmitOnChange();
                  });
                }),
          ),
          Expanded(
              flex: 6,
              child: Container(
                padding: const EdgeInsets.only(left: DOUBLE_DEFAULT_MARGIN),
                child: GCWIntegerTextField(
                    hintText: 'DD',
                    textInputFormatter: _DegreesLonTextInputFormatter(allowNegativeValues: false),
                    controller: _LonDegreesController,
                    onChanged: (IntegerText ret) {
                      setState(() {
                        _currentLonDegrees = ret.text;
                        _setCurrentValueAndEmitOnChange();

                        if (_currentLonDegrees.length == 3) {
                          FocusScope.of(context).requestFocus(_lonMilliDegreesFocusNode);
                        }
                      });
                    }),
              )),
          const Expanded(
            flex: 1,
            child: GCWText(align: Alignment.center, text: '.'),
          ),
          Expanded(
            flex: 20,
            child: GCWIntegerTextField(
                hintText: 'DDD',
                min: 0,
                controller: _LonMilliDegreesController,
                focusNode: _lonMilliDegreesFocusNode,
                onChanged: (IntegerText ret) {
                  setState(() {
                    _currentLonMilliDegrees = ret.text;
                    _setCurrentValueAndEmitOnChange();
                  });
                }),
          ),
          const Expanded(
            flex: 1,
            child: GCWText(align: Alignment.center, text: '°'),
          ),
        ],
      )
    ]);
  }

  void _setCurrentValueAndEmitOnChange() {
    int _degrees = ['', '-'].contains(_currentLatDegrees) ? 0 : int.parse(_currentLatDegrees);
    double _degreesD = double.parse('$_degrees.$_currentLatMilliDegrees');
    double _currentLat = _currentLatSign * _degreesD;

    _degrees = ['', '-'].contains(_currentLonDegrees) ? 0 : int.parse(_currentLonDegrees);
    _degreesD = double.parse('$_degrees.$_currentLonMilliDegrees');
    double _currentLon = _currentLonSign * _degreesD;

    widget.onChanged(DEC(_currentLat, _currentLon));
  }
}
