import 'package:flutter/material.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:touchable/touchable.dart';

class GameOfLifeBoard extends StatefulWidget {
  final int size;
  final void Function(List<List<bool>>) onChanged;
  final List<List<bool>> state;

  const GameOfLifeBoard({Key? key, required this.size, required this.onChanged, required this.state}) : super(key: key);

  @override
  GameOfLifeBoardState createState() => GameOfLifeBoardState();
}

class GameOfLifeBoardState extends State<GameOfLifeBoard> {
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
                        painter: GameOfLifePainter(context, widget.size, widget.state, (int x, int y, bool value) {
                      setState(() {
                        widget.state[x][y] = value;
                        widget.onChanged(widget.state);
                      });
                    }));
                  },
                )))
      ],
    );
  }
}

class GameOfLifePainter extends CustomPainter {
  final int size;
  final List<List<bool>> state;
  final BuildContext context;
  final void Function(int, int, bool) onSetCell;

  GameOfLifePainter(this.context, this.size, this.state, this.onSetCell);

  @override
  void paint(Canvas canvas, Size size) {
    var _touchCanvas = TouchyCanvas(context, canvas);

    var paint = Paint();
    paint.style = PaintingStyle.stroke;

    double boxSize = size.width / this.size;

    for (int i = 0; i < this.size; i++) {
      for (int j = 0; j < this.size; j++) {
        paint.strokeWidth = this.size > 20 ? 1 : 2;

        var x = j * boxSize;
        var y = i * boxSize;

        var isSet = state[i][j] == true;

        paint.color = isSet ? themeColors().mainFont() : themeColors().gridBackground();
        paint.style = PaintingStyle.fill;

        _touchCanvas.drawRect(Rect.fromLTWH(x, y, boxSize, boxSize), paint);

        paint.color = themeColors().secondary();

        if (this.size > 50) paint.color = paint.color.withOpacity(0.0);

        _touchCanvas.drawLine(Offset(x, 0.0), Offset(x, size.width), paint);
        _touchCanvas.drawLine(Offset(0.0, y), Offset(size.height, y), paint);

        paint.color = paint.color.withOpacity(0.0);
        _touchCanvas.drawRect(Rect.fromLTWH(x, y, boxSize, boxSize), paint, onTapDown: (tapDetail) {
          onSetCell(i, j, !isSet);
        });
      }
    }

    if (this.size > 50) {
      paint.color = paint.color.withOpacity(0.0);
    } else {
      paint.color = themeColors().secondary();
    }

    _touchCanvas.drawLine(Offset(size.height, 0.0), Offset(size.height, size.width), paint);
    _touchCanvas.drawLine(Offset(0.0, size.width), Offset(size.height, size.width), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
