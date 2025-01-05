import 'package:gcw_server/controller.dart';
import 'package:gcw_server/web_parameter.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

void main() async {
  var handler =
  const Pipeline().addMiddleware(logRequests()).addHandler(_echoRequest);

  var server = await shelf_io.serve(handler, 'localhost', 4044);

  // Enable content compression
  server.autoCompress = true;

//  print('Serving at http://${server.address.host}:${server.port}');
}

Response _echoRequest(Request _request) {
  var arguments = parseUrl(_request);

  if (arguments == null) return Response.notFound('Request error for ${_request.url}  ' + DateTime.now().toString());
  var result = request(arguments);

  return Response.ok('Request for ${_request.url}  ' + DateTime.now().toString() + ' result: ${result ?? ''}');
}

WebParameter? parseUrl(Request settings) {

  var uri = Uri.parse(settings.url.toString());
  var title = uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : '';

  return WebParameter(title: title, arguments: uri.queryParameters, settings: settings);
}


