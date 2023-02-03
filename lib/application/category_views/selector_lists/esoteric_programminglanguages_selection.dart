import 'package:flutter/material.dart';
import 'package:gc_wizard/application/registry.dart';
import 'package:gc_wizard/common_widgets/gcw_selection.dart';
import 'package:gc_wizard/common_widgets/gcw_tool.dart';
import 'package:gc_wizard/common_widgets/gcw_toollist.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/beatnik_language/widget/beatnik_language.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/befunge/widget/befunge.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/brainfk/widget/brainfk.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/chef_language/widget/chef_language.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/cow/widget/cow.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/deadfish/widget/deadfish.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/hohoho/widget/hohoho.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/karol_robot/widget/karol_robot.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/malbolge/widget/malbolge.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/ook/widget/ook.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/piet/widget/piet.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/whitespace_language/widget/whitespace_language.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/common_widget_utils.dart';

class EsotericProgrammingLanguageSelection extends GCWSelection {
  @override
  Widget build(BuildContext context) {
    final List<GCWTool> _toolList = registeredTools.where((element) {
      return [
        className(Beatnik()),
        className(Befunge()),
        className(Brainfk()),
        className(Chef()),
        className(Cow()),
        className(Deadfish()),
        className(Hohoho()),
        className(KarolRobot()),
        className(Malbolge()),
        className(Ook()),
        className(Piet()),
        className(WhitespaceLanguage()),
      ].contains(className(element.tool));
    }).toList();

    _toolList.sort((a, b) => sortToolList(a, b));

    return Container(child: GCWToolList(toolList: _toolList));
  }
}
