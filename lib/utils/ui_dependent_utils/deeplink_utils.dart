import 'package:gc_wizard/application/tools/widget/gcw_tool.dart';
import 'package:gc_wizard/common_widgets/gcw_web_statefulwidget.dart';
import 'package:gc_wizard/utils/constants.dart';

String deeplinkToolId(GCWTool tool) {
  return (tool.id_prefix ?? '') + tool.id;
}

String deepLinkURL(GCWTool tool, {String? fallbackPath, bool withParameter = true}) {
  if (withParameter && tool.tool is GCWWebStatefulWidget) {
    var deeplinkParameter = (tool.tool as GCWWebStatefulWidget).deepLinkParameter;

    if (deeplinkParameter != null) {
      return deepLinkUriWithParameter(tool, deeplinkParameter).toString();
    }
  }

  var path = BASE_URL +
      '/#/' +
      (tool.deeplinkAlias != null && tool.deeplinkAlias!.isNotEmpty
          ? tool.deeplinkAlias!.first
          : (fallbackPath ?? deeplinkToolId(tool)));

  return path;
}

Uri deepLinkUriWithParameter(GCWTool tool, Map<String, dynamic>? queryParameters, {String? fallbackPath}) {
  var uriBase = Uri.parse(deepLinkURL(tool, fallbackPath: fallbackPath, withParameter: false));
  var uriQuery = Uri.https(uriBase.host, uriBase.fragment, queryParameters);
  return Uri.parse(uriBase.toString() + '?' + uriQuery.query);
}
