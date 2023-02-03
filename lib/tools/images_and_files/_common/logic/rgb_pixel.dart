import 'dart:typed_data';

class RGBPixel {
  double red;
  double green;
  double blue;

  RGBPixel(this.red, this.green, this.blue);

  @override
  String toString() {
    return 'RGB(${this.red}, ${this.green}, ${this.blue})';
  }

  static RGBPixel getPixel(Uint8List data, int offset) {
    return RGBPixel(data[offset + 0].toDouble(), data[offset + 1].toDouble(), data[offset + 2].toDouble());
  }

  RGBPixel setPixel(Uint8List data, int offset) {
    data[offset + 0] = this.red.round().clamp(0, 255);
    data[offset + 1] = this.green.round().clamp(0, 255);
    data[offset + 2] = this.blue.round().clamp(0, 255);
  }
}