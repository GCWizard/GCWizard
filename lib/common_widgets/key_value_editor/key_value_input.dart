part of 'package:gc_wizard/common_widgets/key_value_editor/gcw_key_value_editor.dart';

class GCWKeyValueInput extends StatefulWidget {
  late List<KeyValueBase> entries;
  late String? keyHintText;
  late String valueHintText;
  late TextEditingController? keyController;
  late List<TextInputFormatter>? keyInputFormatters;
  late List<TextInputFormatter>? valueInputFormatters;
  late void Function(KeyValueBase)? onAddEntry;
  late void Function(KeyValueBase)? onNewEntryChanged;
  late void Function(KeyValueBase)? onUpdateEntry;
  late bool addOnDispose;
  late int? valueFlex;
  late void Function()? onSetState;

  GCWKeyValueInput({
    Key? key,
  }) : super(key: key);

  @override
  GCWKeyValueInputState createState() => GCWKeyValueInputState();
}

class GCWKeyValueInputState extends State<GCWKeyValueInput> {
  late TextEditingController _keyController;
  late TextEditingController _valueController;
  late FocusNode _focusNodeEditValue;

  var currentKey = '';
  var currentValue = '';

  @override
  void initState() {
    super.initState();

    if (widget.keyController == null) {
      _keyController = TextEditingController(text: currentKey);
    } else {
      _keyController = widget.keyController!;
      currentKey = _keyController.text;
    }
    _valueController = TextEditingController(text: currentValue);

    _focusNodeEditValue = FocusNode();
  }

  @override
  void dispose() {
    if (widget.addOnDispose && currentKey.isNotEmpty && currentValue.isNotEmpty) {
      addEntry(KeyValueBase(null, currentKey, currentValue));
    }
    if (widget.keyController == null) _keyController.dispose();
    _valueController.dispose();

    _focusNodeEditValue.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            keyWidget(),
            arrowIcon(),
            valueWidget(),
            addIcon(),
          ],
        ),
      ],
    );
  }

  Widget keyWidget() {
    return Expanded(
        flex: 2,
        child: GCWTextField(
          hintText: widget.keyHintText,
          controller: _keyController,
          inputFormatters: widget.keyInputFormatters,
          onChanged: (text) {
            setState(() {
              currentKey = text;
              _onNewEntryChanged(false);
            });
          },
        ));
  }

  Widget arrowIcon() {
    return Icon(
      Icons.arrow_forward,
      color: themeColors().mainFont(),
    );
  }

  Widget addIcon() {
    return GCWIconButton(
        icon: Icons.add,
        onPressed: () {
          if (!validInput()) {
            return;
          }

          setState(() {
            addEntry(KeyValueBase(null, currentKey, currentValue));
          });
        });
  }

  Widget valueWidget() {
    return Expanded(
      flex: widget.valueFlex ?? 2,
      child: GCWTextField(
        hintText: widget.valueHintText,
        controller: _valueController,
        inputFormatters: widget.valueInputFormatters,
        onChanged: (text) {
          setState(() {
            currentValue = text;
            _onNewEntryChanged(false);
          });
        },
      ),
    );
  }

  bool validInput() {
    return true;
  }

  void addEntry(KeyValueBase entry, {bool clearInput = true}) {
    if (widget.onAddEntry == null) {
      widget.entries.add(entry);
    } else {
      widget.onAddEntry!(entry);
    }
    finishAddEntry(entry, clearInput);
  }

  void finishAddEntry(KeyValueBase entry, bool clearInput) {
    if (clearInput) _onNewEntryChanged(true);
    if (widget.onAddEntry == null) {
      if (widget.onUpdateEntry != null) widget.onUpdateEntry!(entry);
    }

    if (widget.onSetState != null) widget.onSetState!();
  }

  void _onNewEntryChanged(bool resetInput) {
    if (resetInput) {
      if (widget.keyController == null) {
        _keyController.clear();
        currentKey = '';
      } else {
        currentKey = _keyController.text;
      }

      _valueController.clear();
      currentValue = '';
    }
    if (widget.onNewEntryChanged != null) {
      widget.onNewEntryChanged!(KeyValueBase(null, currentKey, currentValue));
    }
  }

  void pasteClipboard(String text) {
    Object? json = jsonDecode(text);
    List<MapEntry<String, String>>? list;
    if (isJsonArray(json)) {
      list = _fromJson(json as List<Object?>);
    } else {
      list = _parseClipboardText(text);
    }

    if (list != null) {
      for (var mapEntry in list) {
        addEntry(KeyValueBase(null, mapEntry.key, mapEntry.value), clearInput: false);
      }
    }
  }

  List<MapEntry<String, String>>? _fromJson(List<Object?> json) {
    var list = <MapEntry<String, String>>[];
    String? key;
    String? value;

    for (var jsonEntry in json) {
      if (jsonEntry == null || jsonEntry is! String) {
        continue;
      }

      var json = jsonDecode(jsonEntry);
      key = toStringOrNull(json['key']);
      value = toStringOrNull(json['value']);

      if (key != null && value != null) list.add(MapEntry(key, value));
    }

    return list.isEmpty ? null : list;
  }

  List<MapEntry<String, String>>? _parseClipboardText(String? text) {
    var list = <MapEntry<String, String>>[];
    if (text == null) return null;

    List<String> lines = const LineSplitter().convert(text);

    for (var line in lines) {
      var regExp = RegExp(r"^([\s]*)([\S])([\s]*)([=]?)([\s]*)([\s*\S+]+)([\s]*)");
      var match = regExp.firstMatch(line);
      if (match != null && match.group(2) != null && match.group(6) != null) {
        list.add(MapEntry(match.group(2)!, match.group(6)!));
      }
    }

    return list.isEmpty ? null : list;
  }
}
