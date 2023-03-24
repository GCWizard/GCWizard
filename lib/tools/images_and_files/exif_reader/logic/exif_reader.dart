import 'dart:typed_data';

import 'package:exif/exif.dart';
import 'package:gc_wizard/utils/data_type_utils/object_type_utils.dart';
import 'package:gc_wizard/utils/file_utils/gcw_file.dart';
import 'package:gc_wizard/common_widgets/image_viewers/gcw_imageview.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_parser.dart';
import 'package:gc_wizard/tools/coords/format_converter/logic/dec.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/tools/images_and_files/exif_reader/logic/external_libs/justkawal.xmp/xmp.dart';
import 'package:latlong2/latlong.dart';

const String _TIFF_THUMBNAIL = 'TIFFThumbnail';
const String _JPEG_THUMBNAIL = 'JPEGThumbnail';
const String _GPS_LAT = 'GPS GPSLatitude';
const String _GPS_LNG = 'GPS GPSLongitude';
const String _GPS_LAT_REF = 'GPS GPSLatitudeRef';
const String _GPS_LNG_REF = 'GPS GPSLongitudeRef';
const String _RDF_LOCATION = 'Rdf Location';

Future<Map<String, IfdTag>?> parseExif(GCWFile file) async {
  Map<String, IfdTag>? data;

  try {
    data = await readExifFromBytes(file.bytes,
        details: true,
        //debug: true, //XMP (experimental)
        //strict: false,
        truncateTags: false);
  } on Exception {
    // silent error
  }

  if (data == null || data.isEmpty) {
    // print("No EXIF information found\n");
    return null;
  }
  return Future.value(data);
}

GCWImageViewData? completeThumbnail(Map<String, IfdTag> data) {
  if (data.containsKey(_JPEG_THUMBNAIL)) {
    // print('File has JPEG thumbnail');
    var _jpgBytes = data[_JPEG_THUMBNAIL]!.values;
    data.remove(_JPEG_THUMBNAIL);
    var bytes = _jpgBytes.toList();
    if (bytes is! Uint8List) return null;
    return GCWImageViewData(GCWFile(bytes: bytes));
  } else if (data.containsKey(_TIFF_THUMBNAIL)) {
    // print('File has TIFF thumbnail');
    var _tiffBytes = data[_TIFF_THUMBNAIL]!.values;
    data.remove(_TIFF_THUMBNAIL);
    var bytes = _tiffBytes.toList();
    if (bytes is! Uint8List) return null;
    return GCWImageViewData(GCWFile(bytes: bytes));
  }
  return null;
}

///
///  GPS Latitude         : 37.885000 deg (37.000000 deg, 53.100000 min, 0.000000 sec N)
//   GPS Longitude        : -122.622500 deg (122.000000 deg, 37.350000 min, 0.000000 sec W)
///
LatLng? completeGPSData(Map<String, IfdTag> data) {
  try {
    if (data.containsKey(_GPS_LAT) &&
        data.containsKey(_GPS_LNG) &&
        data.containsKey(_GPS_LAT_REF) &&
        data.containsKey(_GPS_LNG_REF)) {

      IfdTag? latRef = data[_GPS_LAT_REF];
      IfdTag? lat = data[_GPS_LAT];
      double? _lat;
      if (lat != null && latRef != null) {
        _lat = _getCoordDecFromIfdTag(lat, latRef.printable, true);
      }
      if (_lat == null || _lat.isNaN) return null;

      IfdTag? lngRef = data[_GPS_LNG_REF];
      IfdTag? lng = data[_GPS_LNG];
      double? _lng;
      if (lng != null && lngRef != null) {
        _lng = _getCoordDecFromIfdTag(lng, lngRef.printable, false);
      }
      if (_lng == null || _lng.isNaN) return null;

      if (_lat == 0 && _lng == 0) return null;

      // DEC should be the pivot format from EXIF
      return decToLatLon(DEC(_lat, _lng));
    }
  } catch (error) {
  }

  return null;
}

///
///  Use location from XMP section
///
LatLng? completeGPSDataFromXmp(Map<String, dynamic> xmpTags) {
  LatLng? point;
  try {
    if (xmpTags.containsKey(_RDF_LOCATION)) {
      String latlng = toStringOrNull(xmpTags[_RDF_LOCATION]) ?? '';
      var pt = parseStandardFormats(latlng, wholeString: true);
      if (pt != null) {
        var value = pt.toLatLng();
        if (value is LatLng) {
          point = value;
        }
      }
    }
  } catch (error) {
  }

  return point;
}

double _getCoordDecFromIfdTag(IfdTag tag, String latlngRef, bool isLatitude) {
  return getCoordDecFromText(tag.values.toList(), latlngRef, isLatitude);
}

double getCoordDecFromText(List<dynamic> values, String latlngRef, bool isLatitude) {
  double _degrees = _getRatioValue(values[0] is Ratio ? values[0] as Ratio : Ratio(0, 0));
  double _minutes = _getRatioValue(values[1] is Ratio ? values[1] as Ratio : Ratio(0, 0));
  double _seconds = _getRatioValue(values[2] is Ratio ? values[2] as Ratio : Ratio(0, 0));
  int _sign = getCoordinateSignFromString(latlngRef, isLatitude);
  return _sign * (_degrees + _minutes / 60 + _seconds / 3600);
}

double _getRatioValue(Ratio _ratio) {
  return _ratio.numerator / _ratio.denominator;
}

Map<String, dynamic>? buildXmpTags(GCWFile platformFile, Map<String, List<List<dynamic>>> tableTags) {
  Map<String, dynamic>? xmpTags;
  try {
    Uint8List data = platformFile.bytes;
    xmpTags = XMP.extract(data);
    xmpTags.forEach((key, tag) {
      List<String> groupedKey = _parseKey(key);
      String section = groupedKey[0];
      String code = groupedKey[1];
      // groupBy section
      var value = tag;
      (tableTags[section] ??= []).add([code, value]);
    });
  } catch (e) {
    // Fail silently, if XMP process crash
  }
  return xmpTags;
}

Map<String, List<List<Object>>> buildTablesExif(Map<String, IfdTag> ifdTags) {
  var map = <String, List<List<Object>>>{};

  ifdTags.forEach((key, ifdTag) {
    List<String> groupedKey = _parseKey(key);
    String section = groupedKey[0];
    String code = groupedKey[1];
    // groupBy section
    (map[section] ??= []).add([code, _formatExifValue(ifdTag)]);
  });
  return map;
}

List<String> _parseKey(String key) {
  String group;
  String code;
  List<String> words = key.split(" ");
  if (words.length >= 2) {
    group = words[0];
    code = words.sublist(1).join(" ");
  } else {
    group = "general";
    code = key;
  }
  return [group, code];
}

String _formatExifValue(IfdTag tag) {
  switch (tag.tagType) {
    case 'ASCII':
      return tag.printable;
    case 'Short':
      return tag.printable;
    case 'Long':
      return tag.printable;
    case 'Byte':
      try {
        var byteList = tag.values.toList();
        return (byteList is List<int>) ? String.fromCharCodes(byteList) : tag.printable;
      } catch (e) {
        return tag.printable;
      }
    case 'Ratio':
      return tag.values.toString();
    case 'Signed Ratio':
      return tag.values.toString();
    case 'Undefined':
      //TODO: makerNote can be display as ascii text
      //return _ascii2string(tag.values);
      return tag.printable;
    default:
      return tag.printable;
  }
}
