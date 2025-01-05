part of 'package:gc_wizard/tools/games/logical_supporter/widget/logical_supporter.dart';

const _boxSize = 20.0;
const _fontSize = _boxSize * 0.7;
const _blockMargin = _boxSize/ 2;
const _itemTextOffsetStart = 3;
const _itemTextOffsetEnd = 10;
Point<int>? _selectedBox;
Rect? _selectedBoxRect;
FocusNode? _valueFocusNode;

class LogicalBoard extends StatefulWidget {
  final void Function(Logical) onChanged;
  final Logical board;
  final void Function(int, int) onTapped;

  const LogicalBoard({Key? key, required this.onChanged, required this.board, required this.onTapped})
      : super(key: key);

  @override
  LogicalBoardState createState() => LogicalBoardState();
}

class LogicalBoardState extends State<LogicalBoard> {
  late TextEditingController _currentInputController;
  final _currentValueFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _valueFocusNode = _currentValueFocusNode;
    _currentInputController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        children: <Widget>[
          Expanded(
              child:
              Stack(children: <Widget>[
                AspectRatio(
                    aspectRatio: max(_maxRowItemsWidth(widget.board, _fontSize) + widget.board.getLineLength(0) * _boxSize, 1) /
                        max(_maxColumnsItemsWidth(widget.board, _fontSize) + widget.board.getMaxLineLength() * _boxSize, 1),
                    child: CanvasTouchDetector(
                      gesturesToOverride: const [GestureType.onTapDown, GestureType.onTapUp],
                      builder: (context) {
                      return CustomPaint(
                          painter: LogicPuzzleBoardPainter(context, widget.board, _showInputTextBox, _setState,
                              onTapped: widget.onTapped)
                      );
                    },
                  )
                ),
                _editWidget()
              ])
          )
        ]);
  }

  Widget _editWidget() {
    const int hightOffset = 4;
    ThemeColors colors = themeColors();
    if (_selectedBoxRect != null && _selectedBox != null) {
      if (_selectedBox!.x < 0) {
        _currentInputController.text = widget.board.logicalItems[
            widget.board.blockIndex(_selectedBox!.y)][widget.board.blockLine(_selectedBox!.y)];
      } else if (_selectedBox!.y < 0) {
        _currentInputController.text = widget.board.logicalItems[
            widget.board.blockIndex(_selectedBox!.x)][widget.board.blockLine(_selectedBox!.x)];
      }
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
                  focusNode: _currentValueFocusNode,
                  style: TextStyle(
                    fontSize: _selectedBoxRect!.height * 0.5,
                    color: themeColors().mainFont(),
                  ),
                  onChanged: (text) {
                    var closeBox = false;
                    if (text.contains('\n')) {
                      _currentInputController.text = _currentInputController.text.replaceAll('\n', '');
                      closeBox = true;
                    }
                    setState(() {
                      if (_selectedBox!.x < 0) {
                        widget.board.logicalItems[widget.board.blockIndex(_selectedBox!.y)]
                            [widget.board.blockLine(_selectedBox!.y)] = _currentInputController.text;
                      } else if (_selectedBox!.y < 0) {
                        widget.board.logicalItems[widget.board.blockIndex(_selectedBox!.x)]
                            [widget.board.blockLine(_selectedBox!.x)] = _currentInputController.text;
                      }
                      if (closeBox) {
                        _showInputTextBox(null, null);
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
      if (_selectedBoxRect == selectedBoxRect) return;
      if (showInputTextBox != null) {
        _selectedBox = showInputTextBox;
        _selectedBoxRect = selectedBoxRect;
        _currentValueFocusNode.requestFocus();
      } else {
        _hideInputTextBox();
        widget.onChanged(widget.board);
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

class LogicPuzzleBoardPainter extends CustomPainter {
  final BuildContext context;
  final void Function(Point<int>?, Rect?) showInputTextBox;
  final void Function() setState;
  final Logical board;
  Color line_color = themeColors().secondary();
  Color item_line_color = themeColors().switchThumb1();
  Color full_color = themeColors().secondary();
  Color background_color = themeColors().gridBackground();
  Color font_color = themeColors().mainFont();
  final void Function(int, int) onTapped;

  LogicPuzzleBoardPainter(this.context, this.board, this.showInputTextBox, this.setState,
      {Color? line_color, Color?  item_line_color, Color? full_color, Color? background_color, Color? font_color,
        required this.onTapped}) {
    this.line_color = line_color ?? this.line_color;
    this.item_line_color = item_line_color ?? this.item_line_color;
    this.full_color = full_color ?? this.full_color;
    this.background_color = background_color ?? this.background_color;
    this.font_color = font_color ?? this.font_color;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var _touchCanvas = TouchyCanvas(context, canvas);

    var paintLine = Paint();
    var paintItemLine = Paint();
    var paintBackground = Paint();
    var paintTransparent= Paint();
    paintLine.strokeWidth = 1;
    paintLine.style = PaintingStyle.stroke;
    paintLine.color = line_color;

    paintItemLine.strokeWidth = 1;
    paintItemLine.style = PaintingStyle.stroke;
    paintItemLine.color = item_line_color;

    paintBackground.style = PaintingStyle.fill;
    paintBackground.color = background_color;

    paintTransparent.color = Colors.transparent;
    paintTransparent.style = PaintingStyle.fill;

    const border = 5;
    var maxColumnItemsWidth = _maxColumnsItemsWidth(board, _fontSize);
    var maxRowItemsWidth = _maxRowItemsWidth(board, _fontSize);

    int maxLineLength = board.getMaxLineLength();
    double widthOuter = size.width - 2 * border;
    double xOuter = 1 * border.toDouble();
    double yOuter = 1 * border.toDouble();
    double widthInner = _calcBoxWidth(widthOuter, maxRowItemsWidth, 1, maxLineLength);
    double widthInnerOld = 0.0;
    double factor = widthInner/ _boxSize;
    int loopCounter = 0;

    while ((widthInnerOld - widthInner).abs() > 0.05 && loopCounter <= 100) {
      widthInnerOld = widthInner;
      widthInner = _calcBoxWidth(widthOuter, maxRowItemsWidth, factor, maxLineLength);
      factor = widthInner/ _boxSize;
      loopCounter++;
    }
    double heightInner = widthInner;

    var fontSize = _fontSize * factor;
    maxColumnItemsWidth *= factor;
    maxRowItemsWidth *= factor;

    var xInnerStart = xOuter + maxRowItemsWidth + _blockMargin * factor;
    var yInnerStart = yOuter + maxColumnItemsWidth + _blockMargin * factor;

    var rect = Rect.zero;

    rect = Rect.fromLTWH(0, 0, size.width, size.height);
    _touchCanvas.drawRect(rect, paintTransparent,
        onTapDown: (tapDetail) {if (_selectedBox != null) showInputTextBox(null, null);});

    // row item names
    for (int y = 0; y < maxLineLength; y++) {
      var yInner = yInnerStart + y * heightInner + _lineOffset(y, factor);
      rect = Rect.fromLTWH(xOuter, yInner, maxRowItemsWidth, heightInner);
      var rectTextBox = Rect.fromLTWH(rect.left, rect.top - rect.height/ 2, rect.width * 2, rect.height * 2);
      var itemIndex = y + board.itemsCount;
      canvas.drawRect(rect, paintItemLine);
      _touchCanvas.drawRect(rect, paintTransparent,
          onTapUp: (tapDetail) {showInputTextBox(Point<int>(-1, itemIndex), rectTextBox);});
      _paintItemText(canvas, rect, board.logicalItems[board.blockIndex(itemIndex)][board.blockLine(itemIndex)],
          fontSize, font_color);
    }

    // column item names
    canvas.save();
    canvas.rotate(-90 / 180 * pi);
    canvas.translate(-yInnerStart + _blockMargin * factor, xInnerStart);
    for (int x = 0; x < board.getLineLength(0) ; x++) {
      var itemIndex = board.fullLine(board.mapColumnToRowBlockIndex(board.blockIndex(x)), board.blockLine(x));
      var xInner = x * widthInner + _lineOffset(x, factor);
      rect = Rect.fromLTWH(0, xInner, maxColumnItemsWidth, heightInner);
      _paintItemText(canvas, rect,
          board.logicalItems[board.blockIndex(itemIndex)][board.blockLine(itemIndex)], fontSize, font_color);

      if (x < board.itemsCount) {
        _touchCanvas.drawRect(rect, paintItemLine);
        rect = Rect.fromLTWH(xInnerStart + xInner, yOuter, rect.height, rect.width);
        var rectTextBox = Rect.fromLTWH(rect.left, rect.bottom - rect.width * 2, rect.height * 2, rect.width * 2);
        
        _touchCanvas.drawRect(rect, paintTransparent,
            onTapUp: (tapDetail) {showInputTextBox(Point<int>(itemIndex, -1), rectTextBox);});
      }
    }
    canvas.restore();

    for (int y = 0; y < maxLineLength; y++) {
      var yInner = yInnerStart + y * heightInner + _lineOffset(y, factor);
      for (int x = 0; x < board.getLineLength(y); x++) {
        var xInner = xInnerStart + x * widthInner + _lineOffset(x, factor);
        rect = Rect.fromLTWH(xInner, yInner, widthInner, heightInner);
        _touchCanvas.drawRect(rect, paintBackground,
            onTapUp: (tapDetail) {(_selectedBox == null) ? onTapped(x, y) : showInputTextBox(null, null);});
        canvas.drawRect(rect, paintLine);
        var value = board.getValue(x, y);
        if (value != null) {
          _paintText(canvas, rect, value == Logical.plusValue ? '+' : '-',
              fontSize * 2, board.getFillType(x, y) == LogicalFillType.USER_FILLED ? line_color : item_line_color);
        }
      }
    }
  }

  double _calcBoxWidth(double widthOuter, double maxRowItemsWidth, double factor, int maxLineLength) {
    return (widthOuter - maxRowItemsWidth * factor - _lineOffset(maxLineLength, factor)) / maxLineLength.toDouble();
  }

  double _lineOffset(int value, double factor) {
    return (value / board.itemsCount).floor() * _blockMargin * factor;
  }

  void _paintText(Canvas canvas, Rect rect, String text, double fontSize, Color color) {
    var textPainter = _buildTextPainter(text, color, fontSize);
    textPainter.paint(canvas, Offset(rect.topCenter.dx - textPainter.width * 0.5,
        rect.centerLeft.dy - textPainter.height * 0.5));
  }

  void _paintItemText(Canvas canvas, Rect rect, String text, double fontSize, Color color) {
    var textPainter = _buildTextPainter(text, color, fontSize);
    textPainter.paint(canvas, Offset(rect.left + _itemTextOffsetStart,
        rect.centerLeft.dy - textPainter.height * 0.5));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

double _maxColumnsItemsWidth(Logical board, double fontsize) {
  return _maxRowItemsWidth(board, fontsize, ignoreBlock: 1);
}

double _maxRowItemsWidth(Logical board, double fontsize, {int ignoreBlock = 0}) {
  var maxWidth = 3 * _boxSize - _itemTextOffsetStart - _itemTextOffsetEnd;
  for(var itemBlock = 0; itemBlock < board.logicalItems.length; itemBlock++) {
    if (itemBlock == ignoreBlock) continue;
    maxWidth = max(maxWidth, _maxItemBlockWidth(board.logicalItems[itemBlock], fontsize));
  }
  return maxWidth + _itemTextOffsetStart + _itemTextOffsetEnd;
}

double _maxItemBlockWidth(List<String> itemBlock, double fontsize) {
  var maxWidth = 0.0;
  for(var item = 0; item < itemBlock.length; item++) {
    maxWidth = max(maxWidth, _buildTextPainter(itemBlock[item], Colors.black, fontsize).width);
  }
  return maxWidth;
}

TextPainter _buildTextPainter(String text, Color color, double fontsize) {
  TextSpan span = TextSpan(style: gcwTextStyle().copyWith(color: color, fontSize: fontsize), text: text);
  TextPainter textPainter = TextPainter(text: span, textDirection: TextDirection.ltr);
  textPainter.layout();

  return textPainter;
}
