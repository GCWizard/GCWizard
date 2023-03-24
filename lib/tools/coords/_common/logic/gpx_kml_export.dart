import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/coords/map_view/logic/map_geometries.dart';
import 'package:gc_wizard/utils/file_utils/file_utils.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/file_widget_utils.dart';
import 'package:latlong2/latlong.dart';
import 'package:xml/xml.dart';

Future<bool> exportCoordinates(BuildContext context, List<GCWMapPoint> points, List<GCWMapPolyline> polylines,
    {bool kmlFormat = false}) async {
  String data;
  FileType fileType;

  var defaultName = points.first.markerText;
  if (defaultName == null || defaultName.isEmpty) {
    defaultName = buildFileNameWithDate('GC Wizard Export ', null);
  }

  if ((points.isEmpty) && (polylines.isEmpty)) {
    return false;
  }

  if (kmlFormat) {
    data = _KmlWriter().asString(defaultName, points, polylines);
    fileType = FileType.KML;
  } else {
    data = _GpxWriter().asString(defaultName, points, polylines);
    fileType = FileType.GPX;
  }

  try {
    var fileName = buildFileNameWithDate('coords_', fileType);
    return saveStringToFile(context, data, fileName);
  } on Exception {
    return false;
  }
}

/// Convert points into GPX
class _GpxWriter {
  /// Convert points into GPX XML (v1.0) as String
  String asString(String name, List<GCWMapPoint> points, List<GCWMapPolyline> polylines) =>
      _build(name, points, polylines).toXmlString(pretty: true, indent: '\t');

  /// Convert Gpx into GPX XML (v1.0) as XmlNode
  XmlNode asXml(String name, List<GCWMapPoint> points, List<GCWMapPolyline> polylines) =>
      _build(name, points, polylines);

  XmlNode _build(String name, List<GCWMapPoint> points, List<GCWMapPolyline> polylines) {
    final builder = XmlBuilder();

    if ((points.isEmpty) && (polylines.isEmpty)) return builder.buildDocument();

    builder.processing('xml', 'version="1.0" encoding="UTF-8"');
    builder.element('gpx', nest: () {
      builder.attribute('version', '1.0');
      builder.attribute('creator', 'GC Wizard');
      builder.attribute('xsi:schemaLocation',
          '"http://www.topografix.com/GPX/1/0 http://www.topografix.com/GPX/1/0/gpx.xsd http://www.groundspeak.com/cache/1/0/1 http://www.groundspeak.com/cache/1/0/1/cache.xsd http://www.gsak.net/xmlv1/6 http://www.gsak.net/xmlv1/6/gsak.xsd');
      builder.attribute('xmlns', 'http://www.topografix.com/GPX/1/0');
      builder.attribute('xmlns:xsi', 'http://www.w3.org/2001/XMLSchema-instance');
      builder.attribute('xmlns:groundspeak', 'http://www.groundspeak.com/cache/1/0/1');
      builder.attribute('xmlns:gsak', 'http://www.gsak.net/xmlv1/6');

      var i = 0;
      for (var point in points) {
        _writePoint(builder, (i != 0), name, 'S' + i.toString(), point);
        i++;
      }

      var circles = points.where((GCWMapPoint point) => point.hasCircle()).map((point) => point.circle!).toList();
      for (var circle in circles) {
        _writeLines(builder, name, 'circle', circle.shape);
      }

      for (var geodetic in polylines) {
        _writeLines(builder, name, 'line', geodetic.points.map((mapPoint) => mapPoint.point).toList());
      }
    });

    return builder.buildDocument();
  }

  void _writePoint(XmlBuilder builder, bool waypoint, String cacheName, String stageName, GCWMapPoint wpt) {
    builder.element('wpt', nest: () {
      _writeAttribute(builder, 'lat', wpt.point.latitude);
      _writeAttribute(builder, 'lon', wpt.point.longitude);
      if (!waypoint) {
        _writeElement(builder, 'name', cacheName);
        if (wpt.markerText != null) {
          _writeElement(builder, 'desc', wpt.markerText!);
        }
        _writeElement(builder, 'urlname', cacheName);
        _writeElement(builder, 'sym', 'Geocache');
        _writeElement(builder, 'type', 'Geocache|User defined cache');
        builder.element('groundspeak:cache', nest: () {
          _writeElement(builder, 'groundspeak:name', cacheName);
          _writeElement(builder, 'groundspeak:placed_by', 'You');
          _writeElement(builder, 'groundspeak:type', 'User defined cache');
          _writeElement(builder, 'groundspeak:container', 'Unknown');
          builder.element('groundspeak:short_description', nest: () {
            _writeAttribute(builder, 'html', 'False');
          });
        });
      } else {
        if (wpt.markerText != null) {
          _writeElement(builder, 'name', wpt.markerText!);
        }
        _writeElement(builder, 'cmt', '');
        _writeElement(builder, 'desc', '');
        _writeElement(builder, 'sym', 'Virtual Stage');
        _writeElement(builder, 'type', 'Waypoint|Virtual Stage');
        builder.element('gsak:wptExtension', nest: () {
          _writeElement(builder, 'gsak:Parent', cacheName);
        });
      }
    });
  }

  void _writeLines(XmlBuilder builder, String cacheName, String tagName, List<LatLng> shapes) {

    builder.element('trk', nest: () {
      _writeElement(builder, 'name', tagName);

      builder.element('trkseg', nest: () {
        for (var point in shapes) {
          builder.element('trkpt', nest: () {
            _writeAttribute(builder, 'lat', point.latitude);
            _writeAttribute(builder, 'lon', point.longitude);
          });
        }
      });
    });

  }

  void _writeElement(XmlBuilder builder, String tagName, Object value) {
    builder.element(tagName, nest: value);
  }

  void _writeAttribute(XmlBuilder builder, String tagName, Object value) {
    builder.attribute(tagName, value);
  }
}

/// Convert Gpx into KML
class _KmlWriter {
  var elementNames = <String>[];

  /// Convert points into KML as String
  String asString(String name, List<GCWMapPoint> points, List<GCWMapPolyline> polylines) =>
      _build(name, points, polylines).toXmlString(pretty: true, indent: '\t');

  /// Convert points into KML as XmlNode
  XmlNode asXml(String name, List<GCWMapPoint> points, List<GCWMapPolyline> polylines) =>
      _build(name, points, polylines);

  XmlNode _build(String name, List<GCWMapPoint> points, List<GCWMapPolyline> polylines) {
    final builder = XmlBuilder();
    var i = 0;
    var styleMap = <String, String>{};

    if ((points.isEmpty) && (polylines.isEmpty)) return builder.buildDocument();
    elementNames.clear();

    builder.processing('xml', 'version="1.0" encoding="UTF-8"');
    builder.element('kml', nest: () {
      builder.attribute('xmlns', 'http://www.opengis.net/kml/2.2');

      builder.element('Document', nest: () {
        _writeElement(builder, 'name', 'GC Wizard');

        for (i = 0; i < points.length; i++) {
          for (var x = 0; x <= i; x++) {
            if (points[x].color == points[i].color) {
              styleMap.addAll({'waypoint' + i.toString(): 'waypoint' + x.toString()});
              break;
            }
          }
        }
        for (i = 0; i < points.length; i++) {
          var styleId = 'waypoint' + i.toString();
          if (styleMap[styleId] == styleId) {
            builder.element('StyleMap', nest: () {
              builder.attribute('id', styleId);

              builder.element('Pair', nest: () {
                _writeElement(builder, 'key', 'normal');
                _writeElement(builder, 'styleUrl', '#' + styleId);
              });
            });
          }
        }
        for (i = 0; i < points.length; i++) {
          var styleId = 'waypoint' + i.toString();
          if (styleMap[styleId] == styleId) {
            builder.element('Style', nest: () {
              builder.attribute('id', 'waypoint' + i.toString());
              _writeElement(builder, 'color', _ColorCode(points[i].color));
              builder.element('IconStyle', nest: () {
                builder.element('Icon', nest: () {
                  _writeElement(builder, 'href', 'https://maps.google.com/mapfiles/kml/pal4/icon61.png');
                });
              });
            });
          }
        }


        var circles = points.where((point) => point.hasCircle()).map((point) => point.circle!).toList();

        for (i = 0; i < circles.length; i++) {
          for (var x = 0; x <= i; x++) {
            if (circles[x].color == circles[i].color) {
              styleMap.addAll({'circle' + i.toString(): 'circle' + x.toString()});
              break;
            }
          }
        }
        for (i = 0; i < circles.length; i++) {
          var styleId = 'circle' + i.toString();
          if (styleMap[styleId] == styleId) {
            builder.element('StyleMap', nest: () {
              builder.attribute('id', styleId);

              builder.element('Pair', nest: () {
                _writeElement(builder, 'key', 'normal');
                _writeElement(builder, 'styleUrl', '#' + styleId);
              });
            });
          }
        }
        for (i = 0; i < circles.length; i++) {
          var styleId = 'circle' + i.toString();
          if (styleMap[styleId] == styleId) {
            builder.element('Style', nest: () {
              builder.attribute('id', styleId);
              builder.element('LineStyle', nest: () {
                _writeElement(builder, 'color', _ColorCode(circles[i].color));
                _writeElement(builder, 'width', 3);
              });
              _writeElement(builder, 'color', _ColorCode(circles[i].color));
            });
          }
        }

        for (i = 0; i < polylines.length; i++) {
          for (var x = 0; x <= i; x++) {
            if (polylines[x].color == polylines[i].color) {
              styleMap.addAll({'polyline' + i.toString(): 'polyline' + x.toString()});
              break;
            }
          }
        }
        for (i = 0; i < polylines.length; i++) {
          var styleId = 'polyline' + i.toString();
          if (styleMap[styleId] == styleId) {
            builder.element('StyleMap', nest: () {
              builder.attribute('id', styleId);

              builder.element('Pair', nest: () {
                _writeElement(builder, 'key', 'normal');
                _writeElement(builder, 'styleUrl', '#' + styleId);
              });
            });
          }
        }
        for (i = 0; i < polylines.length; i++) {
          var styleId = 'polyline' + i.toString();
          if (styleMap[styleId] == styleId) {
            builder.element('Style', nest: () {
              builder.attribute('id', styleId);
              builder.element('LineStyle', nest: () {
                _writeElement(builder, 'color', _ColorCode(polylines[i].color));
                _writeElement(builder, 'width', 3);
              });
              _writeElement(builder, 'color', _ColorCode(polylines[i].color));
            });
          }
        }


        builder.element('Folder', nest: () {
          _writeElement(builder, 'name', 'Waypoints');

          for (i = 0; i < points.length; i++) {
            var waypointStyle = styleMap['waypoint' + i.toString()];
            if (waypointStyle == null) {
              continue;
            }

            if (i == 0) {
              _writePoint(
                  builder, false, name, 'S' + i.toString(), points[i], '#' + waypointStyle);
            }
            _writePoint(
                builder, true, name, 'S' + i.toString(), points[i], '#' + waypointStyle);
          }

        });

        for (i = 0; i < circles.length; i++) {
          var circleStyle = styleMap['circle' + i.toString()];
          if (circleStyle == null) {
            continue;
          }

          _writeLines(builder, circles[i].shape, '#' + circleStyle);
        }

        if (polylines.isNotEmpty) {
          for (i = 0; i < polylines.length; i++) {
            var polylineStyle = styleMap['polyline' + i.toString()];
            if (polylineStyle == null) {
              continue;
            }

            _writeLines(builder, polylines[i].points.map((mapPoint) => mapPoint.point).toList(),
                '#' + polylineStyle);
          }
        }
      });
    });

    return builder.buildDocument();
  }

  String _checkName(String label) {
    var count = elementNames.where((element) => label == element).length;
    elementNames.add(label);
    if (count > 0) return label + ' ($count)';
    return label;
  }

  void _writePoint(
      XmlBuilder builder, bool waypoint, String cacheName, String stageName, GCWMapPoint wpt, String styleId) {

    builder.element('Placemark', nest: () {
      if (!waypoint) {
        _writeElement(builder, 'name', _checkName(cacheName));
      } else if ((wpt.markerText != null) && wpt.markerText!.isNotEmpty) {
        _writeElement(builder, 'name', _checkName(wpt.markerText!));
      }
      _writeElement(builder, 'altitudeMode', 'relativeToGround');
      _writeElement(builder, 'styleUrl', styleId);
      builder.element('Point', nest: () {
        _writeElement(builder, 'coordinates', [wpt.point.longitude, wpt.point.latitude].join(','));
      });
    });

  }

  void _writeLines(XmlBuilder builder, List<LatLng> shapes, String styleId) {
    builder.element('Placemark', nest: () {
      _writeElement(builder, 'visibility', 1);
      _writeElement(builder, 'styleUrl', styleId);

      builder.element('LineString', nest: () {
        _writeElement(builder, 'tesselerate', 1);
        _writeElement(builder, 'altitudeMode', 'relativeToGround');
        _writeElement(
            builder, 'coordinates', shapes.map((point) => [point.longitude, point.latitude].join(',') + ' \n'));
      });
    });
  }

  void _writeElement(XmlBuilder builder, String tagName, Object value) {
    builder.element(tagName, nest: value);
  }

  String _ColorCode(Color color) {
    var s = color.value.toRadixString(16);
    return s.substring(0, 2) + s.substring(6, 8) + s.substring(4, 6) + s.substring(2, 4);
  }
}
