part of 'package:gc_wizard/common_widgets/coordinates/gcw_coords/gcw_coords.dart';

class _GCWCoordsDMM extends StatefulWidget {
  final void Function(DMM) onChanged;
  final DMM coordinates;

  const _GCWCoordsDMM({Key? key, required this.onChanged, required this.coordinates}) : super(key: key);

  @override
  _GCWCoordsDMMState createState() => _GCWCoordsDMMState();
}

class _GCWCoordsDMMState extends State<_GCWCoordsDMM> {
  late TextEditingController _LatDegreesController;
  late TextEditingController _LatMinutesController;
  late TextEditingController _LatMilliMinutesController;

  late TextEditingController _LonDegreesController;
  late TextEditingController _LonMinutesController;
  late TextEditingController _LonMilliMinutesController;

  int _currentLatSign = defaultHemiphereLatitude();
  int _currentLonSign = defaultHemiphereLongitude();

  String _currentLatDegrees = '';
  String _currentLatMinutes = '';
  String _currentLatMilliMinutes = '';
  String _currentLonDegrees = '';
  String _currentLonMinutes = '';
  String _currentLonMilliMinutes = '';

  final FocusNode _latMinutesFocusNode = FocusNode();
  final FocusNode _latMilliMinutesFocusNode = FocusNode();
  final FocusNode _lonMinutesFocusNode = FocusNode();
  final FocusNode _lonMilliMinutesFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _LatDegreesController = TextEditingController(text: _currentLatDegrees);
    _LatMinutesController = TextEditingController(text: _currentLatMinutes);
    _LatMilliMinutesController = TextEditingController(text: _currentLatMilliMinutes);

    _LonDegreesController = TextEditingController(text: _currentLonDegrees);
    _LonMinutesController = TextEditingController(text: _currentLonMinutes);
    _LonMilliMinutesController = TextEditingController(text: _currentLonMilliMinutes);
  }

  @override
  void dispose() {
    _LatDegreesController.dispose();
    _LatMinutesController.dispose();
    _LatMilliMinutesController.dispose();
    _LonDegreesController.dispose();
    _LonMinutesController.dispose();
    _LonMilliMinutesController.dispose();

    _latMinutesFocusNode.dispose();
    _latMilliMinutesFocusNode.dispose();
    _lonMinutesFocusNode.dispose();
    _lonMilliMinutesFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var dmm = widget.coordinates;
    var lat = dmm.latitude.formatParts(10);
    var lon = dmm.longitude.formatParts(10);

    _currentLatDegrees = lat.degrees;
    _currentLatMinutes = lat.minutes.split('.')[0];
    _currentLatMilliMinutes = lat.minutes.split('.')[1];
    _currentLatSign = lat.sign.value;

    _currentLonDegrees = lon.degrees;
    _currentLonMinutes = lon.minutes.split('.')[0];
    _currentLonMilliMinutes = lon.minutes.split('.')[1];
    _currentLonSign = lon.sign.value;

    _LatDegreesController.text = _currentLatDegrees;
    _LatMinutesController.text = _currentLatMinutes;
    _LatMilliMinutesController.text = _currentLatMilliMinutes;

    _LonDegreesController.text = _currentLonDegrees;
    _LonMinutesController.text = _currentLonMinutes;
    _LonMilliMinutesController.text = _currentLonMilliMinutes;

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
                    textInputFormatter: _DegreesLatTextInputFormatter(allowNegativeValues: false),
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

                    if (_currentLatMinutes.length == 2) FocusScope.of(context).requestFocus(_latMilliMinutesFocusNode);
                  });
                }),
          ),
          const Expanded(
            flex: 1,
            child: GCWText(align: Alignment.center, text: '.'),
          ),
          Expanded(
            flex: 13,
            child: GCWIntegerTextField(
                hintText: 'MMM',
                min: 0,
                controller: _LatMilliMinutesController,
                focusNode: _latMilliMinutesFocusNode,
                onChanged: (IntegerText ret) {
                  setState(() {
                    _currentLatMilliMinutes = ret.text;
                    _setCurrentValueAndEmitOnChange();
                  });
                }),
          ),
          const Expanded(
            flex: 1,
            child: GCWText(align: Alignment.center, text: '\''),
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

                    if (_currentLonMinutes.length == 2) FocusScope.of(context).requestFocus(_lonMilliMinutesFocusNode);
                  });
                }),
          ),
          const Expanded(
            flex: 1,
            child: GCWText(align: Alignment.center, text: '.'),
          ),
          Expanded(
            flex: 13,
            child: GCWIntegerTextField(
                hintText: 'MMM',
                min: 0,
                controller: _LonMilliMinutesController,
                focusNode: _lonMilliMinutesFocusNode,
                onChanged: (IntegerText ret) {
                  setState(() {
                    _currentLonMilliMinutes = ret.text;
                    _setCurrentValueAndEmitOnChange();
                  });
                }),
          ),
          const Expanded(
            flex: 1,
            child: GCWText(align: Alignment.center, text: '\''),
          ),
        ],
      )
    ]);
  }

  void _setCurrentValueAndEmitOnChange() {
    int _degrees = ['', '-'].contains(_currentLatDegrees) ? 0 : int.parse(_currentLatDegrees);
    int _minutes = ['', '-'].contains(_currentLatMinutes) ? 0 : int.parse(_currentLatMinutes);
    double _minutesD = double.parse('$_minutes.$_currentLatMilliMinutes');
    var _currentLat = DMMLatitude(_currentLatSign, _degrees, _minutesD);

    _degrees = ['', '-'].contains(_currentLonDegrees) ? 0 : int.parse(_currentLonDegrees);
    _minutes = ['', '-'].contains(_currentLonMinutes) ? 0 : int.parse(_currentLonMinutes);
    _minutesD = double.parse('$_minutes.$_currentLonMilliMinutes');
    var _currentLon = DMMLongitude(_currentLonSign, _degrees, _minutesD);

    widget.onChanged(DMM(_currentLat, _currentLon));
  }
}
