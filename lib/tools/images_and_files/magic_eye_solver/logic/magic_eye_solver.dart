// source decode: https://piellardj.github.io/stereogram-solver/
// source encode: https://github.com/machinewrapped/StereogrammerOS

import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer_parameters.dart';
import 'package:gc_wizard/utils/complex_return_types.dart';
import 'package:gc_wizard/utils/file_utils/file_utils.dart';
import 'package:gc_wizard/tools/images_and_files/_common/logic/rgb_pixel.dart';
import 'package:gc_wizard/utils/math_utils.dart';
import 'package:image/image.dart' as Image;
import 'package:tuple/tuple.dart';

enum TextureType { GREYDOTS, COLORDOTS, BITMAP }

enum MagicEyeErrorCode { OK, IMAGE_TOO_SMALL }

const int _MIN_DISPLACEMENT_ALLOWED = 10;
const _MAX_TESTED_LINES_COUNT = 50;
const int _channelCount = 4;
late double _fieldDepth;
late int _separation;
late int _lineWidth;
late int _rows;
late int _depthWidth;
late int _depthScale;
late int _midpoint;
late int _textureWidth;
late int _textureHeight;
late Uint32List _pixels;
late Uint8List _texturePixels;
late Uint8List _depthBytes;

Future<Tuple3<Image.Image, Uint8List, int>?> decodeImageAsync(GCWAsyncExecuterParameters? jobData) async {
  if (jobData?.parameters is! Tuple3<Uint8List, Image.Image?, int?>) return null;

  var data = jobData!.parameters as Tuple3<Uint8List, Image.Image?, int?>;
  Uint8List image = data.item1;
  Image.Image? imageData = data.item2;
  int? displacement = data.item3;
  
  return decodeImage(image, imageData, displacement, sendAsyncPort: jobData.sendAsyncPort);
}

Future<Tuple3<Image.Image, Uint8List, int>?> decodeImage(
    Uint8List image,
    Image.Image? imageData,
    int? displacement,
   {SendPort? sendAsyncPort}) async {

  imageData ??= Image.decodeImage(image);
  if (imageData == null) return null;
  displacement ??= _magicEyeSolver(imageData);

  var outputImage = _createResultImage(imageData, displacement);
  var result = Tuple3<Image.Image, Uint8List, int>(imageData, outputImage, displacement);

  sendAsyncPort?.send(result);

  return Future.value(result);
}

/// calculate the displacement
int _magicEyeSolver(Image.Image image) {
  var testedLines = _computeTestedLines(image);
  int maxDisplacementAllowed = image.width ~/ 3;

  var differences = <double>[]; // displacement=0 is considered as unavailable so set a high value for it

  for (int displacement = _MIN_DISPLACEMENT_ALLOWED; displacement <= maxDisplacementAllowed; displacement++) {
    var totalDifference = 0.0;
    for (var y in testedLines) {
      for (int x = displacement; x < image.width; x++) {
        var _pixel1 = image.getPixel(x, y);
        var _pixel2 = image.getPixel(x - displacement, y);

        var red = _pixel1.r - _pixel2.r;
        var green = _pixel1.g - _pixel2.g;
        var blue = _pixel1.b - _pixel2.b;

        var difference = (red.abs() + green.abs() + blue.abs()) / 3.0;
        totalDifference += difference;
      }
    }

    var nbPixels = (testedLines.length * (image.width - displacement));
    var averageDifference = totalDifference / nbPixels;
    differences.add(averageDifference);
  }
  return _computeBestDisplacement(differences) + _MIN_DISPLACEMENT_ALLOWED;
}

List<int> _computeTestedLines(Image.Image image) {
  var lines = <int>[];
  var delta = (image.height < _MAX_TESTED_LINES_COUNT) ? 1 : (image.height / _MAX_TESTED_LINES_COUNT);

  for (double i = 0; i < image.height; i += delta) {
    lines.add(i.floor());
  }

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
    if (highestGradientIndex > 0 && differences[highestGradientIndex - 1] < differences[highestGradientIndex]) {
      highestGradientIndex--;
    }
  }
  return highestGradientIndex;
}

Uint8List _createResultImage(Image.Image image, int displacement) {
  var bitmap = Image.Image(width: image.width, height: image.height);

  for (int y = 0; y < bitmap.height; y++) {
    for (int x = 0; x < displacement; x++) {
      bitmap.setPixel(x, y, image.getPixel(x, y));
    }
  }

  for (int y = 0; y < bitmap.height; y++) {
    for (int x = displacement; x < bitmap.width; x++) {
      var _pixel1 = image.getPixel(x, y);
      var _pixel2 = image.getPixel(x - displacement, y);

      bitmap.setPixelRgb(x, y,
          (_pixel1.r - _pixel2.r).abs(), (_pixel1.g - _pixel2.g).abs(), (_pixel1.b - _pixel2.b).abs());
    }
  }
  return encodeTrimmedPng(bitmap);
}

Future<Tuple2<Uint8List?, MagicEyeErrorCode>?> generateImageAsync(GCWAsyncExecuterParameters? jobData) async {
  if (jobData?.parameters is! Tuple3<Uint8List?, Uint8List?, TextureType?>) return null;

  var data = jobData!.parameters as Tuple3<Uint8List?, Uint8List?, TextureType?>;
  Uint8List? hiddenImage = data.item1;
  Uint8List? textureImage = data.item2;
  TextureType? textureType = data.item3;

  if (hiddenImage == null) return null;
  var outputData = _generateImage(hiddenImage, textureImage, textureType);

  jobData.sendAsyncPort?.send(outputData);

  return Future.value(outputData);
}

Tuple2<Uint8List?, MagicEyeErrorCode>? _generateImage(
    Uint8List hiddenDataImage, Uint8List? textureImage, TextureType? textureType,
    {SendPort? sendAsyncPort}) {
  var bInterpolateDepthmap = true;
  var oversample = 2;
  Image.Image? texture;

  _fieldDepth = 0.33333;
  _separation = 128;

  if (((textureType == TextureType.BITMAP) && (textureImage == null))) return null;

  var depthmap = Image.decodeImage(hiddenDataImage);
  if (depthmap == null) return null;
  var resolutionX = depthmap.width;
  var resolutionY = depthmap.height;

  if (resolutionX < 3 * _separation) {
    return const Tuple2<Uint8List?, MagicEyeErrorCode>(null, MagicEyeErrorCode.IMAGE_TOO_SMALL);
  }

  if (((textureType == TextureType.BITMAP) || (textureType == null)) && (textureImage != null)) {
    texture = Image.decodeImage(textureImage);
  } else if (textureType == TextureType.GREYDOTS) {
    texture = _generateGrayDotsTexture(_separation, resolutionY);
  } else {
    texture = _generateColoredDotsTexture(_separation, resolutionY);
  }

  if (texture == null) return null;

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
  _texturePixels = bmTexture.getBytes(order: Image.ChannelOrder.rgba);

  // grayscale and invert
  bmDepthMap = Image.grayscale(bmDepthMap);
  bmDepthMap = Image.invert(bmDepthMap);
  // Copy the depthmap data into a buffer
  _depthBytes = bmDepthMap.getBytes(order: Image.ChannelOrder.rgba);

  // progress indicator
  var generatedLines = 0;
  var _progressStep = max(_rows ~/ 100, 1); // 100 steps

  sendAsyncPort?.send(DoubleText('progress', 0.0));

  _initHoroptic();

  for (int y = 0; y < _rows; y++) {
    _doLineHoroptic(y);

    if (sendAsyncPort != null && (generatedLines % _progressStep == 0)) {
      sendAsyncPort.send(DoubleText('progress', y / _rows));
    }
  }

  var bmStereogram = Image.Image.fromBytes(width: _lineWidth, height: _rows, bytes: _pixels.buffer,
      order: Image.ChannelOrder.rgba);

  // High quality images need to be scaled back down...
  if (oversample > 1) {
    bmStereogram = Image.copyResize(bmStereogram, width: resolutionX, height: resolutionY);
  }

  return Tuple2<Uint8List, MagicEyeErrorCode>(encodeTrimmedPng(bmStereogram), MagicEyeErrorCode.OK);
}

late List<int> centreOut;

void _initHoroptic() {
  // Create an array of offsets which alternate pixels from the center out to the edges
  centreOut = List<int>.filled(_lineWidth, 0);
  int offset = _midpoint;
  int flip = -1;
  for (int i = 0; i < centreOut.length; i++) {
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
      while (constraints[constrainer] != constrainer) {
        constrainer = constraints[constrainer];
      }

      constraints[constrainee] = constrainer;

      // Points can only be hidden by a point closer to the centre, i.e. one we've already processed
      if (depthLine[i] > max_depth) max_depth = depthLine[i];
    }
  }

  // Now actually set the pixels
  for (int i = 0; i < _lineWidth; i++) {
    int pix = i;

    // Find an unconstrained pixel
    while (constraints[pix] != pix) {
      pix = constraints[pix];
    }

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

void _setStereoPixel(int x, int y, RGBPixel pixel) {
  int sp = ((y * _lineWidth) + x);
  _pixels[sp] = _rgbPixelColor(pixel);
}

Image.Image _generateColoredDotsTexture(int resX, int resY) {
  Random random = Random();
  var pixels = Uint8List(resX * resY * _channelCount); // (RGBA)

  for (int i = 0; i < pixels.length; i++) {
    pixels[i] = random.nextInt(256);
  }

  return Image.Image.fromBytes(width: resX, height: resY, bytes: pixels.buffer, order: Image.ChannelOrder.rgba);
}

Image.Image _generateGrayDotsTexture(int resX, int resY) {
  var image = _generateColoredDotsTexture(resX, resY);
  return Image.grayscale(image);
}
