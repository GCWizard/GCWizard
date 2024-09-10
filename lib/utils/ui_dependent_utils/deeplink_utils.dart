import 'package:gc_wizard/application/tools/widget/gcw_tool.dart';
import 'package:gc_wizard/utils/constants.dart';

String deeplinkToolId(GCWTool tool) {
  return (tool.id_prefix ?? '') + tool.id;
}

String deepLinkURL(GCWTool tool, {String? fallbackPath}) {
  return BASE_URL +
      '/#/' +
      (tool.deeplinkAlias != null && tool.deeplinkAlias!.isNotEmpty
          ? tool.deeplinkAlias!.first
          : (fallbackPath ?? deeplinkToolId(tool)));
}
