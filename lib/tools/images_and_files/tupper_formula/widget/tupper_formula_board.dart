import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/tools/images_and_files/tupper_formula/logic/tupper_formula.dart';
import 'package:touchable/touchable.dart';

class TupperFormulaBoard extends StatefulWidget {
  final void Function(List<List<int>>) onChanged;
  final List<List<int>> state;
  final int width;
  final int height;
  final int colors;

  const TupperFormulaBoard(
      {super.key,
      required this.onChanged,
      required this.state,
      required this.width,
      required this.height,
      required this.colors});


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
                aspectRatio: (widget.width != 0 && widget.height != 0)
                    ? widget.width / widget.height
                    : 1.0,
                child: CanvasTouchDetector(
                  gesturesToOverride: const [GestureType.onTapDown],
                  builder: (context) {
                    return CustomPaint(
                        painter: TupperFormulaBoardPainter(
                      context,
                      widget.state,
                      (int x, int y) {
                        setState(() {
                          widget.state[x][y] = widget.state[x][y] + 1;
                          if (widget.state[x][y] == widget.colors) {
                            widget.state[x][y] = 0;
                          }
                          widget.onChanged(widget.state);
                        });
                      },
                      widget.width,
                      widget.height,
                      widget.colors,
                    ));
                  },
                )))
      ],
    );
  }
}

class TupperFormulaBoardPainter extends CustomPainter {
  final List<List<int>> state;
  final BuildContext context;
  final void Function(int, int) onInvertCell;
  final int width;
  final int height;
  final int colors;

  TupperFormulaBoardPainter(this.context, this.state, this.onInvertCell,
      this.width, this.height, this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    var _touchCanvas = TouchyCanvas(context, canvas);
    var paintLine = Paint();
    var paintFull = Paint();
    var paintBackground = Paint();
    var paintTransparent = Paint();
    double boxSize = size.width / width;

    paintLine.strokeWidth = 2;
    paintLine.style = PaintingStyle.stroke;
    paintLine.color = themeColors().secondary();

    paintBackground.style = PaintingStyle.fill;
    paintBackground.color = themeColors().gridBackground();

    paintTransparent.style = PaintingStyle.fill;
    paintTransparent.color = Colors.transparent;

    paintFull.style = PaintingStyle.fill;
    paintFull.color = themeColors().mainFont();

    if (width != 0 && height != 0) {
      _touchCanvas.drawRect(
          Rect.fromLTWH(0, 0, width * boxSize, height * boxSize),
          paintBackground);
    }
    for (int i = 0; i < height; i++) {
      for (int j = 0; j < width; j++) {
        if (state[i][j] < colors) {
          paintFull.color = TUPPER_COLORS[colors]![state[i][j]];
        } else {
          paintFull.color = Colors.black;
        }
        _touchCanvas.drawRect(
            Rect.fromLTWH(j * boxSize, i * boxSize, boxSize, boxSize),
            paintFull);
      }
    }

    if (max(width, height) <= 50) {
      for (double j = 0; j <= width * boxSize + 0.0000001; j += boxSize) {
        _touchCanvas.drawLine(
            Offset(j, 0.0), Offset(j, size.height), paintLine);
      }
      for (double i = 0; i <= height * boxSize + 0.0000001; i += boxSize) {
        _touchCanvas.drawLine(Offset(0.0, i), Offset(size.width, i), paintLine);
      }
    }

    _touchCanvas.drawRect(
        Rect.fromLTWH(0, 0, width * boxSize, height * boxSize),
        paintTransparent, onTapDown: (tapDetail) {
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
