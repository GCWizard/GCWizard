import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_button.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/gcw_painter_container.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/utils/variable_string_expander.dart';
import 'package:touchable/touchable.dart';

part 'package:gc_wizard/tools/general_tools/grid_generator/grid/widget/grid_painter.dart';

class _GridConfiguration {
  _GridType type;
  int width;
  int height;
  String? enumeration;
  String? columnEnumeration;
  String? rowEnumeration;
  _GridEnumerationStart? enumerationStart;
  _GridBoxEnumerationStartDirection? enumerationStartDirection;
  _GridBoxEnumerationBehaviour? enumerationBehaviour;

  _GridConfiguration(this.type, this.width, this.height,
      {this.enumeration, this.columnEnumeration, this.rowEnumeration});
}

Map<int, Map<int, _GridPaintColor>>? _gridState;

const _GRID_CUSTOM_KEY = 'grid_custom';

final _GRID_CONFIGURATIONS = {
  _GRID_CUSTOM_KEY: _GridConfiguration(
    _GridType.BOXES,
    10,
    10,
    enumeration: '1-100',
  ),
  'grid_intersections_5x5':
      _GridConfiguration(_GridType.INTERSECTIONS, 5, 5, columnEnumeration: '12345', rowEnumeration: '12345'),
  'grid_intersections_6x6':
      _GridConfiguration(_GridType.INTERSECTIONS, 6, 6, columnEnumeration: '123456', rowEnumeration: '123456'),
  'grid_intersections_7x7':
      _GridConfiguration(_GridType.INTERSECTIONS, 7, 7, columnEnumeration: '1234567', rowEnumeration: '1,2,3,4,5-7'),
  'grid_intersections_8x8':
      _GridConfiguration(_GridType.INTERSECTIONS, 8, 8, columnEnumeration: '12345678', rowEnumeration: '12345678'),
  'grid_intersections_9x9':
      _GridConfiguration(_GridType.INTERSECTIONS, 9, 9, columnEnumeration: '123456789', rowEnumeration: '123456789'),
  'grid_intersections_10x10': _GridConfiguration(_GridType.INTERSECTIONS, 10, 10,
      columnEnumeration: '1 2 3 4 5 6 7 8 9 10', rowEnumeration: '1 2 3 4 5 6 7 8 9 10'),
  'grid_boxes_5x5': _GridConfiguration(
    _GridType.BOXES,
    5,
    5,
    enumeration: '1-25',
  ),
  'grid_boxes_6x6': _GridConfiguration(
    _GridType.BOXES,
    6,
    6,
    enumeration: '1-36',
  ),
  'grid_boxes_7x7': _GridConfiguration(
    _GridType.BOXES,
    7,
    7,
    enumeration: '1-49',
  ),
  'grid_boxes_8x8': _GridConfiguration(_GridType.BOXES, 8, 8, enumeration: '1-64'),
  'grid_boxes_9x9': _GridConfiguration(
    _GridType.BOXES,
    9,
    9,
    enumeration: '1-81',
  ),
  'grid_boxes_10x10': _GridConfiguration(
    _GridType.BOXES,
    10,
    10,
    enumeration: '1-100',
  ),
  'grid_chessboard': _GridConfiguration(_GridType.BOXES, 8, 8, columnEnumeration: 'ABCDEFGH', rowEnumeration: '1-8'),
  'grid_germanlotto': _GridConfiguration(
    _GridType.BOXES,
    7,
    7,
    enumeration: '1-49',
  ),
  'grid_germantoto6from45': _GridConfiguration(
    _GridType.BOXES,
    7,
    7,
    enumeration: '1-45',
  ),
  'grid_eurojackpot5from50': _GridConfiguration(
    _GridType.BOXES,
    10,
    5,
    enumeration: '1-50',
  ),
};

class Grid extends StatefulWidget {
  const Grid({Key? key}) : super(key: key);

  @override
  _GridState createState() => _GridState();
}

class _GridState extends State<Grid> {
  var _currentColor = _GridPaintColor.RED;
  var _currentGridConfiguration = 'grid_boxes_10x10';

  var _isConfiguration = false;
  double _scale = 1;
  late _GridType _currentConfigType;
  late int _currentConfigColumns;
  late int _currentConfigRows;
  String? _currentConfigBoxEnumeration;
  String? _currentConfigColumnEnumeration;
  String? _currentConfigRowEnumeration;
  late _GridEnumerationStart _currentConfigBoxEnumerationStart;
  late _GridBoxEnumerationStartDirection _currentConfigBoxEnumerationStartDirection;
  late _GridBoxEnumerationBehaviour _currentConfigBoxEnumerationBehaviour;

  late List<_GridBoxEnumerationStartDirection> _currentConfigBoxEnumerationStartDirections;

  late TextEditingController _boxEnumerationController;
  late TextEditingController _columnEnumerationController;
  late TextEditingController _rowEnumerationController;

  @override
  void initState() {
    super.initState();

    _initializeDefaultGrid();

    _boxEnumerationController = TextEditingController(text: _currentConfigBoxEnumeration);
    _columnEnumerationController = TextEditingController(text: _currentConfigColumnEnumeration);
    _rowEnumerationController = TextEditingController(text: _currentConfigRowEnumeration);
  }

  @override
  void dispose() {
    _boxEnumerationController.dispose();
    _columnEnumerationController.dispose();
    _rowEnumerationController.dispose();

    super.dispose();
  }

  void _initializeDefaultGrid() {
    _clearGrid();

    _currentConfigType = _GRID_CONFIGURATIONS[_currentGridConfiguration]?.type ?? _GridType.BOXES;
    _currentConfigColumns = _GRID_CONFIGURATIONS[_currentGridConfiguration]?.width ?? 10;
    _currentConfigRows = _GRID_CONFIGURATIONS[_currentGridConfiguration]?.height ?? 10;
    _currentConfigBoxEnumeration = _GRID_CONFIGURATIONS[_currentGridConfiguration]?.enumeration ?? '';
    _currentConfigColumnEnumeration = _GRID_CONFIGURATIONS[_currentGridConfiguration]?.columnEnumeration ?? '';
    _currentConfigRowEnumeration = _GRID_CONFIGURATIONS[_currentGridConfiguration]?.rowEnumeration ?? '';
    _currentConfigBoxEnumerationStart =
        _GRID_CONFIGURATIONS[_currentGridConfiguration]?.enumerationStart ?? _GridEnumerationStart.TOP_LEFT;
    _currentConfigBoxEnumerationStartDirection =
        _GRID_CONFIGURATIONS[_currentGridConfiguration]?.enumerationStartDirection ??
            _GridBoxEnumerationStartDirection.RIGHT;
    _currentConfigBoxEnumerationBehaviour =
        _GRID_CONFIGURATIONS[_currentGridConfiguration]?.enumerationBehaviour ?? _GridBoxEnumerationBehaviour.ALIGNED;

    _currentConfigBoxEnumerationStartDirections = _possibleStartDirections();
  }

  List<_GridBoxEnumerationStartDirection> _possibleStartDirections() {
    switch (_currentConfigBoxEnumerationStart) {
      case _GridEnumerationStart.TOP_LEFT:
        return [_GridBoxEnumerationStartDirection.RIGHT, _GridBoxEnumerationStartDirection.DOWN];
      case _GridEnumerationStart.TOP_RIGHT:
        return [_GridBoxEnumerationStartDirection.LEFT, _GridBoxEnumerationStartDirection.DOWN];
      case _GridEnumerationStart.BOTTOM_LEFT:
        return [_GridBoxEnumerationStartDirection.RIGHT, _GridBoxEnumerationStartDirection.UP];
      case _GridEnumerationStart.BOTTOM_RIGHT:
        return [_GridBoxEnumerationStartDirection.LEFT, _GridBoxEnumerationStartDirection.UP];
      default:
        return [_GridBoxEnumerationStartDirection.RIGHT, _GridBoxEnumerationStartDirection.DOWN];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: [
            Expanded(
              child: GCWDropDown<String>(
                value: _currentGridConfiguration,
                items: _GRID_CONFIGURATIONS
                    .map((key, value) {
                      return MapEntry(key, GCWDropDownMenuItem(value: key, child: i18n(context, key)));
                    })
                    .values
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _clearGrid();

                    _currentGridConfiguration = value;

                    _currentConfigType = _GRID_CONFIGURATIONS[_currentGridConfiguration]?.type ?? _GridType.BOXES;
                    _currentConfigColumns = _GRID_CONFIGURATIONS[_currentGridConfiguration]?.width ?? 10;
                    _currentConfigRows = _GRID_CONFIGURATIONS[_currentGridConfiguration]?.height ?? 10;
                    _currentConfigBoxEnumeration = _GRID_CONFIGURATIONS[_currentGridConfiguration]?.enumeration ?? '';
                    _boxEnumerationController.text = _currentConfigBoxEnumeration ?? '';
                    _currentConfigColumnEnumeration =
                        _GRID_CONFIGURATIONS[_currentGridConfiguration]?.columnEnumeration ?? '';
                    _columnEnumerationController.text = _currentConfigColumnEnumeration ?? '';
                    _currentConfigRowEnumeration =
                        _GRID_CONFIGURATIONS[_currentGridConfiguration]?.rowEnumeration ?? '';
                    _rowEnumerationController.text = _currentConfigRowEnumeration ?? '';
                    _currentConfigBoxEnumerationStart =
                        _GRID_CONFIGURATIONS[_currentGridConfiguration]?.enumerationStart ??
                            _GridEnumerationStart.TOP_LEFT;
                    _currentConfigBoxEnumerationStartDirection =
                        _GRID_CONFIGURATIONS[_currentGridConfiguration]?.enumerationStartDirection ??
                            _GridBoxEnumerationStartDirection.RIGHT;
                    _currentConfigBoxEnumerationBehaviour =
                        _GRID_CONFIGURATIONS[_currentGridConfiguration]?.enumerationBehaviour ??
                            _GridBoxEnumerationBehaviour.ALIGNED;

                    if (_currentGridConfiguration == _GRID_CUSTOM_KEY) _isConfiguration = true;
                  });
                },
              ),
            ),
            GCWIconButton(
              icon: _isConfiguration ? Icons.check : Icons.edit,
              onPressed: () {
                setState(() {
                  _clearGrid();

                  if (_isConfiguration) {
                    _currentGridConfiguration = _GRID_CUSTOM_KEY;
                  }

                  _isConfiguration = !_isConfiguration;
                });
              },
            )
          ],
        ),
        if (_isConfiguration) _buildConfiguration() else _buildGrid()
      ],
    );
  }

  Widget _buildConfiguration() {
    return Column(
      children: [
        GCWTextDivider(
          text: i18n(context, 'grid_configuration'),
        ),
        GCWDropDown<_GridType>(
          title: i18n(context, 'grid_type_title'),
          value: _currentConfigType,
          items: {
            _GridType.BOXES: 'grid_boxes_title',
            _GridType.INTERSECTIONS: 'grid_intersections_title',
            _GridType.LINES: 'grid_lines_title',
          }
              .map((type, name) {
                return MapEntry(type, GCWDropDownMenuItem(value: type, child: i18n(context, name)));
              })
              .values
              .toList(),
          onChanged: (value) {
            setState(() {
              _currentConfigType = value;
            });
          },
        ),
        GCWIntegerSpinner(
          title: i18n(context, 'grid_columns'),
          value: _currentConfigColumns,
          min: 1,
          max: 100,
          onChanged: (value) {
            setState(() {
              _currentConfigColumns = value;
            });
          },
        ),
        GCWIntegerSpinner(
          title: i18n(context, 'grid_rows'),
          value: _currentConfigRows,
          min: 1,
          max: 100,
          onChanged: (value) {
            setState(() {
              _currentConfigRows = value;
            });
          },
        ),
        _currentConfigType == _GridType.BOXES
            ? Row(
                children: [
                  Expanded(flex: 1, child: GCWText(text: i18n(context, 'grid_boxenumeration') + ':')),
                  Expanded(
                      flex: 3,
                      child: GCWTextField(
                        controller: _boxEnumerationController,
                        onChanged: (text) {
                          setState(() {
                            _currentConfigBoxEnumeration = text;
                          });
                        },
                      ))
                ],
              )
            : Container(),
        Row(
          children: [
            Expanded(
                flex: 1,
                child: GCWText(
                  text: i18n(context, 'grid_columnenumeration') + ':',
                )),
            Expanded(
                flex: 3,
                child: GCWTextField(
                  controller: _columnEnumerationController,
                  onChanged: (text) {
                    setState(() {
                      _currentConfigColumnEnumeration = text;
                    });
                  },
                ))
          ],
        ),
        Row(
          children: [
            Expanded(
                flex: 1,
                child: GCWText(
                  text: i18n(context, 'grid_rowenumeration') + ':',
                )),
            Expanded(
                flex: 3,
                child: GCWTextField(
                  controller: _rowEnumerationController,
                  onChanged: (text) {
                    setState(() {
                      _currentConfigRowEnumeration = text;
                    });
                  },
                ))
          ],
        ),
        _currentConfigType == _GridType.BOXES ? _buildBoxEnumerationOptions() : Container()
      ],
    );
  }

  Widget _buildBoxEnumerationOptions() {
    return Column(
      children: [
        GCWDropDown<_GridEnumerationStart>(
          title: i18n(context, 'grid_boxes_start_title'),
          value: _currentConfigBoxEnumerationStart,
          items: {
            _GridEnumerationStart.TOP_LEFT: 'grid_boxes_start_topleft',
            _GridEnumerationStart.TOP_RIGHT: 'grid_boxes_start_topright',
            _GridEnumerationStart.BOTTOM_LEFT: 'grid_boxes_start_bottomleft',
            _GridEnumerationStart.BOTTOM_RIGHT: 'grid_boxes_start_bottomright',
          }
              .map((corner, name) {
                return MapEntry(corner, GCWDropDownMenuItem(value: corner, child: i18n(context, name)));
              })
              .values
              .toList(),
          onChanged: (value) {
            if (value == _currentConfigBoxEnumerationStart) return;

            setState(() {
              _currentConfigBoxEnumerationStart = value;
              _currentConfigBoxEnumerationStartDirections = _possibleStartDirections();

              if (!_currentConfigBoxEnumerationStartDirections.contains(_currentConfigBoxEnumerationStartDirection)) {
                _currentConfigBoxEnumerationStartDirection = _currentConfigBoxEnumerationStartDirections.first;
              }
            });
          },
        ),
        GCWDropDown<_GridBoxEnumerationStartDirection>(
          title: i18n(context, 'grid_boxes_startdirection_title'),
          value: _currentConfigBoxEnumerationStartDirection,
          items: _currentConfigBoxEnumerationStartDirections
              .map<GCWDropDownMenuItem<_GridBoxEnumerationStartDirection>>((direction) {
            String name;
            switch (direction) {
              case _GridBoxEnumerationStartDirection.RIGHT:
                name = 'grid_boxes_startdirection_right';
                break;
              case _GridBoxEnumerationStartDirection.LEFT:
                name = 'grid_boxes_startdirection_left';
                break;
              case _GridBoxEnumerationStartDirection.UP:
                name = 'grid_boxes_startdirection_up';
                break;
              case _GridBoxEnumerationStartDirection.DOWN:
                name = 'grid_boxes_startdirection_down';
                break;
              default:
                name = '';
            }

            return GCWDropDownMenuItem(value: direction, child: i18n(context, name));
          }).toList(),
          onChanged: (value) {
            setState(() {
              _currentConfigBoxEnumerationStartDirection = value;
            });
          },
        ),
        GCWDropDown<_GridBoxEnumerationBehaviour>(
          title: i18n(context, 'grid_boxes_behaviour_title'),
          value: _currentConfigBoxEnumerationBehaviour,
          items: {
            _GridBoxEnumerationBehaviour.ALIGNED: {
              'title': 'grid_boxes_behaviour_aligned_title',
              'description': 'grid_boxes_behaviour_aligned_description'
            },
            _GridBoxEnumerationBehaviour.ALTERNATED: {
              'title': 'grid_boxes_behaviour_alternated_title',
              'description': 'grid_boxes_behaviour_alternated_description'
            },
            _GridBoxEnumerationBehaviour.SPIRAL: {
              'title': 'grid_boxes_behaviour_spiral_title',
              'description': 'grid_boxes_behaviour_spiral_description'
            },
          }
              .map((behaviour, name) {
                return MapEntry(
                    behaviour,
                    GCWDropDownMenuItem(
                        value: behaviour,
                        child: i18n(context, name['title'] ?? ''),
                        subtitle: i18n(context, name['description'] ?? '')));
              })
              .values
              .toList(),
          onChanged: (value) {
            setState(() {
              _currentConfigBoxEnumerationBehaviour = value;
            });
          },
        )
      ],
    );
  }

  Widget _buildGrid() {
    return Column(
      children: [
        GCWPainterContainer(
          scale: _scale,
          onChanged: (value) {
            _scale = value;
          },
          child: _GridPainter(
            tapColor: _currentColor,
            type: _currentConfigType,
            countColumns: _currentConfigColumns,
            countRows: _currentConfigRows,
            boxEnumeration: _getEnumeration(_currentConfigBoxEnumeration ?? ''),
            columnEnumeration: _getEnumeration(_currentConfigColumnEnumeration ?? ''),
            rowEnumeration: _getEnumeration(_currentConfigRowEnumeration ?? ''),
            boxEnumerationStart: _currentConfigBoxEnumerationStart,
            boxEnumerationStartDirection: _currentConfigBoxEnumerationStartDirection,
            boxEnumerationBehaviour: _currentConfigBoxEnumerationBehaviour,
          ),
        ),
        Row(children: _GridPaintColor.values.map((color) => _buildColorField(color)).toList()),
        GCWButton(
            text: i18n(context, 'grid_cleargrid'),
            onPressed: () {
              setState(() {
                _clearGrid();
              });
            })
      ],
    );
  }

  void _clearGrid() {
    _gridState = <int, Map<int, _GridPaintColor>>{};
  }

  List<String> _getEnumeration(String enumeration) {
    if (enumeration.isEmpty) return <String>[];

    if (enumeration.contains(RegExp(r'[,\-]')) && VARIABLESTRING.hasMatch(enumeration)) {
      var expanded = VariableStringExpander('x', {'x': enumeration}, orderAndUnique: false)
          .run()
          .map((e) => e.text)
          .whereType<String>()
          .toList();

      expanded.sort((a, b) {
        var intA = int.tryParse(a);
        var intB = int.tryParse(b);

        if (intA == null || intB == null) return 0;
        return intA.compareTo(intB);
      });

      return expanded.whereType<String>().toList();
    }

    if (enumeration.contains(RegExp(r'\s+'))) {
      return enumeration.split(RegExp(r'\s+')).toList();
    }

    return enumeration.split('').toList();
  }

  Expanded _buildColorField(_GridPaintColor color) {
    return Expanded(
        child: InkWell(
      child: Container(
        height: 50,
        decoration: _getColorDecoration(color),
        margin: EdgeInsets.only(
          left: _GridPaintColor.values.indexOf(color) == 0 ? 0.0 : DEFAULT_MARGIN,
          right: _GridPaintColor.values.indexOf(color) == _GridPaintColor.values.length - 1 ? 0.0 : DEFAULT_MARGIN,
        ),
      ),
      onTap: () {
        setState(() {
          _currentColor = color;
        });
      },
    ));
  }

  BoxDecoration _getColorDecoration(_GridPaintColor color) {
    return _currentColor == color
        ? BoxDecoration(
            color: (_GRID_COLORS[color]?['color'] ?? Colors.black),
            border: Border.all(color: themeColors().secondary(), width: 5))
        : BoxDecoration(
            color: (_GRID_COLORS[color]?['color'] ?? Colors.black),
            border: Border.all(color: themeColors().mainFont(), width: 1.0));
  }
}
