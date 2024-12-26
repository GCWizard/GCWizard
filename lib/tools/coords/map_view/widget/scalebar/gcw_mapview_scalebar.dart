part of 'package:gc_wizard/tools/coords/map_view/widget/gcw_mapview.dart';

// based on FlutterMap v7 Scalebar, but adjusted to vertical direction and 3 sections. Even more precise
// https://github.com/josxha/flutter_map/tree/477bbdf41e5e99b74b8f2f6b7054f38e1e8d64c7/lib/src/layer/scalebar

/// The [GCWMapViewScalebar] widget is a map layer for [FlutterMap].
///
/// Not every CRS is currently supported!
class GCWMapViewScalebar extends StatelessWidget {
  /// The [Alignment] of the Scalebar.
  ///
  /// Defaults to [Alignment.topRight]
  final Alignment alignment;

  /// The [TextStyle] for the scale bar label.
  ///
  /// Defaults to a black color and font size 14.
  final TextStyle? textStyle;

  /// The color of the lines.
  ///
  /// Defaults to black.
  final Color lineColor;

  /// The width of the line strokes in pixel.
  ///
  /// Defaults to 2px.
  final double strokeWidth;

  /// The height of the line strokes in pixel.
  ///
  /// Defaults to 5px.
  final double lineWidth;

  /// The padding of the scale bar.
  ///
  /// Defaults to 10px on all sides.
  final EdgeInsets padding;

  /// The relative length of the scalebar.
  ///
  /// Defaults to [ScalebarLength.m] for a medium length.
  final ScalebarLength length;

  /// Create a new [GCWMapViewScalebar].
  ///
  /// This widget needs to be placed in the [FlutterMap.children] list.
  const GCWMapViewScalebar({
    super.key,
    this.alignment = Alignment.topRight,
    this.textStyle = const TextStyle(color: Color(0xFF000000), fontSize: 14),
    this.lineColor = const Color(0xFF000000),
    this.strokeWidth = 2,
    this.lineWidth = 5,
    this.padding = const EdgeInsets.all(10),
    this.length = ScalebarLength.m,
  });

  TextSpan _label(String label) {
    return TextSpan(
      text: label,
      style: textStyle
    );
  }

  @override
  Widget build(BuildContext context) {
    final camera = MapCamera.of(context);
    const dst = Distance();

    // calculate the scalebar width in pixels
    final pixelsBottomLeft = camera.pixelBounds.bottomLeft;
    var x1 = pixelsBottomLeft.x + 10;
    var y1 = pixelsBottomLeft.y - 30;
    final latlng1 = camera.layerPointToLatLng(Point(x1, y1));

    double index = camera.zoom + 1;
    final metricDst = _metricScale[index.round().clamp(0, _metricScale.length - 1)];

    LatLng latLngOffset1 = dst.offset(latlng1, metricDst.toDouble(), 0);
    LatLng latLngOffset2 = dst.offset(latlng1, metricDst.toDouble() * 2, 0);
    LatLng latLngOffset3 = dst.offset(latlng1, metricDst.toDouble() * 3, 0);
    final offsetDistance1 = camera.project(latLngOffset1);
    final offsetDistance2 = camera.project(latLngOffset2);
    final offsetDistance3 = camera.project(latLngOffset3);

    var unit = metricDst < 1000 ? 'm' : 'km';
    String _metricValue(int baseMetric, int metricDst) {
      return (baseMetric < 1000 ? metricDst : (metricDst / 1000.0)).toStringAsFixed(0);
    }

    final label0 = '0 $unit';
    final label1 = _metricValue(metricDst, metricDst);
    final label2 = _metricValue(metricDst, metricDst * 2);
    final label3 = _metricValue(metricDst, metricDst * 3);

    final scalebarPainter = GCWMapViewScalebarPainter(
      // use .abs() to avoid wrong placements on the right map border
      scalebarLength: (offsetDistance1.y - y1).abs(),
      scalebarPoints: [Point(x1, y1), offsetDistance1, offsetDistance2, offsetDistance3],
      texts: [_label(label0), _label(label1), _label(label2), _label(label3)],
      alignment: alignment,
      lineColor: lineColor,
      strokeWidth: strokeWidth,
      lineWidth: lineWidth,
    );

    return Align(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, bottom: 30),//padding,
        child: CustomPaint(
          // size: scalebarPainter.widgetSize,
          painter: scalebarPainter,
        ),
      ),
    );
  }
}

/// Stop points for the scalebar label.
const _metricScale = <int>[
  15000000,
  8000000,
  4000000,
  2000000,
  1000000,
  500000,
  250000,
  100000,
  50000,
  25000,
  15000,
  8000,
  4000,
  2000,
  1000,
  500,
  250,
  100,
  50,
  25,
  10,
  5,
  2,
  1,
];

enum ScalebarLength {
  /// Small scalebar
  s(-2),

  /// Medium scalebar
  m(-1),

  /// large scalebar
  l(0),

  /// very large scalebar
  ///
  /// This length potentially overflows the screen width near the north or
  /// south pole.
  xl(1),

  /// very very large scalebar
  ///
  /// This length potentially overflows the screen width near the north or
  /// south pole.
  xxl(2);

  final int value;

  const ScalebarLength(this.value);
}