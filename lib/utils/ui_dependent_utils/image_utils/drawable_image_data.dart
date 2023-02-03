class DrawableImageData {
  final List<String> lines;
  final Map<String, int> colors;
  final int bounds;
  final double pointSize;

  DrawableImageData(this.lines, this.colors, {this.bounds = 10, this.pointSize = 5.0});
}