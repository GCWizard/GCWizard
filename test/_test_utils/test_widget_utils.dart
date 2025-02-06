import 'package:flutter/material.dart';

//TODO: for some reasons the tests throw exceptions, when widgets under test do not have a MaterialApp as root; Maybe otherwise fixable?
MaterialApp createTestWidget(Widget widget) {
  return MaterialApp(
      home: Builder(
        builder: (BuildContext builder) {
          return widget;
        }
      )
  );
}