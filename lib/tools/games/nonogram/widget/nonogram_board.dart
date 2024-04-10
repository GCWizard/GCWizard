part of 'package:gc_wizard/tools/games/nonogram/widget/nonogram_solver.dart';

const int _boldLineIntvervall = 5;

class NonogramBoard extends StatefulWidget {
  final void Function(Puzzle) onChanged;
  final Puzzle board;
  final void Function(int, int)? onTapped;

  const NonogramBoard({Key? key, required this.onChanged,
    required this.board, this.onTapped})
      : super(key: key);

  @override
  NonogramBoardState createState() => NonogramBoardState();
}

class NonogramBoardState extends State<NonogramBoard> {

  @override
  Widget build(BuildContext context) {
    return Row(
        children: <Widget>[
          Expanded(
              child:
              Stack(children: <Widget>[
                AspectRatio(
                    aspectRatio: max(_maxRowHintsCount(widget.board) + widget.board.width, 1) /
                                max(_maxColumnHintsCount(widget.board) + widget.board.height, 1),
                    child: CanvasTouchDetector(
                      gesturesToOverride: const [GestureType.onTapDown],
                      builder: (context) {
                        return CustomPaint(
                            painter: NonogramBoardPainter(context, widget.board, _setState, onTapped: widget.onTapped)
                        );
                      },
                    )
                ),
              ])
          )
        ]);
  }

  void _setState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }
}

class NonogramBoardPainter extends CustomPainter {
  final BuildContext context;
  final void Function() setState;
  final Puzzle board;
  Color line_color = themeColors().secondary();
  Color hint_line_color = themeColors().switchThumb1();
  Color full_color = themeColors().secondary();
  Color background_color = themeColors().gridBackground();
  Color font_color = themeColors().mainFont();
  final void Function(int, int)? onTapped;

  NonogramBoardPainter(this.context, this.board, this.setState,
    {Color? line_color, Color?  hint_line_color, Color? full_color, Color? background_color, Color? font_color,
    this.onTapped}) {
    this.line_color = line_color ?? this.line_color;
    this.hint_line_color = hint_line_color ?? this.hint_line_color;
    this.full_color = full_color ?? this.full_color;
    this.background_color = background_color ?? this.background_color;
    this.font_color = font_color ?? this.font_color;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var _touchCanvas = TouchyCanvas(context, canvas);

    var paintLine = Paint();
    var paintHintLine = Paint();
    var paintFull = Paint();
    var paintBackground = Paint();
    var paintTransparent = Paint();
    paintLine.strokeWidth = 1;
    paintLine.style = PaintingStyle.stroke;
    paintLine.color = line_color;

    paintHintLine.strokeWidth = 1;
    paintHintLine.style = PaintingStyle.stroke;
    paintHintLine.color = hint_line_color;

    paintFull.style = PaintingStyle.fill;
    paintFull.color = full_color;

    paintBackground.style = PaintingStyle.fill;
    paintBackground.color = background_color;

    paintTransparent.style = PaintingStyle.fill;
    paintTransparent.color = Colors.transparent;

    const border = 5;
    var maxRowHints = _maxRowHintsCount(board);
    var maxColumnHints = _maxColumnHintsCount(board);

    double widthOuter = size.width - 2 * border;
    double xOuter = 1 * border.toDouble();
    double yOuter = 1 * border.toDouble();
    double widthInner = (widthOuter - _lineOffset(maxRowHints + board.width)) / (maxRowHints + board.width);
    double heightInner = widthInner;
    var fontSize = heightInner * 0.7;
    var fieldBorderOn = widthInner / 10;

    var xInnerStart = xOuter + (maxRowHints * widthInner);
    var xInnerEnd = xInnerStart + (board.width * widthInner) + _lineOffset(board.width);
    var yInnerStart = yOuter + (maxColumnHints * heightInner);
    var yInnerEnd = yInnerStart + (board.height * heightInner) + _lineOffset(board.height);

    var rect = Rect.fromLTRB(xInnerStart, yInnerStart, xInnerEnd, yInnerEnd);
    _touchCanvas.drawRect(rect, paintBackground);

    for (int y = 0; y <= board.height; y++) {
      var yInner = yInnerStart + y * heightInner + _lineOffset(y);
      if (y < board.height) {
        // row hints
        var offset = xInnerStart - board.rowHints[y].length * widthInner;
        for (int i = 0; i < board.rowHints[y].length; i++) {
          rect = Rect.fromLTWH(offset + i * widthInner, yInner, widthInner, heightInner);
          _touchCanvas.drawRect(rect, paintHintLine);
          _paintText(canvas, rect, board.rowHints[y][i].toString(), fontSize, font_color);
        }
        if ((y % _boldLineIntvervall) == 0) {
          // double line
          var xOffset = board.rowHints[y].length * widthInner;
          _touchCanvas.drawLine(
              Offset(xInnerStart - xOffset, yInner-1),
              Offset(xInnerStart, yInner-1), paintHintLine);
        }
      }

      // horizontal lines
      _touchCanvas.drawLine(
          Offset(xInnerStart, yInner),
          Offset(xInnerEnd, yInner), paintLine);

      if ((y % _boldLineIntvervall) == 0) {
        // double line
        yInner -= 1;
        _touchCanvas.drawLine(
            Offset(xInnerStart, yInner),
            Offset(xInnerEnd, yInner), paintLine);
      }
    }

    for (int x = 0; x <= board.width; x++) {
      var xInner = xInnerStart + x * widthInner + _lineOffset(x);
      if (x < board.width) {
        var offset = yInnerStart - board.columnHints[x].length * heightInner;
        // column hints
        for (int i = 0; i < board.columnHints[x].length; i++) {
          rect = Rect.fromLTWH(xInner, offset + i * heightInner, widthInner, heightInner);
          _touchCanvas.drawRect(rect, paintHintLine);
          _paintText(canvas, rect, board.columnHints[x][i].toString(), fontSize, font_color);
        }

        if ((x % _boldLineIntvervall) == 0) {
          // double line
          var yOffset = board.columnHints[x].length * heightInner;
          _touchCanvas.drawLine(
              Offset(xInner-1, yInnerStart - yOffset),
              Offset(xInner-1, yInnerStart), paintHintLine);
        }
      }

      // vertical lines
      _touchCanvas.drawLine(
          Offset(xInner, yInnerStart),
          Offset(xInner, yInnerEnd), paintLine);

      if ((x % _boldLineIntvervall) == 0) {
        // double line
        xInner -= 1;
        _touchCanvas.drawLine(
            Offset(xInner, yInnerStart),
            Offset(xInner, yInnerEnd), paintLine);
      }

      // fields
      if (x < board.width) {
        xInner = xInnerStart + x * widthInner + _lineOffset(x);
        for (int y = 0; y < board.height; y++) {
          var rect = Rect.fromLTWH(xInner, yInnerStart + y * widthInner + _lineOffset(y), widthInner, heightInner);
          var value = board.rows[y][x];
          if (value == 1) {
            var rectI = Rect.fromLTWH(rect.left + fieldBorderOn, rect.top + fieldBorderOn,
                                      rect.width - 2 * fieldBorderOn, rect.height - 2 * fieldBorderOn);
            _touchCanvas.drawRect(rectI, paintFull);
          } else if (value == 0 && (board.state == PuzzleState.Finished || board.state == PuzzleState.Solved)) {
            _paintText(canvas, rect, '?', fontSize * 1.2, paintFull.color);
          }
          if (onTapped != null) {
            _touchCanvas.drawRect(rect, paintTransparent, onTapDown: (tapDetail) {onTapped!(y, x);});
          }
        }
      }
    }
  }

  static int _lineOffset(int value) {
    return (value / _boldLineIntvervall).floor();
  }

  void _paintText(Canvas canvas, Rect rect, String text, double fontSize, Color color) {
    var textPainter = _buildTextPainter(text, color, fontSize);
    textPainter.paint(canvas, Offset(rect.topCenter.dx - textPainter.width * 0.5,
                                     rect.centerLeft.dy - textPainter.height * 0.5));
}

  TextPainter _buildTextPainter(String text, Color color, double fontsize) {
    TextSpan span = TextSpan(
        style: gcwTextStyle().copyWith(color: color, fontSize: fontsize),
        text: text);
    TextPainter textPainter = TextPainter(text: span, textDirection: TextDirection.ltr);
    textPainter.layout();

    return textPainter;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

int _maxRowHintsCount(Puzzle board) {
  return board.rowHints.reduce((value, hints) => (hints.length > value.length ? hints : value)).length;
}

int _maxColumnHintsCount(Puzzle board) {
  return board.columnHints.reduce((value, hints) => (hints.length > value.length ? hints : value)).length;
}
