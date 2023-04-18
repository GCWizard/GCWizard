part of 'package:gc_wizard/common_widgets/coordinates/gcw_coords/gcw_coords.dart';

class _GCWCoordsDMS extends StatefulWidget {
  final void Function(DMS) onChanged;
  final DMS coordinates;
  final bool isDefault;

  const _GCWCoordsDMS({Key? key, required this.onChanged, required this.coordinates, this.isDefault = true}) : super(key: key);

  @override
  _GCWCoordsDMSState createState() => _GCWCoordsDMSState();
}

class _GCWCoordsDMSState extends State<_GCWCoordsDMS> {
  late TextEditingController _LatDegreesController;
  late TextEditingController _LatMinutesController;
  late TextEditingController _LatSecondsController;
  late TextEditingController _LatMilliSecondsController;
  late TextEditingController _LonDegreesController;
  late TextEditingController _LonMinutesController;
  late TextEditingController _LonSecondsController;
  late TextEditingController _LonMilliSecondsController;

  final FocusNode _latMinutesFocusNode = FocusNode();
  final FocusNode _latSecondsFocusNode = FocusNode();
  final FocusNode _latMilliSecondsFocusNode = FocusNode();
  final FocusNode _lonMinutesFocusNode = FocusNode();
  final FocusNode _lonSecondsFocusNode = FocusNode();
  final FocusNode _lonMilliSecondsFocusNode = FocusNode();

  int _currentLatSign = defaultHemiphereLatitude();
  int _currentLonSign = defaultHemiphereLongitude();

  String _currentLatDegrees = '';
  String _currentLatMinutes = '';
  String _currentLatSeconds = '';
  String _currentLatMilliSeconds = '';
  String _currentLonDegrees = '';
  String _currentLonMinutes = '';
  String _currentLonSeconds = '';
  String _currentLonMilliSeconds = '';

  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _LatDegreesController = TextEditingController(text: _currentLatDegrees);
    _LatMinutesController = TextEditingController(text: _currentLatMinutes);
    _LatSecondsController = TextEditingController(text: _currentLatSeconds);
    _LatMilliSecondsController = TextEditingController(text: _currentLatMilliSeconds);

    _LonDegreesController = TextEditingController(text: _currentLonDegrees);
    _LonMinutesController = TextEditingController(text: _currentLonMinutes);
    _LonSecondsController = TextEditingController(text: _currentLonSeconds);
    _LonMilliSecondsController = TextEditingController(text: _currentLonMilliSeconds);
  }

  @override
  void dispose() {
    _LatDegreesController.dispose();
    _LatMinutesController.dispose();
    _LatSecondsController.dispose();
    _LatMilliSecondsController.dispose();
    _LonDegreesController.dispose();
    _LonMinutesController.dispose();
    _LonSecondsController.dispose();
    _LonMilliSecondsController.dispose();

    _latMinutesFocusNode.dispose();
    _latSecondsFocusNode.dispose();
    _latMilliSecondsFocusNode.dispose();
    _lonMinutesFocusNode.dispose();
    _lonSecondsFocusNode.dispose();
    _lonMilliSecondsFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isDefault && !_initialized) {
      var dms = widget.coordinates;
      var lat = dms.latitude.formatParts(10);
      var lon = dms.longitude.formatParts(10);

      _currentLatDegrees = lat.degrees;
      _currentLatMinutes = lat.minutes;
      _currentLatSeconds = lat.seconds.split('.')[0];
      _currentLatMilliSeconds = lat.seconds.split('.')[1];
      _currentLatSign = lat.sign.value;

      _currentLonDegrees = lon.degrees;
      _currentLonMinutes = lon.minutes;
      _currentLonSeconds = lon.seconds.split('.')[0];
      _currentLonMilliSeconds = lon.seconds.split('.')[1];
      _currentLonSign = lon.sign.value;

      _LatDegreesController.text = _currentLatDegrees;
      _LatMinutesController.text = _currentLatMinutes;
      _LatSecondsController.text = _currentLatSeconds;
      _LatMilliSecondsController.text = _currentLatMilliSeconds;

      _LonDegreesController.text = _currentLonDegrees;
      _LonMinutesController.text = _currentLonMinutes;
      _LonSecondsController.text = _currentLonSeconds;
      _LonMilliSecondsController.text = _currentLonMilliSeconds;

      _initialized = true;
    }

    return Column(children: <Widget>[
      Row(
        children: <Widget>[
          Expanded(
            flex: 6,
            child: GCWSignDropDown(
                itemList: const ['N', 'S'],
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
                    textInputFormatter: _DegreesLatTextInputFormatter(),
                    controller: _LatDegreesController,
                    onChanged: (IntegerText ret) {
                      setState(() {
                        _currentLatDegrees = ret.text;
                        _setCurrentValueAndEmitOnChange();

                        if (_currentLatDegrees.length == 2) FocusScope.of(context).requestFocus(_latMinutesFocusNode);
                      });
                    }),
              )),
          const Expanded(
            flex: 1,
            child: GCWText(align: Alignment.center, text: '°'),
          ),
          Expanded(
            flex: 6,
            child: GCWIntegerTextField(
                hintText: 'MM',
                textInputFormatter: GCWMinutesSecondsTextInputFormatter(),
                controller: _LatMinutesController,
                focusNode: _latMinutesFocusNode,
                onChanged: (IntegerText ret) {
                  setState(() {
                    _currentLatMinutes = ret.text;
                    _setCurrentValueAndEmitOnChange();

                    if (_currentLatMinutes.length == 2) FocusScope.of(context).requestFocus(_latSecondsFocusNode);
                  });
                }),
          ),
          const Expanded(
            flex: 1,
            child: GCWText(align: Alignment.center, text: '\''),
          ),
          Expanded(
            flex: 6,
            child: GCWIntegerTextField(
                hintText: 'SS',
                textInputFormatter: GCWMinutesSecondsTextInputFormatter(),
                controller: _LatSecondsController,
                focusNode: _latSecondsFocusNode,
                onChanged: (IntegerText ret) {
                  setState(() {
                    _currentLatSeconds = ret.text;
                    _setCurrentValueAndEmitOnChange();

                    if (_currentLatSeconds.length == 2) FocusScope.of(context).requestFocus(_latMilliSecondsFocusNode);
                  });
                }),
          ),
          const Expanded(
            flex: 1,
            child: GCWText(align: Alignment.center, text: '.'),
          ),
          Expanded(
            flex: 6,
            child: GCWIntegerTextField(
                hintText: 'SSS',
                min: 0,
                controller: _LatMilliSecondsController,
                focusNode: _latMilliSecondsFocusNode,
                onChanged: (IntegerText ret) {
                  setState(() {
                    _currentLatMilliSeconds = ret.text;
                    _setCurrentValueAndEmitOnChange();
                  });
                }),
          ),
          const Expanded(
            flex: 1,
            child: GCWText(align: Alignment.center, text: '"'),
          ),
        ],
      ),
      Row(
        children: <Widget>[
          Expanded(
            flex: 6,
            child: GCWSignDropDown(
                itemList: const ['E', 'W'],
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
                    textInputFormatter: _DegreesLonTextInputFormatter(),
                    controller: _LonDegreesController,
                    onChanged: (IntegerText ret) {
                      setState(() {
                        _currentLonDegrees = ret.text;
                        _setCurrentValueAndEmitOnChange();

                        if (_currentLonDegrees.length == 3) FocusScope.of(context).requestFocus(_lonMinutesFocusNode);
                      });
                    }),
              )),
          const Expanded(
            flex: 1,
            child: GCWText(align: Alignment.center, text: '°'),
          ),
          Expanded(
            flex: 6,
            child: GCWIntegerTextField(
                hintText: 'MM',
                textInputFormatter: GCWMinutesSecondsTextInputFormatter(),
                controller: _LonMinutesController,
                focusNode: _lonMinutesFocusNode,
                onChanged: (IntegerText ret) {
                  setState(() {
                    _currentLonMinutes = ret.text;
                    _setCurrentValueAndEmitOnChange();

                    if (_currentLonMinutes.length == 2) FocusScope.of(context).requestFocus(_lonSecondsFocusNode);
                  });
                }),
          ),
          const Expanded(
            flex: 1,
            child: GCWText(align: Alignment.center, text: '\''),
          ),
          Expanded(
            flex: 6,
            child: GCWIntegerTextField(
                hintText: 'SS',
                textInputFormatter: GCWMinutesSecondsTextInputFormatter(),
                controller: _LonSecondsController,
                focusNode: _lonSecondsFocusNode,
                onChanged: (IntegerText ret) {
                  setState(() {
                    _currentLonSeconds = ret.text;
                    _setCurrentValueAndEmitOnChange();

                    if (_currentLonSeconds.length == 2) {
                      FocusScope.of(context).requestFocus(_lonMilliSecondsFocusNode);
                    }
                  });
                }),
          ),
          const Expanded(
            flex: 1,
            child: GCWText(align: Alignment.center, text: '.'),
          ),
          Expanded(
            flex: 6,
            child: GCWIntegerTextField(
                hintText: 'SSS',
                min: 0,
                controller: _LonMilliSecondsController,
                focusNode: _lonMilliSecondsFocusNode,
                onChanged: (IntegerText ret) {
                  setState(() {
                    _currentLonMilliSeconds = ret.text;
                    _setCurrentValueAndEmitOnChange();
                  });
                }),
          ),
          const Expanded(
            flex: 1,
            child: GCWText(align: Alignment.center, text: '"'),
          ),
        ],
      )
    ]);
  }

  void _setCurrentValueAndEmitOnChange() {
    int _degrees = ['', '-'].contains(_currentLatDegrees) ? 0 : int.parse(_currentLatDegrees);
    int _minutes = ['', '-'].contains(_currentLatMinutes) ? 0 : int.parse(_currentLatMinutes);
    int _seconds = (['', '-'].contains(_currentLatSeconds) ? 0 : int.parse(_currentLatSeconds));
    double _secondsD = double.parse('$_seconds.$_currentLatMilliSeconds');
    var _currentLat = DMSLatitude(_currentLatSign, _degrees, _minutes, _secondsD);

    _degrees = ['', '-'].contains(_currentLonDegrees) ? 0 : int.parse(_currentLonDegrees);
    _minutes = ['', '-'].contains(_currentLonMinutes) ? 0 : int.parse(_currentLonMinutes);
    _seconds = (['', '-'].contains(_currentLonSeconds) ? 0 : int.parse(_currentLonSeconds));
    _secondsD = double.parse('$_seconds.$_currentLonMilliSeconds');
    var _currentLon = DMSLongitude(_currentLonSign, _degrees, _minutes, _secondsD);

    widget.onChanged(DMS(_currentLat, _currentLon));
  }
}
