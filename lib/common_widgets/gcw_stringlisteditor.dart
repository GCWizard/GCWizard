import 'package:flutter/material.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';

class GCWStringlistEditor extends StatefulWidget {
  final List<String> list;
  final List<TextEditingController> controllers;
  final void Function() onChanged;

  const GCWStringlistEditor(
      {Key? key, required this.list, required this.controllers, required this.onChanged})
      : super(key: key);

  @override
  _GCWStringlistEditorState createState() => _GCWStringlistEditorState();
}

class _GCWStringlistEditorState extends State<GCWStringlistEditor> {
  int? _editIndex;
  String? _editValue;
  bool odd = false;

  void _resetControllers() {
    for (var controller in widget.controllers) {
      controller.dispose();
    }
    widget.controllers.clear();
  }

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[
      Row(
        children: [
          Expanded(
            child: Container(),
          ),
          GCWIconButton(
            icon: Icons.add,
            onPressed: () {
              setState(() {
                if (_editIndex != null && _editIndex! < widget.list.length && _editValue != null) {
                  widget.list[_editIndex!] = _editValue!;
                }
                widget.list.add('');
                _resetControllers();
                widget.onChanged();
                _editIndex = widget.list.length - 1;
                _editValue = '';
              });
            },
          )
        ],
      )
    ];

    if (widget.list.isEmpty) {
      return Column(
        children: children,
      );
    }

    for (var i = 0; i < widget.list.length; i++) {
      widget.controllers.add(TextEditingController(text: widget.list[i].toString()));
    }

    children.addAll(widget.list
        .asMap()
        .map<int, Widget>((index, item) {

      odd = !odd;

      return MapEntry<int, Widget>(
          index,
          Container(
            color: odd ? themeColors().outputListOddRows() : null,
            child: _editIndex == null || _editIndex != index
            ? Row(
                children: [
                  Expanded(
                    child: GCWText(
                      text: widget.list[index],
                    ),
                  ),
                  Container(width: DOUBLE_DEFAULT_MARGIN),
                  GCWIconButton(
                    icon: Icons.edit,
                    onPressed: () {
                      setState(() {
                        _editIndex = index;
                        _editValue = widget.list[index];
                      });
                    },
                  ),
                  GCWIconButton(
                    icon: Icons.remove,
                    onPressed: () {
                      setState(() {
                        widget.list.removeAt(index);
                        _resetControllers();
                        widget.onChanged();
                      });
                    },
                  )
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: GCWTextField(
                      controller: widget.controllers[index],
                      onChanged: (value) {
                        _editValue = value;
                      },
                    ),
                  ),
                  Container(width: DOUBLE_DEFAULT_MARGIN),
                  GCWIconButton(
                    icon: Icons.check,
                    onPressed: () {
                      setState(() {
                        widget.list[index] = _editValue!;
                        _editIndex = null;
                        _editValue = null;
                        widget.onChanged();
                      });
                    },
                  )
                ],
              )));
    })
        .values
        .toList());

    return Column(
      children: children,
    );
  }
}
