part of 'package:gc_wizard/tools/crypto_and_encodings/alphabet_values/widget/alphabet_values.dart';

class _AlphabetValuesKeyValueItem extends GCWKeyValueItem {
  _AlphabetValuesKeyValueItem({
    required super.keyValueEntry,
    required super.odd,
  });

  @override
  GCWKeyValueItemState createState() => _GCWKeyValueAlphabetEntryState();
}

class _GCWKeyValueAlphabetEntryState extends GCWKeyValueItemState {
  @override
  void removeEntry() {
    var _isList = widget.keyValueEntry.value.contains(',');

    var buttons = [
      GCWDialogButton(
          text: i18n(context, 'alphabetvalues_edit_mode_customize_deleteletter_remove'),
          onPressed: () {
            super.removeEntry();
          })
    ];

    if (!_isList) {
      var deleteValue = int.tryParse(widget.keyValueEntry.value);

      buttons.add(GCWDialogButton(
        text: i18n(context, 'alphabetvalues_edit_mode_customize_deleteletter_removeandadjust'),
        onPressed: () {
          if (deleteValue != null) {
            for (var entry in widget.entries) {
              var newValue = entry.value.split(',').map((value) {
                var intValue = int.tryParse(value);
                if (intValue == null) return '';
                if (intValue > deleteValue) intValue--;

                return intValue.toString();
              }).join(',');

              entry.value = newValue;
            }
            super.removeEntry();
          }
        },
      ));
    }

    showGCWDialog(
        context,
        i18n(context, 'alphabetvalues_edit_mode_customize_deleteletter_title'),
        Text(i18n(context, 'alphabetvalues_edit_mode_customize_deleteletter_text',
            parameters: [widget.keyValueEntry.key])),
        buttons);
  }
}
