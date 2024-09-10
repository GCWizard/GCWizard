part of 'package:gc_wizard/tools/coords/map_view/widget/gcw_mapview.dart';

/// This is the [CustomPainter] that draws the scalebar label and lines
/// onto the canvas.
class GCWMapViewScalebarPainter extends CustomPainter {
  /// length of the scalebar
  final double scalebarLength;

  /// marker points
  final List<Point<double>> scalebarPoints;

  /// width of the scalebar line stroke
  final double strokeWidth;

  /// scalebar line height
  final double lineWidth;

  /// The alignment is used to align the scalebar if it is smaller than the
  /// text label.
  final Alignment alignment;

  /// The cached half of the line stroke width
  late final _halfStrokeWidth = strokeWidth / 2;

  final Paint _linePaint = Paint();
  final TextPainter _textPainter;

  /// Create a new [GCWMapViewScalebar], internally used in the [GCWMapViewScalebar].
  GCWMapViewScalebarPainter({
    required this.scalebarLength,
    required this.scalebarPoints,
    required TextSpan text,
    required this.strokeWidth,
    required this.lineWidth,
    required Color lineColor,
    required this.alignment,
  }) : _textPainter = TextPainter(
    text: text,
    textDirection: ui.TextDirection.ltr,
    maxLines: 1,
  ) {
    _linePaint
      ..color = lineColor
      ..strokeCap = StrokeCap.square
      ..strokeWidth = strokeWidth;
    _textPainter.layout();
  }

  @override
  void paint(Canvas canvas, Size size) {
    // draw text label
    final labelX = lineWidth;
    _textPainter.paint(
      canvas,
      Offset(max(0, labelX), -18),
    );

    final length = scalebarPoints[3].y - scalebarPoints[0].y;

    final linePoints = Float32List.fromList(<double>[
      //main line
      0.0,
      0.0 - _halfStrokeWidth,
      0.0,
      length - _halfStrokeWidth,

      // bottom marker
      _halfStrokeWidth,
      0.0 - _halfStrokeWidth,
      lineWidth,
      0.0 - _halfStrokeWidth,

      // 1. section
      _halfStrokeWidth,
      scalebarPoints[1].y - scalebarPoints[0].y - _halfStrokeWidth,
      lineWidth,
      scalebarPoints[1].y - scalebarPoints[0].y - _halfStrokeWidth,

      // 2. section
      _halfStrokeWidth,
      scalebarPoints[2].y - scalebarPoints[0].y - _halfStrokeWidth,
      lineWidth,
      scalebarPoints[2].y - scalebarPoints[0].y - _halfStrokeWidth,

      // top marker
      _halfStrokeWidth,
      scalebarPoints[3].y - scalebarPoints[0].y - _halfStrokeWidth,
      lineWidth,
      scalebarPoints[3].y - scalebarPoints[0].y - _halfStrokeWidth,
    ]);

    // draw lines as raw points
    canvas.drawRawPoints(
      ui.PointMode.lines,
      linePoints,
      _linePaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}