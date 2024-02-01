part of 'package:gc_wizard/tools/science_and_technology/teletypewriter/punchtape_segment_display/widget/punchtape_segmentdisplay_output.dart';

Future<void> _exportFile(BuildContext context, Uint8List? data) async {
  if (data == null) return;
  await saveByteDataToFile(context, data, buildFileNameWithDate('img_', FileType.PNG)).then((value) {
    if (value) showExportedFileDialog(context, contentWidget: imageContent(context, data));
  });
}

Widget _buildPunchtapeSegmentDisplayOutput(List<Widget> displays) {
  var rows = <Widget>[];

  for (var displayIndex = 0; displayIndex < displays.length; displayIndex++) {
    var columns = <Widget>[];
    Widget widget;
    var display = displays[displayIndex];

    widget = Container(
      width: 200,
      height: 40,
      padding: const EdgeInsets.all(2),
      child: display,
    );

    columns.add(Expanded(
        child: Container(
      padding: const EdgeInsets.all(3),
      child: widget,
    )));

    rows.add(Row(
      children: columns,
    ));
  }

  return SizedBox(
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
  var offset = const ui.Offset(0, bounds);

  // create images
  for (var i = 0; i < displays.length; i++) {
    images.add(await displays[i].renderedImage);
  }

  // calc image size
  for (var image in images) {
    rowWidth = max(rowWidth, image.width.toDouble() + 2 * padding);
    width = max(width, rowWidth);
    rowHeight += image.height + 6 * padding;
    height = max(height, rowHeight);
  }

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
