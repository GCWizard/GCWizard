// source decode: https://piellardj.github.io/stereogram-solver/
// source encode: https://github.com/machinewrapped/StereogrammerOS

import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';
import 'package:gc_wizard/utils/common_utils.dart';
import 'package:gc_wizard/widgets/utils/file_utils.dart';
import 'package:image/image.dart' as Image;
import 'image_processing.dart';
import 'package:tuple/tuple.dart';

enum TextureType { GREYDOTS, COLORDOTS, BITMAP }

enum MagicEyeErrorCode { OK, IMAGE_TOO_SMALL }

const int MIN_DISPLACEMENT_ALLOWED = 10;
const MAX_TESTED_LINES_COUNT = 50;
const int _channelCount = 4;
double _fieldDepth;
int _separation;
int _lineWidth;
int _rows;
int _depthWidth;
int _depthScale;
int _midpoint;
int _textureWidth;
int _textureHeight;
Uint32List _pixels;
Uint8List _texturePixels;
Uint8List _depthBytes;

Future<Tuple3<Image.Image, Uint8List, int>> decodeImageAsync(dynamic jobData) async {
  if (jobData == null) return null;

  Uint8List image = jobData.parameters.item1;
  Image.Image imageData = jobData.parameters.item2;
  int displacement = jobData.parameters.item3;

  if (image == null) return null;
  if (imageData == null) imageData = Image.decodeImage(image);
  if (displacement == null) displacement = magicEyeSolver(imageData);

  var outputImage = createResultImage(imageData, displacement);
  var result = Tuple3<Image.Image, Uint8List, int>(imageData, outputImage, displacement);

  if (jobData.sendAsyncPort != null) jobData.sendAsyncPort.send(result);

  return Future.value(result);
}

/// calculate the displacement
int magicEyeSolver(Image.Image image) {
  if (image == null) return null;

  var testedLines = _computeTestedLines(image);
  int maxDisplacementAllowed = image.width ~/ 3;

  var differences = <double>[]; // displacement=0 is considered as unavailable so set a high value for it

  for (int displacement = MIN_DISPLACEMENT_ALLOWED; displacement <= maxDisplacementAllowed; displacement++) {
    var totalDifference = 0.0;
    testedLines.forEach((y) {
      for (int x = displacement; x < image.width; x++) {
        var _pixel1 = image.getPixel(x, y);
        var _pixel2 = image.getPixel(x - displacement, y);

        var red = Image.getRed(_pixel1) - Image.getRed(_pixel2);
        var green = Image.getGreen(_pixel1) - Image.getGreen(_pixel2);
        var blue = Image.getBlue(_pixel1) - Image.getBlue(_pixel2);

        var difference = (red.abs() + green.abs() + blue.abs()) / 3.0;
        totalDifference += difference;
      }
    });

    var nbPixels = (testedLines.length * (image.width - displacement));
    var averageDifference = totalDifference / nbPixels;
    differences.add(averageDifference);
  }
  return _computeBestDisplacement(differences) + MIN_DISPLACEMENT_ALLOWED;
}

List<int> _computeTestedLines(Image.Image image) {
  if (image == null) return null;

  var lines = <int>[];
  var delta = (image.height < MAX_TESTED_LINES_COUNT) ? 1 : (image.height / MAX_TESTED_LINES_COUNT);

  for (double i = 0; i < image.height; i += delta) lines.add(i.floor());

  return lines;
}

/// when reaching the correct delta, on most stereograms the total difference is at its lowest,
/// and goes right up just after, so try to detect this point
int _computeBestDisplacement(List<double> differences) {
  var highestGradientIndex = 1;
  var highestGradient = -1.0;

  for (var i = 2; i < differences.length - 1; i++) {
    var gradient = differences[i + 1] - differences[i];
    if (gradient > highestGradient) {
      highestGradientIndex = i;
      highestGradient = gradient;
    }
  }
  // The gradient helps determine the end of the lowest plateau.
  // Once found, check what was just before because maybe it was better
  for (var i = 0; i < 3; i++) {
    if (highestGradientIndex > 0 && differences[highestGradientIndex - 1] < differences[highestGradientIndex])
      highestGradientIndex--;
  }
  return highestGradientIndex;
}

Uint8List createResultImage(Image.Image image, int displacement) {
  if (image == null || displacement == null) return null;

  var bitmap = Image.Image(image.width, image.height);

  for (int y = 0; y < bitmap.height; y++)
    for (int x = 0; x < displacement; x++) bitmap.setPixel(x, y, image.getPixel(x, y));

  for (int y = 0; y < bitmap.height; y++) {
    for (int x = displacement; x < bitmap.width; x++) {
      var _pixel1 = image.getPixel(x, y);
      var _pixel2 = image.getPixel(x - displacement, y);

      var color = Image.Color.fromRgb(
          (Image.getRed(_pixel1) - Image.getRed(_pixel2)).abs(),
          (Image.getGreen(_pixel1) - Image.getGreen(_pixel2)).abs(),
          (Image.getBlue(_pixel1) - Image.getBlue(_pixel2)).abs());
      bitmap.setPixel(x, y, color);
    }
  }
  return encodeTrimmedPng(bitmap);
}

Future<Tuple2<Uint8List, MagicEyeErrorCode>> generateImageAsync(dynamic jobData) async {
  if (jobData == null) return null;

  Uint8List hiddenImage = jobData.parameters.item1;
  Uint8List textureImage = jobData.parameters.item2;
  TextureType textureType = jobData.parameters.item3;

  var outputData = generateImage(hiddenImage, textureImage, textureType);

  if (jobData.sendAsyncPort != null) jobData.sendAsyncPort.send(outputData);

  return Future.value(outputData);
}

Tuple2<Uint8List, MagicEyeErrorCode> generateImage(
    Uint8List hiddenDataImage, Uint8List textureImage, TextureType textureType,
    {SendPort sendAsyncPort}) {
  var bInterpolateDepthmap = true;
  var oversample = 2;
  Image.Image texture;

  _fieldDepth = 0.33333;
  _separation = 128;

  if ((hiddenDataImage == null) | ((textureType == TextureType.BITMAP) && (textureImage == null))) return null;

  var depthmap = Image.decodeImage(hiddenDataImage);
  var resolutionX = depthmap.width;
  var resolutionY = depthmap.height;

  if (resolutionX < 3 * _separation)
    return Tuple2<Uint8List, MagicEyeErrorCode>(null, MagicEyeErrorCode.IMAGE_TOO_SMALL);

  if ((textureType == TextureType.BITMAP) || ((textureType == null) && (textureImage != null)))
    texture = Image.decodeImage(textureImage);
  else if (textureType == TextureType.GREYDOTS)
    texture = _generateGrayDotsTexture(_separation, resolutionY);
  else
    texture = _generateColoredDotsTexture(_separation, resolutionY);

  if (hiddenDataImage == null || texture == null) return null;

  _textureWidth = _separation;
  _textureHeight = (_separation * texture.height) ~/ texture.width;

  // Cache some intermediaries
  _lineWidth = resolutionX;
  _rows = resolutionY;
  _depthWidth = _lineWidth;
  _depthScale = oversample;

  _fieldDepth = _fieldDepth.clamp(0, 1);

  // Apply oversampling factor to relevant settings
  if (oversample > 1) {
    _separation *= oversample;
    _lineWidth *= oversample;
    _textureWidth *= oversample;

    if (bInterpolateDepthmap) {
      _depthWidth *= oversample;
      _depthScale = 1;
    }
  }
  _midpoint = _lineWidth ~/ 2;

  // Convert texture to RGB24 and scale it to fit the separation (preserving ratio but doubling width for HQ mode)
  var bmTexture = Image.copyResize(texture, width: _textureWidth, height: _textureHeight);

  // Resize the depthmap to our target resolution
  var bmDepthMap = Image.copyResize(depthmap, width: _depthWidth, height: resolutionY);

  // Create a great big 2D array to hold the bytes - wasteful but convenient
  _pixels = Uint32List(_lineWidth * _rows);

  // Copy the texture data into a buffer
  _texturePixels = bmTexture.getBytes(format: Image.Format.rgba);

  // grayscale and invert
  bmDepthMap = Image.grayscale(bmDepthMap);
  bmDepthMap = Image.invert(bmDepthMap);
  // Copy the depthmap data into a buffer
  _depthBytes = bmDepthMap.getBytes(format: Image.Format.rgba);

  // progress indicator
  var generatedLines = 0;
  var _progressStep = max(_rows ~/ 100, 1); // 100 steps

  if (sendAsyncPort != null) sendAsyncPort.send({'progress': 0.0});

  initHoroptic();

  for (int y = 0; y < _rows; y++) {
    _doLineHoroptic(y);

    if (sendAsyncPort != null && (generatedLines % _progressStep == 0)) sendAsyncPort.send({'progress': y / _rows});
  }

  var bmStereogram = Image.Image.fromBytes(_lineWidth, _rows, _pixels.buffer.asUint8List(),
      format: Image.Format.rgba, channels: Image.Channels.rgba);

  // High quality images need to be scaled back down...
  if (oversample > 1) {
    bmStereogram = Image.copyResize(bmStereogram, width: resolutionX, height: resolutionY);
  }

  return Tuple2<Uint8List, MagicEyeErrorCode>(encodeTrimmedPng(bmStereogram), MagicEyeErrorCode.OK);
}

List<int> centreOut;

void initHoroptic() {
  // Create an array of offsets which alternate pixels from the center out to the edges
  centreOut = List<int>.filled(_lineWidth, 0);
  int offset = _midpoint;
  int flip = -1;
  for (int i = 0; i < _lineWidth; i++) {
    centreOut[i] = offset;
    offset += ((i + 1) * flip);
    flip = -flip;
  }
}

void _doLineHoroptic(int y) {
  // Set up a constraints buffer with each pixel initially constrained to equal itself (probably slower than a for loop but easier to step over :p)
  // And convert depths to floats normalised 0..1

  var constraints = List<int>.filled(_lineWidth, 0);
  var depthLine = List<double>.filled(_lineWidth, 0);
  var max_depth = 0.0;

  for (int i = 0; i < _lineWidth; i++) {
    constraints[i] = i;
    depthLine[i] = _getDepthFloat(i, y);
  }

  // Process the line updating any constrained pixels
  for (int ii = 0; ii < _lineWidth; ii++) {
    // Work from centre out
    int i = centreOut[ii];

    // Calculate Z value of the horopter at this x,y. w.r.t its centre.  20 * separation is approximation of distance to viewer's eyes
    double zh = sqrt(pow(20 * _separation, 2) - pow(i - _midpoint, 2));

    // Scale to the range [0,1] and adjust to displacement from the far plane
    zh = 1.0 - (zh / (20 * _separation));

    // Separation of pixels on image plane for this point
    // Note - divide ZH by FieldDepth as the horopter is independant
    // of field depth, but sep macro is not.
    int s = round(_sep(depthLine[i] - (zh / _fieldDepth))).toInt();

    int left = (i - (s / 2)).toInt(); // The pixel on the image plane for the left eye
    int right = left + s; // And for the right eye

    if ((0 <= left) && (right < _lineWidth)) {
      // If both points lie within the image bounds ...
      // Decide whether we want to constrain the left or right pixel
      // Want to avoid constraint loops, so always constrain outermost pixel to innermost
      // Should depend if one or the other is already constrained I suppose
      int constrainee = _outermost(left, right, _midpoint);
      int constrainer = (constrainee == left) ? right : left;

      // Find an unconstrained pixel and constrain ourselves to it
      // Uh-oh, what happens if they become constrained to each other?  Constrainee is flagged as unconstrained, I suppose
      while (constraints[constrainer] != constrainer) constrainer = constraints[constrainer];

      constraints[constrainee] = constrainer;

      // Points can only be hidden by a point closer to the centre, i.e. one we've already processed
      if (depthLine[i] > max_depth) max_depth = depthLine[i];
    }
  }

  // Now actually set the pixels
  for (int i = 0; i < _lineWidth; i++) {
    int pix = i;

    // Find an unconstrained pixel
    while (constraints[pix] != pix) pix = constraints[pix];

    // And get the RGBs from the tiled texture at that point
    _setStereoPixel(i, y, _getTexturePixel(pix, y));
  }
}

int _rgbPixelColor(RGBPixel pixel) {
  var _color = ByteData(4);
  _color.setUint8(3, pixel.red.round().clamp(0, 255));
  _color.setUint8(2, pixel.green.round().clamp(0, 255));
  _color.setUint8(1, pixel.blue.round().clamp(0, 255));
  _color.setUint8(0, 255);
  return _color.getUint32(0);
}

double _getDepthFloat(int x, int y) {
  int tp = ((y * _depthWidth) + (x / _depthScale)).toInt() * _channelCount;
  return ((_depthBytes[tp] / 255.0 + _depthBytes[tp + 1] / 255.0 + _depthBytes[tp + 2]) / 255.0); // (RGBA)
}

/// Helper to calculate stereo separation in pixels of a point at depth Z
double _sep(double z) {
  z = z.clamp(0.0, 1.0);
  return ((1 - _fieldDepth * z) * (2 * _separation) / (2 - _fieldDepth * z));
}

/// Return which of two values is furthest from a mid-point (or indeed any point)
int _outermost(int a, int b, int midpoint) {
  return ((midpoint - a).abs() > (midpoint - b).abs()) ? a : b;
}

RGBPixel _getTexturePixel(int x, int y) {
  int tp = ((y % _textureHeight) * _textureWidth) + ((x + _midpoint) % _textureWidth);
  return RGBPixel.getPixel(_texturePixels, tp * _channelCount); // (RGBA)
}

_setStereoPixel(int x, int y, RGBPixel pixel) {
  int sp = ((y * _lineWidth) + x);
  _pixels[sp] = _rgbPixelColor(pixel);
}

Image.Image _generateColoredDotsTexture(int resX, int resY) {
  Random random = Random();
  var pixels = Uint8List(resX * resY * _channelCount); // (RGBA)

  for (int i = 0; i < pixels.length; i++) pixels[i] = random.nextInt(256);

  return Image.Image.fromBytes(resX, resY, pixels, format: Image.Format.rgba, channels: Image.Channels.rgba);
}

Image.Image _generateGrayDotsTexture(int resX, int resY) {
  var image = _generateColoredDotsTexture(resX, resY);
  return Image.grayscale(image);
}
