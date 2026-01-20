part of 'package:gc_wizard/tools/games/wordoku/widget/wordoku_solver.dart';

class _WordokuBoard extends StatefulWidget {
  final void Function(WordokuBoard) onChanged;
  final WordokuBoard board;

  const _WordokuBoard({required this.onChanged, required this.board});

  @override
  _WordokuBoardState createState() => _WordokuBoardState();
}

class _WordokuBoardState extends State<_WordokuBoard> {
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
                        painter: WordokuBoardPainter(context, widget.board, (x, y, value) {
                      setState(() {
                        if (value == null || value.trim().isEmpty) {
                          widget.board.setValue(x, y, null, WordokuFillType.CALCULATED);
                          widget.onChanged(widget.board);
                          return;
                        }

                        widget.board.setValue(x, y, value, WordokuFillType.USER_FILLED);
                        widget.onChanged(widget.board);
                      });
                    }));
                  },
                )))
      ],
    );
  }
}

class WordokuBoardPainter extends CustomPainter {
  final void Function(int, int, String?) setBoxValue;
  final WordokuBoard board;
  final BuildContext context;

  WordokuBoardPainter(this.context, this.board, this.setBoxValue);

  @override
  void paint(Canvas canvas, Size size) {
    var _touchCanvas = TouchyCanvas(context, canvas);
    ThemeColors colors = themeColors();
    var _mapCharacterCleaned = board.mapLetterCleaned();

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
            var text = board.getValue(boardX, boardY);

            _touchCanvas.drawRect(Rect.fromLTWH(xInner, yInner, widthInner, heightInner), paint,
                onTapDown: (tapDetail) {
              board.removeCalculated();
              _showInputDialog(boardX, boardY);
            });

            paint.color = colors.secondary();

            _touchCanvas.drawLine(Offset(xInner, 0.0), Offset(xInner, size.width), paint);
            _touchCanvas.drawLine(Offset(0.0, yInner), Offset(size.height, yInner), paint);

            if (text != null) {
              var textColor = board.getFillType(boardX, boardY) == WordokuFillType.USER_FILLED
                  ? _mapCharacterCleaned.contains(text) ? colors.secondary() : Colors.red
                  : colors.mainFont();

              TextSpan span = TextSpan(
                  style: gcwTextStyle().copyWith(color: textColor, fontSize: heightInner * 0.8),
                  text: text);
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
    var values = board.mapLetterCleaned();

    for (int i = 0; i < 3; i++) {
      var rows = <Widget>[];
      for (int j = 0; j < 3; j++) {
        var index = i * 3 + j;
        var value = index >= values.length ? '' : values[index];

        rows.add(GCWButton(
          text: value,
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
