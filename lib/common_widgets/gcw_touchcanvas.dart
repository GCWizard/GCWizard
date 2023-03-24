import 'package:flutter/material.dart';
import 'package:touchable/touchable.dart';

class GCWTouchCanvas {
  late TouchyCanvas touchCanvas;
  final Canvas canvas;

  GCWTouchCanvas(BuildContext context, this.canvas) {
    touchCanvas = TouchyCanvas(context, canvas);
  }
}
