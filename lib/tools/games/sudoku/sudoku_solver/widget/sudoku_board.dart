part of 'package:gc_wizard/tools/games/sudoku/sudoku_solver/widget/sudoku_solver.dart';

class _SudokuBoard extends StatefulWidget {
  final void Function(SudokuBoard) onChanged;
  final SudokuBoard board;

  const _SudokuBoard({Key? key, required this.onChanged, required this.board}) : super(key: key);

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
                  gesturesToOverride: const [GestureType.onTapDown],
                  builder: (context) {
                    return CustomPaint(
                        painter: SudokuBoardPainter(context, widget.board, (x, y, value) {
                          setState(() {
                            if (value == null) {
                              widget.board.setValue(x, y, null, SudokuFillType.CALCULATED);
                              widget.onChanged(widget.board);
                              return;
                            }

                            widget.board.setValue(x, y, value, SudokuFillType.USER_FILLED);
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
  final void Function(int, int, int?) setBoxValue;
  final SudokuBoard board;
  final BuildContext context;

  SudokuBoardPainter(this.context, this.board, this.setBoxValue);

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
                  board.removeCalculated();
                  _showInputDialog(boardX, boardY);
                });

            paint.color = colors.secondary();

            _touchCanvas.drawLine(Offset(xInner, 0.0), Offset(xInner, size.width), paint);
            _touchCanvas.drawLine(Offset(0.0, yInner), Offset(size.height, yInner), paint);

            if (board.getValue(boardX, boardY) != null) {
              var textColor =
              board.getFillType(boardX, boardY) == SudokuFillType.USER_FILLED ? colors.secondary() : colors.mainFont();

              TextSpan span = TextSpan(
                  style: gcwTextStyle().copyWith(color: textColor, fontSize: heightInner * 0.8),
                  text: board.getValue(boardX, boardY)?.toString());
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

  void _showInputDialog(int x, int y) {
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
        SizedBox(
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
