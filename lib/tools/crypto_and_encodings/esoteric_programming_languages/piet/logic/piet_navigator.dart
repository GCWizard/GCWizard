part of 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/piet/logic/piet_language.dart';

enum _Direction { East, South, West, North }

enum _CodelChoice { Left, Right }

class _PietNavigator {
  var _direction = _Direction.East;
  _Direction get direction => _direction;

  var _codelChooser = _CodelChoice.Left;
  _CodelChoice get codelChooser => _codelChooser;

  List<List<int>> _data = [];

  final int white = _knownColors[18];
  final int black = _knownColors[19];

  int _width = 0;
  int _height = 0;

  _PietNavigator(List<List<int>> data) {
    _data = data;
    _width = _data.length;
    _height = _data[0].length;
  }

  var _currentPoint = const Point<int>(0, 0);
  Point<int> get currentPoint => _currentPoint;

  Tuple2<bool, Point<int>> tryNavigate(_PietBlock block) {
    Point<int> result;
    int failureCount = 0;

    bool moveStraight = block.color == white || !block.knownColor;

    while (failureCount < 8) {
      var exitPoint = const Point<int>(0, 0);

      if (moveStraight) {
        exitPoint = currentPoint;
      } else if (direction == _Direction.East && codelChooser == _CodelChoice.Left) {
        exitPoint = block.eastLeft;
      } else if (direction == _Direction.East && codelChooser == _CodelChoice.Right) {
        exitPoint = block.eastRight;
      } else if (direction == _Direction.South && codelChooser == _CodelChoice.Left) {
        exitPoint = block.southLeft;
      } else if (direction == _Direction.South && codelChooser == _CodelChoice.Right) {
        exitPoint = block.southRight;
      } else if (direction == _Direction.West && codelChooser == _CodelChoice.Left) {
        exitPoint = block.westLeft;
      } else if (direction == _Direction.West && codelChooser == _CodelChoice.Right) {
        exitPoint = block.westRight;
      } else if (direction == _Direction.North && codelChooser == _CodelChoice.Left) {
        exitPoint = block.northLeft;
      } else if (direction == _Direction.North && codelChooser == _CodelChoice.Right) {
        exitPoint = block.northRight;
      } else {
        return throw const FormatException('common_programming_error_invalid_opcode');
      }

      if (moveStraight) {
        var prevStep = exitPoint;
        while (_stillInBlock(exitPoint, block)) {
          prevStep = exitPoint;
          switch (direction) {
            case _Direction.East:
              exitPoint = Point<int>(exitPoint.x + 1, exitPoint.y);
              break;
            case _Direction.South:
              exitPoint = Point<int>(exitPoint.x, exitPoint.y + 1);
              break;
            case _Direction.West:
              exitPoint = Point<int>(exitPoint.x - 1, exitPoint.y);
              break;
            case _Direction.North:
              exitPoint = Point<int>(exitPoint.x, exitPoint.y - 1);
              break;
            default:
              return throw const FormatException('common_programming_error_invalid_opcode');
          }
        }
        // we've crossed the boundary, one step back to be on the edge
        exitPoint = prevStep;
      }

      Point<int> nextStep;
      if (direction == _Direction.East) {
        nextStep = Point<int>(exitPoint.x + 1, exitPoint.y);
      } else if (direction == _Direction.South) {
        nextStep = Point<int>(exitPoint.x, exitPoint.y + 1);
      } else if (direction == _Direction.West) {
        nextStep = Point<int>(exitPoint.x - 1, exitPoint.y);
      } else if (direction == _Direction.North) {
        nextStep = Point<int>(exitPoint.x, exitPoint.y - 1);
      } else {
        return throw const FormatException('common_programming_error_invalid_opcode');
      }

      bool isOutOfBounds = nextStep.x < 0 || nextStep.y < 0 || nextStep.x >= _width || nextStep.y >= _height;

      // you're blocked if the target is a black codel or you're out of bounds
      bool isBlocked = isOutOfBounds || _data[nextStep.x][nextStep.y] == black;

      if (!isBlocked) {
        _currentPoint = nextStep;
        result = nextStep;
        return Tuple2<bool, Point<int>>(true, result);
      }

      _currentPoint = exitPoint;

      if (failureCount % 2 == 0) {
        toggleCodelChooser(1);
      } else {
        rotateDirectionPointer(1);
      }

      failureCount++;
    }

    result = const Point<int>(0, 0);
    return Tuple2<bool, Point<int>>(false, result);
  }

  bool _stillInBlock(Point<int> exitPoint, _PietBlock block) {
    return exitPoint.x >= 0 &&
        exitPoint.y >= 0 &&
        exitPoint.x < _width &&
        exitPoint.y < _height &&
        block.containsPixel(Point<int>(exitPoint.x, exitPoint.y));
  }

  /// <summary>
  /// Rotates abs(turns) times. In turns is positive rotates clockwise otherwise counter clockwise
  /// </summary>
  /// <param name="turns">I</param>
  void rotateDirectionPointer(int turns) {
    _direction = _Direction.values[(direction.index + turns) % 4];
  }

  void toggleCodelChooser(int times) {
    _codelChooser = _CodelChoice.values[(codelChooser.index + times.abs()) % 2];
  }
}
