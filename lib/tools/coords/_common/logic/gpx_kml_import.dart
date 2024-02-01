import 'dart:typed_data';

import 'package:archive/archive_io.dart';
import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/_common/logic/distance_bearing.dart';
import 'package:gc_wizard/tools/coords/distance_and_bearing/logic/distance_and_bearing.dart';
import 'package:gc_wizard/tools/coords/intersect_lines/logic/intersect_lines.dart';
import 'package:gc_wizard/tools/coords/map_view/logic/map_geometries.dart';
import 'package:gc_wizard/tools/coords/map_view/persistence/mapview_persistence_adapter.dart';
import 'package:gc_wizard/tools/coords/map_view/persistence/model.dart';
import 'package:gc_wizard/utils/constants.dart';
import 'package:gc_wizard/utils/file_utils/file_utils.dart';
import 'package:gc_wizard/utils/file_utils/gcw_file.dart';
import 'package:latlong2/latlong.dart';
import 'package:xml/xml.dart';

Future<MapViewDAO?> importCoordinatesFile(GCWFile file) async {
  var type = fileTypeByFilename(file.name!);

  switch (type) {
    case FileType.GPX:
      var xml = convertBytesToString(file.bytes);
      return parseCoordinatesFile(xml);
    case FileType.KML:
      var xml = convertBytesToString(file.bytes);
      return parseCoordinatesFile(xml, kmlFormat: true);
    case FileType.KMZ:
      InputStream input = InputStream(file.bytes.buffer.asByteData());
      // Decode the Zip file
      final archive = ZipDecoder().decodeBuffer(input);
      if (archive.files.isNotEmpty) {
        var file = archive.first;
        file.decompress();

        var xml = convertBytesToString(Uint8List.fromList(file.content as List<int>));
        return parseCoordinatesFile(xml, kmlFormat: true);
      }
      break;
    default:
      break;
  }

  return null;
}

MapViewDAO? parseCoordinatesFile(String xml, {bool kmlFormat = false}) {
  MapViewDAO? result;
  try {
    var xmlDoc = XmlDocument.parse(xml);
    if (kmlFormat) {
      result = _KmlReader()._parse(xmlDoc);
    } else {
      result = _GpxReader()._parse(xmlDoc);
    }
  } catch (e) {
    return null;
  }

  // merge points
  if ((result != null)) {
    for (var x = 0; x < result.points.length; x++) {
      for (var y = x + 1; y < result.points.length; y++) {
        if ((result.points[x].latitude == result.points[y].latitude) &&
            (result.points[x].longitude == result.points[y].longitude)) {
          for (var polyline in result.polylines) {
            for (var i = 0; i < polyline.pointUUIDs.length; i++) {
              if (polyline.pointUUIDs[i] == result.points[y].uuid) {
                polyline.pointUUIDs[i] = result.points[x].uuid;
              } else if (polyline.pointUUIDs[i] == result.points[x].uuid) {
                result.points[x].color = '#000000';
              }
            }
          }

          result.points[x].name = result.points[x].name;
          result.points[x].color =
              (result.points[x].color == '#000000') ? result.points[y].color : result.points[x].color;
          result.points[x].radius = result.points[x].radius ?? result.points[y].radius;
          result.points[x].circleColor =
              (result.points[x].circleColor == null) || (result.points[x].circleColor == '#000000')
                  ? result.points[y].circleColor
                  : result.points[x].circleColor;
          result.points[x].circleColorSameAsColor =
              result.points[x].circleColorSameAsColor || result.points[y].circleColorSameAsColor;

          result.points.removeAt(y);
          y--;
        }
      }
    }
  }

  return result;
}

/// Convert GPX-XML into points
class _GpxReader {
  MapViewDAO? _parse(XmlDocument xmlDocument) {
    var parent = xmlDocument.getElement('gpx');
    if (parent != null) {
      var points = <GCWMapPoint>[];
      var lines = <GCWMapPolyline>[];

      parent.findAllElements('wpt').forEach((xmlWpt) {
        var wpt = _readPoint(xmlWpt);
        if (wpt != null) points.add(wpt);
      });
      parent.findAllElements('trk').forEach((xmlTrk) {
        xmlTrk.findElements('trkseg').forEach((xmlTrkseg) {
          var line = _readLine(xmlTrkseg);
          if (line.points.isNotEmpty) {
            lines.add(line);
            points.addAll(line.points);
          }
        });
      });

      _restoreCircles(points, lines);
      return _convertToMapViewDAO(points, lines);
    }
    return null;
  }

  GCWMapPoint? _readPoint(XmlElement xmlElement) {
    var lat = xmlElement.getAttribute('lat');
    var lon = xmlElement.getAttribute('lon');
    if (lat != null && lon != null) {
      var wpt = GCWMapPoint(point: LatLng(double.tryParse(lat) ?? 0, double.tryParse(lon) ?? 0), isEditable: true);
      wpt.markerText = xmlElement.getElement('name')?.innerText;
      if (wpt.markerText == null || wpt.markerText!.isEmpty) {
        wpt.markerText = xmlElement.getElement('desc')?.innerText;
      }
      return wpt;
    }
    return null;
  }

  GCWMapPolyline _readLine(XmlElement xmlElement) {
    var line = GCWMapPolyline(points: <GCWMapPoint>[]);

    xmlElement.findAllElements('trkpt').forEach((trkpt) {
      var lat = trkpt.getAttribute('lat');
      var lon = trkpt.getAttribute('lon');
      if (lat != null && lon != null) {
        line.points
            .add(GCWMapPoint(point: LatLng(double.tryParse(lat) ?? 0, double.tryParse(lon) ?? 0), isEditable: true));
      }
    });
    return line;
  }
}

/// Convert KML-XML into points
class _KmlReader {
  MapViewDAO? _parse(XmlDocument xmlDocument) {
    var parent = xmlDocument.getElement('kml');

    if (parent != null) {
      var document = parent.getElement('Document');
      if (document != null) {
        var points = <GCWMapPoint>[];
        var lines = <GCWMapPolyline>[];

        document.findAllElements('Placemark').forEach((xmlPlacemark) {
          var points = _readPoints(xmlPlacemark, parent);
          lines.addAll(points);
        });

        _restorePoints(points, lines);
        _restoreCircles(points, lines);

        return _convertToMapViewDAO(points, lines);
      }
    }
    return null;
  }

  List<GCWMapPolyline> _readPoints(XmlElement xmlElement, XmlElement styleParent) {
    var lines = <GCWMapPolyline>[];

    var group = xmlElement.getElement('Point');
    group ??= xmlElement.getElement('LineString');
    group ??= xmlElement.getElement('LinearRing');
    if (group == null) {
      group = xmlElement.getElement('Polygon');
      if (group != null) {
        group.findAllElements('outerBoundaryIs').forEach((boundery) {
          var linesTmp = _readPoints(boundery, styleParent);
          lines.addAll(linesTmp);
        });
        group.findAllElements('innerBoundaryIs').forEach((boundery) {
          var linesTmp = _readPoints(boundery, styleParent);
          lines.addAll(linesTmp);
        });
        if (lines.isEmpty) return [];

        return lines;
      }
    }
    if (group == null) {
      group = xmlElement.getElement('MultiGeometry');
      if (group != null) {
        for (var child in group.children) {
          var linesTmp = _readPoints(child as XmlElement, styleParent);
          lines.addAll(linesTmp);
        }
        if (lines.isEmpty) return [];

        return lines;
      }
    }
    if (group == null) return [];
    var coords = group.getElement('coordinates');
    if (coords == null) return [];

    var line = GCWMapPolyline(points: <GCWMapPoint>[]);
    var regExp = RegExp(r'(-?[.\d]+),(-?[.\d]+),?(-?[.\d]+)?');

    regExp.allMatches(coords.innerText).forEach((coordinates) {
      var lat = coordinates.group(2);
      var lon = coordinates.group(1);
      if (lat != null && lon != null) {
        var wpt = GCWMapPoint(point: LatLng(double.tryParse(lat) ?? 0, double.tryParse(lon) ?? 0));
        wpt.markerText = xmlElement.getElement('name')?.innerText;
        if (wpt.markerText == null || wpt.markerText!.isEmpty) {
          wpt.markerText = xmlElement.getElement('description')?.innerText;
        }

        if (line.points.isEmpty) {
          wpt = _readPointStyleMap(wpt, xmlElement.getElement('styleUrl')?.innerText, styleParent);
        }

        line.points.add(wpt);
      }
    });

    if (line.points.isNotEmpty) lines.add(line);
    if (lines.isEmpty) return [];

    return lines;
  }

  GCWMapPoint _readPointStyleMap(GCWMapPoint point, String? styleUrl, XmlElement styleParent) {
    if (styleUrl == null) return point;
    if (styleUrl.startsWith('#')) styleUrl = styleUrl.replaceFirst('#', '');

    for (XmlElement xmlElement in styleParent.findAllElements('StyleMap')) {
      if (xmlElement.getAttribute('id') == styleUrl) {
        var pair = xmlElement.getElement('Pair');
        if (pair != null) {
          var styleUrl = pair.getElement('styleUrl');
          if (styleUrl != null) return _readPointStyle(point, styleUrl.innerText, styleParent);
        }
      }
    }

    return point;
  }

  GCWMapPoint _readPointStyle(GCWMapPoint point, String? styleUrl, XmlElement styleParent) {
    if (styleUrl == null) return point;
    if (styleUrl.startsWith('#')) styleUrl = styleUrl.replaceFirst('#', '');

    styleParent.findAllElements('Style').forEach((xmlElement) {
      if (xmlElement.getAttribute('id') == styleUrl) {
        var color = xmlElement.findAllElements('color');
        if (color.isNotEmpty) point.color = _ColorCode(color.first.innerText);
      }
    });

    return point;
  }

  void _restorePoints(List<GCWMapPoint> points, List<GCWMapPolyline> lines) {
    for (int i = lines.length - 1; i >= 0; i--) {
      points.addAll(lines[i].points);
      if (lines[i].points.length == 1) {
        lines.removeAt(i);
      } else {
        lines[i].color = lines[i].points[0].color;
      }
    }
  }

  Color _ColorCode(String color) {
    if (color.length == 8) {
      color = color.substring(0, 2) + color.substring(6, 8) + color.substring(4, 6) + color.substring(2, 4);
    }
    return Color(int.parse(color, radix: 16));
  }
}

void _restoreCircles(List<GCWMapPoint> points, List<GCWMapPolyline> lines) {
  for (int i = lines.length - 1; i >= 0; i--) {
    if (_isClosedLine(lines[i]) && _completeCircle(lines[i], points)) {
      for (var point in lines[i].points) {
        points.remove(point);
      }
      lines.removeAt(i);
    }
  }
}

bool _isClosedLine(GCWMapPolyline line) {
  return ((line.points.first.point.latitude - line.points.last.point.latitude) < practical_epsilon) &&
      ((line.points.first.point.longitude - line.points.last.point.longitude) < practical_epsilon);
}

bool _completeCircle(GCWMapPolyline line, List<GCWMapPoint> points) {
  const tolerance = 2 / 100;
  if (line.points.length < 36) return false;

  var pt1 = line.points[0].point;
  var pt2 = line.points[line.points.length ~/ 2].point;
  var pt3 = line.points[line.points.length ~/ 4].point;
  var pt4 = line.points[line.points.length * 3 ~/ 4].point;
  var ells = defaultEllipsoid;

  DistanceBearingData length1 = distanceBearing(pt1, pt2, ells);
  DistanceBearingData length2 = distanceBearing(pt3, pt4, ells);
  double dist = (length1.distance - length2.distance);
  double distToller = length1.distance * tolerance;
  if (dist.abs() > distToller) return false;

  var crossPoint = intersectFourPoints(pt1, pt2, pt3, pt4, ells);
  late GCWMapPoint center;
  double minDist = double.maxFinite;

  if (crossPoint == null) return false;
  for (var wpt in points) {
    var dist = distanceBearing(wpt.point, crossPoint, ells);
    if (dist.distance < minDist && !wpt.hasCircle()) {
      minDist = dist.distance;
      center = wpt;
    }
  }
  if (minDist > distToller) return false;

  var radius = length1.distance / 2;
  distToller = distToller / 2;
  for (GCWMapPoint wpt in line.points) {
    dist = distanceBearing(wpt.point, center.point, ells).distance;
    if ((dist - radius).abs() > distToller) return false;
  }
  center.circle = GCWMapCircle(centerPoint: center.point, radius: radius, color: line.color);
  center.circleColorSameAsPointColor = (center.color == center.circle?.color);
  return true;
}

MapViewDAO _convertToMapViewDAO(List<GCWMapPoint> points, List<GCWMapPolyline> lines) {
  var daoPoints = <MapPointDAO>[];
  var daoLines = <MapPolylineDAO>[];

  for (var point in points) {
    daoPoints.add(MapViewPersistenceAdapter.gcwMapPointToMapPointDAO(point));
  }

  for (var line in lines) {
    daoLines.add(MapViewPersistenceAdapter.gcwMapPolylineToMapPolylineDAO(line));
  }

  return MapViewDAO(daoPoints, daoLines);
}
