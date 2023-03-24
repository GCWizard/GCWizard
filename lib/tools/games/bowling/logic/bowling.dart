class BowlingFrame {
  final int one;
  final int two;
  final int three;

  BowlingFrame({this.one = 0, this.two = 0, this.three = 0});
}

List<int> bowlingCalcFrameTotals(List<BowlingFrame> bowlingScore) {
  int frame = 0;
  List<int> total = Iterable<int>.generate(10, (i) => 0).toList();

  for (int i = 0; i < 9; i++) {
    if (bowlingScore[i].one == 10) {
      frame = bowlingScore[i].one + bowlingScore[i + 1].one;
      if (bowlingScore[i + 1].one == 10) {
        if (i + 1 == 10) {
          frame = frame + bowlingScore[i + 1].two;
        } else {
          if (i + 2 == 10) {
            frame = frame + bowlingScore[i + 1].two;
          } else {
            frame = frame + bowlingScore[i + 2].one;
          }
        }
      } else {
        frame = frame + bowlingScore[i + 1].two;
      }
      total[i] = frame;
    } else if (bowlingScore[i].one + bowlingScore[i].two == 10) {
      total[i] = bowlingScore[i].one + bowlingScore[i].two + bowlingScore[i + 1].one;
    } else {
      total[i] = bowlingScore[i].one + bowlingScore[i].two;
    }
  }
  total[9] = bowlingScore[9].one + bowlingScore[9].two;

  if (total[9] >= 10) total[9] += bowlingScore[9].three;

  return total;
}

int bowlingTotalAfterFrames(int frame, List<int> total) {
  int result = 0;
  for (int i = 0; i <= frame; i++) {
    result = result + total[i];
  }
  return result;
}

String bowlingBuildDataRow1(int frame, int count, List<BowlingFrame> bowlingScore) {
  String result = '';
  switch (count) {
    case 1:
      result = bowlingScore[frame].one == 10 ? 'X' : bowlingScore[frame].one.toString();
      break;
    case 2:
      if (bowlingScore[frame].one == 10) {
        if (frame != 9) {
          result = ' ';
        } else {
          result = bowlingScore[frame].two == 10 ? 'X' : bowlingScore[frame].two.toString();
        }
      } else if (bowlingScore[frame].one + bowlingScore[frame].two == 10) {
        result = '/';
      } else {
        result = bowlingScore[frame].two.toString();
      }
      break;
    case 3:
      result = bowlingScore[frame].three == 10 ? 'X' : bowlingScore[frame].three.toString();
      break;
  }
  return result == '0' ? '-' : result;
}
