import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_button.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/science_and_technology/iata_icao_search/logic/iata_icao.dart';

class IATAICAOSearch extends StatefulWidget {
  @override
  IATAICAOSearchState createState() => IATAICAOSearchState();
}

class IATAICAOSearchState extends State<IATAICAOSearch> {
  var _inputControllerCode;
  var _inputControllerName;

  String _currentInputCode = '';
  String _currentInputName = '';

  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;
  GCWSwitchPosition _currentCode = GCWSwitchPosition.left;

  var _output;

  @override
  void initState() {
    super.initState();
    _inputControllerCode = TextEditingController(text: _currentInputCode);
    _inputControllerName = TextEditingController(text: _currentInputName);
  }

  @override
  void dispose() {
    _inputControllerCode.dispose();
    _inputControllerName.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTwoOptionsSwitch(
          value: _currentMode,
          notitle: true,
          title: i18n(context, 'iataicao_search'),
          leftValue: i18n(context, 'iataicao_search_name'),
          rightValue: i18n(context, 'iataicao_search_code'),
          onChanged: (value) {
            setState(() {
              _currentMode = value;
              _output = null;
            });
          },
        ),
        _currentMode == GCWSwitchPosition.left
            ? GCWTextField(
                controller: _inputControllerName,
                hintText: i18n(context, 'iataicao_search_contains'),
                onChanged: (text) {
                  setState(() {
                    _currentInputName = text;
                    _output = null;
                  });
                },
              )
            : Column(
                children: <Widget>[
                  GCWTwoOptionsSwitch(
                    value: _currentCode,
                    notitle: true,
                    leftValue: i18n(context, 'iataicao_iata'),
                    rightValue: i18n(context, 'iataicao_icao'),
                    onChanged: (value) {
                      setState(() {
                        _currentCode = value;
                        _output = null;
                      });
                    },
                  ),
                  GCWTextField(
                    controller: _inputControllerCode,
                    hintText: i18n(context, 'iataicao_search_startswith'),
                    onChanged: (text) {
                      setState(() {
                        _currentInputCode = text;
                        _output = null;
                      });
                    },
                  ),
                ],
              ),
        GCWButton(
          text: i18n(context, 'common_search'),
          onPressed: () {
            setState(() {
              _output = _buildOutput();
            });
          },
        ),
        GCWDefaultOutput(child: _output)
      ],
    );
  }

  Widget _buildOutput() {
    if (_currentMode == GCWSwitchPosition.left) {
      // search for name
      if (_currentInputName == null || _currentInputName == "") return Container();

      List<List<String>> data = [];
      List<int> flexValues = List<int>.generate(4, (index) => 1);

      data = IATA_ICAO_CODES.values
          .where((e) => e['name'] != null && e['name'].toLowerCase().contains(_currentInputName.toLowerCase()))
          .map((e) {
        var dataList = [e['name']];
        dataList.addAll(['IATA', 'ICAO', 'Location_served'].map((field) => e[field]));

        return dataList;
      }).toList();

      flexValues = [2, 1, 1, 2];
      data.sort((a, b) => a[0].compareTo(b[0]));
      data.insert(0, [
        i18n(context, 'common_name'),
        i18n(context, 'iataicao_iata'),
        i18n(context, 'iataicao_icao'),
        i18n(context, 'common_place')
      ]);

      return GCWColumnedMultilineOutput(
          data: data,
          flexValues: flexValues,
          copyColumn: 1,
          hasHeader: true
      );
    } else {
      // search for code
      if (_currentInputCode == null || _currentInputCode == "") return Container();

      List<int> flexValues = List<int>.generate(4, (index) => 1);
      var output;

      if (_currentCode == GCWSwitchPosition.left) {
        // search for IATA
        var data = IATA_ICAO_CODES.values
            .where((e) => (e['IATA'] != null && e['IATA'].startsWith(_currentInputCode.toUpperCase())))
            .map((e) {
          var dataList = [e['IATA']];
          dataList.addAll(['IATA', 'ICAO', 'name', 'Location_served'].where((f) => (f != 'IATA')).map((f) => e[f]));
          return dataList;
        }).toList();
        flexValues = [1, 1, 2, 2];

        data.sort((a, b) {
          var result = a[0].compareTo(b[0]);
          if (result != 0) return result;

          return a[1].compareTo(b[1]);
        });

        data.insert(0, [
          i18n(context, 'iataicao_iata'),
          i18n(context, 'iataicao_icao'),
          i18n(context, 'common_name'),
          i18n(context, 'common_place')
        ]);

        return GCWColumnedMultilineOutput(
            data: data,
            flexValues: flexValues,
            copyColumn: 2,
            hasHeader: true
        );
      } else {
        var data = IATA_ICAO_CODES.values
            .where((e) => (e['ICAO'] != null && e['ICAO'].startsWith(_currentInputCode.toUpperCase())))
            .map((e) {
          var dataList = [e['ICAO']];
          dataList.addAll(['ICAO', 'IATA', 'name', 'Location_served'].where((f) => (f != 'ICAO')).map((f) => e[f]));
          return dataList;
        }).toList();
        flexValues = [1, 1, 2, 2];

        data.sort((a, b) {
          var result = a[0].compareTo(b[0]);
          if (result != 0) return result;

          return a[1].compareTo(b[1]);
        });

        data.insert(0, [
          i18n(context, 'iataicao_icao'),
          i18n(context, 'iataicao_iata'),
          i18n(context, 'common_name'),
          i18n(context, 'common_place')
        ]);

        return GCWColumnedMultilineOutput(
            data: data,
            flexValues: flexValues,
            copyColumn: 2,
            hasHeader: true
        );
      }
    }
  }
}
