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
  return FutureBuilder<Tuple2<String, String>>(
      future: _toolInfoText(tool),
      builder: (BuildContext context, AsyncSnapshot<Tuple2<String, String>> snapshot) {
        return Column(
          children: [
            GCWColumnedMultilineOutput(data: [
              [i18n(context, 'webapi_deeplink_toolsapi_toolinfo_toolname'), toolName(context, tool)],
              [
                i18n(context, 'webapi_deeplink_toolsapi_toolinfo_apipath'),
                i18n(context, 'about_webversion_url') + '#/' + (snapshot.data?.item1 ?? '')
              ],
            ]),
            ((snapshot.data?.item2 ?? '').isNotEmpty)
                ? GCWExpandableTextDivider(
                    text: 'OpenAPI 3.0.0 ' + i18n(context, 'webapi_deeplink_toolsapi_toolinfo_specification'),
                    expanded: true,
                    child: _buildApiInfo(snapshot.data?.item2 ?? ''))
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

Future<Tuple2<String, String>> _toolInfoText(GCWTool tool) async {
  var id = deeplinkToolId(tool);
  var apiInfo = '';
  if (_hasAPISpecification(tool)) {
    apiInfo = (tool.tool as GCWWebStatefulWidget).apiSpecification!;
  }

  return Tuple2<String, String>(id, apiInfo);
}
