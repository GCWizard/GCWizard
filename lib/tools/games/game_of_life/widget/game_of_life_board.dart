import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:touchable/touchable.dart';

class GameOfLifeBoard extends StatefulWidget {
  final Point<int> size;
  final void Function(List<List<bool>>) onChanged;
  final List<List<bool>> state;

  const GameOfLifeBoard({Key? key, required this.size, required this.onChanged, required this.state}) : super(key: key);

  @override
  _GameOfLifeBoardState createState() => _GameOfLifeBoardState();
}

class _GameOfLifeBoardState extends State<GameOfLifeBoard> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
            child: AspectRatio(
                aspectRatio: max(widget.size.x, 1) / max(widget.size.y, 1),
                child: CanvasTouchDetector(
                  gesturesToOverride: const [GestureType.onTapDown],
                  builder: (context) {
                    return CustomPaint(
                        painter: GameOfLifePainter(context, widget.size, widget.state, (int x, int y) {
                      setState(() {
                        widget.state[x][y] = !widget.state[x][y];
                        widget.onChanged(widget.state);
                      });
                    }));
                  },
                )
            )
        )
      ],
    );
  }
}

class GameOfLifePainter extends CustomPainter {
  final Point<int> size;
  final List<List<bool>> state;
  final BuildContext context;
  final void Function(int, int) onInvertCell;

  GameOfLifePainter(this.context, this.size, this.state, this.onInvertCell);

  @override
  void paint(Canvas canvas, Size size) {
    var _touchCanvas = TouchyCanvas(context, canvas);
    var paintLine = Paint();
    var paintFull = Paint();
    var paintBackground = Paint();
    var paintTransparent = Paint();
    double boxSize = size.width / this.size.x;

    paintLine.strokeWidth = (max(this.size.x, this.size.y) > 20) ? 1 : 2;
    paintLine.style = PaintingStyle.stroke;
    paintLine.color = themeColors().secondary();

    paintBackground.style = PaintingStyle.fill;
    paintBackground.color = themeColors().gridBackground();

    paintTransparent.style = PaintingStyle.fill;
    paintTransparent.color = Colors.transparent;

    paintFull.style = PaintingStyle.fill;
    paintFull.color = themeColors().mainFont();


    _touchCanvas.drawRect(Rect.fromLTWH(0, 0, this.size.x  * boxSize, this.size.y * boxSize), paintBackground);
    
    for (int i = 0; i < this.size.y; i++) {
      for (int j = 0; j < this.size.x; j++) {
        if (state[i][j]) {
          _touchCanvas.drawRect(Rect.fromLTWH(j * boxSize, i * boxSize, boxSize, boxSize), paintFull);
        }
      }
    }

    if (max(this.size.x, this.size.y) <= 50) {
      for (double j = 0; j <= this.size.x * boxSize + 0.0000001; j += boxSize) {
        _touchCanvas.drawLine(Offset(j, 0.0), Offset(j, size.height), paintLine);
      }
      for (double i = 0; i <= this.size.y * boxSize + 0.0000001; i += boxSize) {
        _touchCanvas.drawLine(Offset(0.0, i), Offset(size.width, i), paintLine);
      }
    }

    _touchCanvas.drawRect(Rect.fromLTWH(0, 0, this.size.x  * boxSize, this.size.y * boxSize), paintTransparent,
        onTapDown: (tapDetail) {
          var j = (tapDetail.localPosition.dx / boxSize).toInt();
          var i = (tapDetail.localPosition.dy / boxSize).toInt();
          onInvertCell(i, j);
        });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
