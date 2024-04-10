part of 'package:gc_wizard/tools/games/number_pyramid/widget/number_pyramid_solver.dart';

Point<int>? _selectedBox;
Rect? _selectedBoxRect;
FocusNode? _valueFocusNode;

class NumberPyramidBoard extends StatefulWidget {
  final NumberPyramidFillType type;
  final void Function(NumberPyramid) onChanged;
  final NumberPyramid board;

  const NumberPyramidBoard(
      {Key? key, required this.onChanged, required this.board, this.type = NumberPyramidFillType.CALCULATED})
      : super(key: key);

  @override
  NumberPyramidBoardState createState() => NumberPyramidBoardState();
}

class NumberPyramidBoardState extends State<NumberPyramidBoard> {
  int? _currentValue;
  late TextEditingController _currentInputController;
  late GCWIntegerTextInputFormatter _integerInputFormatter;
  final _currentValueFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _valueFocusNode = _currentValueFocusNode;
    _currentInputController = TextEditingController();
    _integerInputFormatter = GCWIntegerTextInputFormatter(min: 0, max: 99999);
  }

  @override
  void dispose() {
    _currentInputController.dispose();
    _currentValueFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Expanded(
          child: Stack(children: <Widget>[
              AspectRatio(
                aspectRatio: 1 / 0.5,
                child: CanvasTouchDetector(
                  gesturesToOverride: const [GestureType.onTapDown],
                  builder: (context) {
                    return CustomPaint(
                        painter:
                            NumberPyramidBoardPainter(context, widget.type, widget.board, _showInputTextBox, _setState));
                  },
                )),
            _editWidget()
      ]))
    ]);
  }

  Widget _editWidget() {
    const int hightOffset = 4;
    ThemeColors colors = themeColors();
    if (_selectedBoxRect != null && _selectedBox != null) {
      if (widget.board.getFillType(_selectedBox!.x, _selectedBox!.y) == NumberPyramidFillType.USER_FILLED) {
        _currentValue = widget.board.getValue(_selectedBox!.x, _selectedBox!.y);
      } else {
        _currentValue = null;
      }
      _currentInputController.text = _currentValue?.toString() ?? '';
      _currentInputController.selection = TextSelection.collapsed(offset: _currentInputController.text.length);

      if (_selectedBoxRect!.height < 35) {
        var offset = (35 - _selectedBoxRect!.height) / 2;
        _selectedBoxRect = Rect.fromLTWH(_selectedBoxRect!.left - 2 * offset, _selectedBoxRect!.top - offset,
            _selectedBoxRect!.width + 4 * offset, _selectedBoxRect!.height + 2 * offset);
      }

      return Positioned(
          left: _selectedBoxRect!.left,
          top: _selectedBoxRect!.top - hightOffset,
          width: _selectedBoxRect!.width,
          height: _selectedBoxRect!.height + 2 * hightOffset,
          child: Container(
              color: colors.gridBackground(),
              child: GCWTextField(
                  controller: _currentInputController,
                  inputFormatters: [_integerInputFormatter],
                  keyboardType: const TextInputType.numberWithOptions(),
                  focusNode: _currentValueFocusNode,
                  style: TextStyle(
                    fontSize: _selectedBoxRect!.height * 0.5,
                    color: colors.secondary(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _currentValue = int.tryParse(value);
                      var type = NumberPyramidFillType.USER_FILLED;
                      if (_currentValue == null) type = NumberPyramidFillType.CALCULATED;
                      if (_selectedBox != null &&
                          widget.board.setValue(_selectedBox!.x, _selectedBox!.y, _currentValue, type)) {
                        widget.board.removeCalculated();
                      }
                    });
                  })));
    }
    return Container();
  }

  void _setState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  void _showInputTextBox(Point<int>? showInputTextBox, Rect? selectedBoxRect) {
    setState(() {
      if (showInputTextBox != null) {
        _selectedBox = showInputTextBox;
        _selectedBoxRect = selectedBoxRect;
        _currentValueFocusNode.requestFocus();
      } else {
        _hideInputTextBox();
      }
    });
  }
}

void _hideInputTextBox() {
  _selectedBox = null;
  _selectedBoxRect = null;
  if (_valueFocusNode != null) {
    _valueFocusNode!.unfocus();
  }
}

class NumberPyramidBoardPainter extends CustomPainter {
  final BuildContext context;
  final void Function(Point<int>?, Rect?) showInputTextBox;
  final void Function() setState;
  final NumberPyramidFillType type;
  final NumberPyramid board;

  NumberPyramidBoardPainter(this.context, this.type, this.board, this.showInputTextBox, this.setState);

  @override
  void paint(Canvas canvas, Size size) {
    var _touchCanvas = TouchyCanvas(context, canvas);
    ThemeColors colors = themeColors();

    var paint = Paint();
    var paintBack = Paint();
    var paintBackground = Paint();
    paint.strokeWidth = 1;
    paint.style = PaintingStyle.stroke;
    paint.color = colors.secondary();

    paintBack.style = PaintingStyle.fill;
    paintBack.color = colors.gridBackground();

    paintBackground.color = Colors.transparent;
    paintBackground.style = PaintingStyle.fill;

    const border = 10;
    double widthOuter = size.width - 8 * border;
    double heightOuter = size.height - 4 * border;
    double xOuter = 4 * border.toDouble();
    double yOuter = 2 * border.toDouble();
    double widthInner = widthOuter / board.getRowsCount();
    double heightInner = min(heightOuter / board.getRowsCount(), widthInner / 2);
    var fontsize = heightInner * 0.8;
    Rect rect = Rect.zero;

    rect = Rect.fromLTWH(0, 0, size.width, size.height);
    _touchCanvas.drawRect(rect, paintBackground, onTapDown: (tapDetail) {
      showInputTextBox(null, null);
    });

    for (int y = 0; y < board.getRowsCount(); y++) {
      double xInner = (widthOuter + xOuter - (y + 1) * widthInner) / 2;
      double yInner = yOuter + y * heightInner;

      for (int x = 0; x < board.getColumnsCount(y); x++) {
        var boardY = y;
        var boardX = x;

        var rect = Rect.fromLTWH(xInner, yInner, widthInner, heightInner);
        _touchCanvas.drawRect(rect, paintBack, onTapDown: (tapDetail) {
          showInputTextBox(Point<int>(boardX, boardY), rect);
        });

        if ((_selectedBox != null) && (_selectedBox!.x == x) && (_selectedBox!.y == y)) {
          if (_selectedBoxRect != rect) {
            _selectedBoxRect = rect;
            setState();
          }
        }

        _touchCanvas.drawRect(rect, paint);

        if (board.getValue(boardX, boardY) != null) {
          var textColor = board.getFillType(boardX, boardY) == NumberPyramidFillType.USER_FILLED
              ? colors.secondary()
              : colors.mainFont();

          var text = board.getValue(boardX, boardY)?.toString();
          var textPainter = _buildTextPainter(text ?? '', textColor, fontsize);

          while (textPainter.width > widthInner) {
            fontsize *= 0.95;
            if (fontsize < heightInner * 0.8 * 0.5) {
              // min. 50% fontsize
              if (text == null || text.length < 2) break;
              var splitPos = (text.length / 2).ceil();
              text = text.substring(0, splitPos) + '\n' + text.substring(splitPos);
              textPainter = _buildTextPainter(text, textColor, fontsize);
              break;
            }
            textPainter = _buildTextPainter(text ?? '', textColor, fontsize);
          }

          if ((_selectedBox == null) || !((_selectedBox!.x == x) && (_selectedBox!.y == y))) {
            textPainter.paint(
                canvas,
                Offset(xInner + (widthInner - textPainter.width) * 0.5,
                    yInner + (heightInner - textPainter.height) * 0.5));
          }
        }

        xInner += widthInner;
      }
    }
  }

  TextPainter _buildTextPainter(String text, Color color, double fontsize) {
    TextSpan span = TextSpan(style: gcwTextStyle().copyWith(color: color, fontSize: fontsize), text: text);
    TextPainter textPainter = TextPainter(text: span, textDirection: TextDirection.ltr);
    textPainter.layout();

    return textPainter;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
