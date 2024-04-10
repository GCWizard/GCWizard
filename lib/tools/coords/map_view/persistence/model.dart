import 'package:gc_wizard/application/theme/fixed_colors.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/map_view/logic/map_geometries.dart';
import 'package:gc_wizard/utils/data_type_utils/object_type_utils.dart';
import 'package:gc_wizard/utils/json_utils.dart';
import 'package:gc_wizard/utils/string_utils.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/color_utils.dart';
import 'package:uuid/uuid.dart';

List<MapViewDAO> mapViews = [];

class MapViewDAO {
  int? id;
  String? name;
  List<MapPointDAO> points = [];
  List<MapPolylineDAO> polylines = [];

  MapViewDAO(this.points, this.polylines);

  Map<String, Object?> toMap() => {
        'id': id,
        'name': name,
        'points': points.map((point) => point.toMap()).toList(),
        'polylines': polylines.map((polyline) => polyline.toMap()).toList(),
      };

  MapViewDAO.fromJson(Map<String, Object?> json) {
    name = toStringOrNull(json['name']);
    id = toIntOrNull(json['id']);

    var pointsRaw = toObjectWithNullableContentListOrNull(json['points']);
    if (pointsRaw != null) {
      points = <MapPointDAO>[];
      for (var element in pointsRaw) {
        var point = asJsonMapOrNull(element);
        if (point == null) continue;

        points.add(MapPointDAO.fromJson(point));
      }
    }

    var polylinesRaw = toObjectWithNullableContentListOrNull(json['polylines']);
    if (polylinesRaw != null) {
      polylines = <MapPolylineDAO>[];
      for (var element in polylinesRaw) {
        var polyline = asJsonMapOrNull(element);
        if (polyline == null) continue;
        
        polylines.add(MapPolylineDAO.fromJson(polyline));
      }
    }
  }

  @override
  String toString() {
    return toMap().toString();
  }
}

class MapPointDAO {
  final String uuid;
  String? name;
  double latitude;
  double longitude;
  String coordinateFormat;
  bool isVisible;
  String color;
  double? radius;
  bool circleColorSameAsColor;
  String? circleColor;
  bool? isEditable;

  MapPointDAO(this.uuid, this.name, this.latitude, this.longitude, this.coordinateFormat, this.isVisible, this.color,
      this.radius, this.circleColorSameAsColor, this.circleColor, this.isEditable);

  Map<String, Object?> toMap() => {
        'uuid': uuid,
        'name': name,
        'latitude': latitude,
        'longitude': longitude,
        'coordinateFormat': coordinateFormat,
        'isVisible': isVisible,
        'color': color,
        'radius': radius,
        'circleColorSameAsColor': circleColorSameAsColor,
        'circleColor': circleColor,
        'isEditable': isEditable
      };

  MapPointDAO.fromJson(Map<String, Object?> json)
      : uuid = toStringOrNull(json['uuid']) ?? const Uuid().v4(),
        name = toStringOrNull(json['name']),
        latitude = toDoubleOrNull(json['latitude']) ?? defaultCoordinate.latitude,
        longitude = toDoubleOrNull(json['longitude']) ?? defaultCoordinate.longitude,
        coordinateFormat = toStringOrNull(json['coordinateFormat']) ?? defaultCoordinateFormatPersistenceKey,
        isVisible = toBoolOrNull(json['isVisible']) ?? true,
        color = toStringOrNull(json['color']) ?? colorToHexString(COLOR_MAP_POINT),
        radius = toDoubleOrNull(json['radius']),
        circleColorSameAsColor = toBoolOrNull(json['circleColorSameAsColor']) ?? true,
        circleColor = toStringOrNull(json['circleColor']) ?? colorToHexString(COLOR_MAP_POINT),
        isEditable = toBoolOrNull(json['isEditable']) ?? false;

  @override
  String toString() {
    return toMap().toString();
  }
}

String gcwMapLineTypeFromEnumValue(GCWMapLineType type) {
  return enumName(type.toString()).toLowerCase();
}

class MapPolylineDAO {
  String uuid;
  List<String> pointUUIDs;
  String color;
  String type;

  MapPolylineDAO(this.uuid, this.pointUUIDs, this.color, this.type);

  Map<String, Object?> toMap() => {'uuid': uuid, 'pointUUIDs': pointUUIDs, 'color': color, 'type': type};

  MapPolylineDAO.fromJson(Map<String, Object?> json)
      : uuid = toStringOrNull(json['uuid']) ?? const Uuid().v4(),
        pointUUIDs = List<String>.from(toStringListOrNull(json['pointUUIDs']) ?? []),
        color = toStringOrNull(json['color']) ?? colorToHexString(COLOR_MAP_POLYLINE),
        type = toStringOrNull(json['type']) ?? gcwMapLineTypeFromEnumValue(GCWMapLineType.GEODETIC);

  @override
  String toString() {
    return toMap().toString();
  }
}
