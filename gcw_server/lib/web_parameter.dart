import 'package:shelf/shelf.dart';

class WebParameter {
  String title;
  Map<String, String> arguments;
  Request? settings;

  WebParameter({required this.title, required this.arguments, required this.settings});
}