part of 'package:gc_wizard/common_widgets/coordinates/gcw_coords/gcw_coords.dart';

class _GCWCoordsDEC extends StatefulWidget {
  final Function onChanged;
  BaseCoordinates coordinates;

  _GCWCoordsDEC({Key key, this.onChanged, this.coordinates}) : super(key: key);

  @override
  _GCWCoordsDECState createState() => _GCWCoordsDECState();
}

class _GCWCoordsDECState extends State<_GCWCoordsDEC> {
  TextEditingController _LatDegreesController;
  TextEditingController _LatMilliDegreesController;
  TextEditingController _LonDegreesController;
  TextEditingController _LonMilliDegreesController;

  FocusNode _latMilliDegreesFocusNode;
  FocusNode _lonMilliDegreesFocusNode;

  int _currentLatSign = defaultHemiphereLatitude();
  int _currentLonSign = defaultHemiphereLongitude();

  String _currentLatDegrees = '';
  String _currentLatMilliDegrees = '';
  String _currentLonDegrees = '';
  String _currentLonMilliDegrees = '';

  @override
  void initState() {
    super.initState();

    _LatDegreesController = TextEditingController(text: _currentLatDegrees);
    _LatMilliDegreesController = TextEditingController(text: _currentLatMilliDegrees);

    _LonDegreesController = TextEditingController(text: _currentLonDegrees);
    _LonMilliDegreesController = TextEditingController(text: _currentLonMilliDegrees);

    _latMilliDegreesFocusNode = FocusNode();
    _lonMilliDegreesFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _LatDegreesController.dispose();
    _LatMilliDegreesController.dispose();
    _LonDegreesController.dispose();
    _LonMilliDegreesController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.coordinates != null) {
      var dec = widget.coordinates is DEC ? widget.coordinates as DEC : DEC.fromLatLon(widget.coordinates.toLatLng());
      _currentLatDegrees = dec.latitude.abs().floor().toString();
      _currentLatMilliDegrees = dec.latitude.toString().split('.')[1];
      _currentLatSign = widget.coordinates.isDefault() ? defaultHemiphereLatitude() : coordinateSign(dec.latitude);

      _currentLonDegrees = dec.longitude.abs().floor().toString();
      _currentLonMilliDegrees = dec.longitude.toString().split('.')[1];
      _currentLonSign = widget.coordinates.isDefault() ? defaultHemiphereLongitude() : coordinateSign(dec.longitude);

      _LatDegreesController.text = _currentLatDegrees;
      _LatMilliDegreesController.text = _currentLatMilliDegrees;

      _LonDegreesController.text = _currentLonDegrees;
      _LonMilliDegreesController.text = _currentLonMilliDegrees;
    }

    return Column(children: <Widget>[
      Row(
        children: <Widget>[
          Expanded(
            flex: 6,
            child: GCWSignDropDown(
                itemList: ['+', '-'],
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
                child: GCWIntegerTextField(
                    hintText: 'DD',
                    textInputFormatter: _DegreesLatTextInputFormatter(allowNegativeValues: false),
                    controller: _LatDegreesController,
                    onChanged: (ret) {
                      setState(() {
                        _currentLatDegrees = ret['text'];
                        _setCurrentValueAndEmitOnChange();

                        if (_currentLatDegrees.length == 2)
                          FocusScope.of(context).requestFocus(_latMilliDegreesFocusNode);
                      });
                    }),
                padding: EdgeInsets.only(left: DOUBLE_DEFAULT_MARGIN),
              )),
          Expanded(
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
                    _currentLatMilliDegrees = ret['text'];
                    _setCurrentValueAndEmitOnChange();
                  });
                }),
          ),
          Expanded(
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
                itemList: ['+', '-'],
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
                child: GCWIntegerTextField(
                    hintText: 'DD',
                    textInputFormatter: _DegreesLonTextInputFormatter(allowNegativeValues: false),
                    controller: _LonDegreesController,
                    onChanged: (ret) {
                      setState(() {
                        _currentLonDegrees = ret['text'];
                        _setCurrentValueAndEmitOnChange();

                        if (_currentLonDegrees.length == 3)
                          FocusScope.of(context).requestFocus(_lonMilliDegreesFocusNode);
                      });
                    }),
                padding: EdgeInsets.only(left: DOUBLE_DEFAULT_MARGIN),
              )),
          Expanded(
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
                onChanged: (ret) {
                  setState(() {
                    _currentLonMilliDegrees = ret['text'];
                    _setCurrentValueAndEmitOnChange();
                  });
                }),
          ),
          Expanded(
            flex: 1,
            child: GCWText(align: Alignment.center, text: '°'),
          ),
        ],
      )
    ]);
  }

  _setCurrentValueAndEmitOnChange() {
    int _degrees = ['', '-'].contains(_currentLatDegrees) ? 0 : int.parse(_currentLatDegrees);
    double _degreesD = double.parse('$_degrees.$_currentLatMilliDegrees');
    double _currentLat = _currentLatSign * _degreesD;

    _degrees = ['', '-'].contains(_currentLonDegrees) ? 0 : int.parse(_currentLonDegrees);
    _degreesD = double.parse('$_degrees.$_currentLonMilliDegrees');
    double _currentLon = _currentLonSign * _degreesD;

    widget.onChanged(DEC(_currentLat, _currentLon));
  }
}
