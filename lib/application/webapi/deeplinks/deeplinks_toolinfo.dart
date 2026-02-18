part of 'package:gc_wizard/application/webapi/deeplinks/deeplinks.dart';

Widget _buildApiInfo(String apiInfo) {
  return Column(children: [
    Container(height: 20),
    const GCWText(text: 'API info:'),
    GCWCodeTextField(
      controller: TextEditingController(text: apiInfo),
      patternMap: _openApiHiglightMap,
    ),
  ]);
}

Widget _toolInfo(BuildContext context, GCWTool tool) {
  return FutureBuilder<({String id, String apiInfo})>(
      future: _toolInfoText(tool),
      builder: (BuildContext context, AsyncSnapshot<({String id, String apiInfo})> snapshot) {
        return Column(
          children: [
            GCWColumnedMultilineOutput(data: [
              [i18n(context, 'webapi_deeplink_toolsapi_toolinfo_toolname'), toolName(context, tool)],
              [
                i18n(context, 'webapi_deeplink_toolsapi_toolinfo_apipath'),
                i18n(context, 'about_webversion_url') + '#/' + (snapshot.data?.id ?? '')
              ],
            ]),
            ((snapshot.data?.apiInfo ?? '').isNotEmpty)
                ? GCWExpandableTextDivider(
                    text: 'OpenAPI 3.0.0 ' + i18n(context, 'webapi_deeplink_toolsapi_toolinfo_specification'),
                    expanded: true,
                    child: _buildApiInfo(snapshot.data?.apiInfo ?? ''))
                : Container()
          ],
        );
      });
}

GCWTool _infoTool(BuildContext context, GCWTool tool) {
  return GCWTool(
    suppressHelpButton: true,
    id: 'webapi_deeplink_toolsapi_toolinfo_title',
    toolName: i18n(context, 'webapi_deeplink_toolsapi_toolinfo_title'),
    tool: _toolInfo(context, tool),
  );
}

Future<({String id, String apiInfo})> _toolInfoText(GCWTool tool) async {
  var id = deeplinkToolId(tool);
  var apiInfo = '';
  if (_hasAPISpecification(tool)) {
    apiInfo = (tool.tool as GCWWebStatefulWidget).apiSpecification!;
  }

  return (id: id, apiInfo: apiInfo);
}
