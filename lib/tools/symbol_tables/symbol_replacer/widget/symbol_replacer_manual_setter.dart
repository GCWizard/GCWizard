part of 'package:gc_wizard/tools/symbol_tables/symbol_replacer/widget/symbol_replacer_manual_control.dart';

class SymbolReplacerManualSetter extends StatefulWidget {
  final SymbolReplacerImage symbolImage;
  final List<Symbol> viewSymbols;

  const SymbolReplacerManualSetter({Key? key, required this.symbolImage, required this.viewSymbols}) : super(key: key);

  @override
  _SymbolReplacerManualSetterState createState() => _SymbolReplacerManualSetterState();
}

class _SymbolReplacerManualSetterState extends State<SymbolReplacerManualSetter> {
  final _symbolMap = <Symbol, Map<String, SymbolData>>{};
  List<GCWDropDownMenuItem<Map<String, SymbolReplacerSymbolData>>> _symbolDataItems = [];
  final _gcwTextStyle = gcwTextStyle();
  var _currentMode = GCWSwitchPosition.left;
  Map<String, SymbolReplacerSymbolData>? _currentSymbolData;
  var _init = true;

  late TextEditingController _editValueController;

  @override
  void initState() {
    super.initState();
    _editValueController = TextEditingController();
  }

  @override
  void dispose() {
    _editValueController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    var countColumns = mediaQueryData.orientation == Orientation.portrait
        ? Prefs.getInt(PREFERENCE_SYMBOLTABLES_COUNTCOLUMNS_PORTRAIT)
        : Prefs.getInt(PREFERENCE_SYMBOLTABLES_COUNTCOLUMNS_LANDSCAPE);

    if (_init) {
      _fillSymbolDataItems(widget.symbolImage.compareSymbols);
      _currentSymbolData = widget.symbolImage.compareSymbols?.firstOrNull;
      _fillSymbolMap(widget.symbolImage, widget.viewSymbols);

      // select all
      for (var image in _symbolMap.values) {
        image.values.first.primarySelected = true;
      }
      if (_symbolMap.values.isNotEmpty) {
        _selectSymbol(_symbolMap.values.first.values.first);
      }

      if ((widget.symbolImage.compareSymbols == null) ||
          (widget.viewSymbols.isEmpty || widget.viewSymbols.first.symbolGroup?.compareSymbol == null)) {
        _currentMode = GCWSwitchPosition.right;
      }

      _init = false;
    }

    return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      _buildEditRow(),
      _buildMatrix(widget.symbolImage, widget.viewSymbols, countColumns, mediaQueryData),
    ]);
  }

  void _fillSymbolMap(SymbolReplacerImage symbolImage, List<Symbol> viewSymbols) {
    symbolImage.symbols.where((sym) => viewSymbols.contains(sym)).forEach((symbol) {
      if (_symbolMap.containsKey(symbol)) {
        var _symbolData = _symbolMap[symbol];
        var _displayText = symbol.symbolGroup?.text ?? '';
        if (_symbolData?.values.first.displayName != _displayText) {
          _symbolMap[symbol] = _cloneSymbolData(_symbolData!, _displayText);
        }
      } else {
        _symbolMap.addAll({
          symbol: {'': SymbolData(path: '', bytes: symbol.getImage(), displayName: symbol.symbolGroup?.text ?? '')}
        });
      }
    });
  }

  void _fillSymbolDataItems(List<Map<String, SymbolReplacerSymbolData>>? compareSymbols) {
    _symbolDataItems = (compareSymbols == null)
        ? <GCWDropDownMenuItem<Map<String, SymbolReplacerSymbolData>>>[].toList()
        : compareSymbols.map((symbolData) {
            return _buildDropDownMenuItem(symbolData);
          }).toList();
  }

  Widget _buildMatrix(
      SymbolReplacerImage symbolImage, List<Symbol> viewSymbols, int countColumns, MediaQueryData mediaQueryData) {
    _fillSymbolMap(symbolImage, viewSymbols);

    return Expanded(
        child: GCWSymbolTableSymbolMatrix(
      fixed: false,
      imageData: _symbolMap.values,
      countColumns: countColumns,
      mediaQueryData: mediaQueryData,
      onChanged: () => setState(() {}),
      selectable: true,
      overlayOn: true,
      scale: widget.symbolImage.symbolScale,
      onSymbolTapped: (String tappedText, SymbolData symbolData) {
        setState(() {
          _selectSymbol(symbolData);
        });
      },
    ));
  }

  void _selectSymbol(SymbolData symbolData) {
    _selectSymbolDataItem(symbolData);
    _editValueController.text = symbolData.displayName ?? '';
  }

  void _setSelectedSymbolsText(String? text, {SymbolReplacerSymbolData? symbolData}) {
    var selectedSymbols = <Symbol>[];
    _symbolMap.forEach((symbol, image) {
      var symbolData = image.values.first;
      if (symbolData.primarySelected || symbolData.secondarySelected) selectedSymbols.add(symbol);
    });
    widget.symbolImage.buildSymbolGroup(selectedSymbols);
    if (selectedSymbols.isNotEmpty && (selectedSymbols.first.symbolGroup != null)) {
      selectedSymbols.first.symbolGroup!.text = text;
      selectedSymbols.first.symbolGroup!.compareSymbol = symbolData;
    }
  }

  Widget _buildEditRow() {
    return Column(
      children: <Widget>[
        (widget.symbolImage.compareSymbols == null || widget.symbolImage.compareSymbols!.isEmpty)
            ? Container()
            : GCWTwoOptionsSwitch(
                leftValue: i18n(context, 'symbol_replacer_from_symboltable'),
                rightValue: i18n(context, 'symbol_replacer_own_text'),
                value: _currentMode,
                notitle: true,
                onChanged: (value) {
                  setState(() {
                    _currentMode = value;
                  });
                },
              ),
        _buildTextEditRow()
      ],
    );
  }

  Widget _buildTextEditRow() {
    return Column(children: [
      GCWToolBar(
        flexValues: const [3, 1],
        children: <Widget>[
          _currentMode == GCWSwitchPosition.right
              ? GCWTextField(
                  controller: _editValueController,
                  autofocus: true,
                )
              : GCWDropDown<Map<String, SymbolReplacerSymbolData>>(
                  value: _currentSymbolData ?? _symbolDataItems.firstOrNull?.value ?? {},
                  onChanged: (value) {
                    setState(() {
                      _currentSymbolData = value;
                    });
                  },
                  items: _symbolDataItems),
          GCWIconButton(
            icon: Icons.alt_route,
            iconColor: _symbolMap.values.any((symbol) => symbol.values.first.primarySelected)
                ? null
                : themeColors().inActive(),
            onPressed: () {
              setState(() {
                if (_currentMode == GCWSwitchPosition.left) {
                  _setSelectedSymbolsText(_currentSymbolData?.keys.first, symbolData: _currentSymbolData?.values.first);
                } else {
                  _setSelectedSymbolsText(_editValueController.text);
                }
              });
            },
          ),
        ],
      ),
      Row(
        children: [
          Expanded(
              child: GCWButton(
            text: i18n(context, 'symboltablesexamples_selectall'),
            margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
            onPressed: () {
              setState(() {
                for (var image in _symbolMap.values) {
                  image.values.first.primarySelected = true;
                }
              });
            },
          )),
          Container(width: DOUBLE_DEFAULT_MARGIN),
          Expanded(
              child: GCWButton(
            text: i18n(context, 'symboltablesexamples_deselectall'),
            margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
            onPressed: () {
              setState(() {
                for (var image in _symbolMap.values) {
                  image.values.first.primarySelected = false;
                }
              });
            },
          )),
        ],
      ),
    ]);
  }

  void _selectSymbolDataItem(SymbolData symbolData) {
    var compareSymbol = _getSymbol(_symbolMap, symbolData)?.symbolGroup?.compareSymbol;
    if ((widget.symbolImage.compareSymbols != null) && (compareSymbol != null)) {
      for (var item in _symbolDataItems) {
        if (item.value.values.first == compareSymbol) {
          _currentSymbolData = item.value;
          break;
        }
      }
    }
  }

  GCWDropDownMenuItem<Map<String, SymbolReplacerSymbolData>> _buildDropDownMenuItem(
      Map<String, SymbolReplacerSymbolData> symbolData) {
    var iconBytes = symbolData.values.first.bytes;
    var displayText = symbolData.keys.first;
    return GCWDropDownMenuItem(
        value: symbolData,
        child: Row(children: [
          Container(
            margin: const EdgeInsets.only(left: 2, top: 2, bottom: 2, right: 10),
            child: (iconBytes != null)
                ? GCWSymbolContainer(symbol: Image.memory(iconBytes))
                : Container(width: DEFAULT_LISTITEM_SIZE),
          ),
          Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(displayText, style: _gcwTextStyle)]))
        ]));
  }
}

Map<String, SymbolData> _cloneSymbolData(Map<String, SymbolData> image, String text) {
  var symbolData = SymbolData(bytes: image.values.first.bytes, displayName: text, path: '');
  symbolData.primarySelected = image.values.first.primarySelected;
  symbolData.secondarySelected = image.values.first.secondarySelected;
  return {'': symbolData};
}

Symbol? _getSymbol(Map<Symbol, Map<String, SymbolData>> _symbolMap, SymbolData? imageData) {
  return _symbolMap.entries.firstWhereOrNull((entry) => entry.value.values.first == imageData)?.key;
}
