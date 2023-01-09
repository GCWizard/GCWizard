import 'dart:typed_data';

import 'package:exif/exif.dart';
import 'package:gc_wizard/logic/tools/coords/converter/dec.dart';
import 'package:gc_wizard/logic/tools/coords/data/coordinates.dart';
import 'package:gc_wizard/logic/tools/coords/parser/latlon.dart';
import 'package:gc_wizard/plugins/xmp/xmp.dart';
import 'package:gc_wizard/widgets/common/gcw_imageview.dart';
import 'package:gc_wizard/widgets/utils/gcw_file.dart' as local;
import 'package:latlong2/latlong.dart';

const String TIFF_THUMBNAIL = 'TIFFThumbnail';
const String JPEG_THUMBNAIL = 'JPEGThumbnail';
const String GPS_LAT = 'GPS GPSLatitude';
const String GPS_LNG = 'GPS GPSLongitude';
const String GPS_LAT_REF = 'GPS GPSLatitudeRef';
const String GPS_LNG_REF = 'GPS GPSLongitudeRef';
const String RDF_LOCATION = 'Rdf Location';

Future<Map<String, IfdTag>> parseExif(local.GCWFile file) async {
  Map<String, IfdTag> data;

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
  return data;
}

GCWImageViewData completeThumbnail(Map<String, IfdTag> data) {
  if (data.containsKey(JPEG_THUMBNAIL)) {
    // print('File has JPEG thumbnail');
    var _jpgBytes = data[JPEG_THUMBNAIL].values;
    data.remove(JPEG_THUMBNAIL);
    return GCWImageViewData(local.GCWFile(bytes: _jpgBytes.toList()));
  } else if (data.containsKey(TIFF_THUMBNAIL)) {
    // print('File has TIFF thumbnail');
    var _tiffBytes = data[TIFF_THUMBNAIL].values;
    data.remove(TIFF_THUMBNAIL);
    return GCWImageViewData(local.GCWFile(bytes: _tiffBytes.toList()));
  }
  return null;
}

///
///  GPS Latitude         : 37.885000 deg (37.000000 deg, 53.100000 min, 0.000000 sec N)
//   GPS Longitude        : -122.622500 deg (122.000000 deg, 37.350000 min, 0.000000 sec W)
///
LatLng completeGPSData(Map<String, IfdTag> data) {
  try {
    if (data.containsKey(GPS_LAT) &&
        data.containsKey(GPS_LNG) &&
        data.containsKey(GPS_LAT_REF) &&
        data.containsKey(GPS_LNG_REF)) {
      IfdTag latRef = data[GPS_LAT_REF];
      IfdTag lat = data[GPS_LAT];
      double _lat = _getCoordDecFromIfdTag(lat, latRef.printable, true);
      if (_lat.isNaN) return null;

      IfdTag lngRef = data[GPS_LNG_REF];
      IfdTag lng = data[GPS_LNG];
      double _lng = _getCoordDecFromIfdTag(lng, lngRef.printable, false);
      if (_lng.isNaN) return null;

      if (_lat == 0 && _lng == 0) return null;

      // DEC should be the pivot format from EXIF
      return decToLatLon(DEC(_lat, _lng));
    }
  } catch (error) {
    print("silent error: $error");
  }

  return null;
}

///
///  Use location from XMP section
///
LatLng completeGPSDataFromXmp(Map<String, dynamic> xmpTags) {
  LatLng point;
  try {
    if (xmpTags.containsKey(RDF_LOCATION)) {
      String latlng = xmpTags[RDF_LOCATION];
      var pt = parseStandardFormats(latlng, wholeString: true);
      if (pt != null) {
        point = pt['coordinate'];
      }
    }
  } catch (error) {
    print("silent error: $error");
  }

  return point;
}

double _getCoordDecFromIfdTag(IfdTag tag, String latlngRef, bool isLatitude) {
  return getCoordDecFromText(tag.values.toList(), latlngRef, isLatitude);
}

double getCoordDecFromText(List<dynamic> values, String latlngRef, bool isLatitude) {
  double _degrees = _getRatioValue(values[0]);
  double _minutes = _getRatioValue(values[1]);
  double _seconds = _getRatioValue(values[2]);
  int _sign = getCoordinateSignFromString(latlngRef, isLatitude);
  return _sign * (_degrees + _minutes / 60 + _seconds / 3600);
}

double _getRatioValue(Ratio _ratio) {
  return _ratio.numerator / _ratio.denominator;
}

Map<String, dynamic> buildXmpTags(local.GCWFile platformFile, Map<String, List<List<dynamic>>> tableTags) {
  Map<String, dynamic> xmpTags;
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

Map<String, List<List<dynamic>>> buildTablesExif(Map<String, IfdTag> ifdTags) {
  var map = <String, List<List>>{};

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
        List<int> byteList = tag.values.toList();
        return String.fromCharCodes(byteList);
      } catch (e) {
        return tag.printable;
      }
      break;
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
