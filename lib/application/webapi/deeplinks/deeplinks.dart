import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:gc_wizard/application/category_views/all_tools_view.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/navigation/no_animation_material_page_route.dart';
import 'package:gc_wizard/application/registry.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/clipboard/gcw_clipboard.dart';
import 'package:gc_wizard/common_widgets/gcw_expandable.dart';
import 'package:gc_wizard/common_widgets/gcw_selection.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/gcw_textselectioncontrols.dart';
import 'package:gc_wizard/application/tools/widget/gcw_tool.dart';
import 'package:gc_wizard/common_widgets/gcw_web_statefulwidget.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_code_textfield.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/common_widget_utils.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/deeplink_utils.dart';
import 'package:tuple/tuple.dart';

part 'package:gc_wizard/application/webapi/deeplinks/deeplinks_toolinfo.dart';
part 'package:gc_wizard/application/webapi/deeplinks/deeplinks_toolinfo_codecolorscheme.dart';

const String _questionmark = '/?';
const String _initRoute = 'initRoute';

class WebParameter {
  String title;
  Map<String, String> arguments;
  RouteSettings? settings;

  WebParameter({required this.title, required this.arguments, required this.settings});
}

NoAnimationMaterialPageRoute<GCWTool>? createRoute(BuildContext context, RouteSettings settings) {
  var args = _parseUrl(settings);
  return (args == null) ? null : _createRoute(context, args, settings);
}

List<Route<GCWTool>> startMainView(BuildContext context, String route) {
  return [
    NoAnimationMaterialPageRoute<GCWTool>(
        builder: (context) =>
            MainView(webParameter: _parseUrl(RouteSettings(name: route), initRoute: true)?.arguments)),
  ];
}

NoAnimationMaterialPageRoute<GCWTool>? createStartDeepLinkRoute(BuildContext context, Map<String, String> arguments) {
  var webparameter = WebParameter(title: arguments[_initRoute] ?? '', arguments: arguments, settings: null);
  return _createRoute(context, webparameter, const RouteSettings());
}

// A Widget that accepts the necessary arguments via the constructor.
NoAnimationMaterialPageRoute<GCWTool>? _createRoute(
    BuildContext context, WebParameter arguments, RouteSettings settings) {
  var gcwTool = _findGCWTool(context, arguments);
  if (gcwTool == null) return null;

  if (gcwTool.tool is GCWWebStatefulWidget) {
    try {
      (gcwTool.tool as GCWWebStatefulWidget).webQueryParameter = arguments.arguments;
    } catch (e) {}
  }
  return _buildRoute(context, gcwTool, settings);
}

NoAnimationMaterialPageRoute<GCWTool> _buildRoute(BuildContext context, GCWTool gcwTool, RouteSettings settings) {
  // arguments settings only for view the path in the url , settings: arguments.settings
  return NoAnimationMaterialPageRoute<GCWTool>(builder: (context) => gcwTool, settings: settings);
}

GCWTool? _findGCWTool(BuildContext context, WebParameter arguments) {
  if (arguments.title.isEmpty) return null;
  var name = arguments.title.toLowerCase();

  try {
    // if name == /? open tool overview
    if (name == _questionmark) return _toolNameList(context);

    var tool = registeredTools.firstWhereOrNull((_tool) {
      var id = deeplinkToolId(_tool);
      return id == name || (_tool.deeplinkAlias != null && _tool.deeplinkAlias!.contains(name));
    });
    // if name == toolname/? open tool info
    if ((arguments.arguments[_questionmark] == _questionmark) && tool != null) {
      return _infoTool(context, tool);
    }

    return tool;
  } catch (e) {}

  return null;
}

WebParameter? _parseUrl(RouteSettings settings, {bool initRoute = false}) {
  if (settings.name == null) return null;

  Uri? uri;
  try {
    uri = settings.name == _questionmark ? Uri(pathSegments: [_questionmark]) : Uri.parse(settings.name!);
  } catch (e) {
    return null;
  }

  if (uri.pathSegments.isEmpty) return null;

  var title = uri.pathSegments[0];
  var parameter = uri.queryParameters;
  // tool info ?
  if ((uri.pathSegments.length > 1) && (uri.pathSegments[1].isEmpty && settings.name!.endsWith(_questionmark))) {
    parameter = {_questionmark: _questionmark};
  }

  if (initRoute) {
    parameter = Map<String, String>.from(parameter);
    parameter.addAll({_initRoute: title});
  }

  return WebParameter(title: title, arguments: parameter, settings: settings);
}

GCWTool _toolNameList(BuildContext context) {
  var apiToolList = List<GCWTool>.from(registeredTools.where((element) => element.tool is GCWWebStatefulWidget));
  var toolList = List<GCWTool>.from(registeredTools.where((element) => element.tool is! GCWSelection));

  for (var element in apiToolList) {
    toolList.remove(element);
  }

  apiToolList.sort((a, b) => deeplinkToolId(a).compareTo(deeplinkToolId(b)));
  toolList.sort((a, b) => deeplinkToolId(a).compareTo(deeplinkToolId(b)));
  apiToolList.addAll(toolList);

  return GCWTool(
    suppressHelpButton: true,
    id: 'webapi_deeplink_toolsapi_title',
    toolName:
        i18n(context, 'webapi_deeplink_toolsapi_title') + ': ' + i18n(context, 'webapi_deeplink_toolsapi_toolpaths'),
    tool: _buildItems(context, apiToolList),
  );
}

Widget _buildItems(BuildContext context, List<GCWTool> toolList) {
  return SizedBox(
      height: maxScreenHeight(context),
      child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(
            dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
          ),
          child: FutureBuilder<List<Widget>>(
              future: _buildRows(context, toolList),
              builder: (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
                return ListView(
                    primary: true, physics: const AlwaysScrollableScrollPhysics(), children: snapshot.data ?? []);
              })));
}

Future<List<Widget>> _buildRows(BuildContext context, List<GCWTool> toolList) async {
  return Future.value(toolList.map((tool) => _buildRow(context, tool)).toList());
}

Widget _buildRow(BuildContext context, GCWTool tool) {
  return FutureBuilder<Tuple2<String, String>>(
      future: _toolInfoTextShort(context, tool),
      builder: (BuildContext context, AsyncSnapshot<Tuple2<String, String>> snapshot) {
        return _buildRowWidget(
            context, tool, snapshot.data?.item2 ?? '', deepLinkURL(tool, fallbackPath: snapshot.data?.item1));
      });
}

Future<Tuple2<String, String>> _toolInfoTextShort(BuildContext context, GCWTool tool) async {
  var id = deeplinkToolId(tool);
  var info = id;
  return Tuple2<String, String>(id, info);
}

bool _hasAPISpecification(GCWTool tool) {
  return (tool.tool is GCWWebStatefulWidget) && (tool.tool as GCWWebStatefulWidget).apiSpecification != null;
}

InkWell _buildRowWidget(BuildContext context, GCWTool tool, String id, String url) {
  return InkWell(
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    if (_hasAPISpecification(tool)) Icon(Icons.check, color: themeColors().secondary()),
                    Container(width: DOUBLE_DEFAULT_MARGIN),
                    SelectableText(
                      '/' +
                          (tool.deeplinkAlias != null && tool.deeplinkAlias!.isNotEmpty
                              ? tool.deeplinkAlias!.first
                              : id),
                      textAlign: TextAlign.left,
                      style: gcwTextStyle(),
                      selectionControls: GCWTextSelectionControls(),
                    )
                  ],
                )),
          ),
          Expanded(
            flex: 2,
            child: Text(toolName(context, tool), style: gcwTextStyle()),
          ),
          _hasAPISpecification(tool)
              ? GCWIconButton(
                  iconColor: themeColors().mainFont(),
                  size: IconButtonSize.SMALL,
                  icon: Icons.question_mark,
                  onPressed: () {
                    var route = _createRoute(
                        context,
                        WebParameter(
                            title: deeplinkToolId(tool), arguments: {_questionmark: _questionmark}, settings: null),
                        const RouteSettings());
                    if (route != null) {
                      Navigator.push(context, route);
                    }
                  },
                )
              : Container(
                  width: 40.0,
                ),
          url.isNotEmpty
              ? GCWIconButton(
                  iconColor: themeColors().mainFont(),
                  size: IconButtonSize.SMALL,
                  icon: Icons.content_copy,
                  onPressed: () {
                    insertIntoGCWClipboard(context, url);
                  },
                )
              : Container()
        ],
      ),
      onTap: () {
        launchUrl(Uri.parse(url));
      });
}
