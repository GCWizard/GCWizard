import 'package:flutter/material.dart';

// from https://stackoverflow.com/a/63325745/3984221
class NavigationService {
  GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

  static NavigationService instance = NavigationService();

  // Future<dynamic> navigateToReplacement(String _rn) {
  //   return navigationKey.currentState!.pushReplacementNamed(_rn);
  // }

  Future<dynamic> navigateTo(String _rn) {
    return navigationKey.currentState!.pushNamed(_rn);
  }

  // Future<dynamic> navigateToRoute(MaterialPageRoute _rn) {
  //   return navigationKey.currentState!.push(_rn);
  // }

  void goBack() {
    return navigationKey.currentState!.pop();
  }
}
