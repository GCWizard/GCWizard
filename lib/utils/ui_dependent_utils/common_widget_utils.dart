import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart' as urlLauncher;

String className(Widget widget) {
  return widget.runtimeType.toString();
}

String printErrorMessage(BuildContext context, String message) {
  return i18n(context, 'common_error') + ': ' + i18n(context, message);
}

Future<bool> launchUrl(Uri url) async {
  return urlLauncher.launchUrl(url, mode: urlLauncher.LaunchMode.externalApplication);
}
