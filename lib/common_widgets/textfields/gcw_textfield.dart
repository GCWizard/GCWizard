import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/gcw_textselectioncontrols.dart';
import 'package:gc_wizard/common_widgets/text_input_formatters/wrapper_for_masktextinputformatter.dart';

class GCWTextField extends StatefulWidget {
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final String? Function(String?)? validate;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final String? hintText;
  final Color? hintColor;
  final String? labelText;
  final FocusNode? focusNode;
  final bool? autofocus;
  final Widget? icon;
  final bool? filled;
  final int? maxLength;
  final int? maxLines;
  final double? fontSize;
  final String title;
  final TextStyle? style;
  final List<int> flexValues;

  const GCWTextField({
    super.key,
    this.onChanged,
    this.controller,
    this.validate,
    this.inputFormatters,
    this.keyboardType,
    this.hintText,
    this.hintColor,
    this.labelText,
    this.focusNode,
    this.autofocus,
    this.icon,
    this.filled = false,
    this.maxLength,
    this.maxLines,
    this.title = '',
    this.fontSize,
    this.style,
    this.flexValues = const [],
  });

  @override
  _GCWTextFieldState createState() => _GCWTextFieldState();
}

class _GCWTextFieldState extends State<GCWTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    if (widget.focusNode != null && widget.controller != null) {
      widget.focusNode?.addListener(() {
        if (widget.focusNode?.hasFocus == true) {
          widget.controller?.selection =
              TextSelection(baseOffset: 0, extentOffset: widget.controller?.text.length ?? 0);
        }
      });
    }

    _controller = widget.controller ?? TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    ThemeColors colors = themeColors();
    var textField = Container(
        margin: const EdgeInsets.symmetric(vertical: DEFAULT_MARGIN),
        child: LayoutBuilder(builder: (context, constraints) {
          return TextFormField(
            autocorrect: false,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: gcwTextStyle().copyWith(color: widget.hintColor ?? themeColors().textFieldHintText()),
              labelText: widget.labelText,
              fillColor: widget.filled == true ? colors.textFieldFill() : null,
              filled: widget.filled,
              prefixIcon: widget.icon,
              isDense: true,
              suffixIconConstraints: const BoxConstraints(minWidth: 2, minHeight: 2),
              suffixIcon: constraints.maxWidth > 100
                  ? InkWell(
                child: Container(
                  padding: const EdgeInsets.only(right: 5, top: 5, bottom: 5),
                  child: Icon(Icons.clear, color: colors.mainFont()),
                ),
                onTap: () {
                  widget.controller?.clear();
                  _controller.clear();
                  widget.onChanged?.call('');
                  widget.inputFormatters?.forEach((f) {
                    if (f is GCWMaskTextInputFormatter) f.clear();
                  });
                },
              )
                  : null,
              suffix: widget.maxLength != null
                  ? Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _controller,
                  builder: (context, value, _) {
                    return Text(
                      '${value.text.length}/${widget.maxLength}',
                      style: TextStyle(color: colors.textFieldHintText(), fontSize: 12),
                    );
                  },
                ),
              )
                  : null,
              counterText: '', // verhindert den unteren Zähler
            ),
            onChanged: widget.onChanged,
            controller: widget.controller ?? _controller,
            autovalidateMode: AutovalidateMode.always,
            validator: widget.validate,
            inputFormatters: widget.inputFormatters,
            keyboardType: widget.keyboardType,
            maxLines: widget.maxLines,
            focusNode: widget.focusNode,
            autofocus: widget.autofocus ?? false,
            style: widget.style ??
                TextStyle(
                    fontSize: widget.fontSize ?? defaultFontSize(),
                    color: widget.filled == true ? colors.textFieldFillText() : colors.mainFont()),
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            maxLength: widget.maxLength,
            selectionControls: GCWTextSelectionControls(),
          );
        }));

    if (widget.title.isEmpty) return textField;

    return Row(
      children: [
        Expanded(
            flex: widget.flexValues.isNotEmpty ? widget.flexValues[0] : 1,
            child: GCWText(
              text: widget.title + ':',
            )),
        Expanded(flex: widget.flexValues.length > 1 ? widget.flexValues[1] : 3, child: textField)
      ],
    );
  }
}
