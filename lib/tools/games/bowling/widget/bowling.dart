import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/spinners/spinner_constants.dart';
import 'package:gc_wizard/tools/games/bowling/logic/bowling.dart';

class Bowling extends StatefulWidget {
  const Bowling({Key? key}) : super(key: key);

  @override
  _BowlingState createState() => _BowlingState();
}

class _BowlingState extends State<Bowling> {
  late List<BowlingFrame> _currentBowlingScore;
  List<int> _currentFrameTotals = [10];
  int _currentFrame = 0;
  int _currentThrow1 = 0;
  int _currentThrow2 = 0;
  int _currentThrow3 = 0;
  int _currentHDCP = 0;

  double _cellWidth = 0;
  final BorderSide _border = const BorderSide(width: 1.0, color: Colors.black87);

  @override
  void initState() {
    super.initState();
    _initScoreBoard();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _cellWidth = (maxScreenWidth(context) - 20) / 21;

    return Column(
      children: <Widget>[
        GCWIntegerSpinner(
          title: i18n(context, 'bowling_hdcp'),
          layout: SpinnerLayout.HORIZONTAL,
          value: _currentHDCP,
          min: 0,
          max: 100,
          onChanged: (value) {
            setState(() {
              _currentHDCP = value;

              _calculateAndSetScore();
            });
          },
        ),
        const GCWTextDivider(text: '',
        suppressTopSpace: true,
        suppressBottomSpace: true,
        ),
        Row(
          children: <Widget>[
            GCWIconButton(
              icon: Icons.arrow_back_ios,
              onPressed: () {
                setState(() {
                  _currentFrame--;
                  if (_currentFrame < 0) _currentFrame = 9;

                  _setThrowPointsForCurrentFrame();
                });
              },
            ),
            Expanded(
              child: GCWText(
                align: Alignment.center,
                text: i18n(context, 'bowling_frame') + ' ' + (_currentFrame + 1).toString() + ' / 10',
              ),
            ),
            GCWIconButton(
              icon: Icons.arrow_forward_ios,
              onPressed: () {
                setState(() {
                  _currentFrame++;
                  if (_currentFrame > 9) _currentFrame = 0;

                  _setThrowPointsForCurrentFrame();
                });
              },
            ),
          ],
        ),
        Row(children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.only(left: DEFAULT_MARGIN, right: DEFAULT_MARGIN),
              child: GCWIntegerSpinner(
                layout: SpinnerLayout.VERTICAL,
                value: _currentThrow1,
                min: 0,
                max: 10,
                onChanged: (value) {
                  setState(() {
                    _currentThrow1 = value;
                    if (_currentFrame < 9 || _currentThrow1 < 10) {
                      _currentThrow2 = min(_currentThrow2, 10 - _currentThrow1);
                    }
                    if (_currentThrow1 == 10) {
                      _currentThrow3 = min(_currentThrow3, 10 - _currentThrow2);
                    }

                    _calculateAndSetScore();
                  });
                },
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.only(left: DEFAULT_MARGIN, right: DEFAULT_MARGIN),
              child: (_currentFrame < 9 && _currentThrow1 == 10)
                  ? Container()
                  : GCWIntegerSpinner(
                      layout: SpinnerLayout.VERTICAL,
                      value: _currentThrow2,
                      min: 0,
                      max: (_currentFrame == 9 && _currentThrow1 == 10) ? 10 : 10 - _currentThrow1,
                      onChanged: (value) {
                        setState(() {
                          _currentThrow2 = value;
                          if (_currentThrow1 == 10) {
                            _currentThrow3 = min(_currentThrow3, 10 - _currentThrow2);
                          }

                          _calculateAndSetScore();
                        });
                      },
                    ),
            ),
          ),
          (_currentFrame == 9 &&
                  _currentBowlingScore[_currentFrame].one + _currentBowlingScore[_currentFrame].two >= 10)
              ? Expanded(
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsets.only(left: DEFAULT_MARGIN),
                    child: GCWIntegerSpinner(
                      layout: SpinnerLayout.VERTICAL,
                      value: _currentThrow3,
                      min: 0,
                      max: 10,
                      onChanged: (value) {
                        setState(() {
                          _currentThrow3 = value;

                          _calculateAndSetScore();
                        });
                      },
                    ),
                  ))
              : Container()
        ]),
        _buildOutput(),
      ],
    );
  }

  Widget _buildOutput() {
    return Column(
      children: <Widget>[
        GCWDefaultOutput(
          child: GCWColumnedMultilineOutput(
              data: _buildBowlingScoreTable(), hasHeader: true, copyColumn: 4, flexValues: const [2, 1, 1, 1, 2, 3]),
        ),
        GCWTextDivider(
          text: i18n(context, 'bowling_scoreboard'),
        ),
        GCWOutput(
            child: Column(
          children: _buildBowlingScoreBoard(),
        )),
      ],
    );
  }

  void _initScoreBoard() {
    _currentBowlingScore = List<BowlingFrame>.generate(10, (i) => BowlingFrame(one: 0, two: 0, three: 0));
    _currentFrameTotals = List<int>.generate(10, (i) => 0);
  }

  void _setThrowPointsForCurrentFrame() {
    _currentThrow1 = _currentBowlingScore[_currentFrame].one;
    _currentThrow2 = _currentBowlingScore[_currentFrame].two;
    _currentThrow3 = _currentBowlingScore[_currentFrame].three;
  }

  void _calculateAndSetScore() {
    _currentBowlingScore[_currentFrame] = BowlingFrame(one: _currentThrow1, two: _currentThrow2, three: _currentThrow3);
    _currentFrameTotals = bowlingCalcFrameTotals(_currentBowlingScore);
  }

  List<List<Object?>> _buildBowlingScoreTable() {
    List<List<Object?>> result = [];
    result.add([
      i18n(context, 'bowling_frame'),
      '1',
      '2',
      '3',
      i18n(context, 'bowling_total'),
      i18n(context, 'bowling_wholetotal')
    ]);
    for (int i = 0; i < 10; i++) {
      result.add([
        i + 1,
        _currentBowlingScore[i].one,
        (_currentBowlingScore[i].one == 10) && (i < 9) ? null : _currentBowlingScore[i].two,
        (i == 9) && (_currentBowlingScore[i].one + _currentBowlingScore[i].two == 10)
            ? _currentBowlingScore[i].three
            : null,
        _currentFrameTotals[i],
        bowlingTotalAfterFrames(i, _currentFrameTotals, HDCP: _currentHDCP),
      ]);
    }
    return result;
  }

  List<Widget> _buildBowlingScoreBoard() {
    // https: //www.sportcalculators.com/bowling-score-calculator
    var score = <Widget>[];
    var scoreRow0 = <Widget>[];
    var scoreRow1 = <Widget>[];
    var scoreRow2 = <Widget>[];
    var scoreRow3 = <Widget>[];

    scoreRow0.add(_buildCellRow0(1));
    scoreRow0.add(_buildCellRow0(2));
    score.add(Row(
      children: scoreRow0,
    ));

    for (int i = 0; i < 10; i++) {
      scoreRow1.add(_buildCellRow1(i, 1));
      scoreRow1.add(_buildCellRow1(i, 2));
    }
    scoreRow1.add(_buildCellRow1(9, 3));
    score.add(Row(
      children: scoreRow1,
    ));

    for (int i = 0; i < 10; i++) {
      i != 9 ? scoreRow2.add(_buildCellRow2(i)) : scoreRow2.add(_buildCellRow2_10());
    }
    score.add(Row(
      children: scoreRow2,
    ));

    scoreRow3.add(_buildCellRow3(1));
    scoreRow3.add(_buildCellRow3(2));
    score.add(Row(
      children: scoreRow3,
    ));

    return score;
  }

  Widget _buildCellRow0(int count){
    return Container(
      height: defaultFontSize() * 1.5,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: _border, left: count == 1 ? _border : BorderSide.none, right: count == 1 ? BorderSide.none : _border, bottom: BorderSide.none),
      ),
      width: count == 1 ? _cellWidth * 18 : _cellWidth * 3,
      child: Column(
        children: [
          Expanded(
              child: Align(
                alignment: count == 1 ? Alignment.centerRight : Alignment.center,
                child: AutoSizeText(
                  count == 1 ? i18n(context, 'bowling_hdcp') : _currentHDCP.toString(),
                  style: gcwTextStyle().copyWith(color: Colors.black),
                  minFontSize: AUTO_FONT_SIZE_MIN,
                  maxLines: 1,
                )
              )
          ),
        ],
      ),
    );
  }

  Widget _buildCellRow1(int frame, int count) {
    return Container(
      height: defaultFontSize() * 1.5,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: _border, left: _border, right: _border, bottom: count != 1 ? _border : BorderSide.none),
      ),
      width: _cellWidth,
      child: Column(
        children: [
          Expanded(
              child: AutoSizeText(
            bowlingBuildDataRow1(frame, count, _currentBowlingScore),
            style: gcwTextStyle().copyWith(color: Colors.black),
            minFontSize: AUTO_FONT_SIZE_MIN,
            maxLines: 1,
          )),
        ],
      ),
    );
  }

  Widget _buildCellRow2(int frame) {
    return Container(
      height: defaultFontSize() * 1.5,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide.none, left: _border, right: _border, bottom: _border),
      ),
      width: _cellWidth * 2,
      child: Column(
        children: [
          Expanded(
              child: AutoSizeText(
            bowlingTotalAfterFrames(frame, _currentFrameTotals,).toString(),
            style: gcwTextStyle().copyWith(color: Colors.black),
            minFontSize: AUTO_FONT_SIZE_MIN,
            maxLines: 1,
          )),
        ],
      ),
    );
  }

  Widget _buildCellRow2_10() {
    return Container(
      height: defaultFontSize() * 1.5,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide.none, left: _border, right: _border, bottom: _border),
      ),
      width: _cellWidth * 3,
      child: Column(
        children: [
          Expanded(
              child: AutoSizeText(
            bowlingTotalAfterFrames(9, _currentFrameTotals).toString(),
            style: gcwTextStyle().copyWith(color: Colors.black),
            minFontSize: AUTO_FONT_SIZE_MIN,
            maxLines: 1,
          )),
        ],
      ),
    );
  }

  Widget _buildCellRow3(int count){
    return Container(
      height: defaultFontSize() * 1.5,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: _border, left: count == 1 ? _border : BorderSide.none, right: count == 1 ? BorderSide.none : _border, bottom: BorderSide.none),
      ),
      width: count == 1 ? _cellWidth * 18 : _cellWidth * 3,
      child: Column(
        children: [
          Expanded(
              child: Align(
                  alignment: count == 1 ? Alignment.centerRight : Alignment.center,
                  child: AutoSizeText(
                    count == 1 ? i18n(context, 'bowling_totalscore') : bowlingTotalAfterFrames(9, _currentFrameTotals, HDCP: _currentHDCP).toString(),
                    style: gcwTextStyle().copyWith(color: Colors.black),
                    minFontSize: AUTO_FONT_SIZE_MIN,
                    maxLines: 1,
                  )
              )
          ),
        ],
      ),
    );
  }
}
