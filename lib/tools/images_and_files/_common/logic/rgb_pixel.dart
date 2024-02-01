import 'dart:typed_data';

class RGBPixel {
  double red;
  double green;
  double blue;

  RGBPixel(this.red, this.green, this.blue);

  @override
  String toString() {
    return 'RGB($red, $green, $blue)';
  }

  static RGBPixel getPixel(Uint8List data, int offset) {
    return RGBPixel(data[offset + 0].toDouble(), data[offset + 1].toDouble(), data[offset + 2].toDouble());
  }

  void setPixel(Uint8List data, int offset) {
    data[offset + 0] = red.round().clamp(0, 255);
    data[offset + 1] = green.round().clamp(0, 255);
    data[offset + 2] = blue.round().clamp(0, 255);
  }
}
