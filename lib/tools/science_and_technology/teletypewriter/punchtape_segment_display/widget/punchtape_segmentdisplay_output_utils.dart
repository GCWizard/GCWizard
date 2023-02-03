part of 'package:gc_wizard/tools/science_and_technology/teletypewriter/punchtape_segment_display/widget/punchtape_segmentdisplay_output.dart';

_exportFile(BuildContext context, Uint8List data) async {
  var value =
  await saveByteDataToFile(context, data, 'img_' + DateFormat('yyyyMMdd_HHmmss').format(DateTime.now()) + '.png');

  if (value != null) showExportedFileDialog(context, fileType: FileType.PNG, contentWidget: Image.memory(data));
}

Widget _buildPunchtapeSegmentDisplayOutput(List<dynamic> displays) {
  var rows = <Widget>[];

  for (var displayIndex = 0; displayIndex < displays.length; displayIndex++) {
    var columns = <Widget>[];
    var widget;
    var display = displays[displayIndex];

    widget = Container(
      width: 200,
      height: 40,
      child: display,
      padding: EdgeInsets.all(2),
    );

    columns.add(Expanded(
        child: Container(
          child: widget,
          padding: EdgeInsets.all(3),
        )));

    rows.add(Row(
      children: columns,
    ));
  }

  return Container(
      width: 300,
      child: Column(
        children: rows,
      ));
}

Future<ui.Image> _buildPunchtapeSegmentDisplayImage(List<NSegmentDisplay> displays, bool upsideDown) async {
  const double bounds = 3.0;
  const double padding = 2.0;
  var width = 0.0;
  var height = 0.0;
  var rowWidth = 0.0;
  var rowHeight = 0.0;
  var images = <ui.Image>[];
  var offset = ui.Offset(0, bounds);

  if (displays == null) return null;

  // create images
  for (var i = 0; i < displays.length; i++) {
    images.add(await displays[i].renderedImage);
  }

  // calc image size
  images.forEach((image) {
    rowWidth = max(rowWidth, image.width.toDouble() + 2 * padding);
    width = max(width, rowWidth);
    rowHeight += image.height + 6 * padding;
    height = max(height, rowHeight);
  });

  width = width + 2 * bounds;
  height = height + 2 * bounds;

  final canvasRecorder = ui.PictureRecorder();
  final canvas = ui.Canvas(canvasRecorder, ui.Rect.fromLTWH(0, 0, width, height));

  final paint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.fill;

  canvas.drawRect(Rect.fromLTWH(0, 0, width, height), paint);

  for (var imageIndex = 0; imageIndex < images.length; imageIndex++) {
    offset = ui.Offset(bounds, offset.dy);
    rowHeight = 0;

    var image = images[imageIndex];
    var middlePoint = ui.Offset(offset.dx + padding + image.width / 2, offset.dy + padding + image.height / 2);
    if (upsideDown) {
      canvas.translate(middlePoint.dx, middlePoint.dy);
      canvas.rotate(pi);
      canvas.translate(-middlePoint.dx, -middlePoint.dy);
    }
    canvas.drawImage(image, offset.translate(padding, padding * 3), paint);
    if (upsideDown) {
      canvas.translate(middlePoint.dx, middlePoint.dy);
      canvas.rotate(pi);
      canvas.translate(-middlePoint.dx, -middlePoint.dy);
    }
    offset = offset.translate(image.height.toDouble() + 3 * padding, 0);
    rowHeight = max(rowHeight, image.height.toDouble() + 3 * padding);

    offset = offset.translate(0, rowHeight);
  }
  return canvasRecorder.endRecording().toImage(width.toInt(), height.toInt());
}