import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/segment_display/base/n_segment_display.dart';

Widget buildSegmentDisplayOutput(int countColumns, List<dynamic> displays) {
  var rows = <Widget>[];
  var countRows = (displays.length / countColumns).floor();

  for (var i = 0; i <= countRows; i++) {
    var columns = <Widget>[];

    for (var j = 0; j < countColumns; j++) {
      var widget;
      var displayIndex = i * countColumns + j;

      if (displayIndex < displays.length) {
        var display = displays[displayIndex];

        widget = Container(
          child: display,
          padding: EdgeInsets.all(2),
        );
      } else {
        widget = Container();
      }

      columns.add(Expanded(
          child: Container(
        child: widget,
        padding: EdgeInsets.all(3),
      )));
    }

    rows.add(Row(
      children: columns,
    ));
  }

  return Column(
    children: rows,
  );
}

Future<ui.Image> buildSegmentDisplayImage(int countColumns, List<NSegmentDisplay> displays, bool upsideDown) async {
  const double bounds = 3.0;
  const double padding = 2.0;
  var width = 0.0;
  var height = 0.0;
  var columnCounter = 0;
  var rowWidth = 0.0;
  var rowHeight = 0.0;
  var images = <ui.Image>[];
  var offset = ui.Offset(0, bounds);

  if (displays == null) return null;

  // create images
  for (var i = 0; i < displays.length; i++) images.add(await displays[i].renderedImage);

  // calc image size
  images.forEach((image) {
    rowWidth += image.width + 2 * padding;
    width = max(width, rowWidth);
    rowHeight = max(rowHeight, image.height.toDouble() + 2 * padding);
    columnCounter++;

    if (columnCounter >= countColumns) {
      height += rowHeight;
      rowWidth = 0;
      rowHeight = 0;
      columnCounter = 0;
    }
  });

  width = width + 2 * bounds;
  height = height + rowHeight + 2 * bounds;

  final canvasRecorder = ui.PictureRecorder();
  final canvas = ui.Canvas(canvasRecorder, ui.Rect.fromLTWH(0, 0, width, height));

  final paint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.fill;

  canvas.drawRect(Rect.fromLTWH(0, 0, width, height), paint);

  var countRows = (images.length / countColumns).floor();

  for (var i = 0; i <= countRows; i++) {
    offset = ui.Offset(bounds, offset.dy);
    rowHeight = 0;

    for (var j = 0; j < countColumns; j++) {
      var imageIndex = i * countColumns + j;

      if (imageIndex < images.length) {
        var image = images[imageIndex];
        var middlePoint = ui.Offset(offset.dx + padding + image.width / 2, offset.dy + padding + image.height / 2);
        if (upsideDown) {
          canvas.translate(middlePoint.dx, middlePoint.dy);
          canvas.rotate(pi);
          canvas.translate(-middlePoint.dx, -middlePoint.dy);
        }
        canvas.drawImage(image, offset.translate(padding, padding), paint);
        if (upsideDown) {
          canvas.translate(middlePoint.dx, middlePoint.dy);
          canvas.rotate(pi);
          canvas.translate(-middlePoint.dx, -middlePoint.dy);
        }
        offset = offset.translate(image.width.toDouble() + 2 * padding, 0);
        rowHeight = max(rowHeight, image.height.toDouble() + 2 * padding);
      }
    }
    offset = offset.translate(0, rowHeight);
  }
  return canvasRecorder.endRecording().toImage(width.toInt(), height.toInt());
}
