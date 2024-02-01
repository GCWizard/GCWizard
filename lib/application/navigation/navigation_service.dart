import 'package:flutter/material.dart';

const String clipboard_editor = 'clipboard_editor';

// from https://stackoverflow.com/a/63325745/3984221
// only used for copy paste widget
class NavigationService {
  GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

  static NavigationService instance = NavigationService();

  Future<dynamic> navigateTo(String _rn) {
    return navigationKey.currentState!.pushNamed(_rn);
  }

  void goBack() {
    return navigationKey.currentState!.pop();
  }
}
