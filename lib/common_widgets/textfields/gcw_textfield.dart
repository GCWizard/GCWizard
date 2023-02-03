import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/gcw_textselectioncontrols.dart';
import 'package:gc_wizard/common_widgets/text_input_formatters/wrapper_for_masktextinputformatter.dart';

class GCWTextField extends StatefulWidget {
  final TextEditingController controller;
  final Function onChanged;
  final Function validate;
  final List<TextInputFormatter> inputFormatters;
  final TextInputType keyboardType;
  final hintText;
  final hintColor;
  final labelText;
  final FocusNode focusNode;
  final autofocus;
  final icon;
  final filled;
  final maxLength;
  final maxLines;
  final fontSize;
  final String title;
  final TextStyle style;

  const GCWTextField({
    Key key,
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
    this.filled: false,
    this.maxLength,
    this.maxLines,
    this.title,
    this.fontSize,
    this.style,
  }) : super(key: key);

  @override
  _GCWTextFieldState createState() => _GCWTextFieldState();
}

class _GCWTextFieldState extends State<GCWTextField> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    if (widget.focusNode != null && widget.controller != null) {
      widget.focusNode?.addListener(() {
        if (widget.focusNode?.hasFocus) {
          widget?.controller?.selection = TextSelection(baseOffset: 0, extentOffset: widget?.controller?.text.length);
        }
      });
    }

    _controller = widget.controller ?? TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    ThemeColors colors = themeColors();
    var textField = Container(
        margin: EdgeInsets.symmetric(vertical: DEFAULT_MARGIN),
        child: LayoutBuilder(builder: (context, constraints) {
          return TextFormField(
            autocorrect: false,
            decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: gcwTextStyle().copyWith(color: widget.hintColor ?? themeColors().textFieldHintText()),
                labelText: widget.labelText,
                fillColor: widget.filled ? colors.textFieldFill() : null,
                filled: widget.filled,
                prefixIcon: widget.icon,
                isDense: true,
                suffixIconConstraints: BoxConstraints(
                  minWidth: 2,
                  minHeight: 2,
                ),
                suffixIcon: constraints.maxWidth > 100
                    ? InkWell(
                        child: Container(
                          child: Icon(
                            Icons.clear,
                            color: colors.mainFont(),
                          ),
                          padding: EdgeInsets.only(right: 5, top: 5, bottom: 5),
                        ),
                        onTap: () {
                          if (widget.controller != null) widget.controller.clear();

                          _controller.clear();

                          if (widget.onChanged != null) widget.onChanged('');

                          if (widget.inputFormatters != null) {
                            widget.inputFormatters.forEach((formatter) {
                              if (formatter is WrapperForMaskTextInputFormatter) {
                                formatter.clear();
                              }
                            });
                          }
                        },
                      )
                    : null),
            onChanged: widget.onChanged,
            controller: widget.controller ?? _controller,
            autovalidateMode: AutovalidateMode.always,
            validator: widget.validate,
            inputFormatters: widget.inputFormatters,
            keyboardType: widget.keyboardType,
            maxLines: widget.maxLines,
            focusNode: widget.focusNode,
            autofocus: widget.autofocus ?? false,
            style: widget.style != null
                ? widget.style
                : TextStyle(
                    fontSize: widget.fontSize ?? defaultFontSize(),
                    color: widget.filled ? colors.textFieldFillText() : colors.mainFont()),
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            maxLength: widget.maxLength,
            selectionControls: GCWTextSelectionControls(),
          );
        }));

    if ((widget.title ?? '').isEmpty) return textField;

    return Row(
      children: [
        Expanded(
            child: GCWText(
              text: widget.title + ':',
            ),
            flex: 1),
        Expanded(child: textField, flex: 3)
      ],
    );
  }
}
