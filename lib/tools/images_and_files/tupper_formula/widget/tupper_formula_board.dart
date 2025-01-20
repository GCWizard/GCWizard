import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:touchable/touchable.dart';

class TupperFormulaBoard extends StatefulWidget {
  final void Function(List<List<bool>>) onChanged;
  final List<List<bool>> state;

  const TupperFormulaBoard({Key? key, required this.onChanged, required this.state}) : super(key: key);

  @override
  _TupperFormulaBoardState createState() => _TupperFormulaBoardState();
}

class _TupperFormulaBoardState extends State<TupperFormulaBoard> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
            child: AspectRatio(
                aspectRatio: 106 / 17,
                child: CanvasTouchDetector(
                  gesturesToOverride: const [GestureType.onTapDown],
                  builder: (context) {
                    return CustomPaint(
                        painter: TupperFormulaBoardPainter(context, widget.state, (int x, int y) {
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

class TupperFormulaBoardPainter extends CustomPainter {
  final List<List<bool>> state;
  final BuildContext context;
  final void Function(int, int) onInvertCell;

  TupperFormulaBoardPainter(this.context, this.state, this.onInvertCell);

  @override
  void paint(Canvas canvas, Size size) {
    var _touchCanvas = TouchyCanvas(context, canvas);
    var paintLine = Paint();
    var paintFull = Paint();
    var paintBackground = Paint();
    var paintTransparent = Paint();
    double boxSize = size.width / 106;

    paintLine.strokeWidth = 2;
    paintLine.style = PaintingStyle.stroke;
    paintLine.color = themeColors().secondary();

    paintBackground.style = PaintingStyle.fill;
    paintBackground.color = themeColors().gridBackground();

    paintTransparent.style = PaintingStyle.fill;
    paintTransparent.color = Colors.transparent;

    paintFull.style = PaintingStyle.fill;
    paintFull.color = themeColors().mainFont();


    _touchCanvas.drawRect(Rect.fromLTWH(0, 0, 106  * boxSize, 17 * boxSize), paintBackground);
    
    for (int i = 0; i < 17; i++) {
      for (int j = 0; j < 106; j++) {
        if (state[i][j]) {
          _touchCanvas.drawRect(Rect.fromLTWH(j * boxSize, i * boxSize, boxSize, boxSize), paintFull);
        }
      }
    }

    if (max(106, 17) <= 50) {
      for (double j = 0; j <= 106 * boxSize + 0.0000001; j += boxSize) {
        _touchCanvas.drawLine(Offset(j, 0.0), Offset(j, size.height), paintLine);
      }
      for (double i = 0; i <= 17 * boxSize + 0.0000001; i += boxSize) {
        _touchCanvas.drawLine(Offset(0.0, i), Offset(size.width, i), paintLine);
      }
    }

    _touchCanvas.drawRect(Rect.fromLTWH(0, 0, 106  * boxSize, 17 * boxSize), paintTransparent,
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
