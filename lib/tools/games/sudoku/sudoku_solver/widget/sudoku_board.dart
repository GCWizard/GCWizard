part of 'package:gc_wizard/tools/games/sudoku/sudoku_solver/widget/sudoku_solver.dart';

enum _SudokuFillType { USER_FILLED, CALCULATED }

class _SudokuBoard extends StatefulWidget {
  final _SudokuFillType type;
  final Function onChanged;
  final List<List<Map<String, dynamic>>> board;

  _SudokuBoard({Key key, this.onChanged, this.board, this.type: _SudokuFillType.CALCULATED}) : super(key: key);

  @override
  _SudokuBoardState createState() => _SudokuBoardState();
}

class _SudokuBoardState extends State<_SudokuBoard> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
            child: AspectRatio(
                aspectRatio: 1 / 1,
                child: CanvasTouchDetector(
                  gesturesToOverride: [GestureType.onTapDown],
                  builder: (context) {
                    return CustomPaint(
                        painter: SudokuBoardPainter(context, widget.type, widget.board, (x, y, value) {
                      setState(() {
                        if (value == null) {
                          widget.board[x][y] = null;
                          widget.onChanged(widget.board);
                          return;
                        }

                        widget.board[x][y] = {'value': value, 'type': _SudokuFillType.USER_FILLED};
                        widget.onChanged(widget.board);
                      });
                    }));
                  },
                )))
      ],
    );
  }
}

class SudokuBoardPainter extends CustomPainter {
  final Function(int, int, int) setBoxValue;
  final List<List<Map<String, dynamic>>> board;
  final BuildContext context;
  final _SudokuFillType type;

  SudokuBoardPainter(this.context, this.type, this.board, this.setBoxValue);

  @override
  void paint(Canvas canvas, Size size) {
    var _touchCanvas = TouchyCanvas(context, canvas);
    ThemeColors colors = themeColors();

    var paint = Paint();

    paint.style = PaintingStyle.stroke;

    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        paint.strokeWidth = 3;

        double widthOuter = size.width / 3.0;
        double heightOuter = size.height / 3.0;
        double xOuter = i * widthOuter;
        double yOuter = j * heightOuter;

        _touchCanvas.drawRect(Rect.fromLTWH(xOuter, yOuter, widthOuter, heightOuter), paint);

        for (int k = 0; k < 3; k++) {
          for (int l = 0; l < 3; l++) {
            paint.strokeWidth = 1;

            double widthInner = widthOuter / 3.0;
            double heightInner = heightOuter / 3.0;
            double xInner = k * widthInner + xOuter;
            double yInner = l * heightInner + yOuter;

            paint.style = PaintingStyle.fill;
            paint.color = colors.gridBackground();

            var boardY = i * 3 + k;
            var boardX = j * 3 + l;

            _touchCanvas.drawRect(Rect.fromLTWH(xInner, yInner, widthInner, heightInner), paint,
                onTapDown: (tapDetail) {
              _removeCalculated(board);
              _showInputDialog(boardX, boardY);
            });

            paint.color = colors.accent();

            _touchCanvas.drawLine(Offset(xInner, 0.0), Offset(xInner, size.width), paint);
            _touchCanvas.drawLine(Offset(0.0, yInner), Offset(size.height, yInner), paint);

            if (board[boardX][boardY] != null) {
              var textColor =
                  board[boardX][boardY]['type'] == _SudokuFillType.USER_FILLED ? colors.accent() : colors.mainFont();

              TextSpan span = TextSpan(
                  style: gcwTextStyle().copyWith(color: textColor, fontSize: heightInner * 0.8),
                  text: board[boardX][boardY]['value'].toString());
              TextPainter textPainter = TextPainter(text: span, textDirection: TextDirection.ltr);
              textPainter.layout();

              textPainter.paint(
                  canvas,
                  Offset(xInner + (widthInner - textPainter.width) * 0.5,
                      yInner + (heightInner - textPainter.height) * 0.5));
            }
          }
        }

        paint.strokeWidth = 4;

        _touchCanvas.drawLine(Offset(xOuter, 0.0), Offset(xOuter, size.width), paint);
        _touchCanvas.drawLine(Offset(0.0, yOuter), Offset(size.height, yOuter), paint);
      }
    }

    _touchCanvas.drawLine(Offset(size.height, 0.0), Offset(size.height, size.width), paint);
    _touchCanvas.drawLine(Offset(0.0, size.width), Offset(size.height, size.width), paint);
  }

  _removeCalculated(List<List<Map<String, dynamic>>> board) {
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (board[i][j] != null && board[i][j]['type'] == _SudokuFillType.CALCULATED) board[i][j] = null;
      }
    }
  }

  _showInputDialog(int x, y) {
    var columns = <Widget>[];

    for (int i = 0; i < 3; i++) {
      var rows = <Widget>[];
      for (int j = 0; j < 3; j++) {
        var value = i * 3 + j + 1;

        rows.add(GCWButton(
          text: value.toString(),
          textStyle: gcwTextStyle().copyWith(fontSize: 32, color: themeColors().dialogText()),
          onPressed: () {
            Navigator.of(context).pop();
            setBoxValue(x, y, value);
          },
        ));
      }

      columns.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: rows,
      ));
    }

    columns.add(GCWButton(
      text: i18n(context, 'sudokusolver_removevalue'),
      onPressed: () {
        Navigator.of(context).pop();
        setBoxValue(x, y, null);
      },
    ));

    showGCWDialog(
        context,
        i18n(context, 'sudokusolver_entervalue'),
        Container(
          height: 300,
          child: Column(children: columns),
        ),
        []);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
