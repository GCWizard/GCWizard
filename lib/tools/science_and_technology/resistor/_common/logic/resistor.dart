import 'dart:math';

enum ResistorBandType { FIRST, SECOND, THIRD, MULTIPLIER, TOLERANCE, TEMPERATURE_COEFFICIENT }

// source: https://en.wikipedia.org/wiki/Electronic_color_code#cite_note-IEC_60062_2016ECC-7
enum ResistorBandColor { PINK, SILVER, GOLD, BLACK, BROWN, RED, ORANGE, YELLOW, GREEN, BLUE, VIOLET, GREY, WHITE }

final defaultResistorBandColor = ResistorBandColor.BROWN;

// source: https://de.wikipedia.org/wiki/Widerstand_(Bauelement)#Angaben_auf_Widerst%C3%A4nden
final Map<ResistorBandColor, Map<ResistorBandType, double>> _RESISTOR_VALUES_THREE_AND_FOUR_BANDS = {
  ResistorBandColor.PINK: {ResistorBandType.MULTIPLIER: 1e-3},
  ResistorBandColor.SILVER: {ResistorBandType.MULTIPLIER: 1e-2, ResistorBandType.TOLERANCE: 0.1},
  ResistorBandColor.GOLD: {ResistorBandType.MULTIPLIER: 1e-1, ResistorBandType.TOLERANCE: 0.05},
  ResistorBandColor.BLACK: {ResistorBandType.SECOND: 0, ResistorBandType.MULTIPLIER: 1},
  ResistorBandColor.BROWN: {
    ResistorBandType.FIRST: 10,
    ResistorBandType.SECOND: 1,
    ResistorBandType.MULTIPLIER: 10,
    ResistorBandType.TOLERANCE: 0.01
  },
  ResistorBandColor.RED: {
    ResistorBandType.FIRST: 20,
    ResistorBandType.SECOND: 2,
    ResistorBandType.MULTIPLIER: 1e2,
    ResistorBandType.TOLERANCE: 0.02
  },
  ResistorBandColor.ORANGE: {ResistorBandType.FIRST: 30, ResistorBandType.SECOND: 3, ResistorBandType.MULTIPLIER: 1e3},
  ResistorBandColor.YELLOW: {ResistorBandType.FIRST: 40, ResistorBandType.SECOND: 4, ResistorBandType.MULTIPLIER: 1e4},
  ResistorBandColor.GREEN: {
    ResistorBandType.FIRST: 50,
    ResistorBandType.SECOND: 5,
    ResistorBandType.MULTIPLIER: 1e5,
    ResistorBandType.TOLERANCE: 0.005
  },
  ResistorBandColor.BLUE: {
    ResistorBandType.FIRST: 60,
    ResistorBandType.SECOND: 6,
    ResistorBandType.MULTIPLIER: 1e6,
    ResistorBandType.TOLERANCE: 0.0025
  },
  ResistorBandColor.VIOLET: {
    ResistorBandType.FIRST: 70,
    ResistorBandType.SECOND: 7,
    ResistorBandType.MULTIPLIER: 1e7,
    ResistorBandType.TOLERANCE: 0.001
  },
  ResistorBandColor.GREY: {
    ResistorBandType.FIRST: 80,
    ResistorBandType.SECOND: 8,
    ResistorBandType.MULTIPLIER: 1e8,
    ResistorBandType.TOLERANCE: 0.0005
  },
  ResistorBandColor.WHITE: {ResistorBandType.FIRST: 90, ResistorBandType.SECOND: 9, ResistorBandType.MULTIPLIER: 1e9}
};

// source: Temperature coefficient: https://web.archive.org/web/20180723125246/https://www.sis.se/api/document/preview/8021442/
final Map<ResistorBandColor, Map<ResistorBandType, double>> _RESISTOR_VALUES_FIVE_AND_SIX_BANDS = {
  ResistorBandColor.PINK: {ResistorBandType.MULTIPLIER: 1e-3},
  ResistorBandColor.SILVER: {ResistorBandType.MULTIPLIER: 1e-2, ResistorBandType.TOLERANCE: 0.1},
  ResistorBandColor.GOLD: {ResistorBandType.MULTIPLIER: 1e-1, ResistorBandType.TOLERANCE: 0.05},
  ResistorBandColor.BLACK: {
    ResistorBandType.SECOND: 0,
    ResistorBandType.THIRD: 0,
    ResistorBandType.MULTIPLIER: 1,
    ResistorBandType.TEMPERATURE_COEFFICIENT: 250
  },
  ResistorBandColor.BROWN: {
    ResistorBandType.FIRST: 100,
    ResistorBandType.SECOND: 10,
    ResistorBandType.THIRD: 1,
    ResistorBandType.MULTIPLIER: 10,
    ResistorBandType.TOLERANCE: 0.01,
    ResistorBandType.TEMPERATURE_COEFFICIENT: 100
  },
  ResistorBandColor.RED: {
    ResistorBandType.FIRST: 200,
    ResistorBandType.SECOND: 20,
    ResistorBandType.THIRD: 2,
    ResistorBandType.MULTIPLIER: 1e2,
    ResistorBandType.TOLERANCE: 0.02,
    ResistorBandType.TEMPERATURE_COEFFICIENT: 50
  },
  ResistorBandColor.ORANGE: {
    ResistorBandType.FIRST: 300,
    ResistorBandType.SECOND: 30,
    ResistorBandType.THIRD: 3,
    ResistorBandType.MULTIPLIER: 1e3,
    ResistorBandType.TEMPERATURE_COEFFICIENT: 15
  },
  ResistorBandColor.YELLOW: {
    ResistorBandType.FIRST: 400,
    ResistorBandType.SECOND: 40,
    ResistorBandType.THIRD: 4,
    ResistorBandType.MULTIPLIER: 1e4,
    ResistorBandType.TEMPERATURE_COEFFICIENT: 25
  },
  ResistorBandColor.GREEN: {
    ResistorBandType.FIRST: 500,
    ResistorBandType.SECOND: 50,
    ResistorBandType.THIRD: 5,
    ResistorBandType.MULTIPLIER: 1e5,
    ResistorBandType.TOLERANCE: 0.005,
    ResistorBandType.TEMPERATURE_COEFFICIENT: 20
  },
  ResistorBandColor.BLUE: {
    ResistorBandType.FIRST: 600,
    ResistorBandType.SECOND: 60,
    ResistorBandType.THIRD: 6,
    ResistorBandType.MULTIPLIER: 1e6,
    ResistorBandType.TOLERANCE: 0.0025,
    ResistorBandType.TEMPERATURE_COEFFICIENT: 10
  },
  ResistorBandColor.VIOLET: {
    ResistorBandType.FIRST: 700,
    ResistorBandType.SECOND: 70,
    ResistorBandType.THIRD: 7,
    ResistorBandType.MULTIPLIER: 1e7,
    ResistorBandType.TOLERANCE: 0.001,
    ResistorBandType.TEMPERATURE_COEFFICIENT: 5
  },
  ResistorBandColor.GREY: {
    ResistorBandType.FIRST: 800,
    ResistorBandType.SECOND: 80,
    ResistorBandType.THIRD: 8,
    ResistorBandType.MULTIPLIER: 1e8,
    ResistorBandType.TOLERANCE: 0.0005,
    ResistorBandType.TEMPERATURE_COEFFICIENT: 1
  },
  ResistorBandColor.WHITE: {
    ResistorBandType.FIRST: 900,
    ResistorBandType.SECOND: 90,
    ResistorBandType.THIRD: 9,
    ResistorBandType.MULTIPLIER: 1e9
  }
};

ResistorBandType getResistorBandTypeByNumberAndPosition(int numberBands, int position) {
  if (numberBands < 5) {
    switch (position) {
      case 1:
        return ResistorBandType.FIRST;
      case 2:
        return ResistorBandType.SECOND;
      case 3:
        return ResistorBandType.MULTIPLIER;
      case 4:
        return ResistorBandType.TOLERANCE;
      default:
        return null;
    }
  } else {
    switch (position) {
      case 1:
        return ResistorBandType.FIRST;
      case 2:
        return ResistorBandType.SECOND;
      case 3:
        return ResistorBandType.THIRD;
      case 4:
        return ResistorBandType.MULTIPLIER;
      case 5:
        return ResistorBandType.TOLERANCE;
      case 6:
        return ResistorBandType.TEMPERATURE_COEFFICIENT;
      default:
        return null;
    }
  }
}

int getPositionByNumberAndType(int numberBands, ResistorBandType type) {
  if (numberBands < 5) {
    switch (type) {
      case ResistorBandType.FIRST:
        return 1;
      case ResistorBandType.SECOND:
        return 2;
      case ResistorBandType.MULTIPLIER:
        return 3;
      case ResistorBandType.TOLERANCE:
        return 4;
      default:
        return null;
    }
  } else {
    switch (type) {
      case ResistorBandType.FIRST:
        return 1;
      case ResistorBandType.SECOND:
        return 2;
      case ResistorBandType.THIRD:
        return 3;
      case ResistorBandType.MULTIPLIER:
        return 4;
      case ResistorBandType.TOLERANCE:
        return 5;
      case ResistorBandType.TEMPERATURE_COEFFICIENT:
        return 6;
      default:
        return null;
    }
  }
}

List<ResistorBandColor> getResistorColorsByBandType(ResistorBandType type) {
  return _RESISTOR_VALUES_FIVE_AND_SIX_BANDS.entries
      .where((color) => color.value[type] != null)
      .map((color) => color.key)
      .toList();
}

class ResistorValue {
  final double value;
  final double tolerance;
  final double temperatureCoefficient;

  const ResistorValue(this.value, this.tolerance, {this.temperatureCoefficient});

  List<double> get tolerancedValueInterval {
    return [value - value * tolerance, value + value * tolerance];
  }
}

double _getResistorValueByTypeAndColor(
  int numberBands,
  ResistorBandType bandType,
  ResistorBandColor color,
) {
  switch (numberBands) {
    case 3:
    case 4:
      var colorValues = _RESISTOR_VALUES_THREE_AND_FOUR_BANDS[color];
      return colorValues == null ? null : colorValues[bandType];
    case 5:
    case 6:
      var colorValues = _RESISTOR_VALUES_FIVE_AND_SIX_BANDS[color];
      return colorValues == null ? null : colorValues[bandType];
    default:
      return null;
  }
}

ResistorValue _getThreeOrFourBandResistorValue(int numberBands, List<ResistorBandColor> colors) {
  var value = (_getResistorValueByTypeAndColor(numberBands, ResistorBandType.FIRST, colors[0]) ?? 0.0) +
      (_getResistorValueByTypeAndColor(numberBands, ResistorBandType.SECOND, colors[1]) ?? 0.0);

  value *= _getResistorValueByTypeAndColor(numberBands, ResistorBandType.MULTIPLIER, colors[2]);

  var tolerance = 0.2;
  if (numberBands == 4) {
    tolerance = _getResistorValueByTypeAndColor(numberBands, ResistorBandType.TOLERANCE, colors[3]);
  }

  return ResistorValue(value, tolerance);
}

ResistorValue _getFiveOrSixBandResistorValue(int numberBands, List<ResistorBandColor> colors) {
  var value = (_getResistorValueByTypeAndColor(numberBands, ResistorBandType.FIRST, colors[0]) ?? 0.0) +
      (_getResistorValueByTypeAndColor(numberBands, ResistorBandType.SECOND, colors[1]) ?? 0.0) +
      (_getResistorValueByTypeAndColor(numberBands, ResistorBandType.THIRD, colors[2]) ?? 0.0);

  value *= _getResistorValueByTypeAndColor(numberBands, ResistorBandType.MULTIPLIER, colors[3]);

  var tolerance = _getResistorValueByTypeAndColor(numberBands, ResistorBandType.TOLERANCE, colors[4]);

  var temperaturCoefficient;
  if (numberBands == 6) {
    temperaturCoefficient =
        _getResistorValueByTypeAndColor(numberBands, ResistorBandType.TEMPERATURE_COEFFICIENT, colors[5]);
  }

  return ResistorValue(value, tolerance, temperatureCoefficient: temperaturCoefficient);
}

Map<ResistorBandColor, double> getResistorBandValues(
    int numberBands, ResistorBandType type, List<ResistorBandColor> colors) {
  if (colors == null) return null;

  return Map.fromIterable(colors,
      key: (color) => color,
      value: (color) {
        switch (numberBands) {
          case 1:
          case 2:
          case 3:
          case 4:
            return _RESISTOR_VALUES_THREE_AND_FOUR_BANDS[color][type];
          case 5:
          case 6:
            return _RESISTOR_VALUES_FIVE_AND_SIX_BANDS[color][type];
          default:
            return null;
        }
      });
}

ResistorValue getResistorValue(List<ResistorBandColor> colors) {
  if (colors == null) return null;

  switch (colors.length) {
    case 3:
      return _getThreeOrFourBandResistorValue(3, colors);
    case 4:
      return _getThreeOrFourBandResistorValue(4, colors);
    case 5:
      return _getFiveOrSixBandResistorValue(5, colors);
    case 6:
      return _getFiveOrSixBandResistorValue(6, colors);
    default:
      return null;
  }
}

double eia96(int code, {String multiplicator: 'A'}) {
  if (code == null) return 0.0;

  var multiplicatorValue = 1.0;

  if (multiplicator != null) {
    switch (multiplicator.toUpperCase()) {
      case 'Y':
        multiplicatorValue = 0.01;
        break;
      case 'X':
        multiplicatorValue = 0.1;
        break;
      case 'A':
        multiplicatorValue = 1.0;
        break;
      case 'B':
        multiplicatorValue = 10.0;
        break;
      case 'C':
        multiplicatorValue = 100.0;
        break;
      case 'D':
        multiplicatorValue = 1000.0;
        break;
      case 'E':
        multiplicatorValue = 10000.0;
        break;
      case 'F':
        multiplicatorValue = 100000.0;
        break;
    }
  }

  return (100.0 * pow(10.0, (code.toDouble() - 1.0) / 96.0) + 0.5).floor() * multiplicatorValue;
}
