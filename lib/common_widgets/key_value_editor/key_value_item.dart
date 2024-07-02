part of 'package:gc_wizard/common_widgets/key_value_editor/gcw_key_value_editor.dart';

class GCWKeyValueItem extends StatefulWidget {
  late List<KeyValueBase> entries;
  KeyValueBase keyValueEntry;
  late KeyValueEditorControl keyValueEditorControl;

  final bool odd;
  late List<TextInputFormatter>? keyInputFormatters;
  late List<TextInputFormatter>? valueInputFormatters;
  bool editAllowed = true;
  late void Function(KeyValueBase)? onUpdateEntry;
  late void Function()? onSetState;

  final bool Function(String)? validateEditedValue;
  final String? invalidEditedValueMessage;

  GCWKeyValueItem(
      {Key? key,
      required this.keyValueEntry,
      required this.odd,
      this.validateEditedValue,
      this.invalidEditedValueMessage})
      : super(key: key);

  @override
  GCWKeyValueItemState createState() => GCWKeyValueItemState();
}

class GCWKeyValueItemState extends State<GCWKeyValueItem> {
  late TextEditingController _keyController;
  late TextEditingController _valueController;
  late FocusNode _focusNodeEditValue;

  var _currentKey = '';
  var currentValue = '';

  @override
  void initState() {
    super.initState();

    initValues();

    _focusNodeEditValue = FocusNode();
  }

  @override
  void didUpdateWidget(GCWKeyValueItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    initValues();
  }

  @override
  void dispose() {
    _keyController.dispose();
    _valueController.dispose();

    _focusNodeEditValue.dispose();

    super.dispose();
  }

  void initValues() {
    _currentKey = widget.keyValueEntry.key;
    currentValue = widget.keyValueEntry.value;

    _keyController = TextEditingController(text: _currentKey);
    _valueController = TextEditingController(text: currentValue);
  }

  @override
  Widget build(BuildContext context) {
    Widget output;

    var row = Row(
      children: <Widget>[
        keyWidget(),
        arrowIcon(),
        valueWidget(),
        editButton(),
        removeButton(),
      ],
    );

    if (widget.odd) {
      output = Container(color: themeColors().outputListOddRows(), child: row);
    } else {
      output = Container(child: row);
    }

    return output;
  }

  Widget keyWidget() {
    return Expanded(
      flex: 1,
      child: Container(
        margin: const EdgeInsets.only(left: 10),
        child: widget.keyValueEditorControl.currentInProgress == widget.keyValueEntry
            ? GCWTextField(
                controller: _keyController,
                inputFormatters: widget.keyInputFormatters,
                onChanged: (text) {
                  setState(() {
                    _currentKey = text;
                  });
                },
              )
            : GCWText(text: widget.keyValueEntry.key),
      ),
    );
  }

  Widget arrowIcon() {
    return Icon(
      Icons.arrow_forward,
      color: themeColors().mainFont(),
    );
  }

  Widget valueWidget() {
    return Expanded(
        flex: 3,
        child: Container(
          margin: const EdgeInsets.only(left: 10),
          child: widget.keyValueEditorControl.currentInProgress == widget.keyValueEntry
              ? GCWTextField(
                  controller: _valueController,
                  focusNode: _focusNodeEditValue,
                  inputFormatters: widget.valueInputFormatters,
                  onChanged: (text) {
                    setState(() {
                      currentValue = text;
                    });
                  },
                )
              : GCWText(text: widget.keyValueEntry.value),
        ));
  }

  Widget editButton() {
    if (!widget.editAllowed) return Container();

    return widget.keyValueEditorControl.currentInProgress == widget.keyValueEntry
        ? GCWIconButton(
            icon: Icons.check,
            onPressed: () {
              if (widget.validateEditedValue != null && !widget.validateEditedValue!(currentValue)) {
                if (widget.invalidEditedValueMessage != null && widget.invalidEditedValueMessage!.isNotEmpty) {
                  showSnackBar(widget.invalidEditedValueMessage!, context);
                }
                return;
              }

              updateEntry();
              widget.keyValueEditorControl.currentInProgress = null;
            },
          )
        : GCWIconButton(
            icon: Icons.edit,
            onPressed: () {
              setState(() {
                FocusScope.of(context).requestFocus(_focusNodeEditValue);

                widget.keyValueEditorControl.currentInProgress = widget.keyValueEntry;
                _currentKey = widget.keyValueEntry.key;
                currentValue = widget.keyValueEntry.value;
                _keyController.text = _currentKey;
                _valueController.text = currentValue;
              });
              if (widget.onSetState != null) widget.onSetState!();
            },
          );
  }

  Widget removeButton() {
    return GCWIconButton(
      icon: Icons.remove,
      onPressed: () {
        setState(() {
          removeEntry();
        });
        if (widget.onSetState != null) widget.onSetState!();
      },
    );
  }

  void updateEntry() {
    widget.keyValueEntry.key = _currentKey;
    widget.keyValueEntry.value = currentValue;
    if (widget.onUpdateEntry != null) widget.onUpdateEntry!(widget.keyValueEntry);

    setState(() {
      widget.keyValueEditorControl.currentInProgress = null;
      _keyController.clear();
      _valueController.clear();
    });
  }

  void removeEntry() {
    widget.entries.remove(widget.keyValueEntry);
    _finishRemoveEntry(widget.keyValueEntry);
  }

  void _finishRemoveEntry(KeyValueBase entry) {
    if (widget.onUpdateEntry != null) widget.onUpdateEntry!(entry);

    if (widget.onSetState != null) widget.onSetState!();
  }
}
