import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/application/navigation/no_animation_material_page_route.dart';
import 'package:gc_wizard/application/settings/logic/preferences.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_button.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/gcw_tool.dart';
import 'package:gc_wizard/common_widgets/gcw_toolbar.dart';
import 'package:gc_wizard/tools/symbol_tables/_common/logic/symbol_table_data.dart';
import 'package:gc_wizard/tools/symbol_tables/symbol_replacer/logic/symbol_replacer.dart';
import 'package:gc_wizard/tools/symbol_tables/symbol_replacer/widget/symbol_replacer_manual_setter.dart';
import 'package:gc_wizard/tools/symbol_tables/_common/widget/gcw_symbol_container.dart';
import 'package:gc_wizard/tools/symbol_tables/_common/widget/gcw_symbol_table_symbol_matrix.dart';
import 'package:prefs/prefs.dart';

class SymbolReplacerManualControl extends StatefulWidget {
  final SymbolReplacerImage symbolImage;

  const SymbolReplacerManualControl({Key key, this.symbolImage}) : super(key: key);

  @override
  SymbolReplacerManualControlState createState() => SymbolReplacerManualControlState();
}

class SymbolReplacerManualControlState extends State<SymbolReplacerManualControl> {
  var _symbolMap = Map<Symbol, Map<String, SymbolData>>();
  SymbolData _selectedSymbolData;
  var _removeActiv = false;
  var _addActiv = false;

  TextEditingController _editValueController;

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
        ? Prefs.get(PREFERENCE_SYMBOLTABLES_COUNTCOLUMNS_PORTRAIT)
        : Prefs.get(PREFERENCE_SYMBOLTABLES_COUNTCOLUMNS_LANDSCAPE);

    return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      widget.symbolImage != null ? _buildEditRow() : Container(),
      _buildMatrix(widget.symbolImage, countColumns, mediaQueryData),
    ]);
  }

  Widget _buildMatrix(SymbolReplacerImage symbolImage, int countColumns, MediaQueryData mediaQueryData) {
    if (symbolImage?.symbols == null) return Container();

    symbolImage.symbols.forEach((symbol) {
      if (_symbolMap.containsKey(symbol)) {
        var _symbolData = _symbolMap[symbol];
        var _displayText = symbol?.symbolGroup?.text ?? '';
        if (_symbolData?.values?.first?.displayName != _displayText) {
          _symbolMap[symbol] = _cloneSymbolData(_symbolData, _displayText);
          if (_selectedSymbolData == _symbolData) _selectedSymbolData = _symbolMap[symbol]?.values?.first;
        }
      } else
        _symbolMap.addAll({
          symbol: {null: SymbolData(bytes: symbol.getImage(), displayName: symbol?.symbolGroup?.text ?? '')}
        });
    });

    return Expanded(
        child: GCWSymbolTableSymbolMatrix(
      fixed: false,
      imageData: _symbolMap.values,
      countColumns: countColumns,
      mediaQueryData: mediaQueryData,
      onChanged: () => setState(() {}),
      selectable: true,
      overlayOn: true,
      onSymbolTapped: (String tappedText, SymbolData imageData) {
        setState(() {
          _selectGroupSymbols(imageData, (imageData.primarySelected || imageData.secondarySelected));
        });
      },
    ));
  }

  Map<String, SymbolData> _cloneSymbolData(Map<String, SymbolData> image, String text) {
    var symbolData = SymbolData(bytes: image.values.first.bytes, displayName: text ?? '');
    symbolData.primarySelected = image.values.first.primarySelected;
    symbolData.secondarySelected = image.values.first.secondarySelected;
    return {null: symbolData};
  }

  Symbol _getSymbol(SymbolData imageData) {
    return _symbolMap.entries.firstWhere((entry) => entry.value.values.first == imageData, orElse: () => null)?.key;
  }

  _selectGroupSymbols(SymbolData imageData, bool selected) {
    Symbol _symbol = _getSymbol(imageData);

    if (!(_addActiv || _removeActiv))
      _selectedSymbolData = selected ? imageData : null;
    else
      selected = _symbol?.symbolGroup == _getSymbol(_selectedSymbolData)?.symbolGroup;

    if (_addActiv && !selected) {
      widget.symbolImage.addToGroup(_symbol, _getSymbol(_selectedSymbolData)?.symbolGroup);
      imageData.primarySelected = true;
      _symbol = _getSymbol(_selectedSymbolData);
      selected = true;
    }

    if (_removeActiv && selected) {
      if (_selectedSymbolData == imageData) {
        var symbolGroup = _getSymbol(_selectedSymbolData)?.symbolGroup;
        widget.symbolImage.removeFromGroup(_symbol);
        _selectedSymbolData = symbolGroup.symbols.isEmpty ? null : _symbolMap[symbolGroup.symbols.first]?.values?.first;
      } else
        widget.symbolImage.removeFromGroup(_symbol);
      _symbol = _getSymbol(_selectedSymbolData);
    }

    if (selected)
      // reset all selections
      _symbolMap.values.forEach((image) {
        image.values.first.primarySelected = false;
      });

    if (_symbol?.symbolGroup?.symbols != null) {
      _symbol.symbolGroup.symbols.forEach((symbol) {
        var image = _symbolMap[symbol];
        image.values.first.primarySelected = selected;
        _editValueController.text = image.values.first.displayName;
      });
    }
  }

  _getGroupSymbol(SymbolData imageData) {
    Symbol _symbol = _getSymbol(imageData);
    if (_symbol?.symbolGroup != null) return _symbol.symbolGroup.compareSymbol;
  }

  Widget _buildEditRow() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            children: [
              GCWToolBar(children: <Widget>[
                GCWIconButton(
                  icon: Icons.add_circle,
                  iconColor: _selectedSymbolData == null
                      ? themeColors().inActive()
                      : _addActiv
                          ? Colors.red
                          : null,
                  onPressed: () {
                    setState(() {
                      _addActiv = !_addActiv;
                      if (_addActiv) _removeActiv = false;
                    });
                  },
                ),
                GCWIconButton(
                  icon: Icons.remove_circle,
                  iconColor: _selectedSymbolData == null
                      ? themeColors().inActive()
                      : _removeActiv
                          ? Colors.red
                          : null,
                  onPressed: () {
                    setState(() {
                      _removeActiv = !_removeActiv;
                      if (_removeActiv) _addActiv = false;
                    });
                  },
                )
              ]),
              GCWButton(
                  text: i18n(context, 'symbol_replacer_letters_manually'),
                  onPressed: () {
                    _navigateToSubPage();
                  })
            ],
          ),
          flex: 1,
        ),
        _identifiedSymbol()
      ],
    );
  }

  Widget _identifiedSymbol() {
    if (widget.symbolImage?.compareSymbols == null) {
      return Expanded(
        child: Column(children: [Container()]),
        flex: 1,
      );
    }

    return Expanded(
      child: Column(children: [
        AutoSizeText(i18n(context, 'symbol_replacer_symbol'),
            textAlign: TextAlign.center,
            style: gcwTextStyle().copyWith(fontSize: defaultFontSize() - 2),
            minFontSize: AUTO_FONT_SIZE_MIN,
            maxLines: 2),
        Container(height: 3),
        Row(children: [
          Expanded(child: Container(), flex: 1),
          Container(
              height: 80,
              child: _getGroupSymbol(_selectedSymbolData) == null
                  ? Container(width: 80, color: Colors.white)
                  : GCWSymbolContainer(symbol: Image.memory(_getGroupSymbol(_selectedSymbolData).bytes))),
          Expanded(child: Container(), flex: 1),
        ])
      ]),
      flex: 1,
    );
  }

  _navigateToSubPage() {
    var selectedSymbols = <Symbol>[];
    _symbolMap.forEach((symbol, image) {
      var symbolData = image.values.first;
      if (symbolData.primarySelected || symbolData.secondarySelected) selectedSymbols.add(symbol);
    });

    var subPageTool = GCWTool(
        autoScroll: false,
        tool: SymbolReplacerManualSetter(symbolImage: widget.symbolImage, viewSymbols: selectedSymbols),
        i18nPrefix: 'symbol_replacer',
        searchKeys: ['symbol_replacer']);

    Navigator.push(context, NoAnimationMaterialPageRoute(builder: (context) => subPageTool)).whenComplete(() {
      setState(() {
        var _addActivTmp = _addActiv;
        var _removeActivTmp = _removeActiv;
        _addActiv = false;
        _removeActiv = false;
        _selectGroupSymbols(_selectedSymbolData, true);
        _addActiv = _addActivTmp;
        _removeActiv = _removeActivTmp;
      });
    });
  }
}
