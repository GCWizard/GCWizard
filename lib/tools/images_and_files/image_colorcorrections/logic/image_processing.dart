import 'dart:math';

import 'package:gc_wizard/tools/images_and_files/_common/logic/rgb_pixel.dart';
import 'package:gc_wizard/tools/science_and_technology/colors/logic/colors_hue.dart';
import 'package:gc_wizard/tools/science_and_technology/colors/logic/colors_rgb.dart';

// https://www.dfstudios.co.uk/articles/programming/image-programming-algorithms/
RGBPixel contrast(RGBPixel pxl, double contrast) {
  final double factor = 259.0 * (contrast + 255.0) / 255.0 / (259.0 - contrast);
  pxl.red = (factor * (pxl.red - 128.0) + 128.0).clamp(0.0, 255.0);
  pxl.green = (factor * (pxl.green - 128.0) + 128.0).clamp(0.0, 255.0);
  pxl.blue = (factor * (pxl.blue - 128.0) + 128.0).clamp(0.0, 255.0);

  return pxl;
}

// https://www.dfstudios.co.uk/articles/programming/image-programming-algorithms/
RGBPixel brightness(RGBPixel pxl, double brightness) {
  pxl.red = (pxl.red + brightness).clamp(0.0, 255.0);
  pxl.green = (pxl.green + brightness).clamp(0.0, 255.0);
  pxl.blue = (pxl.blue + brightness).clamp(0.0, 255.0);

  return pxl;
}

// https://www.dfstudios.co.uk/articles/programming/image-programming-algorithms/
RGBPixel grayscale(RGBPixel pxl) {
  var value = 0.299 * pxl.red + 0.587 * pxl.green + 0.114 * pxl.blue;

  pxl.red = value;
  pxl.green = value;
  pxl.blue = value;

  return pxl;
}

// https://www.dfstudios.co.uk/articles/programming/image-programming-algorithms/
RGBPixel invert(RGBPixel pxl) {
  pxl.red = 255.0 - pxl.red;
  pxl.green = 255.0 - pxl.green;
  pxl.blue = 255.0 - pxl.blue;

  return pxl;
}

// https://www.dfstudios.co.uk/articles/programming/image-programming-algorithms/
RGBPixel gamma(RGBPixel pxl, double gamma) {
  var gammaCorrection = 1.0 / gamma;
  pxl.red = (255.0 * pow(pxl.red / 255.0, gammaCorrection)).clamp(0.0, 255.0);
  pxl.green = (255.0 * pow(pxl.green / 255.0, gammaCorrection)).clamp(0.0, 255.0);
  pxl.blue = (255.0 * pow(pxl.blue / 255.0, gammaCorrection)).clamp(0.0, 255.0);

  return pxl;
}

// https://www.pocketmagic.net/enhance-saturation-in-images-programatically/
RGBPixel saturation(RGBPixel pxl, double saturation, double hue) {
  HSL hsl = HSL.fromRGB(RGB(pxl.red, pxl.green, pxl.blue));

  var newSaturation = hsl.saturation;
  if (saturation != 0.0) {
    if (saturation > 0.0) {
      if (saturation <= 0.5) {
        saturation *= 2.0;
      } else if (saturation <= 0.75) {
        saturation = (saturation - 0.5) * 200 + 1;
      } else {
        saturation = (saturation - 0.75) * 2000 + 100;
      }
    }

    if (saturation >= 0.0) {
      var gray_factor = hsl.saturation;
      var var_interval = 1.0 - hsl.saturation;
      newSaturation = hsl.saturation + saturation * var_interval * gray_factor;
    } else {
      var var_interval = hsl.saturation;
      newSaturation = hsl.saturation + saturation * var_interval;
    }
  }

  var newHue = hsl.hue;
  if (hue != 0.0) {
    newHue = (hsl.hue + hue + 360.0) % 360.0;
  }

  RGB newPxl = HSL(newHue, newSaturation, hsl.lightness).toRGB();
  return RGBPixel(newPxl.red, newPxl.green, newPxl.blue);
}

RGBPixel colorOffset(RGBPixel pxl, double red, double green, double blue) {
  if (red != 0.0) pxl.red = (pxl.red + red).clamp(0.0, 255.0);

  if (green != 0.0) pxl.green = (pxl.green + green).clamp(0.0, 255.0);

  if (blue != 0.0) pxl.blue = (pxl.blue + blue).clamp(0.0, 255.0);

  return pxl;
}

RGBPixel exposure(RGBPixel pxl, double exposure) {
  pxl.red = (pxl.red * exposure).clamp(0.0, 255.0);
  pxl.green = (pxl.green * exposure).clamp(0.0, 255.0);
  pxl.blue = (pxl.blue * exposure).clamp(0.0, 255.0);

  return pxl;
}
