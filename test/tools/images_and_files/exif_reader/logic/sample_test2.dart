import 'package:exif/exif.dart';
import "package:flutter_test/flutter_test.dart";

import 'test_util.dart';

main() async {
  // ❯ Exiv2 test2.jpg
  // File name       : test2.jpg
  // File size       : 11260 Bytes
  // MIME type       : image/jpeg
  // Image size      : 180 x 142
  // Camera make     : Apple
  // Camera model    : iPhone 4S
  // Image timestamp : 2012:12:23 14:47:49
  // Image number    :
  // Exposure time   : 1/120 s
  // Aperture        : F2.4
  // Exposure bias   :
  // Flash           : No, compulsory
  // Flash bias      :
  // Focal length    : 4.3 mm (35 mm equivalent: 35.0 mm)
  // Subject distance:
  // ISO speed       : 80
  // Exposure mode   : Auto
  // Metering mode   : Multi-segment
  // Macro mode      :
  // Image quality   :
  // Exif Resolution : 1319 x 1040
  // White balance   : Auto
  // Thumbnail       : None
  // Copyright       :
  // Exif comment    :

  test('test2', () async {
    var fileSamples = readSampleTest2();
    var file = fileSamples[0].file;
    var tags = await readExifFromFile(file);
    expect(tags.length, isNonZero);
    // Camera make     : Apple
    expect(tags['Image Make'].printable, equals('Apple'));
    // Camera model    : iPhone 4S
    expect(tags['Image Model'].printable, equals('iPhone 4S'));
    // Exposure time   : 1/120 s
    expect(tags['EXIF ExposureTime'].printable, equals('1/120'));
    // Aperture        : F2.4
    expect(tags['EXIF ApertureValue'].printable, equals('4312/1707')); //4312/1707 = F2.4
    // Image timestamp : 2012:12:23 14:47:49
    expect(tags['Image DateTime'].printable, equals('2012:12:23 14:47:49'));
    // Focal length    : 4.3 mm (35 mm equivalent: 35.0 mm)
    expect(tags['EXIF FocalLengthIn35mmFilm'].printable, equals('35'));
    // Exif Resolution : 1319 x 1040
    expect(tags['EXIF ExifImageWidth'].printable, equals('1319'));
    expect(tags['EXIF ExifImageLength'].printable, equals('1040'));
  });
}
